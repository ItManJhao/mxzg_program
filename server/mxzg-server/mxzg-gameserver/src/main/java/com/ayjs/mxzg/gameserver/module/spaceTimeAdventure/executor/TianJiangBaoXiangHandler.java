package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

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
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 天降宝箱
 * @author hyx
 */
@Component
public class TianJiangBaoXiangHandler implements IFleetEventHandler {

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
        return FleetEventType.TIAN_JIANG_BAO_XIANG;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());
        thingService.cost(spaceTimeInfo.getRid(), cSpaceTimeEventShow.getCost(), GameEvent.SPACE_TIME_EVENT_COST);

        //获得道具
        List<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(cSpaceTimeEventShow.getGroup());
        List<ObjectGMsg.PSBackpackData> builderList = spaceTimeInfoService.addItem(spaceTimeInfo, rewardList, GameEvent.SPACE_TIME_EVENT_REWARD);

        SpaceTimeAdventureGMsg.GResFleetEventEight.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventEight.newBuilder();
        builder.addAllItemList(builderList);
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74139, builder.build());

    }

}
