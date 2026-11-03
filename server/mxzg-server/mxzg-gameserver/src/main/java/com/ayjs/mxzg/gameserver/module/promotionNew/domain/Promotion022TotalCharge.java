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
@Table(name = "promotion022_totalcharge", comment = "每日累充")
public class Promotion022TotalCharge extends BaseLoopingPromotion {
	@Column(name = "money", comment = "当天已充值金额")
	private long money;
	@Column(name = "reward_info", comment = "奖励领取信息")
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
