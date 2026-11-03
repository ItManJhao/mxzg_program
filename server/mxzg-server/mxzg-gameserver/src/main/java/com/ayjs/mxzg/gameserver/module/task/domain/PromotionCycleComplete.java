/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "promotion_cycle_complete", comment = "", indexes = {
		@Index(name = "rid", columnList = { "rid" }) }, cache = { @Cache(columns = "rid") })
public class PromotionCycleComplete extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
    @Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "times")
	private int times;
	@Column(name = "type")
	private int type;
	@Column(name = "round")
	private int round;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getRid() {
		return rid;
	}

	public void setRid(long rid) {
		this.rid = rid;
	}

	public int getTimes() {
		return times;
	}

	public void setTimes(int times) {
		this.times = times;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getRound() {
		return round;
	}

	public void setRound(int round) {
		this.round = round;
	}
}
