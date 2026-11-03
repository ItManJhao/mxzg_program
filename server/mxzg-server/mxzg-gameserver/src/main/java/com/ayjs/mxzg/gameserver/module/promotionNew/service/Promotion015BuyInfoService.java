/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion015NewServerLimitGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion015NewSeverLimitGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion015BuyInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion015BuyInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class Promotion015BuyInfoService extends BasePromotionService<Promotion015BuyInfo> implements IRechargeBuyingService {

	@Autowired
	private Promotion015BuyInfoDao promotion015BuyInfoDao;
	@Autowired
	private Promotion015NewServerLimitGiftSysCache promotion015NewServerLimitGiftSysCache;
	@Autowired
    private ThingService thingService;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.XIN_FU_LI_BAO;
	}

	@Override
	public IRepository<Promotion015BuyInfo> getRepository() {
		return promotion015BuyInfoDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion015BuyInfo promotion, PromotionControl control) {
		promotion.getBuyInfo().clear();
	}
	
	/**
	 * 新服礼包是否可以购买
	 * @param rid
	 * @param productionId
	 * @return
	 */
	@Override
	public boolean canBuy(long rid, int productId) {
		if(!promotionControlService.isPromotionRunning(this.thisPromotionType())) {
			return false;
		}
		Promotion015BuyInfo buyInfo = this.getPromotionInfo(rid);
		CPromotion015NewSeverLimitGift config = promotion015NewServerLimitGiftSysCache
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
	 * 记录购买次数
	 * @param rid
	 * @param productionId
	 */
	@Override
	public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
		Promotion015BuyInfo buyInfo = getPromotionInfo(rid);
		CPromotion015NewSeverLimitGift config = promotion015NewServerLimitGiftSysCache
				.getByTurnsProduction(buyInfo.getTurns(), cBuyGem.getIdx());
		Integer buyNum = buyInfo.getBuyInfo().get(config.getIdx());
		if(buyNum == null) {
			buyNum = 0;
		}
		buyInfo.getBuyInfo().put(config.getIdx(), buyNum + 1);
		updatePromotion(buyInfo);

		if(isGm) {
			thingService.add(rid, config.getGift_reward(), GameEvent.GM_RECHARGE);
		} else {
			thingService.add(rid, config.getGift_reward(), GameEvent.BUY_NEWSEVER_GIFT);
		}
	}

	@Override
	public BuyGemType buyGemType() {
		return BuyGemType.NEW_SERVER;
	}
}
