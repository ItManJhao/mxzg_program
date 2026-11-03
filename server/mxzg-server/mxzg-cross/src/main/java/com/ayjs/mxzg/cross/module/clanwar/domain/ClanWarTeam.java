/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
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
@Table(name = "clanwar_team", comment = "公会战出战队伍")
//@Getter
//@Setter
public class ClanWarTeam extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "road", comment = "路号")
	private int road;
	@Column(name = "sort", comment = "排序位置， 越小的序号越先对战")
	private int sort;
	@Column(name = "alive", comment = "队伍是否存活，0死亡，1存活")
	private int alive;
	@Column(name = "battler_vo", comment = "本次公会战的战队战斗属性记录")
	private BattlerVo battlerVo;
	@Column(name = "fighting", comment = "战斗力")
	private int fighting;
	
	//队伍是否显示为存活，0死亡，1存活
	private int showAlive;
	
	
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getRoad() {
		return road;
	}
	public void setRoad(int road) {
		this.road = road;
	}
	public int getSort() {
		return sort;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public int getAlive() {
		return alive;
	}
	public void setAlive(int alive) {
		this.alive = alive;
	}
	public BattlerVo getBattlerVo() {
		return battlerVo;
	}
	public void setBattlerVo(BattlerVo battlerVo) {
		this.battlerVo = battlerVo;
	}
	public int getShowAlive() {
		return showAlive;
	}
	public void setShowAlive(int showAlive) {
		this.showAlive = showAlive;
	}
	public int getFighting() {
		return fighting;
	}
	public void setFighting(int fighting) {
		this.fighting = fighting;
	}
	
}
