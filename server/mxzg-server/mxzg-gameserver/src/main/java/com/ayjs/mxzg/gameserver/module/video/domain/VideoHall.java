package com.ayjs.mxzg.gameserver.module.video.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.protobuf.InvalidProtocolBufferException;

import java.io.UnsupportedEncodingException;

@Entity
@Table(name = "video_hall", comment = "系统的录像馆")
public class VideoHall extends AbstractEntity {
	@Id
    @LongIdGenerate
    @Column(name = "id", comment = "录像馆ID")
	private long id;
	@Column(name = "type", comment = "录像馆类型，1竞技场，2世界BOSS，3冠军赛，4跨服天梯", readOnly = true)
	private int type;
	@Column(name = "sub_type", comment = "录像的小类型，比如冠军赛的选拔赛，32强，16强等等")
	private int subType;
	@Column(name = "time", comment = "录像产生的时间")
	private int time;
	@Column(name = "extra", comment = "扩展信息", length = 200)
	private String extra;
	@Column(name = "battle_log", comment = "战斗日志", length = 10000)
	private String battle_log;

	private BattleGMsg.BattleLog battleLog;
	
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
	public String getExtra() {
		return extra;
	}
	public void setExtra(String extra) {
		this.extra = extra;
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
	public void setBattle_log(String battle_log) {
		this.battle_log = battle_log;
	}
	public String getBattle_log() {
		return battle_log;
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
