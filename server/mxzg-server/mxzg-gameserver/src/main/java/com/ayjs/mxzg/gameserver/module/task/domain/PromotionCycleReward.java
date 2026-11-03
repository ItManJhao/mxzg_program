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
@Table(name = "promotion_cycle_reward", comment = "", indexes = {
		@Index(name = "rid", columnList = { "rid" }) }, cache = { @Cache(columns = "rid") })
public class PromotionCycleReward extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
    @Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "type", comment = "活动类型")
	private int type;
	@Column(name = "idx", comment = "领取的奖励类型")
	private int idx;
	@Column(name = "reward", comment = "是否领取奖励？")
	private int reward;
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
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getReward() {
		return reward;
	}
	public void setReward(int reward) {
		this.reward = reward;
	}
}
