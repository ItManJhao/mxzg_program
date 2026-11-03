package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion042SacrificeShopBuyDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion042SacrificeShopBuy;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion042SacrificesShopConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

@Service
public class Promotion042SacrificeShopService extends BasePromotionService<Promotion042SacrificeShopBuy> {

    @Autowired
    private Promotion042SacrificeShopBuyDao promotion042SacrificeShopBuyDao;


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JI_TAN_DUI_HUAN;
    }

    @Override
    protected void resetOnNewTurns(Promotion042SacrificeShopBuy promotion, PromotionControl control) {
        promotion.getBuyMap().clear();
    }

    @Override
    public IRepository<Promotion042SacrificeShopBuy> getRepository() {
        return promotion042SacrificeShopBuyDao;
    }


    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion042SacrificesShopConfig selectConfigOne(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion042SacrificesShopConfig.class);
    }

    public Collection<Promotion042SacrificesShopConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion042SacrificesShopConfig.class);
    }
}
