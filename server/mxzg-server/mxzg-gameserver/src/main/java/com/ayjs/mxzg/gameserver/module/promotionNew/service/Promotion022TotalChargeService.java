/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion022TotalChargeDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion022TotalCharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion022TotalChargeService extends BasePromotionService<Promotion022TotalCharge> {

	@Autowired
	private Promotion022TotalChargeDao promotion022TotalChargeDao;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.MEI_RI_LEI_CHONG;
	}

	@Override
	public IRepository<Promotion022TotalCharge> getRepository() {
		return promotion022TotalChargeDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion022TotalCharge promotion, PromotionControl control) {
		promotion.setMoney(0);
		promotion.getRewardInfo().clear();
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
		Promotion022TotalCharge chargeInfo = this.getPromotionInfo(event.getRid());
		chargeInfo.setMoney(chargeInfo.getMoney() + event.getMoney());
		updatePromotion(chargeInfo);
	}
}
