/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.domain.base;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;

/**
 * @author YY
 * 具有部位特性的系统接口，比如装备、宝石，后续有类似的系统可进行此实现
 */
@MappedSuperclass
public abstract class HeroPlacingPart extends AbstractEntity {
	@Id
	@LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "rid", comment = "玩家ID", readOnly = true)
	private long rid;
	@Column(name = "sys_id", comment = "配置表ID")
	private int sysId;
	@Column(name = "hero_id", comment = "英雄ID")
	private long heroId;
	@Column(name = "place", comment = "部位，决定对应系统的数据类型", readOnly = true)
	private int place;
	
	/**
	 * 数据唯一ID
	 * @return
	 */
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	/**
	 * 数据所属的玩家ID
	 * @return
	 */
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	/**
	 * 部位系统数据物品ID
	 * @return
	 */
	public int getSysId() {
		return sysId;
	}
	public void setSysId(int sysId) {
		this.sysId = sysId;
	}
	/**
	 * 装配此部位的英雄ID
	 * @return
	 */
	public long getHeroId() {
		return heroId;
	}
	public void setHeroId(long heroId) {
		this.heroId = heroId;
	}
	/**
	 * 部位，对同一个玩家同一个英雄而言，是唯一且不变的
	 * @return
	 */
	public int getPlace() {
		return place;
	}
	public void setPlace(int place) {
		this.place = place;
	}
	
}
