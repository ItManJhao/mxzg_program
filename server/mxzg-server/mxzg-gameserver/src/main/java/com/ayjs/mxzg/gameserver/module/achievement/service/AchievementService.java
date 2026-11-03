package com.ayjs.mxzg.gameserver.module.achievement.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.AchievementTestSysCache;
import com.ayjs.mxzg.config.excel.entity.CAchievementTest;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.achievement.dao.RoleAchievementRecordDao;
import com.ayjs.mxzg.gameserver.module.achievement.dao.TaskAchievementTestDao;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleAchievementRecord;
import com.ayjs.mxzg.gameserver.module.achievement.domain.TaskAchievementTest;
import com.ayjs.mxzg.gameserver.module.achievement.event.AchievementRewardEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.TaskCountChangeEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.AchievementGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/11 22:03
 */
@Service
@Observer
public class AchievementService {
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleAchievementRecordDao roleAchievementRecordDao;
    @Autowired
    private TaskAchievementTestDao taskAchievementTestDao;
    @Autowired
    private AchievementTestSysCache achievementTestSysCache;
    @Autowired
    private EventBus eventBus;

    public RoleAchievementRecord loadAchievementRecord(long rid) {
        RoleAchievementRecord entity = roleAchievementRecordDao.get(rid);
        if (entity == null) {
            entity = new RoleAchievementRecord();
            entity.setRid(rid);
            roleAchievementRecordDao.add(entity);
        }
        if (entity.getCompleteList().size() > entity.getCompleteTipsIdx().size()) {
            entity.getCompleteTipsIdx().addAll(entity.getCompleteList());
            roleAchievementRecordDao.update(entity);
        }

        return entity;
    }

    /***
     * 得到玩家所有成就任务
     * @param rid
     * @return
     */
    public List<TaskAchievementTest> getRoleAllTask(long rid) {
        List<TaskAchievementTest> tasks = taskAchievementTestDao.getAllByRid(rid);
        RoleAchievementRecord roleRecord = loadAchievementRecord(rid);
        if (roleRecord.getAcceptFirsts().size() == achievementTestSysCache.getFirstTask().size()) {
            return tasks;
        }
        //创建新的任务链
        Set<Integer> allFirstTask = new HashSet<>(achievementTestSysCache.getFirstTask());
        allFirstTask.removeAll(roleRecord.getAcceptFirsts());
        //创建任务
        List<TaskAchievementTest> newTasks = new ArrayList<>();
        allFirstTask.forEach(idx -> {
            TaskAchievementTest taskNew = new TaskAchievementTest();
            taskNew.setRid(rid);
            taskNew.setCurrTask(idx);
            newTasks.add(taskNew);
            tasks.add(taskNew);

        });
        roleRecord.getAcceptFirsts().addAll(allFirstTask);
        roleAchievementRecordDao.update(roleRecord);
        taskAchievementTestDao.add(newTasks);
        return tasks;
    }

    //TODO 登录检测任务链

    /***
     * 获取玩家任务
     * @param rid
     * @param idx
     * @return
     */
    public TaskAchievementTest getRoleTaskByIdx(long rid, int idx) {
        return getRoleAllTask(rid).stream().filter(task -> task.getCurrTask() == idx).findFirst().orElse(null);
    }

    public AchievementGMsg.GResAchievementList achievementList(long rid) {
        List<TaskAchievementTest> roleAllTask = getRoleAllTask(rid);
        //接取新任务
        List<TaskAchievementTest> newAcceptTask = new ArrayList<>();
        List<TaskAchievementTest> needRemove = new ArrayList<>();
        roleAllTask.forEach(task -> {
            List<Integer> subTasks = achievementTestSysCache.getSubTask().get(task.getCurrTask());
            if (task.getHadReward() == 1 && subTasks != null && subTasks.isEmpty()) {
                newAcceptTask.addAll(createSubTask(rid, subTasks));
                needRemove.add(task);
            }
        });
        if (newAcceptTask.isEmpty()) {
            taskAchievementTestDao.add(newAcceptTask);
            taskAchievementTestDao.remove(needRemove);
            roleAllTask.addAll(newAcceptTask);
            roleAllTask.removeAll(needRemove);
        }

        AchievementGMsg.GResAchievementList.Builder builder = AchievementGMsg.GResAchievementList.newBuilder();
        roleAllTask.forEach(task -> {
            builder.addTask(builderTaskData(task));
        });
        return builder.build();
    }

