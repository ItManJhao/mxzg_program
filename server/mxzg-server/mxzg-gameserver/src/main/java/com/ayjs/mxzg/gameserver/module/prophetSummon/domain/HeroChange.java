/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.prophetSummon.domain;

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
@Table(name = "hero_change", comment = "英雄置换")
public class HeroChange extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "old_hero_id", comment = "被置换的英雄id")
	private long oldHeroId;
	@Column(name = "new_type", comment = "置换后的英雄类型")
	private int newType;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public long getOldHeroId() {
		return oldHeroId;
	}
	public void setOldHeroId(long oldHeroId) {
		this.oldHeroId = oldHeroId;
	}
	public int getNewType() {
		return newType;
	}
	public void setNewType(int newType) {
		this.newType = newType;
	}
}
