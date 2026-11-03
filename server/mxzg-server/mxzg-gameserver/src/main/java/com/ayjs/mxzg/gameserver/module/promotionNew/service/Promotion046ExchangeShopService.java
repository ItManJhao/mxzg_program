package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion046ExchangeShopDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion046ExchangeShop;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion046ExchangeShopConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 碎片进化
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Service
@Observer
public class Promotion046ExchangeShopService extends BasePromotionService<Promotion046ExchangeShop> {
    @Autowired
    private Promotion046ExchangeShopDao promotion046ExchangeShopDao;
    @Autowired
    RoleService roleService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SUI_PIAN_JIN_HUA;
    }

    @Override
    public IRepository<Promotion046ExchangeShop> getRepository() {
        return promotion046ExchangeShopDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion046ExchangeShop promotion, PromotionControl control) {
        promotion.getRewardRecord().clear();
    }

    public Promotion046ExchangeShopConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx,Promotion046ExchangeShopConfig.class);
    }


}
