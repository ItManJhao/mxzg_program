package com.ayjs.mxzg.gameserver.log.task.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.task.domain.AchievementLog;
import com.ayjs.mxzg.gameserver.log.task.domain.DailyTaskLog;
import com.ayjs.mxzg.gameserver.module.achievement.event.AchievementRewardEvent;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author: CWJ
 * @Date: 2019/11/25
 **/
@Observer
public class AchievementLogObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe
    public void log(AchievementRewardEvent event) {
        AchievementLog entity = logEntityFactory.create(AchievementLog.class);
        entity.setRid(event.getRid());
        entity.setTaskId(event.getTaskId());
        entity.setRewardTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(entity);
//        achievementLogDao.add(entity);

    }

    @Subscribe
    public void log(DailyTaskRewardEvent event) {
        DailyTaskLog entity = logEntityFactory.create(DailyTaskLog.class);
        entity.setRid(event.getRid());
        entity.setTaskId(event.getIdx());
        entity.setRewardTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(entity);
//        achievementLogDao.add(entity);

    }

}
