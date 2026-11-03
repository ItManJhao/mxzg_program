/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.domain;

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
@Table(name = "clanwar_stage_control", comment = "公会战阶段控制器")
public class ClanWarStageControl extends AbstractEntity {
	@Id
	@Column(name = "id")
	@LongIdGenerate
	private long id;
	@Column(name = "round", comment = "当前轮数，第几次公会战")
	private int round;
	@Column(name = "stage", comment = "当前阶段")
	private int stage;
	@Column(name = "next_stage_time", comment = "下一阶段的开始时间")
	private int nextStageTime;
	@Column(name = "config_id", comment = "活动配置ID")
	private int configId;
	@Column(name = "next_battle_time", comment = "下一次战斗的时间")
	private int nextBattleTime;
	@Column(name = "init_battle", comment = "是否已经初始化战斗信息，0未初始化，1已初始化")
	private int initBattle;
	@Column(name = "week_start_time", comment = "本周公会战循环的开始时间")
	private int weekStartTime;
	@Column(name = "round_start_time", comment = "本轮公会战开始时间")
	private int roundStartTime;
	@Column(name = "round_end_time", comment = "本轮公会战结束时间")
	private int roundEndTime;
	@Column(name = "first_round_time", comment = "首轮公会战开始时间")
	private int firstRoundTime;
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
	public int getConfigId() {
		return configId;
	}
	public void setConfigId(int configId) {
		this.configId = configId;
	}
	public int getNextBattleTime() {
		return nextBattleTime;
	}
	public void setNextBattleTime(int nextBattleTime) {
		this.nextBattleTime = nextBattleTime;
	}
	public int getInitBattle() {
		return initBattle;
	}
	public void setInitBattle(int initBattle) {
		this.initBattle = initBattle;
	}
	public int getWeekStartTime() {
		return weekStartTime;
	}
	public void setWeekStartTime(int weekStartTime) {
		this.weekStartTime = weekStartTime;
	}
	public int getRoundStartTime() {
		return roundStartTime;
	}
	public void setRoundStartTime(int roundStartTime) {
		this.roundStartTime = roundStartTime;
	}
	public int getRoundEndTime() {
		return roundEndTime;
	}
	public void setRoundEndTime(int roundEndTime) {
		this.roundEndTime = roundEndTime;
	}
	public int getFirstRoundTime() {
		return firstRoundTime;
	}
	public void setFirstRoundTime(int firstRoundTime) {
		this.firstRoundTime = firstRoundTime;
	}
}
