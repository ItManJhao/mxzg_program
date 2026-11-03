/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion024WeeklyGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion024WeeklyGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion024WeeklyGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion024WeeklyGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class Promotion024WeeklyGiftService extends BasePromotionService<Promotion024WeeklyGift> implements IRechargeBuyingService {

    @Autowired
    private Promotion024WeeklyGiftDao promotion024WeeklyGiftDao;
    @Autowired
    private Promotion024WeeklyGiftSysCache promotion024WeeklyGiftSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MEI_ZHOU_FU_LI;
    }

    @Override
    public IRepository<Promotion024WeeklyGift> getRepository() {
        return promotion024WeeklyGiftDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion024WeeklyGift promotion, PromotionControl control) {
        promotion.getBuyInfo().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.WEEK_GIFT;
    }

    /**
     * 每周福利是否可以购买
     * @param rid
     * @param productionId
     * @return
     */
    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
            return false;
        }
        Promotion024WeeklyGift promotion = this.getPromotionInfo(rid);

        CPromotion024WeeklyGift config = promotion024WeeklyGiftSysCache
                .getByTurnsProduction(promotion.getTurns(), productId);
        if (config == null) {
            return false;
        }
        if (roleService.getOrThrow(rid).getLevel() < config.getAppear_level()) {
            return false;
        }
        Integer buyNum = promotion.getBuyInfo().get(config.getIdx());
        if (buyNum == null) {
            return true;
        }
        if (buyNum < config.getBuy_limit()) {
            return true;
        }

        return false;
    }

    /**
     * 记录购买次数
     * @param rid
     * @param productionId
     */
    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion024WeeklyGift promotion = this.getPromotionInfo(rid);

        CPromotion024WeeklyGift config = promotion024WeeklyGiftSysCache
                .getByTurnsProduction(promotion.getTurns(), cBuyGem.getIdx());
        Integer buyNum = promotion.getBuyInfo().get(config.getIdx());
        if (buyNum == null) {
            buyNum = 0;
        }
        promotion.getBuyInfo().put(config.getIdx(), buyNum + 1);
        updatePromotion(promotion);

        if (isGm) {
            thingService.add(rid, config.getGift_reward(), GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, config.getGift_reward(), GameEvent.BUY_MONTH_GIFT);
        }
    }
}
