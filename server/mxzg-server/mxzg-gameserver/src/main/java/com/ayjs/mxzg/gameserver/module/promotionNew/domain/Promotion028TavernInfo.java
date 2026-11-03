/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "promotion028_taverninfo", comment = "酒馆常客")
public class Promotion028TavernInfo extends BaseRankablePormotion {
	@Column(name = "take_rewards", comment = "已经领取的奖励ID")
	private List<Integer> takeRewards = new ArrayList<>();
	public List<Integer> getTakeRewards() {
		return takeRewards;
	}
	public void setTakeRewards(List<Integer> takeRewards) {
		this.takeRewards = takeRewards;
	}
}
