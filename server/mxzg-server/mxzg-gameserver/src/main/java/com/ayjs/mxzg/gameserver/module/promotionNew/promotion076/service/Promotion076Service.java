package com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.dao.Promotion076Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.domain.Promotion076;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion076ExchangeRewardConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Slf4j
@Service
public class Promotion076Service extends BasePromotionService<Promotion076> {

    @Autowired
    private Promotion076Dao promotion076Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.YONG_JIU_PI_FU;
    }

    @Override
    public IRepository<Promotion076> getRepository() {
        return promotion076Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion076 promotion, PromotionControl control) {
        promotion.getFashionCountRecord().clear();
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public Collection<Promotion076ExchangeRewardConfig> getAllConfig() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion076ExchangeRewardConfig.class);
    }

    public Promotion076ExchangeRewardConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion076ExchangeRewardConfig.class);
    }
}
