/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.domain;

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
@Table(name = "clanworldboss_stage_control", comment = "公会世界BOSS阶段控制器")
public class ClanWorldBossStageControl extends AbstractEntity {
	@Id
	@Column(name = "id")
	@LongIdGenerate
	private long id;
	@Column(name = "round", comment = "当前轮数，第几次BOSS战")
	private int round;
	@Column(name = "stage_config_id", comment = "活动阶段配置ID")
	private int stageConfigId;
	@Column(name = "week_start_time", comment = "本周BOSS战循环的开始时间")
	private int weekStartTime;
	@Column(name = "stage", comment = "当前阶段")
	private int stage;
	@Column(name = "next_stage_time", comment = "下一阶段的开始时间")
	private int nextStageTime;
	@Column(name = "round_start_time", comment = "本轮公会世界BOSS战开始时间")
	private int roundStartTime;
	@Column(name = "round_end_time", comment = "本轮公会世界BOSS战结束时间")
	private int roundEndTime;
	@Column(name = "boss_id", comment = "BOSS配置ID")
	private int bossId;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getRound() {
		return round;
	}
	public void setRound(int round) {
		this.round = round;
	}
	public int getStageConfigId() {
		return stageConfigId;
	}
	public void setStageConfigId(int stageConfigId) {
		this.stageConfigId = stageConfigId;
	}
	public int getWeekStartTime() {
		return weekStartTime;
	}
	public void setWeekStartTime(int weekStartTime) {
		this.weekStartTime = weekStartTime;
	}
	public int getStage() {
		return stage;
	}
	public void setStage(int stage) {
		this.stage = stage;
	}
	public int getNextStageTime() {
		return nextStageTime;
	}
	public void setNextStageTime(int nextStageTime) {
		this.nextStageTime = nextStageTime;
	}
	public int getRoundEndTime() {
		return roundEndTime;
	}
	public void setRoundEndTime(int roundEndTime) {
		this.roundEndTime = roundEndTime;
	}
	public int getBossId() {
		return bossId;
	}
	public void setBossId(int bossId) {
		this.bossId = bossId;
	}
	public int getRoundStartTime() {
		return roundStartTime;
	}
	public void setRoundStartTime(int roundStartTime) {
		this.roundStartTime = roundStartTime;
	}
}
