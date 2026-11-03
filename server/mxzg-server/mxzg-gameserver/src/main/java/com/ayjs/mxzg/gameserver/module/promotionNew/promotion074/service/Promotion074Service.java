package com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.dao.Promotion074Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.domain.Promotion074;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion074LotteryRewardConfig;
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
public class Promotion074Service extends BasePromotionService<Promotion074> {

    @Autowired
    private Promotion074Dao promotion074Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.QIU_SHANG_MING_YUE;
    }

    @Override
    public IRepository<Promotion074> getRepository() {
        return promotion074Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion074 promotion, PromotionControl control) {
        promotion.getSelectInfo().clear();
        promotion.setLotteryCount(0);
        promotion.getLotteryCountRecord().clear();
        promotion.getLotteryTurnRecord().clear();
        promotion.setLotteryTurnCount(0);
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


    public Collection<Promotion074LotteryRewardConfig> getAllConfig() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion074LotteryRewardConfig.class);
    }

    public Promotion074LotteryRewardConfig getBestConfig() {
        return getAllConfig().stream().filter(config -> config.getNeed_select() == 1).findFirst().orElse(null);
    }

    public Promotion074LotteryRewardConfig randomReward(Promotion074 promotionInfo) {
        List<Promotion074LotteryRewardConfig> allRewardConfigs = Lists.newArrayList();
        //先做必出判定
        List<Promotion074LotteryRewardConfig> infallibleTypeConfig = getAllConfig().stream().filter(config ->
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

    public Promotion074LotteryRewardConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion074LotteryRewardConfig.class);
    }
}
