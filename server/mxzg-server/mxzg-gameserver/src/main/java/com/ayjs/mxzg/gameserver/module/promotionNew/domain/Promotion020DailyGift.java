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
@Table(name = "promotion020_dailygift", comment = "每日礼包")
public class Promotion020DailyGift extends BaseLoopingPromotion {
	@Column(name = "buy_info", length = 1000)
	private Map<Integer, Integer> buyInfo = new HashMap<>();
	@Column(name = "has_reward", comment = "是否有奖励可以领取，0未领取，1已领取")
	private int hasReward;
	@Column(name = "daily_time", comment = "每次重置时间")
	private int dailyTime;
	
	public Map<Integer, Integer> getBuyInfo() {
		return buyInfo;
	}
	public void setBuyInfo(Map<Integer, Integer> buyInfo) {
		this.buyInfo = buyInfo;
	}
	public int getHasReward() {
		return hasReward;
	}
	public void setHasReward(int hasReward) {
		this.hasReward = hasReward;
	}
	public int getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(int dailyTime) {
		this.dailyTime = dailyTime;
	}
}
