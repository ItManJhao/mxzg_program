/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.domain;

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
@Table(name = "rainbow_slot", comment = "彩虹圣殿槽位表")
public class RainbowSlot extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "type", comment = "槽位类型ID")
	private int type;
	@Column(name = "level", comment = "槽位等级")
	private int level;
	@Column(name = "rid", comment = "占领的玩家ID")
	private long rid;
	@Column(name = "end_time", comment = "占领结束时间")
	private int endTime;
	@Column(name = "pos", comment = "槽位的位置")
	private int pos;
	
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
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getEndTime() {
		return endTime;
	}
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}
	public int getPos() {
		return pos;
	}
	public void setPos(int pos) {
		this.pos = pos;
	}
}
