package com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.dao.Promotion091Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.domain.Promotion091;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion091GashaponLotteryRewardConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion091Service extends BasePromotionService<Promotion091> {
    @Autowired
    private Promotion091Dao promotion091Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHUN_JIE;
    }

    @Override
    public IRepository<Promotion091> getRepository() {
        return promotion091Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion091 promotion, PromotionControl control) {
        promotion.setLotteryTurns(1);
        promotion.getLotteryRecord().clear();
        promotion.setLotteryCount(0);
    }

    public Collection<Promotion091GashaponLotteryRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion091GashaponLotteryRewardConfig.class);
    }

    public List<Promotion091GashaponLotteryRewardConfig> getByTurns(int turns) {
        return getConfigList().stream().filter(config -> config.getTurns() == turns).collect(Collectors.toList());
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
