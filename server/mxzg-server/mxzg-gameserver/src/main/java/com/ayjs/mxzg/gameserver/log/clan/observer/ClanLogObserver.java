/**
 *
 */
package com.ayjs.mxzg.gameserver.log.clan.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.gameserver.log.clan.domain.ClanCreateOrDissolutionLog;
import com.ayjs.mxzg.gameserver.log.clan.domain.ClanExpLog;
import com.ayjs.mxzg.gameserver.log.clan.domain.ClanJobChangeLog;
import com.ayjs.mxzg.gameserver.log.clan.domain.ClanMemberChangeLog;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanCreateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanExpAddEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanJobChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class ClanLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private ClanService clanService;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ClanExpAddEvent event) {
        ClanExpLog log = logEntityFactory.create(ClanExpLog.class);
        log.setRid(event.getRid());
        log.setDelta(event.getAddCount());
        log.setCurr(event.getCurr());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        log.setClanId(event.getClanId());
        log.setOldLv(event.getOldLv());
        log.setCurrLv(event.getCurrLv());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ClanChangeEvent event) {

        if (event.getNewClanId() > 0) {
            clanMemberChange(event.getRid(), event.getNewClanId(), 0);
        }
        if (event.getOldClanId() > 0) {
            clanMemberChange(event.getRid(), event.getOldClanId(), 1);
        }

    }

    private void clanMemberChange(long rid, long clan, int type) {
		ClanMemberChangeLog log = logEntityFactory.create(ClanMemberChangeLog.class);
		log.setRid(rid);
		log.setClanId(clan);
		log.setTime(DateTimeUtil.currentSecond());
    	log.setEventType(type);
    	logService.addLog(log);
    }


    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ClanJobChangeEvent event) {

        clanJobChange(event.getClanId(),event.getRid(),event.getMemberId(),
				event.getNewJob(),event.getOldJob(),event.getTime());

    }

    private void clanJobChange(long clanId, long rid, long memberId, ClanJobEnum newJob, ClanJobEnum oldJob, int time){
    	ClanJobChangeLog log = logEntityFactory.create(ClanJobChangeLog.class);
    	log.setRid(rid);
    	log.setClanId(clanId);
    	log.setTime(time);
    	log.setNewJob(newJob.getJobNick());
    	log.setOldJob(oldJob.getJobNick());
    	log.setMemberId(memberId);
    	logService.addLog(log);
	}

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ClanCreateEvent event){
        ClanCreateOrDissolutionLog log = logEntityFactory.create(ClanCreateOrDissolutionLog.class);
        Clan clan = clanService.getOrThrow(event.getClanId());
        log.setClanId(event.getClanId());
        log.setClanName(clan.getClanName());
        log.setRid(event.getRid());
        log.setEventType(0);
        log.setTime(DateTimeUtil.currentSecond());
        logService.addLog(log);
    }

}
