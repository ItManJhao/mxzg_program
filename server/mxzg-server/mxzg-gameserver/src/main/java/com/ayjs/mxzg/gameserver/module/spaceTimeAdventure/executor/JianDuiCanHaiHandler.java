package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
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
 * 舰队残骸事件
 *
 * @author hyx
 */
@Component
public class JianDuiCanHaiHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.JIAN_DUI_CAN_HAI;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getOrThrow(thisType().getEventId());
        //获得道具
        List<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(cSpaceTimeEventShow.getGroup());
        List<ObjectGMsg.PSBackpackData> builderList = spaceTimeInfoService.addItem(spaceTimeInfo, rewardList, GameEvent.SPACE_TIME_EVENT_REWARD);

        SpaceTimeAdventureGMsg.GResFleetEventOne.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventOne.newBuilder();
        builder.addAllItemList(builderList);
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74132, builder.build());
    }

}
