/**
 * 
 */
package com.ayjs.mxzg.cross.module.ladder.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 * 
 */
@Entity
@Table(name = "cross_ladder_role", comment = "天梯玩家数据")
public class CrossLadderRole extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "battler_vo", comment = "战斗布阵数据", nullable = true)
	private BattlerVo battlerVo;
	@Column(name = "fighting", comment = "阵容战斗力")
	private int fighting;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public BattlerVo getBattlerVo() {
		return battlerVo;
	}
	public void setBattlerVo(BattlerVo battlerVo) {
		this.battlerVo = battlerVo;
	}
	public int getFighting() {
		return fighting;
	}
	public void setFighting(int fighting) {
		this.fighting = fighting;
	}
}
