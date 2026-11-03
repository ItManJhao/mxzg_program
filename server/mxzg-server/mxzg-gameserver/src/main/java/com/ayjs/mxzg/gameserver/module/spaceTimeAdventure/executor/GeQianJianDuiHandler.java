package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 搁浅舰队
 *
 * @author hyx
 */
@Component
public class GeQianJianDuiHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.GE_QIAN_JIAN_DUI;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
        thingService.cost(spaceTimeInfo.getRid(), cSpaceTimeEventShow.getCost(), GameEvent.SPACE_TIME_EVENT_COST);

        SpaceTimeAdventureGMsg.GResFleetEventSeven.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventSeven.newBuilder();
        builder.addAllBuff(spaceTimeInfoService.addBuff(spaceTimeInfo, cSpaceTimeEventShow.getBuff()));
        builder.setDurability(spaceTimeInfo.getDurability());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74138, builder.build());
    }
}
