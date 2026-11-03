/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion005FoundationDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion005Foundation;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/***
 * 成长基金
 */
@Service
public class Promotion005FoundationService implements IRechargeBuyingService {

    @Autowired
    private Promotion005FoundationDao promotion005FoundationDao;
    @Autowired
    private BuyGemSysCache buyGemSysCache;

    public Promotion005Foundation get(long rid) {
        Promotion005Foundation foundation = promotion005FoundationDao.get(rid);
        if (foundation == null) {
            foundation = new Promotion005Foundation();
            foundation.setRid(rid);
            promotion005FoundationDao.add(foundation);
        }
        return foundation;
    }

    public void update(Promotion005Foundation foundation) {
        promotion005FoundationDao.update(foundation);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.FOUNDATION;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
        if (cBuyGem == null) {
            return false;
        }
        Promotion005Foundation foundation = get(rid);
        return !foundation.isHadBuy();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion005Foundation invest = get(rid);
        invest.setHadBuy(true);
        promotion005FoundationDao.update(invest);
    }
}
