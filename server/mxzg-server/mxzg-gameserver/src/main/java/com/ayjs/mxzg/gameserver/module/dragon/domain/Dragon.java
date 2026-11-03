/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.domain;

import java.util.Map;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonIdentity;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonSlot;

/**
 * @author YY
 *
 */
@Table(name = "dragon", comment = "圣物、圣龙")
@Entity
public class Dragon extends AbstractEntity {
	@Id
    @Column(name = "rid", comment = "玩家ID")
	private long rid;
	
	@Column(name = "identify_level", comment = "鉴定等级，源石鉴定的速度")
	private int identifyLevel;
	
	@Column(name = "attr_level", comment = "属性等级")
	private int attrLevel;
	
	@Column(name = "identitys", comment = "鉴定数据")
	private Map<Integer, DragonIdentity> identitys;
	
	@Column(name = "slots", comment = "圣物槽位放置技能数据")
	private Map<Integer, DragonSlot> slots;
	
	@Column(name = "manuals", comment = "图鉴数据")
	private Set<Integer> manuals;
	
	@Column(name = "identity_num", comment = "鉴定次数")
	private Map<Integer, Integer> identityNum;

	public long getRid() {
		return rid;
	}

	public void setRid(long rid) {
		this.rid = rid;
	}

	public int getIdentifyLevel() {
		return identifyLevel;
	}

	public void setIdentifyLevel(int identifyLevel) {
		this.identifyLevel = identifyLevel;
	}

	public int getAttrLevel() {
		return attrLevel;
	}

	public void setAttrLevel(int attrLevel) {
		this.attrLevel = attrLevel;
	}

	public Map<Integer, DragonIdentity> getIdentitys() {
		return identitys;
	}

	public void setIdentitys(Map<Integer, DragonIdentity> identitys) {
		this.identitys = identitys;
	}

	public Set<Integer> getManuals() {
		return manuals;
	}

	public void setManuals(Set<Integer> manuals) {
		this.manuals = manuals;
	}

	public Map<Integer, DragonSlot> getSlots() {
		return slots;
	}

	public void setSlots(Map<Integer, DragonSlot> slots) {
		this.slots = slots;
	}

	public Map<Integer, Integer> getIdentityNum() {
		return identityNum;
	}

	public void setIdentityNum(Map<Integer, Integer> identityNum) {
		this.identityNum = identityNum;
	}
}
