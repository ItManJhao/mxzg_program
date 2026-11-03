/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.domain;

import java.util.List;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.GodAttr;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "god_equip", comment = "神装表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class GodEquip extends AbstractEntity {
	@Id
	@LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "rid", comment = "玩家ID", readOnly = true)
	private long rid;
	@Column(name = "hero_id", comment = "英雄ID")
	private long heroId;
	@Column(name = "sys_id", comment = "配置表ID")
	private int sysId;
	@Column(name = "place", comment = "部位，决定对应系统的数据类型", readOnly = true)
	private int place;
	@Column(name = "attrs", comment = "属性列表")
	private List<GodAttr> attrs;
	@Column(name = "wash_attrs", comment = "洗练中的属性列表")
	private List<GodAttr> washAttrs;
	@Column(name = "wash_num",comment = "神装洗炼次数")
	private int washNum;
	
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
	public long getHeroId() {
		return heroId;
	}
	public void setHeroId(long heroId) {
		this.heroId = heroId;
	}
	public int getSysId() {
		return sysId;
	}
	public void setSysId(int sysId) {
		this.sysId = sysId;
	}
	public int getPlace() {
		return place;
	}
	public void setPlace(int place) {
		this.place = place;
	}
	public List<GodAttr> getAttrs() {
		return attrs;
	}
	public void setAttrs(List<GodAttr> attrs) {
		this.attrs = attrs;
	}
	public List<GodAttr> getWashAttrs() {
		return washAttrs;
	}
	public void setWashAttrs(List<GodAttr> washAttrs) {
		this.washAttrs = washAttrs;
	}

	public int getWashNum() {
		return washNum;
	}

	public void setWashNum(int washNum) {
		this.washNum = washNum;
	}
}
