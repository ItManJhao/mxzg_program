package com.ayjs.mxzg.gameserver.module.promotionNew.promotion094.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion094.dao.Promotion094Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion094.domain.Promotion094;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion094RandomRewardConfig;
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
public class Promotion094Service extends BasePromotionService<Promotion094> {
    @Autowired
    private Promotion094Dao promotion094Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHI_ZUO_NIU_DAN;
    }

    @Override
    public IRepository<Promotion094> getRepository() {
        return promotion094Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion094 promotion, PromotionControl control) {
        promotion.setScore(0);
    }

    public Collection<Promotion094RandomRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion094RandomRewardConfig.class);
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
