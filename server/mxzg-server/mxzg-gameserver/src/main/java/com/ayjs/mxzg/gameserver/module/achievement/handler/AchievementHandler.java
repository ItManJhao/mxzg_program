package com.ayjs.mxzg.gameserver.module.achievement.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.AchievementTestSysCache;
import com.ayjs.mxzg.config.excel.cache.DailyTaskMainTestSysCache;
import com.ayjs.mxzg.config.excel.cache.DailyTaskPointSysCache;
import com.ayjs.mxzg.config.excel.entity.CAchievementTest;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskMainTest;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskPoint;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.achievement.domain.DailyTask;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleDailyTask;
import com.ayjs.mxzg.gameserver.module.achievement.domain.TaskAchievementTest;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.achievement.service.AchievementService;
import com.ayjs.mxzg.gameserver.module.achievement.service.DailyTaskService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.AchievementGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/11 15:29
 */
@Component
public class AchievementHandler extends ProtocolHandler {

    @Autowired
    private AchievementService achievementService;
    @Autowired
    private DailyTaskService dailyTaskService;
    @Autowired
    private DailyTaskPointSysCache dailyTaskPointSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private AchievementTestSysCache achievementTestSysCache;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private DailyTaskMainTestSysCache dailyTaskMainTestSysCache;
    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._12010)
    public void achievementList(PlayerContext playerContext, AchievementGMsg.GReqAchievementList req) {
        playerContext.write(CmdCode._12010, achievementService.achievementList(playerContext.getId()));
    }

    @CMD(id = CmdCode._12011)
    public void achievementGetReward(PlayerContext playerContext, AchievementGMsg.GReqAchievementGetReward req) {
        CAchievementTest config = achievementTestSysCache.getOrThrow(req.getIdx());
        TaskAchievementTest task = achievementService.getRoleTaskByIdx(playerContext.getId(), req.getIdx());
        Asserts.notNull(task, ErrorCode.ACHIEVEMENT_TASK_NOT_EXIST.getValue(), String.format("不存在该任务{%s}", req.getIdx()));

        long count = targetCounterService.calcTaskCount(playerContext.getId(), config.getTask());
        Asserts.isTrue(config.getTask().getTarget() <= count, ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(),
                String.format("[%s]进度不足，要求{%s}，当前{%s}", req.getIdx(), config.getTask().getTarget(), count));

        Asserts.isTrue(task.getHadReward() == 0, ErrorCode.ACHIEVEMENT_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}", task.getHadReward()));

        playerContext.write(CmdCode._12011, achievementService.achievementGetReward(playerContext.getId(), task));
    }


    /***
     * 每日任务数据
     */
    @CMD(id = CmdCode._12020)
    public void sendDailyTaskData(PlayerContext playerContext, AchievementGMsg.GReqDailyTaskList msg) {
        playerContext.write(CmdCode._12020, dailyTaskService.sendDailyTaskData(playerContext.getId()));
    }

    /***
     * 领取每日任务
     *
     */
    @CMD(id = CmdCode._12021)
    public void getReward(PlayerContext playerContext, AchievementGMsg.GReqDailyTaskGetReward req) {
        long rid = playerContext.getId();
        int idx = req.getTaskId();
        CDailyTaskMainTest taskConfig = dailyTaskMainTestSysCache.getOrThrow(idx);
        Role role = roleService.getOrThrow(rid);

        Asserts.isTrue(role.getLevel() >= taskConfig.getOpen_level(),
                ErrorCode.DAILY_TASK_NOT_EXIST.getValue(), String.format("不存在该任务{%s}", idx));

        DailyTask dailyTask = dailyTaskService.getDailyTaskByRidAndId(rid, taskConfig.getIdx());
        Asserts.notNull(dailyTask, ErrorCode.DAILY_TASK_NOT_EXIST.getValue(), String.format("不存在该任务{%s}", idx));

        Asserts.isTrue(taskConfig.getTask().getTarget() <= dailyTask.getProgress(),
                ErrorCode.DAILY_TASK_PROCESS_LOW.getValue(),
                String.format("任务进度不够,当前进度{%s},配置要求{%s}", dailyTask.getProgress(), taskConfig.getTask().getTarget()));

        Asserts.isTrue(dailyTask.getHadReward() <= 0,
                ErrorCode.DAILY_TASK_HAD_REWARD.getValue(), String.format("奖励已经领取,当前进度{%s}", dailyTask.getHadReward()));

        playerContext.write(CmdCode._12021, dailyTaskService.getReward(rid, dailyTask, taskConfig));

        eventBus.post(DailyTaskRewardEvent.of(playerContext.getId(), taskConfig.getIdx(), taskConfig.getPoint()));

    }

    /***
     * 领取宝箱
     */
    @CMD(id = CmdCode._12022)
    public void getBoxReward(PlayerContext playerContext, AchievementGMsg.GReqDailyTaskBoxGetReward req) {
        long rid = playerContext.getId();
        int idx = req.getBoxId();
        CDailyTaskPoint dailyTaskMain = dailyTaskPointSysCache.getOrThrow(idx);

        RoleDailyTask roleDailyTask = dailyTaskService.loadRoleDailyTask(rid);

        Asserts.isTrue(!roleDailyTask.getRewards().contains(Integer.valueOf(idx)),
                ErrorCode.DAILY_TASK_HAD_REWARD.getValue(), String.format("奖励已经领取,当前进度{%s}", JsonUtil.toJson(roleDailyTask.getRewards())));

        Asserts.isTrue(roleDailyTask.getTaskValue() >= dailyTaskMain.getPoint(),
                ErrorCode.DAILY_TASK_VALUE_LOW.getValue(), String.format("活跃值不够{%s},要求活跃值{%s}", roleDailyTask.getTaskValue(), dailyTaskMain.getPoint()));

        roleDailyTask.getRewards().add(idx);
        dailyTaskService.updateRoleDailyTask(roleDailyTask);
        //奖励
        thingService.add(rid, dailyTaskMain.getReward(), GameEvent.DAILY_TASK);
        AchievementGMsg.GResDailyTaskBoxGetReward.Builder builder = AchievementGMsg.GResDailyTaskBoxGetReward.newBuilder();
        builder.setBoxId(idx);
        playerContext.write(CmdCode._12022, builder.build());
    }
}
