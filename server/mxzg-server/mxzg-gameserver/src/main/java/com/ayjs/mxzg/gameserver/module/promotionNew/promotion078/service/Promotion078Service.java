package com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.dao.Promotion078Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.domain.Promotion078;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion078LotteryRewardConfig;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Slf4j
@Service
public class Promotion078Service extends BasePromotionService<Promotion078> {

    @Autowired
    private Promotion078Dao promotion078Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.WAN_SHENG_LOTTERY;
    }

    @Override
    public IRepository<Promotion078> getRepository() {
        return promotion078Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion078 promotion, PromotionControl control) {
        promotion.getSelectInfo().clear();
        promotion.setLotteryCount(0);
        promotion.getLotteryCountRecord().clear();
        promotion.getLotteryTurnRecord().clear();
        promotion.setLotteryTurnCount(0);
        promotion.setLastLotteryIdx(0);
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public Collection<Promotion078LotteryRewardConfig> getAllConfig() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion078LotteryRewardConfig.class);
    }

    public Promotion078LotteryRewardConfig getBestConfig() {
        return getAllConfig().stream().filter(config -> config.getNeed_select() == 1).findFirst().orElse(null);
    }

    public Promotion078LotteryRewardConfig randomReward(Promotion078 promotionInfo) {
        List<Promotion078LotteryRewardConfig> allRewardConfigs = Lists.newArrayList();
        //先做必出判定
        List<Promotion078LotteryRewardConfig> infallibleTypeConfig = getAllConfig().stream().filter(config ->
                config.getMax_count() <= promotionInfo.getLotteryTurnCount() + 1 &&
                        !promotionInfo.getLotteryTurnRecord().contains(config.getId())).collect(Collectors.toList());
        if (infallibleTypeConfig.size() > 1) {
            log.error("同一次存在两种类型必出，配置有问题", GJsonUtils.toJson(infallibleTypeConfig));
            allRewardConfigs.add(infallibleTypeConfig.get(0));
        } else if (infallibleTypeConfig.size() == 1) {
            allRewardConfigs.add(infallibleTypeConfig.get(0));
        } else {
            allRewardConfigs.addAll(getAllConfig().stream().filter(config ->
                    config.getMin_count() < promotionInfo.getLotteryTurnCount() + 1).collect(Collectors.toList()));
        }
        return DropUtil.randomDrop(allRewardConfigs);
    }

    public Promotion078LotteryRewardConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion078LotteryRewardConfig.class);
    }
}
