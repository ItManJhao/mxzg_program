package com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion087.Promotion087LotteryTypeSysCache;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.dao.Promotion087Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.domain.Promotion087;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion087LotteryRewardConfig;
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
public class Promotion087Service extends BasePromotionService<Promotion087> {
    @Autowired
    private Promotion087Dao promotion087Dao;
    @Autowired
    private Promotion087LotteryTypeSysCache promotion087LotteryTypeSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHRISTMAS_LOTTERY;
    }

    @Override
    public IRepository<Promotion087> getRepository() {
        return promotion087Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion087 promotion, PromotionControl control) {
        promotion.getLotteryRecord().clear();
        promotion.setLotteryType(promotion087LotteryTypeSysCache.getMinType());
    }

    @Override
    protected void onCreatingInfo(Promotion087 promotion) {
        promotion.setLotteryType(1);
    }

    public Collection<Promotion087LotteryRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion087LotteryRewardConfig.class);
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
