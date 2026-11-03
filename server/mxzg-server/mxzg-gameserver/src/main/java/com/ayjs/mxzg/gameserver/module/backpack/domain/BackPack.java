/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Data;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "back_pack", comment = "道具背包表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class BackPack extends AbstractEntity {
	@Id
	@LongIdGenerate
    @Column(name = "id")
	private long id;
	@Column(name = "rid", readOnly= true)
	private long rid;
	@Column(name = "item_id", comment = "道具ID")
	private int itemId;
	@Column(name = "num", comment = "数量")
	private long num;
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
	public int getItemId() {
		return itemId;
	}
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	public long getNum() {
		return num;
	}
	public void setNum(long num) {
		this.num = num;
	}
}
