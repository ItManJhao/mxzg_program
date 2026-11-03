package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 航线礼包
 *
 * @author hyx
 */
@Component
@Observer
public class HangXianLiBaoHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.HANG_XIAN_LI_BAO;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        //无需执行
    }

    @Subscribe
    public void listen(SailingExploreEvent event) {
        if (event.getEventId() != thisType().getEventId()) {
            return;
        }
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());

        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
        if (cSpaceTimeEventShow.getProduct_id() > 0) {
            spaceTimeInfo.setProductEndTime(DateTimeUtil.currentSecond() + SpaceTimeAdventureConst.SPACETIME_PRODUCT_OPEN_TIME);
            spaceTimeInfo.setProductIdx(cSpaceTimeEventShow.getProduct_id());
            spaceTimeInfo.setProductBuy(0);
            spaceTimeInfo.setEventId(0);
            spaceTimeInfoService.update(spaceTimeInfo);

            SpaceTimeAdventureGMsg.GResFleetEventTen.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventTen.newBuilder();
            builder.setProductEndTime(spaceTimeInfo.getProductEndTime());
            builder.setProductId(cSpaceTimeEventShow.getProduct_id());
            contextManager.write(event.getRid(), CmdCode._74147, builder.build());
        }
    }


}
