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
@Table(name = "promotion016_dragoninfo", comment = "龙鳞印记兑换信息")
public class Promotion016DragonInfo extends BaseLoopingPromotion implements IPromotionDropsDomain {
	@Column(name = "last_drop_time", comment = "上一次稳定掉落的时间")
	private int lastDropTime;
	@Column(name = "dragon_info", length = 1000)
	private Map<Integer, Integer> dragonInfo = new HashMap<>();
	public Map<Integer, Integer> getDragonInfo() {
		return dragonInfo;
	}
	public void setDragonInfo(Map<Integer, Integer> dragonInfo) {
		this.dragonInfo = dragonInfo;
	}
	public int getLastDropTime() {
		return lastDropTime;
	}
	public void setLastDropTime(int lastDropTime) {
		this.lastDropTime = lastDropTime;
	}
}
