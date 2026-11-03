package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 什么事都没发生
 *
 * @author hyx
 */
@Component
@Observer
public class MeiYouShiJianHandler implements IFleetEventHandler {


    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.MAI_YOU_SHI_JIAN;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        //没有执行的方法
    }

    /**
     * 发送奖励
     *
     * @param event
     */
    @Subscribe
    public void listen(SailingExploreEvent event) {
        if (event.getEventId() == thisType().getEventId()) {
            SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
            spaceTimeInfo.setEventId(0);
            spaceTimeInfoService.update(spaceTimeInfo);

            CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
            //获得道具
            List<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(cSpaceTimeEventShow.getGroup());
            List<ObjectGMsg.PSBackpackData> builderList = spaceTimeInfoService.addItem(spaceTimeInfo, rewardList, GameEvent.SPACE_TIME_EVENT_REWARD);

            SpaceTimeAdventureGMsg.GResFleetEventNine.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventNine.newBuilder();
            builder.addAllItemList(builderList);
            contextManager.write(spaceTimeInfo.getRid(), CmdCode._74140, builder.build());
        }
    }
}
