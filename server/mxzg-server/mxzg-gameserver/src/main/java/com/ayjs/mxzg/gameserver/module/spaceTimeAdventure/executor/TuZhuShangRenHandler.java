package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeShopSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeShop;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 土著商人事件
 *
 * @author hyx
 */
@Component
@Observer
public class TuZhuShangRenHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeShopSysCache spaceTimeShopSysCache;
    @Autowired
    private ContextManager contextManager;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.TU_ZHU_SHANG_REN;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        this.sendShopItem(spaceTimeInfo);
    }

    /**
     * 解锁土著商店
     *
     * @param event
     */
    @Subscribe
    public void listen(SailingExploreEvent event) {
        if (event.getEventId() == thisType().getEventId()) {
            SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
            List<CSpaceTimeShop> itemList = spaceTimeShopSysCache.getAll().stream().filter(config -> config.getRoute_id() == spaceTimeInfo.getRouteId()).collect(Collectors.toList());
            DropUtil.randomDifDrop(itemList, SpaceTimeAdventureConst.SPACETIME_SHOP_ITEM_LIMIT).forEach(config -> {
                spaceTimeInfo.getShopItems().put(config.getIdx(), 0);
            });
            spaceTimeInfo.setShopEndTime(DateTimeUtil.currentSecond() + SpaceTimeAdventureConst.SPACETIME_SHOP_OPEN_TIME_LIMIT);
            spaceTimeInfo.setEventId(0);
            spaceTimeInfoService.update(spaceTimeInfo);

            this.sendShopItem(spaceTimeInfo);
        }
    }

    private void sendShopItem(SpaceTimeInfo spaceTimeInfo) {
        SpaceTimeAdventureGMsg.GResFleetEventSix.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventSix.newBuilder();
        spaceTimeInfo.getShopItems().forEach((key, value) -> {
            SpaceTimeAdventureGMsg.PSShopItemData.Builder item = SpaceTimeAdventureGMsg.PSShopItemData.newBuilder();
            item.setIdx(key);
            item.setBuyNum(value);
            builder.addShopList(item);
        });
        builder.setEndTime(spaceTimeInfo.getShopEndTime());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74137, builder.build());
    }
}
