package com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.dao.Promotion088Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.domain.Promotion088;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion088RandomRewardConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion088Service extends BasePromotionService<Promotion088> {
    @Autowired
    private Promotion088Dao promotion088Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHRISTMAS_SCORE;
    }

    @Override
    public IRepository<Promotion088> getRepository() {
        return promotion088Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion088 promotion, PromotionControl control) {
        promotion.setScore(0);
    }

    public Collection<Promotion088RandomRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion088RandomRewardConfig.class);
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
