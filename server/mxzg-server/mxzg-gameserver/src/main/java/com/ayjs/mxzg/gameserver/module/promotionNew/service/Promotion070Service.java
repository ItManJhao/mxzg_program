package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070MissionSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070TypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Mission;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Type;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion070Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion070;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion070RewardConfig;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Service
@Slf4j
public class Promotion070Service extends BasePromotionService<Promotion070> implements IRechargeBuyingService {

    @Autowired
    private Promotion070TypeSysCache promotion070TypeSysCache;
    @Autowired
    private Promotion070MissionSysCache promotion070MissionSysCache;
    @Autowired
    private BuyGemSysCache buyGemSysCache;

    @Autowired
    private Promotion070Dao promotion070Dao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MENG_JING_MI_BAO;
    }

    @Override
    public IRepository<Promotion070> getRepository() {
        return promotion070Dao;
    }

    @Override
    public Promotion070 getPromotionInfo(long rid) {
        Promotion070 promotion = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotion.getMissionRefresh())) {
            promotion.getMissionInfoMap().clear();
            promotion.getMissionBoxRecord().clear();
            promotion.setMissionRefresh(LocalDate.now());
            updatePromotion(promotion);
        }
        return promotion;
    }

    @Override
    protected void resetOnNewTurns(Promotion070 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getSelectInfo().clear();
        promotion.setOpenCount(0);
        promotion.getOpenRecord().clear();
        promotion.getCountReward().clear();
        promotion.setGoodBuyCount(0);
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRefresh(promotion.getDefault());
        promotion.setLoginRecord(promotion.getDefault());
    }

    public Promotion070RewardConfig randomReward(Promotion070 promotionInfo) {
        List<Promotion070RewardConfig> allRewardConfigs = Lists.newArrayList();
        //先做必出判定
        List<CPromotion070Type> infallibleTypeConfig = promotion070TypeSysCache.getAll().stream().filter(config ->
                config.getMax_count() == promotionInfo.getOpenRecord().size() + 1).collect(Collectors.toList());
        if (infallibleTypeConfig.size() > 1) {
            log.error("同一次存在两种类型必出，配置有问题", GJsonUtils.toJson(infallibleTypeConfig));
            Collection<Integer> hadOpenIds = promotionInfo.getOpenRecord().values();
            CPromotion070Type typeConfig = infallibleTypeConfig.get(0);
            //已经出了，就纯随机
            if (hadOpenIds.stream().map(id -> getRewardConfigByIdx(id)).anyMatch(config -> config.getType() == typeConfig.getIdx())) {
                promotion070TypeSysCache.getAll().forEach(typeConfig_ -> {
                    allRewardConfigs.addAll(selectRewardConfig(promotionInfo, typeConfig_));
                });
            } else {
                allRewardConfigs.addAll(selectRewardConfig(promotionInfo, typeConfig));
            }
        } else if (infallibleTypeConfig.size() == 1) {
            allRewardConfigs.addAll(selectRewardConfig(promotionInfo, infallibleTypeConfig.get(0)));
        } else {
            promotion070TypeSysCache.getAll().forEach(typeConfig -> {
                allRewardConfigs.addAll(selectRewardConfig(promotionInfo, typeConfig));
            });
        }
        Map<Integer, Integer> map = allRewardConfigs.stream().collect(Collectors.toMap(Promotion070RewardConfig::getId, Promotion070RewardConfig::getWeight));
        Integer hitRewardId = RandomUtil.getRandInteger(map);
        return getRewardConfigByIdx(hitRewardId);
    }

    public Promotion070RewardConfig getRewardConfigByIdx(int idx) {
        Promotion070RewardConfig config = promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion070RewardConfig.class);
        ConfigAsserts.isTrue(Objects.nonNull(config), String.format("配置{%s}不存在", idx));
        return config;
    }

    public List<Promotion070RewardConfig> getRewardConfigsByType(int type) {
        Collection<Promotion070RewardConfig> allConfig = promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion070RewardConfig.class);
        return allConfig.stream().filter(config -> config.getType() == type).collect(Collectors.toList());
    }


    private List<Promotion070RewardConfig> selectRewardConfig(Promotion070 promotionInfo, CPromotion070Type typeConfig) {
        List<Promotion070RewardConfig> result = Lists.newArrayList();
        if (typeConfig.getMin_count() > promotionInfo.getOpenRecord().size() + 1) {
            return result;
        }
        if (typeConfig.getClient() == 1) {
            List<Integer> rewardIds = promotionInfo.getSelectInfo().get(typeConfig.getIdx());
            result.addAll(rewardIds.stream().filter(idx -> !promotionInfo.getOpenRecord().values().contains(idx))
                    .map(idx -> getRewardConfigByIdx(idx)).collect(Collectors.toList()));
        } else {
            List<Promotion070RewardConfig> configs = getRewardConfigsByType(typeConfig.getIdx());
            configs = configs.stream().filter(config -> !promotionInfo.getOpenRecord().values().contains(config.getIdx()))
                    .collect(Collectors.toList());
            result.addAll(configs);
        }
        return result;
    }

    public List<CPromotion070Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion070Mission> missions = getMissionConfigsByDay();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion070Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }

    public List<CPromotion070Mission> getMissionConfigsByDay() {
        if (!isOpening()) {
            return null;
        }
        List<CPromotion070Mission> missions = promotion070MissionSysCache.getMissionByDay(getOpenDay());
        return missions;
    }

    /***
     * 活动未开启时，天数未0
     * @return
     */
    public int getOpenDay() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        if (Objects.isNull(control)) {
            log.error("不存在该活动类型：{}", thisPromotionType());
            return 0;
        }

        if (!isOpening()) {
            return 0;
        }

        int intervalDay = TimeDateUtil.intervalDays(control.getStartTime(), TimeDateUtil.getCurrentTimeInt());
        return intervalDay;
    }


    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.PROMOTION_070;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!isOpening()) {
            return false;
        }
        CBuyGem buyGem = buyGemSysCache.getOrThrow(productId);
        Promotion070 promotionInfo = getPromotionInfo(rid);
        return promotionInfo.getGoodBuyCount() < buyGem.getLimit_times();

    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion070 promotionInfo = getPromotionInfo(rid);
        promotionInfo.setGoodBuyCount(promotionInfo.getGoodBuyCount() + 1);
        updatePromotion(promotionInfo);
        thingService.add(rid, cBuyGem.getItem(), GameEvent.PROMOTION_070_OPEN_REWARD);
    }
}
