/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion020DailyGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion020DailyGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion020DailyGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion020DailyGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;

/**
 * @author YY
 *
 */
@Service
public class Promotion020DailyGiftService extends BasePromotionService<Promotion020DailyGift> implements IRechargeBuyingService {

	@Autowired
	private Promotion020DailyGiftDao promotion020DailyGiftDao;
	@Autowired
	private Promotion020DailyGiftSysCache promotion020DailyGiftSysCache;
	@Autowired
    private ThingService thingService;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.MEI_RI_LI_BAO;
	}

	@Override
	public IRepository<Promotion020DailyGift> getRepository() {
		return promotion020DailyGiftDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion020DailyGift promotion, PromotionControl control) {
		promotion.getBuyInfo().clear();
	}
	
	@Override
	protected boolean resetOnSpecial(Promotion020DailyGift promotion) {
		if(TimeDateUtil.getCurrentTimeInt() > promotion.getDailyTime()) {
			promotion.setHasReward(0);
			promotion.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			return true;
		}
		return false;
	}
	
	
	@Override
	public BuyGemType buyGemType() {
		return BuyGemType.DAILY_GIFT;
	}
	
	/**
	 * 新服礼包是否可以购买
	 * @param rid
	 * @param productionId
	 * @return
	 */
	@Override
	public boolean canBuy(long rid, int productId) {
		if(!promotionControlService.isPromotionRunning(thisPromotionType())) {
			return false;
		}
		Promotion020DailyGift buyInfo = this.getPromotionInfo(rid);
		CPromotion020DailyGift config = promotion020DailyGiftSysCache
				.getByTurnsProduction(buyInfo.getTurns(), productId);
		if(config == null) {
			return false;
		}
		Integer buyNum = buyInfo.getBuyInfo().get(config.getIdx());
		if(buyNum == null) {
			return true;
		}
		if(buyNum < config.getBuy_limit()) {
			return true;
		}
		return false;
	}
	
	/**
	 * 添加每日礼包购买奖励
	 * @param rid
	 * @param productionId
	 */
	@Override
	public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
		Promotion020DailyGift buyInfo = getPromotionInfo(rid);
		CPromotion020DailyGift config = promotion020DailyGiftSysCache
				.getByTurnsProduction(buyInfo.getTurns(), cBuyGem.getIdx());
		
		Integer buyNum = buyInfo.getBuyInfo().get(config.getIdx());
		if(buyNum == null) {
			buyNum = 0;
		}
		buyInfo.getBuyInfo().put(config.getIdx(), buyNum + 1);
		updatePromotion(buyInfo);

        thingService.add(rid, config.getGift_reward(), GameEvent.BUY_DAILY_GIFT);
	}
}
