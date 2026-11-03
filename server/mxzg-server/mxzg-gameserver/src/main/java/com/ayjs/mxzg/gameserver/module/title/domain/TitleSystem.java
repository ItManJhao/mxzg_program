/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.domain;

import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "title_system", comment = "称号的系统数据")
public class TitleSystem extends AbstractEntity {
	@Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "type", comment = "称号系统类型")
	private int type;
	@Column(name = "owners", comment = "称号拥有者")
	private Set<Long> owners;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public Set<Long> getOwners() {
		return owners;
	}
	public void setOwners(Set<Long> owners) {
		this.owners = owners;
	}
}
