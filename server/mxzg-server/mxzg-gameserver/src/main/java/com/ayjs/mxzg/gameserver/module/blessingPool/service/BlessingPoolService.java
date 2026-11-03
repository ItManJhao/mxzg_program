/**
 *
 */
package com.ayjs.mxzg.gameserver.module.blessingPool.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.WishpoolneedSysCache;
import com.ayjs.mxzg.config.excel.cache.WishpoolrewardSysCache;
import com.ayjs.mxzg.config.excel.constant.BlessingConst;
import com.ayjs.mxzg.config.excel.entity.CWishPoolNeed;
import com.ayjs.mxzg.config.excel.entity.CWishpoolreward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.blessingPool.constant.BlessingPoolType;
import com.ayjs.mxzg.gameserver.module.blessingPool.dao.BlessingPoolDao;
import com.ayjs.mxzg.gameserver.module.blessingPool.dao.BlessingPoolRareLogDao;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPool;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPoolItemData;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPoolRareLog;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.RareLogData;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolGetRareEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg;
import com.ayjs.mxzg.protocol.BlessingPoolGMsg.GResBlessingPoolDone;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * 许愿池
 */
@Service
public class BlessingPoolService {

    @Autowired
    private BlessingPoolDao blessingPoolDao;
    @Autowired
    private WishpoolrewardSysCache wishpoolrewardSysCache;
    @Autowired
    private WishpoolneedSysCache wishpoolneedSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private BlessingPoolRareLogDao blessingPoolRareLogDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    private static final String BLESSING_POOL_LOCK = "BLESSING_POOL_LOCK";

    public List<BlessingPool> getBlessingPool(long rid) {
        List<BlessingPool> blessingPools = blessingPoolDao.getBlessingPool(rid);
        // 检查所有抽奖池，没有就初始化
        Role role = roleService.getOrThrow(rid);

        int now = DateTimeUtil.currentSecond();
        for (BlessingPoolType poolType : BlessingPoolType.values()) {
            List<CWishpoolreward> poolRewardList = wishpoolrewardSysCache.getConfigByTypeAndLv(poolType.getValue(), role.getLevel());
            if (Objects.isNull(poolRewardList)) {
                continue;
            }
            // 已经存在不用初始化
            Optional<BlessingPool> blessingPoolOpt = blessingPools.stream().filter(pool ->
                    pool.getPoolType() == poolType.getValue()).findFirst();
            if (blessingPoolOpt.isPresent()) {
                // 是否需要刷新
                BlessingPool blessingPool = blessingPoolOpt.get();

                if (blessingPool.getRefreshDatetime() <= now) {
                    blessingPool.setRefreshTimes(0);
                    blessingPool.setRefreshDatetime(0); // 有免费次数
//                    refreshBlessingPoolItemData(blessingPool);
                    blessingPoolDao.update(blessingPool);
                }
                // 重置更新时间
                if (!TimeDateUtil.isSameDay(TimeDateUtil.getCurrentTime(), blessingPool.getResetTime())) {
                    refreshBlessingPoolItemData(blessingPool);
                    blessingPool.setResetTime(TimeDateUtil.getCurrentTime());
                    blessingPoolDao.update(blessingPool);
                }
            } else {
                // 初始化
                BlessingPool newBlessingPool = new BlessingPool();
                newBlessingPool.setRid(rid);
                newBlessingPool.setPoolType(poolType.getValue());
                newBlessingPool.setRefreshTimes(0);
                newBlessingPool.setRefreshDatetime(0);
//                newBlessingPool.setRefreshDatetime(DateTimeUtil.tomorrowBreak());
                newBlessingPool.setResetTime(TimeDateUtil.getCurrentTime());
                refreshBlessingPoolItemData(newBlessingPool);
                blessingPoolDao.add(newBlessingPool);
                blessingPools.add(newBlessingPool);
            }
        }
        return blessingPools;
    }

    public void updateBlessingPool(BlessingPool blessingPool) {
        blessingPoolDao.update(blessingPool);
    }

