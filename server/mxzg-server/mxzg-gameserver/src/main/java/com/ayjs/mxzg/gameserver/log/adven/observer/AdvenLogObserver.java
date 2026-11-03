package com.ayjs.mxzg.gameserver.log.adven.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.adven.domain.AdvenChallengeLog;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2020/1/19
 **/
@Observer
@Controller
public class AdvenLogObserver {
    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe(async = AsyncType.AsyncLog)
    public void log(AdvenPassEvent event) {
        AdvenChallengeLog advenChallengeLog = logEntityFactory.create(AdvenChallengeLog.class);
        advenChallengeLog.setChallengeTime(TimeDateUtil.getCurrentTimeInt());
        advenChallengeLog.setMissionId(event.getBattleMissionId());
        advenChallengeLog.setRid(event.getRid());
        advenChallengeLog.setWin(event.isWin());
        logService.addLog(advenChallengeLog);
    }
}
