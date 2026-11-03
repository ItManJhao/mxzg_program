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
@Table(name = "promotion015_buyinfo", comment = "新服限购")
public class Promotion015BuyInfo extends BaseLoopingPromotion {
	@Column(name = "buy_info", length = 1000)
	private Map<Integer, Integer> buyInfo = new HashMap<>();
	public Map<Integer, Integer> getBuyInfo() {
		return buyInfo;
	}
	public void setBuyInfo(Map<Integer, Integer> buyInfo) {
		this.buyInfo = buyInfo;
	}
}