    /**
     * 重置许愿池物品
     */
    public void refreshBlessingPoolItemData(BlessingPool blessingPool) {
        Role role = roleService.getOrThrow(blessingPool.getRid());
        List<CWishpoolreward> poolRewardList = wishpoolrewardSysCache.getConfigByTypeAndLv(blessingPool.getPoolType(), role.getLevel());
        if (Objects.isNull(poolRewardList) || poolRewardList.isEmpty()) {
            return;
        }
        Map<Integer, BlessingPoolItemData> newItemDataMap = blessingPool.getItemData();
        if (Objects.isNull(newItemDataMap)) {
            newItemDataMap = new HashMap<>();
            blessingPool.setItemData(newItemDataMap);
        } else {
            newItemDataMap.clear();
        }

        for (CWishpoolreward rewardConfig : poolRewardList) {
            // 位置
            int place = rewardConfig.getPlace();
            List<ImmutableThing> rewardList = rewardConfig.getReward();
            ImmutableThing reward = DropUtil.randomDrop(rewardList);

            BlessingPoolItemData itemData = new BlessingPoolItemData();
            itemData.setPosition(rewardConfig.getPlace());
            itemData.setItemType(reward.getItem_type());
            itemData.setItemNumber(reward.getItem_num());
            itemData.setChance(rewardConfig.getPlace_chance());
            itemData.setConfigIdx(rewardConfig.getIdx());
            itemData.setTimes(0);
            newItemDataMap.put(place, itemData);
        }
    }

    public GResBlessingPoolDone.Builder blessingPoolDone(BlessingPool blessingPool, int times) {
        CWishPoolNeed wishPoolNeed = wishpoolneedSysCache.getWishPoolNeedByTypeAndTime(blessingPool.getPoolType(), times);

        thingService.cost(blessingPool.getRid(), wishPoolNeed.getNeed_item(),
                blessingPool.getPoolType() == BlessingPoolType.Normal.getValue() ? GameEvent.BLESSING_POOL_NORMAL : GameEvent.BLESSING_POOL_ADVANCE);

        GResBlessingPoolDone.Builder builder = GResBlessingPoolDone.newBuilder();

        Map<Integer, BlessingPoolItemData> itemDataMap = blessingPool.getItemData();

        //增加幸运值
        blessingPool.setLuckyValue(blessingPool.getLuckyValue() + wishPoolNeed.getAdd_lucky_value());
        blessingPoolDao.update(blessingPool);

        List<ImmutableThing> listReward = new ArrayList<>();

        if (BlessingPoolType.of(blessingPool.getPoolType()) == BlessingPoolType.Normal) {
            listReward.addAll(ImmutableThingUtil.multiplyThing(BlessingConst.NORMAL_GAIN_ITEM_EACH_PLAY, times));
        } else if (BlessingPoolType.of(blessingPool.getPoolType()) == BlessingPoolType.Advance) {
            listReward.addAll(ImmutableThingUtil.multiplyThing(BlessingConst.ADVANCE_GAIN_ITEM_EACH_PLAY, times));
        }

        List<BlessingPoolItemData> poolItemDataList = blessingPoolDrop(itemDataMap, times);

        int i = 0;

        List<RareLogData> rareReward = new ArrayList<>();

        int time = TimeDateUtil.getCurrentTimeInt();
        for (BlessingPoolItemData itemData : poolItemDataList) {
            if (i == 0) {
                builder.setIndex(itemData.getPosition());
            }
            ImmutableThing reward = ImmutableThing.of(itemData.getItemType(), itemData.getItemNumber(), itemData.getChance());
            listReward.add(reward);

            i++;

            if (wishpoolrewardSysCache.getOrThrow(itemData.getConfigIdx()).getRare_broadcast() == 1)
                rareReward.add(RareLogData.of(blessingPool.getRid(), reward.getItem_type(), time));
        }

        thingService.add(blessingPool.getRid(), listReward,
                blessingPool.getPoolType() == BlessingPoolType.Normal.getValue() ? GameEvent.BLESSING_POOL_NORMAL : GameEvent.BLESSING_POOL_ADVANCE, NoticeType.SLIENT);

        builder.addAllAward(PbUtil.buildReward(listReward));

        if (rareReward.size() > 0) {

            synchronized (InternerPool.intern(BLESSING_POOL_LOCK, blessingPool.getPoolType())) {
                BlessingPoolRareLog blessingPoolRareLog = blessingPoolRareLogDao.get(blessingPool.getPoolType());
                if (blessingPoolRareLog == null) {
                    blessingPoolRareLog = new BlessingPoolRareLog();
                    blessingPoolRareLog.setType(blessingPool.getPoolType());
                    blessingPoolRareLogDao.add(blessingPoolRareLog);
                }
                blessingPoolRareLog.getRareLog().addAll(rareReward);
                if (blessingPoolRareLog.getRareLog().size() > systemSysCache.getWishpoolRareBroadcastNum()) {
                    List<RareLogData> newList = blessingPoolRareLog.getRareLog().subList(blessingPoolRareLog.getRareLog().size() -
                            systemSysCache.getWishpoolRareBroadcastNum(), blessingPoolRareLog.getRareLog().size());
                    blessingPoolRareLog.setRareLog(newList);
                }
                blessingPoolRareLogDao.update(blessingPoolRareLog);

                sendRareLog(blessingPool.getRid(), blessingPool.getPoolType());
                eventBus.post(BlessingPoolGetRareEvent.of(blessingPool.getPoolType(), rareReward));
            }
        }

        return builder;
    }

