package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationTaskSysCache;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupation;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupationTask;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.domain.OccupationTask;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.OccupationUpEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.service.OccupationService;
import com.ayjs.mxzg.protocol.CrusadeGroupOccupationGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class OccupationHandler extends ProtocolHandler {

    @Autowired
    private OccupationService occupationService;
    @Autowired
    private OccupationTaskSysCache occupationTaskSysCache;
    @Autowired
    private OccupationSysCache occupationSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private GroupService groupService;
    @Autowired
    private EventBus eventBus;

    /**
     * 获取职级信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75606)
    public void occupationInfo(PlayerContext playerContext, CrusadeGroupOccupationGMsg.GReqGetOccupationInfo msg) {
        long rid = playerContext.getId();
        List<OccupationTask> taskList = occupationService.getOccupationTasks(rid);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        CrusadeGroupOccupationGMsg.PSOccupationInfo.Builder occupationInfo = CrusadeGroupOccupationGMsg.PSOccupationInfo.newBuilder();
        occupationInfo.setOcId(roleCrusadeGroup.getKnighthoodId());//职级等级id
        for (OccupationTask occupationTask : taskList) {
            occupationInfo.addTaskInfos(creatTaskMsgInfo(occupationTask));
        }
        CrusadeGroupOccupationGMsg.GResGetOccupationInfo.Builder builder = CrusadeGroupOccupationGMsg.GResGetOccupationInfo.newBuilder();
        builder.setOccupationInfo(occupationInfo);
        playerContext.write(CmdCode._75606, builder.build());
    }

    /**
     * 进阶职级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75607)
    public void occupationUp(PlayerContext playerContext, CrusadeGroupOccupationGMsg.GReqGetOccupationInfo msg) {
        long rid = playerContext.getId();
        List<OccupationTask> taskList = occupationService.getOccupationTasks(rid);
        Map<Integer, OccupationTask> taskMap = ListMapUtil.listToMap(taskList, OccupationTask::getTaskId);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        int ocId_now = roleCrusadeGroup.getKnighthoodId();//当前职级等级
//        COccupation cOccupation = occupationSysCache.getById(ocId_now);
        COccupation cOccupation_next = occupationSysCache.getById(ocId_now + 1);
        Asserts.notNull(cOccupation_next, ErrorCode.OCCUPATION_TEMPLATE_ERROR.getValue(), String.format("职级进阶 模板为null,ocId:{%s}", ocId_now + 1));
        List<COccupationTask> taskTemplates = occupationTaskSysCache.getCOccupationTaskTemplate_ocId(ocId_now);
        Asserts.notNull(taskTemplates, ErrorCode.OCCUPATION_TASK_TEMPLATE_ERROR.getValue(), String.format("职级进阶 任务模板为null,ocId:{%s}", ocId_now + 1));
        for (COccupationTask taskTemplate : taskTemplates) {
            int taskId = taskTemplate.getId();
            OccupationTask occupationTask = taskMap.get(taskId);
            if (occupationTask == null) {//玩家还没有做这个任务
                Asserts.isTrue(false, ErrorCode.OCCUPATION_TASK_EMPTY.getValue(),
                        String.format("进阶职级玩家没有做这个任务,rid:{%s},taskId:{%s}", rid, taskId));
                return;
            }
            TargetStruct task = taskTemplate.getTask();
            if (occupationTask.getCondition() < 0 || occupationTask.getComplete_type() < 0) {
                Asserts.isTrue(false, ErrorCode.OCCUPATION_TASK_NO_COMPLETE.getValue(),
                        String.format("进阶职级玩家没有完成该任务,rid:{%s},taskId:{%s}", rid, taskId));
                return;
            }
        }
        //发送奖励
//        List<ImmutableThing> things_all = ImmutableThingUtil.mergeThing(things);
        Rewards rewards = thingService.add(rid, cOccupation_next.getReward(),
                GameEvent.OCCUPATION_UP_REWARD, NoticeType.NORMAL);
        //更新数据
        roleCrusadeGroup.setKnighthoodId(ocId_now + 1);
        groupService.updateRoleCrusadeGroup(roleCrusadeGroup);
        //发送消息
        CrusadeGroupOccupationGMsg.GResOccupationUp.Builder builder = CrusadeGroupOccupationGMsg.GResOccupationUp.newBuilder();
        builder.setOcId(roleCrusadeGroup.getKnighthoodId());
        playerContext.write(CmdCode._75607, builder.build());

        eventBus.post(OccupationUpEvent.valueOf(playerContext.getId(), roleCrusadeGroup.getKnighthoodId()));
    }

    /**
     * 玩家手动完成任务
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75609)
    public void opreaOccupationTask(PlayerContext playerContext, CrusadeGroupOccupationGMsg.GReqOpreaOccupationTask msg) {
        long rid = playerContext.getId();
        int taskId = msg.getTaskId();
        COccupationTask cOccupationTask = occupationTaskSysCache.getById(taskId);
        Asserts.notNull(cOccupationTask, ErrorCode.OCCUPATION_TASKID_NO_TEMPLATE.getValue(), String.format("手动完成任务 任务模板为null,taskId:{%s}", taskId));
        OccupationTask occupationTask = occupationService.getOccupationTask(rid, taskId);
        Asserts.isTrue(occupationTask.getComplete_type() == -1, ErrorCode.OCCUPATION_TASK_COMPLETE_ALREADY.getValue(),
                String.format("手动完成任务 该任务已经手动完成,rid:{%s},taskId:{%s}", rid, taskId));
        TargetStruct task = cOccupationTask.getTask();
        if (occupationTask.getCount() < task.getTarget() || occupationTask.getCondition() < 0) {
            Asserts.isTrue(false, ErrorCode.OCCUPATION_TASK_NO_COMPLETE.getValue(),
                    String.format("手动完成任务 没有完成该任务,rid:{%s},taskId:{%s}", rid, taskId));
            return;
        }
        //更新数据
        occupationTask.setComplete_type(0);
        occupationService.updateOccupationTask(occupationTask);
        //发送消息
        CrusadeGroupOccupationGMsg.GResOpreaOccupationTask.Builder builder = CrusadeGroupOccupationGMsg.GResOpreaOccupationTask.newBuilder();
        builder.setTaskInfo(creatTaskMsgInfo(occupationTask));
        playerContext.write(CmdCode._75609, builder.build());
    }


    //封装任务信息
    private CrusadeGroupOccupationGMsg.PSOccupationTaskInfo.Builder creatTaskMsgInfo(OccupationTask occupationTask) {
        CrusadeGroupOccupationGMsg.PSOccupationTaskInfo.Builder taskInfo = CrusadeGroupOccupationGMsg.PSOccupationTaskInfo.newBuilder();
        taskInfo.setTaskId(occupationTask.getTaskId());
        taskInfo.setTargetCount(occupationTask.getCount());//计数
        taskInfo.setCondition(occupationTask.getCondition());
        taskInfo.setCompleteType(occupationTask.getComplete_type());//玩家手动完成状态
        return taskInfo;
    }

}
