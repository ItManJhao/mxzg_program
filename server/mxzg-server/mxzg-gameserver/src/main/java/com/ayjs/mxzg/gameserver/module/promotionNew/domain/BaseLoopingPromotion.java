/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;

/**
 * @author YY
 * 循环开启的活动
 */
@MappedSuperclass
public abstract class BaseLoopingPromotion extends AbstractEntity {
	@Id
    @Column(name = "rid")
	private long rid;
	@Column(name = "turns")
	private int turns;
	@Column(name = "turns_time")
	private int turnsTime;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getTurns() {
		return turns;
	}
	public void setTurns(int turns) {
		this.turns = turns;
	}
	public int getTurnsTime() {
		return turnsTime;
	}
	public void setTurnsTime(int turnsTime) {
		this.turnsTime = turnsTime;
	}
}
