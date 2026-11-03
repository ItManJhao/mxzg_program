package com.ayjs.mxzg.gameserver.module.achievement.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DailyTaskMainTestSysCache;
import com.ayjs.mxzg.config.excel.cache.DailyTaskPointSysCache;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskMainTest;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.achievement.dao.DailyTaskDao;
import com.ayjs.mxzg.gameserver.module.achievement.dao.RoleDailyTaskDao;
import com.ayjs.mxzg.gameserver.module.achievement.domain.DailyTask;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleDailyTask;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.AchievementGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 15:44
 */
@Service
@Slf4j
public class DailyTaskService {

    @Autowired
    RoleService roleService;
    @Autowired
    DailyTaskDao dailyTaskDao;
    @Autowired
    RoleDailyTaskDao roleDailyTaskDao;
    @Autowired
    DailyTaskMainTestSysCache dailyTaskMainTestSysCache;
    @Autowired
    DailyTaskPointSysCache dailyTaskPointSysCache;
    @Autowired
    ThingService thingService;
    @Autowired
    ContextManager contextManager;

    /***
     * 获取玩家每日任务模块数据
     * @param rid
     * @return
     */
    public RoleDailyTask loadRoleDailyTask(long rid) {
        if (rid == 0) {
            log.error("rid = 0", new Exception());
        }
        RoleDailyTask roleDailyTask = roleDailyTaskDao.get(rid);
        if (roleDailyTask == null) {
            roleDailyTask = new RoleDailyTask();
            roleDailyTask.setRid(rid);
            roleDailyTaskDao.add(roleDailyTask);
        }
        if (!TimeDateUtil.isToday(roleDailyTask.getBoxRefreshTime())) {
            roleDailyTask.setTaskValue(0);
            roleDailyTask.getRewards().clear();
            roleDailyTask.setBoxRefreshTime(TimeDateUtil.getCurrentTimeInt());
            roleDailyTaskDao.update(roleDailyTask);
        }
        return roleDailyTask;
    }

    /***
     * 获取玩家所有任务
     * @param rid
     * @return
     */
    public List<DailyTask> getDailyTasks(long rid) {
        List<DailyTask> newList = resetDailyTask(rid);
        checkNewTask(rid);
        if (newList == null) {
            newList = dailyTaskDao.getAllByRid(rid);
        }
        return newList;
    }

    /***
     * 获取特定配置的任务
     * @param rid
     * @param idx
     * @return
     */
    public DailyTask getDailyTaskByRidAndId(long rid, int idx) {
        return getDailyTasks(rid).stream().filter(task -> task.getTaskId() == idx).findFirst().orElse(null);
    }


    public List<DailyTask> resetDailyTask(long rid) {
        RoleDailyTask roleDailyTask = loadRoleDailyTask(rid);
        if (TimeDateUtil.isToday(roleDailyTask.getTaskResetTime())) {
            return null;
        }
        List<DailyTask> currList = dailyTaskDao.getAllByRid(rid);
        long now = System.currentTimeMillis();
        List<CDailyTaskMainTest> allConfig = dailyTaskMainTestSysCache.getAll();
        if (!currList.isEmpty()) {
            //重置所有任务
            currList.forEach(entity -> {
                entity.setProgress(0);
                entity.setHadReward(0);
                entity.setLastTime(now);
            });
            dailyTaskDao.update(currList);
            //检查是否有新的任务类型
            Map<Integer, DailyTask> map = currList.stream().collect(Collectors.toMap(DailyTask::getTaskId, Function.identity()));
            allConfig.forEach(config -> {
                DailyTask dailyTask = map.get(config.getIdx());
                if (dailyTask == null) {
                    dailyTask = new DailyTask();
                    dailyTask.setRid(rid);
                    dailyTask.setTaskId(config.getIdx());
                    dailyTask.setLastTime(now);
                    dailyTaskDao.add(dailyTask);
                }
            });
        } else {//创号的时候,初始化所有任务
            allConfig.forEach(config -> {
                DailyTask task = new DailyTask();
                task.setRid(rid);
                task.setTaskId(config.getIdx());
                task.setLastTime(now);
                currList.add(task);
            });
            dailyTaskDao.add(currList);
        }
        roleDailyTask.setTaskResetTime(now);
        roleDailyTaskDao.update(roleDailyTask);
        return currList;
    }

