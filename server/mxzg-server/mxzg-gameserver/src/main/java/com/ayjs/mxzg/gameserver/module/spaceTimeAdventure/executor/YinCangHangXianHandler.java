package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.config.struct.FleetUnlockStruct;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 隐藏航线
 *
 * @author hyx
 */
@Component
public class YinCangHangXianHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.YIN_CANG_HANG_XIAN;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
        List<FleetUnlockStruct> unlockRoutes = cSpaceTimeEventShow.getRoute().stream().filter(config ->
                !spaceTimeInfo.getUnlockRoutes().contains(config.getUnlock_route())).collect(Collectors.toList());
        if (!unlockRoutes.isEmpty()) {
            FleetUnlockStruct fleetUnlockStruct = DropUtil.randomDrop(unlockRoutes);
            spaceTimeInfo.getUnlockRoutes().add(fleetUnlockStruct.getUnlock_route());
            spaceTimeInfoService.update(spaceTimeInfo);

            SpaceTimeAdventureGMsg.GResFleetEventFour.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventFour.newBuilder();
            builder.setRouteId(fleetUnlockStruct.getUnlock_route());
            contextManager.write(spaceTimeInfo.getRid(), CmdCode._74135, builder.build());
        }
    }
}
