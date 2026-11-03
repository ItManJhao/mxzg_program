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
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion017ChargeInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion017ChargeInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion017ChargeInfoService extends BasePromotionService<Promotion017ChargeInfo> {

	@Autowired
	private Promotion017ChargeInfoDao promotion017ChargeInfoDao;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.LEI_JI_CHONG_ZHI;
	}

	@Override
	public IRepository<Promotion017ChargeInfo> getRepository() {
		return promotion017ChargeInfoDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion017ChargeInfo promotion, PromotionControl control) {
		//TODO 是否需要把玩家没有领取的奖励以邮件方式进行发送？
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
		System.out.println("event.getMoney() " + event.getMoney());
		Promotion017ChargeInfo chargeInfo = this.getPromotionInfo(event.getRid());
		chargeInfo.setMoney(chargeInfo.getMoney() + event.getMoney());
		updatePromotion(chargeInfo);
	}
}
