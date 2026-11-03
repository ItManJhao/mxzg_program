/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.HashMap;
import java.util.Map;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "promotion017_chargeinfo", comment = "累计充值")
public class Promotion017ChargeInfo extends BaseLoopingPromotion {
	@Column(name = "money", comment = "累充金额")
	private long money;
	@Column(name = "reward_info", length = 1000, comment = "奖励领取情况")
	private Map<Integer, Integer> rewardInfo = new HashMap<>();
	public long getMoney() {
		return money;
	}
	public void setMoney(long money) {
		this.money = money;
	}
	public Map<Integer, Integer> getRewardInfo() {
		return rewardInfo;
	}
	public void setRewardInfo(Map<Integer, Integer> rewardInfo) {
		this.rewardInfo = rewardInfo;
	}
}
