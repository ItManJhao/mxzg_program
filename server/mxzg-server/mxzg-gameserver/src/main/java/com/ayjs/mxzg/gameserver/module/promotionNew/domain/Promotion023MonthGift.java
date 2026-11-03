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
@Table(name = "promotion023_monthgift", comment = "每周福利")
public class Promotion023MonthGift extends BaseLoopingPromotion {
	@Column(name = "buy_info", comment = "每月福利购买情况，记录ID跟数量", length = 1000)
	private Map<Integer, Integer> buyInfo = new HashMap<>();
	public Map<Integer, Integer> getBuyInfo() {
		return buyInfo;
	}
	public void setBuyInfo(Map<Integer, Integer> buyInfo) {
		this.buyInfo = buyInfo;
	}
}