    private AchievementGMsg.PSTaskData builderTaskData(TaskAchievementTest task) {
        AchievementGMsg.PSTaskData.Builder builder = AchievementGMsg.PSTaskData.newBuilder();
        builder.setIdx(task.getCurrTask());
        builder.setState(task.getHadReward());
        builder.setProcess((int) targetCounterService.calcTaskCount(task.getRid(), achievementTestSysCache.getOrThrow(task.getCurrTask()).getTask()));
        return builder.build();
    }

    public AchievementGMsg.GResAchievementGetReward achievementGetReward(long rid, TaskAchievementTest task) {
        List<Integer> subTask = achievementTestSysCache.getSubTask().get(task.getCurrTask());
        RoleAchievementRecord record = loadAchievementRecord(rid);
        int oldTaskId = task.getCurrTask();

        task.setHadReward(1);
        record.getCompleteList().add(task.getCurrTask());
        roleAchievementRecordDao.update(record);
        List<TaskAchievementTest> newTasks = null;
        //不存在子任务时，不移除当前任务，客户端要展示
        if (subTask != null && !subTask.isEmpty()) {
            taskAchievementTestDao.remove(task);
            //接取子任务
            newTasks = createSubTask(rid, subTask);
            taskAchievementTestDao.add(newTasks);
        } else {
            taskAchievementTestDao.update(task);
        }

        CAchievementTest config = achievementTestSysCache.getOrThrow(oldTaskId);
        thingService.add(rid, config.getReward(), GameEvent.ACHIEVEMENT_ACHIEVE_GET);
        AchievementGMsg.GResAchievementGetReward.Builder builder = AchievementGMsg.GResAchievementGetReward.newBuilder();
        builder.setIdx(oldTaskId);
        if (newTasks == null) {
            builder.setLastTask(builderTaskData(task));
        } else {
            newTasks.forEach(taskTemp -> {
                builder.addAddTasks(builderTaskData(taskTemp));
            });
        }

        eventBus.post(AchievementRewardEvent.of(rid, task.getCurrTask()));

        return builder.build();
    }

    private List<TaskAchievementTest> createSubTask(long rid, List<Integer> taskIds) {
        List<TaskAchievementTest> newTasks = new ArrayList<>();
        taskIds.forEach(subId -> {
            TaskAchievementTest taskNew = new TaskAchievementTest();
            taskNew.setRid(rid);
            taskNew.setCurrTask(subId);
            newTasks.add(taskNew);
        });
        return newTasks;
    }

    @Subscribe
    public void taskCountChange(TaskCountChangeEvent event) {

        sendCompleteTask(event);

        List<TaskAchievementTest> list = getRoleAllTask(event.getRid()).stream().filter(entity ->
                achievementTestSysCache.getOrThrow(entity.getCurrTask()).getTask().getType() == event.getTargetType())
                .collect(Collectors.toList());
        if (list.isEmpty()) {
            return;
        }
        AchievementGMsg.GResUpdateAchievementTask.Builder builder = AchievementGMsg.GResUpdateAchievementTask.newBuilder();
        list.forEach(task -> builder.addUpdateTasks(builderTaskData(task)));
        contextManager.write(event.getRid(), CmdCode._12012, builder.build());
    }

    private void sendCompleteTask(TaskCountChangeEvent event) {
        //飘字提示
        RoleAchievementRecord achievementRecord = loadAchievementRecord(event.getRid());
        //找出类型和未提示的成就任务
        List<CAchievementTest> configList = achievementTestSysCache.getAll().stream().filter(config ->
                config.getTask().getType() == event.getTargetType() &&
                        !achievementRecord.getCompleteTipsIdx().contains(config.getIdx()))
                .collect(Collectors.toList());

        if (configList.isEmpty()) {
            return;
        }

        List<Integer> completeIds = new ArrayList<>();
        configList.forEach(config -> {
            int calcCount = (int) targetCounterService.calcTaskCount(event.getRid(), config.getTask());
            if (calcCount >= config.getTask().getTarget()) {
                completeIds.add(config.getIdx());
            }
        });
        achievementRecord.getCompleteTipsIdx().addAll(completeIds);
        roleAchievementRecordDao.update(achievementRecord);

        AchievementGMsg.GResAchievementTaskComplete.Builder builder = AchievementGMsg.GResAchievementTaskComplete.newBuilder();
        builder.addAllCompleteIds(completeIds);
        contextManager.write(event.getRid(), CmdCode._12013, builder.build());
    }
}
