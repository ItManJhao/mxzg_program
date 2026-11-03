/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.welfare.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "gift_pack_month", comment = "每月福利", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class GiftPackMonth extends AbstractEntity {
	@Id
	@Column(name = "id")
	private long id;
	@Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "gift_pack_id")
	private int giftPackId;
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
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getGiftPackId() {
		return giftPackId;
	}
	public void setGiftPackId(int giftPackId) {
		this.giftPackId = giftPackId;
	}
}
