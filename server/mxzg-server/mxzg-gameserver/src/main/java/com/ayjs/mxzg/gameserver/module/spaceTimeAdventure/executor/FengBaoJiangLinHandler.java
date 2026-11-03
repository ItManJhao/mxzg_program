package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 风暴降临
 *
 * @author hyx
 */
@Component
public class FengBaoJiangLinHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.FENG_BAO_JIANG_LIN;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());

        SpaceTimeAdventureGMsg.GResFleetEventFive.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventFive.newBuilder();
        builder.addAllBuff(spaceTimeInfoService.addBuff(spaceTimeInfo, cSpaceTimeEventShow.getBuff()));
        builder.addAllBuff(spaceTimeInfoService.addDebuff(spaceTimeInfo, cSpaceTimeEventShow.getDebuff()));
        builder.setDurability(spaceTimeInfo.getDurability());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74136, builder.build());
    }

}
