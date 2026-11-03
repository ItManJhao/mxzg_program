/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.domain;

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
@Table(name = "rainbow_record", comment = "彩虹圣殿槽位挑战记录表", indexes = {
		@Index(name = "slotrecord", columnList = { "slot_id" }) }, cache = { @Cache(columns = "slot_id") })
public class RainbowRecord extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "slot_id", comment = "槽位数据的唯一ID", readOnly = true)
	private long slotId;
	@Column(name = "battle_log", comment = "血量统计的战报", length = 2000)
	private String battleLog;
	@Column(name = "time", comment = "时间")
	private int time;
	@Column(name = "evolution", comment = "挑战进化次数")
	private int evolution;
	@Column(name = "battle_id", comment = "战斗ID")
	private String battleId;
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getBattleLog() {
		return battleLog;
	}
	public void setBattleLog(String battleLog) {
		this.battleLog = battleLog;
	}
	public int getTime() {
		return time;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public int getEvolution() {
		return evolution;
	}
	public void setEvolution(int evolution) {
		this.evolution = evolution;
	}
	public String getBattleId() {
		return battleId;
	}
	public void setBattleId(String battleId) {
		this.battleId = battleId;
	}
	public long getSlotId() {
		return slotId;
	}
	public void setSlotId(long slotId) {
		this.slotId = slotId;
	}
}
