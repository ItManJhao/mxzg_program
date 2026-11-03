package com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093GridSysCache;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.dao.Promotion093Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.domain.Promotion093;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion093Service extends BasePromotionService<Promotion093> {
    @Autowired
    private Promotion093Dao promotion093Dao;
    @Autowired
    private Promotion093GridSysCache promotion093GridSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHUN_RI_TA_QING;
    }

    @Override
    public IRepository<Promotion093> getRepository() {
        return promotion093Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion093 promotion, PromotionControl control) {
        promotion.setCurrIdx(promotion093GridSysCache.getStart());
        promotion.setDiceCount(0);
        promotion.setDiceGroup(0);
        promotion.getScenicReward().clear();
        promotion.getScenicCount().clear();
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

}
