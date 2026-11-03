/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion021DailyFirstRechargeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion021DailyFirstRecharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion021DailyChargeDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion021DailyCharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.DailyFirstRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion021DailyChargeService extends BasePromotionService<Promotion021DailyCharge> {
	
	@Autowired
	private Promotion021DailyChargeDao promotion021DailyChargeDao;
	@Autowired
	private Promotion021DailyFirstRechargeSysCache promotion021DailyFirstRechargeSysCache;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.MEI_RI_SHOU_CHONG;
	}

	@Override
	public IRepository<Promotion021DailyCharge> getRepository() {
		return promotion021DailyChargeDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion021DailyCharge promotion, PromotionControl control) {
		promotion.getRecharges().clear();
	}
	
	/**
	 * 记录当天充值金额
	 * @param rid
	 * @param money
	 */
	@Subscribe
	public void addChargeMoney(RechargeEvent event) {
		if(!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
			return;
		}
		Promotion021DailyCharge chargeInfo = this.getPromotionInfo(event.getRid());
		
		Map<Integer, CPromotion021DailyFirstRecharge> cMap = promotion021DailyFirstRechargeSysCache.getByTurns(chargeInfo.getTurns());
		for(CPromotion021DailyFirstRecharge cPromotion : cMap.values()) {
			DailyFirstRecharge dailyFirstRecharge = chargeInfo.getRecharges().get(cPromotion.getType());
			if(dailyFirstRecharge == null) {
				dailyFirstRecharge = new DailyFirstRecharge();
				dailyFirstRecharge.setType(cPromotion.getType());
				chargeInfo.getRecharges().put(cPromotion.getType(), dailyFirstRecharge);
			}
			dailyFirstRecharge.setMoney(dailyFirstRecharge.getMoney() + event.getMoney());
		}
		updatePromotion(chargeInfo);
	}
}