    public void checkNewTask(long rid) {
        //检查是否有新的任务类型
        List<CDailyTaskMainTest> allConfig = dailyTaskMainTestSysCache.getAll();
        long now = System.currentTimeMillis();
        Map<Integer, DailyTask> map = dailyTaskDao.getAllByRid(rid).stream().collect(Collectors.toMap(DailyTask::getTaskId, Function.identity()));
        allConfig.forEach(config -> {
            DailyTask dailyTask = map.get(config.getIdx());
            if (dailyTask == null) {
                dailyTask = new DailyTask();
                dailyTask.setRid(rid);
                dailyTask.setTaskId(config.getIdx());
                dailyTask.setLastTime(now);
                dailyTaskDao.add(dailyTask);
            }
        });
    }

    public void updateRoleDailyTask(RoleDailyTask roleDailyTask) {
        roleDailyTaskDao.update(roleDailyTask);
    }

    private void updateTask(DailyTask dailyTask) {
        dailyTaskDao.update(dailyTask);
    }

    public AchievementGMsg.GResDailyTaskList sendDailyTaskData(long rid) {
        AchievementGMsg.GResDailyTaskList.Builder builder = AchievementGMsg.GResDailyTaskList.newBuilder();
        getDailyTasks(rid).forEach(task -> {
            builder.addTask(builderTaskData(task));
        });

        RoleDailyTask roleDailyTask = loadRoleDailyTask(rid);
        builder.addAllRewardBoxIdx(loadRoleDailyTask(rid).getRewards());
        builder.setDailyValue(roleDailyTask.getTaskValue());
        return builder.build();
    }

    public AchievementGMsg.GResDailyTaskGetReward getReward(long rid, DailyTask dailyTask, CDailyTaskMainTest config) {
        dailyTask.setHadReward(1);
        updateTask(dailyTask);
        RoleDailyTask roleDailyTask = loadRoleDailyTask(rid);
        roleDailyTask.addTaskValue(config.getPoint());
        updateRoleDailyTask(roleDailyTask);
        //奖励
        thingService.add(rid, config.getReward(), GameEvent.DAILY_TASK);

        AchievementGMsg.GResDailyTaskGetReward.Builder builder = AchievementGMsg.GResDailyTaskGetReward.newBuilder();
        builder.setDailyValue(roleDailyTask.getTaskValue());
        builder.addTask(builderTaskData(dailyTask));
        return builder.build();
    }


    public void addProcess(long rid, List<CDailyTaskMainTest> configs, int addValue) {
        if (addValue == 0)
            return;
        List<DailyTask> list = new ArrayList<>();
        Map<Integer, DailyTask> map = getDailyTasks(rid).stream().collect(Collectors.toMap(DailyTask::getTaskId, Function.identity()));

        for (CDailyTaskMainTest config : configs) {
            DailyTask dailyTask = map.get(config.getIdx());
            if (dailyTask == null)
                continue;
            int newValue = addValue + dailyTask.getProgress();
            dailyTask.setProgress(newValue);

            list.add(dailyTask);
        }

        if (list.isEmpty())
            return;
        dailyTaskDao.update(list);

        AchievementGMsg.GResUpdateDailyTask.Builder builder = AchievementGMsg.GResUpdateDailyTask.newBuilder();
        list.forEach(task -> {
            builder.addUpdateTasks(builderTaskData(task));
        });
        contextManager.write(rid, CmdCode._12023, builder.build());
    }

    private AchievementGMsg.PSTaskData builderTaskData(DailyTask task) {
        AchievementGMsg.PSTaskData.Builder builder = AchievementGMsg.PSTaskData.newBuilder();
        builder.setIdx(task.getTaskId());
        builder.setState(task.getHadReward());
        CDailyTaskMainTest config = dailyTaskMainTestSysCache.getById(task.getTaskId());
        builder.setProcess(Math.min(task.getProgress(), config.getTask().getTarget()));
        return builder.build();
    }

}