    public void sendRareLog(long rid, int type) {
        BlessingPoolRareLog blessingPoolRareLog = blessingPoolRareLogDao.get(type);
        BlessingPoolGMsg.GResBlessingPoolRareLog.Builder rareLogBuilder = BlessingPoolGMsg.GResBlessingPoolRareLog.newBuilder();
        //倒序
        List<RareLogData> rareLogData = new ArrayList<>(blessingPoolRareLog.getRareLog());
        for (int i = rareLogData.size() - 1; i >= 0; i--) {
            RareLogData rareLog = rareLogData.get(i);
            BlessingPoolGMsg.PSRareLog.Builder logBuilder = BlessingPoolGMsg.PSRareLog.newBuilder();
            logBuilder.setItemId(rareLog.getItemId());
            logBuilder.setNick(roleService.getOrThrow(rareLog.getRid()).getNick());
            rareLogBuilder.addRareLog(logBuilder);
        }

        contextManager.write(rid, CmdCode._27005, rareLogBuilder.build());
    }

    public List<BlessingPoolItemData> blessingPoolDrop(Map<Integer, BlessingPoolItemData> itemDataMap, int times) {
        List<BlessingPoolItemData> result = new ArrayList<>();
        for (int i = 0; i < times; i++) {
            List<BlessingPoolItemData> randomList = new ArrayList<>();
            for (Map.Entry<Integer, BlessingPoolItemData> entry : itemDataMap.entrySet()) {
                BlessingPoolItemData poolItemData = entry.getValue();

                CWishpoolreward cwishpoolreward = wishpoolrewardSysCache.getOrThrow(poolItemData.getConfigIdx());
                if (cwishpoolreward.getGain_limit() > 0 && poolItemData.getTimes() >= cwishpoolreward.getGain_limit()) {
                    continue;
                }
                randomList.add(poolItemData);
            }
            BlessingPoolItemData itemData = DropUtil.randomDrop(randomList);
            if (Objects.isNull(itemData)) {
                continue;
            }
            result.add(itemData);
            itemData.setTimes(itemData.getTimes() + 1);
        }
        return result;
    }


    public BlessingPool getBlessingPoolByType(long rid, int type) {
        List<BlessingPool> list = getBlessingPool(rid);
        Optional<BlessingPool> blessingPool = list.stream().filter(item -> item.getPoolType() == type).findFirst();
        return blessingPool.orElse(null);
    }

}
