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
@Table(name = "promotion_exchange_list", comment = "", indexes = {
		@Index(name = "rid", columnList = { "rid" }) }, cache = { @Cache(columns = "rid") })
public class PromotionExchangeList extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
	@Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "idx")
	private int idx;
	@Column(name = "num")
	private int num;

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

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}
}
