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
@Table(name = "promotion019_levelinfo", comment = "升级有礼")
public class Promotion019LevelInfo extends BaseLoopingPromotion {
	@Column(name = "level_info", length = 1000)
	private Map<Integer, Integer> levelInfo = new HashMap<>();
	public Map<Integer, Integer> getLevelInfo() {
		return levelInfo;
	}
	public void setLevelInfo(Map<Integer, Integer> levelInfo) {
		this.levelInfo = levelInfo;
	}
}
