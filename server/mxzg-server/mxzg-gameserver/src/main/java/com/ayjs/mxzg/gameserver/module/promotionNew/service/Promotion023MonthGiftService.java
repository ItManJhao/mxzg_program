/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion023MonthGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion023MonthGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion023MonthGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion023MonthGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;

/**
 * @author YY
 *
 */
@Service
public class Promotion023MonthGiftService extends BasePromotionService<Promotion023MonthGift> implements IRechargeBuyingService {

	@Autowired
	private Promotion023MonthGiftDao promotion023MonthGiftDao;
	@Autowired
	private Promotion023MonthGiftSysCache promotion023MonthGiftSysCache;
	@Autowired
    private ThingService thingService;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.MEI_YUE_FU_LI;
	}

	@Override
	public IRepository<Promotion023MonthGift> getRepository() {
		return promotion023MonthGiftDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion023MonthGift promotion, PromotionControl control) {
		promotion.getBuyInfo().clear();
	}
	
	@Override
	public BuyGemType buyGemType() {
		return BuyGemType.MONTH_GIFT;
	}
	
	/**
	 * 每月福利是否可以购买
	 * @param rid
	 * @param productionId
	 * @return
	 */
	@Override
	public boolean canBuy(long rid, int productId) {
		if(!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
			return false;
		}
		Promotion023MonthGift monthGift = this.getPromotionInfo(rid);
		
		CPromotion023MonthGift config = promotion023MonthGiftSysCache
				.getByTurnsProduction(monthGift.getTurns(), productId);
		if(config == null) {
			return false;
		}
		Integer buyNum = monthGift.getBuyInfo().get(config.getIdx());
		if(buyNum == null) {
			return true;
		}
		if(buyNum < config.getBuy_limit()) {
			return true;
		}
		return false;
	}
	
	/**
	 * 记录购买次数
	 * @param rid
	 * @param productionId
	 */
	public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
		Promotion023MonthGift monthGift = getPromotionInfo(rid);
		CPromotion023MonthGift config = promotion023MonthGiftSysCache
				.getByTurnsProduction(monthGift.getTurns(), cBuyGem.getIdx());
		Integer buyNum = monthGift.getBuyInfo().get(config.getIdx());
		if(buyNum == null) {
			buyNum = 0;
		}
		monthGift.getBuyInfo().put(config.getIdx(), buyNum + 1);
		updatePromotion(monthGift);

		if(isGm) {
			thingService.add(rid, config.getGift_reward(), GameEvent.GM_RECHARGE);
		} else {
			thingService.add(rid, config.getGift_reward(), GameEvent.BUY_MONTH_GIFT);
		}
	}
}
