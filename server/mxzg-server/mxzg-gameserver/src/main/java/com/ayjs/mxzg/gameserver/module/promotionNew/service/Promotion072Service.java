package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion072.Promotion072floorSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopZsjtSysCashe;
import com.ayjs.mxzg.config.excel.entity.promotion072.CPromotion072floor;
import com.ayjs.mxzg.config.excel.entity.shop.CShopZsjt;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion072Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion072;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.domain.Shop;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion072RewardConfig;
import com.ayjs.mxzg.protocol.Promotion072GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 诸神祭坛
 */
@Service
@Slf4j
public class Promotion072Service extends BasePromotionService<Promotion072> {

    @Autowired
    private Promotion072Dao promotion072Dao;
    @Autowired
    private Promotion072floorSysCache promotion072floorSysCache;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ShopService shopService;
    @Autowired
    private ShopZsjtSysCashe shopZsjtSysCashe;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHU_SHEN_JI_TAN;
    }

    @Override
    public IRepository<Promotion072> getRepository() {
        return promotion072Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion072 promotion, PromotionControl control) {
        promotion.setFloor(1);
        promotion.setLuckDrawNum(0);
        promotion.setMoneyDrawNum(0);
        promotion.setMoneyDrawTime(System.currentTimeMillis());
        resetShopBuyNum(promotion.getRid());
    }

    // 重置限购次数
    private void resetShopBuyNum(long rid) {
        Shop shop = shopService.getShop(rid, ShopType.ZSJT);
        shop.getItems().clear();
        for (CShopZsjt cShopZsjt : shopZsjtSysCashe.getAll()) {
            shop.getItems().putIfAbsent(cShopZsjt.getIdx(), 0);
        }
        shopService.updateShop(shop);
        shopService.sendOneShopData0(shop);
    }

    //诸神祭坛数据
    public Promotion072GMsg.PSZSJTInfo.Builder creatZSJTInfo(long rid) {
        Promotion072 promotion072 = getPromotionInfo(rid);
        Promotion072GMsg.PSZSJTInfo.Builder info = Promotion072GMsg.PSZSJTInfo.newBuilder();
        info.setFloor(promotion072.getFloor());
        info.setMoneyDrawNum(getMoneyDrawNum(promotion072));
        return info;
    }

    //获取钻石抽奖次数，隔天重置
    private int getMoneyDrawNum(Promotion072 promotion072) {
        long moneyDrawTime = promotion072.getMoneyDrawTime();
        int moneyDrawNum = promotion072.getMoneyDrawNum();
        long nowTime = System.currentTimeMillis();
        //判读钻石抽奖是否在同一天
        if (!DateTimeUtil.isSameDay(nowTime, moneyDrawTime)) {
            moneyDrawNum = 0;
            moneyDrawTime = nowTime;
            promotion072.setMoneyDrawTime(moneyDrawTime);
            promotion072.setMoneyDrawNum(moneyDrawNum);
            updatePromotion(promotion072);//更新数据
        }
        return moneyDrawNum;
    }

    /**
     * 抽奖
     *
     * @param rid
     * @param isBatch     是否批量抽奖
     * @param isMoneyDraw 是否钻石抽奖
     * @return
     */
    public void luckDraw(long rid, boolean isBatch, boolean isMoneyDraw, Promotion072GMsg.GResZSJTLuckDraw.Builder builder) {
        //判断角色等级
        int limitRoleLv = systemSysCache.getPromotionZsjtRolelv();
        Asserts.isTrue(roleService.getOrThrow(rid).getLevel() >= limitRoleLv, ErrorCode.PROMOTION_072_ROLELV.getValue(), "角色等级不够，不能参与诸神祭坛活动");
        //开服天数
        int startTime = promotionControlService.getControl(thisPromotionType()).getStartTime();
        int openDay = DateTimeUtil.apartDay(startTime, serverParamService.getServerStartTime()) + 1;//开服天数
        //直接获取第一层消耗
        CPromotion072floor cPromotion072floor1 = promotion072floorSysCache.getCPromotion072floor_openServerTime_floor(openDay, 1);
        //判断道具或者钻石是否足够
        List<ImmutableThing> cost_money = null;//钻石消耗
        List<ImmutableThing> cost_item = null;//道具消耗
        Promotion072 promotion072 = getPromotionInfo(rid);
        int floorNow = promotion072.getFloor();//当前层级
        int luckDrawNumNow = promotion072.getLuckDrawNum();//当前抽奖次数
        int moneyDrawNum = getMoneyDrawNum(promotion072);//钻石抽奖次数
        int DrawNum = 1;//抽奖次数
        if (isBatch) {//批量抽奖
            DrawNum = systemSysCache.getPromotionZsjtBatchLuckdrawnum();
        }
        if (isMoneyDraw) {
            //判断钻石抽奖次数是否足够
            int limitMoneyBuynum = systemSysCache.getPromotionZsjtMoneyBuynum();
            Asserts.isTrue(limitMoneyBuynum > moneyDrawNum, ErrorCode.PROMOTION_072_MONEYBUY.getValue(), "钻石抽奖次数不够");
            //判断钻石
            cost_money = cPromotion072floor1.getCost_money();
            boolean enough = thingService.enough(rid, cost_money);
            Asserts.isTrue(enough, ErrorCode.BAG_ITEM_LACK.getValue(), "道具不足");
        } else {//道具抽取
            List<ImmutableThing> cost = new ArrayList<>();
            for (int i = 0; i < DrawNum; i++) {
                cost.addAll(cPromotion072floor1.getCost_item());
            }
            cost_item = ImmutableThingUtil.mergeThing(cost);//合并道具
            boolean enough = thingService.enough(rid, cost_item);
            Asserts.isTrue(enough, ErrorCode.BAG_ITEM_LACK.getValue(), "道具不足");
        }
        //**********抽奖
        List<Promotion072RewardConfig> resultConfigList = new ArrayList<>();
        int maxFloor = promotion072floorSysCache.getCPromotion072floor_maxFloor(openDay);
        //根据抽奖次数抽奖
        for (int i = 0; i < DrawNum; i++) {
            //层级模板
            CPromotion072floor cPromotion072floor = promotion072floorSysCache.getCPromotion072floor_openServerTime_floor(openDay, floorNow);
            ConfigAsserts.isTrue(Objects.nonNull(cPromotion072floor), String.format("层级配置{%s}不存在,开服天数{%s}", floorNow, openDay));
            //判断当前是否满足抽解锁道具次数
            int min_count = cPromotion072floor.getMin_count();//最少几次才出（解锁道具）
            int max_count = cPromotion072floor.getMax_count();//最多几次必出（解锁道具）
            Promotion072RewardConfig resultConfig = null;
            if (luckDrawNumNow + 1 >= max_count) {//直接选择解锁道具返回
                resultConfig = getRewardConfigByIdx(cPromotion072floor.getLock_reward());
            } else {
                int lock_reward_id = 0;//默认为0
                if (luckDrawNumNow + 1 < min_count) {//小于最下次数，剔除掉解锁道具
                    lock_reward_id = cPromotion072floor.getLock_reward();//解锁道具
                }
                List<Promotion072RewardConfig> allRewardConfigs = getRewardConfigsByFloor(floorNow, lock_reward_id);//当前层的奖励
                Map<Integer, Integer> map = allRewardConfigs.stream().collect(Collectors.toMap(Promotion072RewardConfig::getId, Promotion072RewardConfig::getWeight));
                Integer hitRewardId = RandomUtil.getRandInteger(map);
                resultConfig = getRewardConfigByIdx(hitRewardId);
            }
            //如果抽中的是解锁道具，设置下一层，次数归零
            if (resultConfig.getId() == cPromotion072floor.getLock_reward()) {
                if (floorNow + 1 > maxFloor) {//从第一层开始
                    floorNow = 1;
                } else {
                    floorNow++;
                }
                builder.addFloors(floorNow);
                luckDrawNumNow = 0;//抽奖次数归零
            } else {
                luckDrawNumNow++;
            }
            if (isMoneyDraw) {//钻石抽奖
                moneyDrawNum++;
            }
            resultConfigList.add(resultConfig);
            builder.addIdx(resultConfig.getId());
        }
        //扣除消耗
        if (isMoneyDraw) {
            thingService.cost(rid, cost_money, GameEvent.PROMOTION_072_MONEYDRAW);
        } else {
            thingService.cost(rid, cost_item, GameEvent.PROMOTION_072_ITEMDRAW);
        }
        //保存数据
        promotion072.setFloor(floorNow);
        promotion072.setLuckDrawNum(luckDrawNumNow);
        promotion072.setMoneyDrawNum(moneyDrawNum);
        promotion072.setMoneyDrawTime(System.currentTimeMillis());
        updatePromotion(promotion072);
        //添加抽奖道具
        List<ImmutableThing> rewardThingsAll = new ArrayList<>();
        for (Promotion072RewardConfig config : resultConfigList) {
            rewardThingsAll.addAll(config.getRewardThings());
        }
        List<ImmutableThing> rewardThingsAll_ = ImmutableThingUtil.mergeThing(rewardThingsAll);//合并道具
        Rewards gotList = thingService.add(rid, rewardThingsAll_, GameEvent.PROMOTION_072_TLUCKDRAW,
                NoticeType.SLIENT);
        builder.addAllRewards(PbUtil.buildReward(gotList.getThingSet().asList()));
    }

    //根据idx获取奖励模板
    private Promotion072RewardConfig getRewardConfigByIdx(int idx) {
        Promotion072RewardConfig config = promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion072RewardConfig.class);
        ConfigAsserts.isTrue(Objects.nonNull(config), String.format("配置{%s}不存在", idx));
        return config;
    }

    //根据floor获取奖励集合,并过滤掉解锁道具
    private List<Promotion072RewardConfig> getRewardConfigsByFloor(int floor, int lock_reward_id) {
        Collection<Promotion072RewardConfig> allConfig = promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion072RewardConfig.class);
        return allConfig.stream().filter(config -> config.getFloor() == floor && config.getId() != lock_reward_id).collect(Collectors.toList());
    }

}
