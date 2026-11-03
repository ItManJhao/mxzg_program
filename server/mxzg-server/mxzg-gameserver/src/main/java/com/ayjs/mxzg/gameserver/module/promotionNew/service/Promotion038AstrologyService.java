package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion038AstrologyDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion038Astrology;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion038AstrologyConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

@Service
public class Promotion038AstrologyService extends BasePromotionService<Promotion038Astrology> {

    @Autowired
    private Promotion038AstrologyDao promotion038AstrologyDao;

    @Override
    public IRepository<Promotion038Astrology> getRepository() {
        return promotion038AstrologyDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion038Astrology promotion, PromotionControl control) {
        promotion.getRewardList().clear();
    }

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHAN_XING_ZHEN_REN_WU;
    }


    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion038AstrologyConfig selectConfigOne(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion038AstrologyConfig.class);
    }

    public Collection<Promotion038AstrologyConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion038AstrologyConfig.class);
    }
}
