package com.ayjs.mxzg.gameserver.module.blessingPool.handler;


import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.WishPoolLuckyRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.BlessingConst;
import com.ayjs.mxzg.config.excel.entity.CWishPoolLuckyReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.blessingPool.constant.BlessingPoolType;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPool;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPoolItemData;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.service.BlessingPoolService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GReqBlessingPoolDone;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GReqBlessingPoolList;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GReqBlessingPoolLuckyReward;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GReqBlessingPoolRefresh;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingData;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingPoolDone;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingPoolList;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingPoolLuckyReward;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingPoolRefresh;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.ResBlessingPoolData;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSBackpackData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 许愿池模块
 */
@Controller
public class BlessingPoolHandler extends ProtocolHandler {

    @Autowired
    private BlessingPoolService blessingPoolService;
    @Autowired
    private WishPoolLuckyRewardSysCache wishPoolLuckyRewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private EventBus eventBus;

    /**
     * 许愿池信息
     */
    @CMD(id = CmdCode._27001)
    public void getBlessingPoolList(PlayerContext playerContext, GReqBlessingPoolList msg) {
        List<BlessingPool> blessingPool = blessingPoolService.getBlessingPool(playerContext.getId());
        GResBlessingPoolList.Builder builder = GResBlessingPoolList.newBuilder();
        for (BlessingPool poolData : blessingPool) {
            builder.addBlessingData(serializeBlessingPool(poolData));
        }
        playerContext.write(CmdCode._27001, builder.build());
    }

    /**
     * 刷新许愿池
     */
    @CMD(id = CmdCode._27002)
    public void blessingPoolRefresh(PlayerContext playerContext, GReqBlessingPoolRefresh msg) {

        BlessingPoolType poolType = BlessingPoolType.of(msg.getType());

        BlessingPool blessingPool = blessingPoolService.getBlessingPoolByType(playerContext.getId(), poolType.getValue());

        int freeTimes = 0;
        int costGem = 0;
        if (BlessingPoolType.Normal == poolType) {
            freeTimes = BlessingConst.NORMAL_DAILY_FREE_TIMES;
            costGem = BlessingConst.NORMAL_REFRESH_COST_GEM;
        } else if (BlessingPoolType.Advance == poolType) {
            freeTimes = BlessingConst.ADVANCE_DAILY_FREE_TIMES;
            costGem = BlessingConst.ADVANCE_REFRESH_COST_GEM;
        }
        if (blessingPool.getRefreshTimes() >= freeTimes) {
            // 收费
            ImmutableThing costThing = ImmutableThing.of(ItemType.IT_GEM, costGem);
            thingService.cost(blessingPool.getRid(), costThing, GameEvent.BLESSING_POOL_REFRESH);
        } else {
            blessingPool.setRefreshTimes(blessingPool.getRefreshTimes() + 1);
            blessingPool.setRefreshDatetime(systemSysCache.getWishpoolFreeRefreshCd() + DateTimeUtil.currentSecond());
        }
        blessingPoolService.refreshBlessingPoolItemData(blessingPool);

        blessingPoolService.updateBlessingPool(blessingPool);

        GResBlessingPoolRefresh.Builder builder = GResBlessingPoolRefresh.newBuilder();
        builder.setBlessingData(serializeBlessingPool(blessingPool));
        playerContext.write(CmdCode._27002, builder.build());
    }

    /**
     * 许愿池抽奖
     */
    @CMD(id = CmdCode._27003, entry = EntryType.MAIN_BLESSINGPOOL)
    public void blessingPoolDone(PlayerContext playerContext, GReqBlessingPoolDone msg) {
        long rid = playerContext.getId();
        BlessingPoolType poolType = BlessingPoolType.of(msg.getType());
        int times = msg.getTimes();
        Asserts.isTrue(times > 0, ErrorCode.ERROR_PARAM.getValue(), () -> "msg.getTimes()=" + times);

        BlessingPool blessingPool = blessingPoolService.getBlessingPoolByType(rid, msg.getType());
        Asserts.notNull(blessingPool, ErrorCode.ERROR_PARAM.getValue(),
                () -> "msg.getType() blessingPool is null");

        // 随机物品
        GResBlessingPoolDone.Builder builder = blessingPoolService.blessingPoolDone(blessingPool, times);

        builder.setBlessingData(serializeBlessingPool(blessingPool));
        playerContext.write(CmdCode._27003, builder.build());


        eventBus.post(BlessingPoolDoneEvent.of(rid, times, poolType));
    }

