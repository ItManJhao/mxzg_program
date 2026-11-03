/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.HashMap;
import java.util.Map;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.DailyFirstRecharge;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "promotion021_dailycharge", comment = "每日充值")
public class Promotion021DailyCharge extends BaseLoopingPromotion {
	/**
	 * 每日首充类型信息
	 */
	@Column(name = "recharges", comment = "每日首充类型信息")
	private Map<Integer, DailyFirstRecharge> recharges = new HashMap<>();

	public Map<Integer, DailyFirstRecharge> getRecharges() {
		return recharges;
	}

	public void setRecharges(Map<Integer, DailyFirstRecharge> recharges) {
		this.recharges = recharges;
	}
}
