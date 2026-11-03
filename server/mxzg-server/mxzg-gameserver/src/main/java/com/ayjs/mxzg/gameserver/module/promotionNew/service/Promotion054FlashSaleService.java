/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion054FlashSaleSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion054FlashSale;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion054FlashSaleDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion054FlashSale;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/**
 * cwj
 */
@Service
public class Promotion054FlashSaleService extends BasePromotionService<Promotion054FlashSale> implements IRechargeBuyingService {

    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion054FlashSaleDao promotion054FlashSaleDao;
    @Autowired
    private Promotion054FlashSaleSysCache promotion054FlashSaleSysCache;
    @Autowired
    private PromotionControlService promotionControlService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.XIAN_SHI_QIANG_GOU;
    }


    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.FLASH_SALE;
    }

    @Override
    protected void resetOnNewTurns(Promotion054FlashSale promotion, PromotionControl control) {
        promotion.getBuyInfo().clear();
        promotion.getBuyRound().clear();
    }

    @Override
    public IRepository<Promotion054FlashSale> getRepository() {
        return promotion054FlashSaleDao;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(PromotionType.XIAN_SHI_QIANG_GOU)) {
            return false;
        }
        PromotionControl control = promotionControlService.getControl(PromotionType.XIAN_SHI_QIANG_GOU);
        List<CPromotion054FlashSale> configsByTurn = promotion054FlashSaleSysCache.getConfigsByTurn(control.getTurns());
        CPromotion054FlashSale config = configsByTurn.stream().filter(configTemp -> configTemp.getProduction_id() == productId).findFirst().get();

        return getCount(getPromotionInfo(rid), config) < config.getLimit_num();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        PromotionControl control = promotionControlService.getControl(PromotionType.XIAN_SHI_QIANG_GOU);
        List<CPromotion054FlashSale> configsByTurn = promotion054FlashSaleSysCache.getConfigsByTurn(control.getTurns());
        CPromotion054FlashSale config = configsByTurn.stream().filter(configTemp -> configTemp.getProduction_id() == cBuyGem.getIdx()).findFirst().get();
        Promotion054FlashSale promotion = getPromotionInfo(rid);
        int count = getCount(promotion, config);
        promotion.getBuyInfo().put(config.getIdx(), count + 1);
        updatePromotion(promotion);

        thingService.add(rid, config.getReward(), GameEvent.FLASH_SALE);
    }

    public int getCount(Promotion054FlashSale promotion054FlashSale, CPromotion054FlashSale config) {

        if (!promotionControlService.isPromotionRunning(PromotionType.XIAN_SHI_QIANG_GOU)) {
            return 0;
        }

        Integer dataRound = promotion054FlashSale.getBuyRound().getOrDefault(config.getIdx(), 0);
        PromotionControl control = promotionControlService.getControl(PromotionType.XIAN_SHI_QIANG_GOU);
        int intervalDay = TimeDateUtil.intervalDays(control.getStartTime(), TimeDateUtil.getCurrentTimeInt());
        int currRound = (intervalDay - 1) / config.getLimit_day();
        if (dataRound != currRound) {
            promotion054FlashSale.getBuyRound().put(config.getIdx(), currRound);
            promotion054FlashSale.getBuyInfo().put(config.getIdx(), 0);
            updatePromotion(promotion054FlashSale);
        }

        return promotion054FlashSale.getBuyInfo().getOrDefault(config.getIdx(), 0);

    }

    @Override
    protected boolean resetOnSpecial(Promotion054FlashSale promotion054FlashSale) {
        return false;
    }
}
