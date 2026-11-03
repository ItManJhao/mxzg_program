package com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.dao.Promotion083Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.domain.Promotion083;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion083LotteryRewardConfig;
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
public class Promotion083Service extends BasePromotionService<Promotion083> {

    @Autowired
    private Promotion083Dao promotion083Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.HEI_WU_LOTTERY;
    }

    @Override
    public IRepository<Promotion083> getRepository() {
        return promotion083Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion083 promotion, PromotionControl control) {
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

    public Collection<Promotion083LotteryRewardConfig> getAllConfig() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion083LotteryRewardConfig.class);
    }

    public Promotion083LotteryRewardConfig getBestConfig() {
        return getAllConfig().stream().filter(config -> config.getNeed_select() == 1).findFirst().orElse(null);
    }

    public Promotion083LotteryRewardConfig randomReward(Promotion083 promotionInfo) {
        List<Promotion083LotteryRewardConfig> allRewardConfigs = Lists.newArrayList();
        //先做必出判定
        List<Promotion083LotteryRewardConfig> infallibleTypeConfig = getAllConfig().stream().filter(config ->
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

    public Promotion083LotteryRewardConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion083LotteryRewardConfig.class);
    }
}
