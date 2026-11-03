package com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.dao.Promotion089Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.domain.Promotion089;
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
public class Promotion089Service extends BasePromotionService<Promotion089> {
    @Autowired
    private Promotion089Dao promotion089Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHRISTMAS_NOTE;
    }

    @Override
    public IRepository<Promotion089> getRepository() {
        return promotion089Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion089 promotion, PromotionControl control) {
        promotion.setRewardTime(0);
    }

    public Collection<Promotion088RandomRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion088RandomRewardConfig.class);
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
