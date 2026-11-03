package com.ayjs.mxzg.gameserver.log.spaceTime.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.log.spaceTime.domain.FleetSailingEventLog;
import com.ayjs.mxzg.gameserver.log.spaceTime.domain.FleetSailingLog;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingEndEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingStartEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class FleetSailingObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe
    public void listen(SailingStartEvent event) {
        FleetSailingLog log = getLog(event.getRid(), 0);
        logService.addLog(log);
    }

    @Subscribe
    public void listen(SailingEndEvent event) {
        FleetSailingLog log = getLog(event.getRid(), 1);
        logService.addLog(log);
    }

    private FleetSailingLog getLog(long rid, int type) {
        FleetSailingLog log = logEntityFactory.create(FleetSailingLog.class);
        log.setRid(rid);
        log.setType(type);
        log.setTime(DateTimeUtil.currentSecond());
        return log;
    }

    @Subscribe
    public void listen(SailingExploreEvent event) {
        FleetSailingEventLog log = logEntityFactory.create(FleetSailingEventLog.class);
        log.setRid(event.getRid());
        log.setRoute(event.getRouteId());
        FleetEventType fleetEventType = FleetEventType.valueOf(event.getEventId());
        log.setEventId(fleetEventType.getEventId());
        log.setEventDesc(fleetEventType.getDesc());
        log.setTime(DateTimeUtil.currentSecond());
        logService.addLog(log);
    }

}