    @CMD(id = CmdCode._27004)
    public void rewardLucky(PlayerContext playerContext, GReqBlessingPoolLuckyReward req) {
        CWishPoolLuckyReward config = wishPoolLuckyRewardSysCache.getOrThrow(req.getIdx());
        long rid = playerContext.getId();
        BlessingPool blessingPool = blessingPoolService.getBlessingPoolByType(rid, config.getType());
        Asserts.isTrue(!blessingPool.getLuckyRewardIds().contains(req.getIdx()), ErrorCode.BLESSING_POOL_LUCKY_HAD_REWARD.getValue(),
                String.format("该奖励已经领取{%s},请求领取{%s}", blessingPool.getLuckyRewardIds(), req.getIdx()));

        Asserts.isTrue(blessingPool.getLuckyValue() >= config.getLucky_value_need(), ErrorCode.BLESSING_POOL_LUCKY_VALUE_LOW.getValue(),
                String.format("该奖励已经领取{%s},请求领取{%s}", blessingPool.getLuckyRewardIds(), req.getIdx()));


        blessingPool.getLuckyRewardIds().add(config.getIdx());
        List<Integer> luckyRewardConfigIds = wishPoolLuckyRewardSysCache.getAll().stream()
                .filter(configTemp -> configTemp.getType() == blessingPool.getPoolType())
                .map(CWishPoolLuckyReward::getIdx).collect(Collectors.toList());
        if (blessingPool.getLuckyRewardIds().containsAll(luckyRewardConfigIds)) {
            blessingPool.setLuckyValue(blessingPool.getLuckyValue() - wishPoolLuckyRewardSysCache.getMaxLuckyValue());
            blessingPool.getLuckyRewardIds().clear();
        }
        blessingPoolService.updateBlessingPool(blessingPool);

        thingService.add(rid, config.getReward(), GameEvent.BLESSING_POOL_LUCKY_REWARD);

        GResBlessingPoolLuckyReward.Builder builder = GResBlessingPoolLuckyReward.newBuilder();
        builder.setBlessingData(serializeBlessingPool(blessingPool));
        playerContext.write(CmdCode._27004, builder.build());
    }

    @CMD(id = CmdCode._27005)
    public void sendRareLog(PlayerContext playerContext, BlessingPoolGMsg.GReqBlessingPoolRareLog req) {
        blessingPoolService.sendRareLog(playerContext.getId(), req.getType());
    }


    private GResBlessingData serializeBlessingPool(BlessingPool poolData) {
        GResBlessingData.Builder builder = GResBlessingData.newBuilder();
        builder.setRefreshTimes(poolData.getRefreshTimes());
        builder.setType(poolData.getPoolType());
        builder.setLuckyValue(poolData.getLuckyValue());
        builder.addAllLuckyRewardId(poolData.getLuckyRewardIds());

        for (BlessingPoolItemData poolItemData : poolData.getItemData().values()) {
            ResBlessingPoolData.Builder poolDataBuilder = ResBlessingPoolData.newBuilder();
            poolDataBuilder.setPosition(poolItemData.getPosition());
            poolDataBuilder.setTimes(poolItemData.getTimes());
            PSBackpackData.Builder itemBuilder = PSBackpackData.newBuilder();
            itemBuilder.setType(poolItemData.getItemType());
            itemBuilder.setNum(poolItemData.getItemNumber());
            poolDataBuilder.setItem(itemBuilder);
            builder.addPoolData(poolDataBuilder.build());
        }

        builder.setRefreshTime(poolData.getRefreshDatetime());
        return builder.build();
    }


    /**
     * 刷新变灰的内容
     *
     */
//    public void blessingPoolTag(PlayerContext playerContext) {
//
//        Set<Integer> set = new HashSet<>();
//        for (CWishpoolreward cWishpoolreward : wishpoolrewardSysCache.getAll()) {
//            if (cWishpoolreward.getGain_limit() == 1) {
//                // 只能抽到1次的位置
//                set.add(cWishpoolreward.getPlace());
//            }
//        }
//
//        GResBlessingPoolRefresh.Builder builder1 = GResBlessingPoolRefresh.newBuilder();
//        builder1.setType(1);
//        GResBlessingPoolRefresh.Builder builder2 = GResBlessingPoolRefresh.newBuilder();
//        builder1.setType(2);
//
//        List<WishpoolLottery> lotteryList = wishpoolLotteryService.getWishpoolLottery(playerContext.getId());
//        for (WishpoolLottery lottery : lotteryList) {
//            if (set.contains(lottery.getPlace())) {
//                if (lottery.getPoolType() == 1) {
//                    builder1.addIndex(lottery.getPlace());
//                } else {
//                    builder2.addIndex(lottery.getPlace());
//                }
//            }
//        }
//        playerContext.write(CmdCode._27002, builder1.build());
//        playerContext.write(CmdCode._27002, builder2.build());
//    }

}
