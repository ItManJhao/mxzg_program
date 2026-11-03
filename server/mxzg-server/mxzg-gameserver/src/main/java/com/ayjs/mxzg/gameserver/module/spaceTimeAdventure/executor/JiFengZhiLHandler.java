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
 * 疾风之力
 *
 * @author hyx
 */
@Component
public class JiFengZhiLHandler implements IFleetEventHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private ContextManager contextManager;


    @Override
    public FleetEventType thisType() {
        return FleetEventType.JI_FENG_ZHI_Li;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
        thingService.cost(spaceTimeInfo.getRid(), cSpaceTimeEventShow.getCost(), GameEvent.SPACE_TIME_EVENT_COST);

        //前端请求选推送改变再增加BUFF
        SpaceTimeAdventureGMsg.GResFleetEventEleven.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventEleven.newBuilder();
        for (FleetSailingStruct fleetSailingStruct : cSpaceTimeEventShow.getBuff()) {
            builder.addBuff(spaceTimeInfoService.builderFleetBuff(fleetSailingStruct.getType(), fleetSailingStruct.getEffect()));
        }
        builder.setDurability(spaceTimeInfo.getDurability());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74148, builder.build());

        spaceTimeInfoService.addBuff(spaceTimeInfo, cSpaceTimeEventShow.getBuff());
    }
}
