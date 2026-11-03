/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.protobuf.InvalidProtocolBufferException;

import java.io.UnsupportedEncodingException;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "video_role", comment = "玩家个人的录像馆", indexes = { @Index(name = "rid", columnList = "rid") }, cache = {
		@Cache(columns = {"rid", "kind"}) })
public class VideoRole extends AbstractEntity {
	@Id
    @LongIdGenerate
    @Column(name = "id", comment = "个人录像馆ID")
	private long id;
	@Column(name = "rid", comment = "玩家ID", readOnly = true)
	private long rid;
	@Column(name = "kind", comment = "录像馆类型，1个人记录，2个人收藏", readOnly = true)
	private int kind;
	@Column(name = "type", comment = "录像馆类型，1竞技场，2世界BOSS，3冠军赛，4跨服天梯")
	private int type;
	@Column(name = "sub_type", comment = "录像的小类型，比如冠军赛的选拔赛，32强，16强等等")
	private int subType;
	@Column(name = "time", comment = "录像产生的时间")
	private int time;
	@Column(name = "battle_log", comment = "战斗统计数据", length = 10000)
	private String battle_log;
	@Column(name = "hall_id", comment = "系统录像馆ID")
	private long hallId;
	@Column(name = "person_id", comment = "个人录像馆ID")
	private long personId;
	
	private BattleGMsg.BattleLog battleLog;
	
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
	public int getKind() {
		return kind;
	}
	public void setKind(int kind) {
		this.kind = kind;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getSubType() {
		return subType;
	}
	public void setSubType(int subType) {
		this.subType = subType;
	}
	public int getTime() {
		return time;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public long getHallId() {
		return hallId;
	}
	public void setHallId(long hallId) {
		this.hallId = hallId;
	}
	public long getPersonId() {
		return personId;
	}
	public void setPersonId(long personId) {
		this.personId = personId;
	}
	public String getBattle_log() {
		return battle_log;
	}
	public void setBattle_log(String battle_log) {
		this.battle_log = battle_log;
	}

	public BattleGMsg.BattleLog getBattleImage() {
		if(battleLog == null && battle_log != null) {
			try {
				battleLog = BattleGMsg.BattleLog.parseFrom(battle_log.getBytes(VideoConst.ISO));
			} catch (InvalidProtocolBufferException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return battleLog;
	}

}
