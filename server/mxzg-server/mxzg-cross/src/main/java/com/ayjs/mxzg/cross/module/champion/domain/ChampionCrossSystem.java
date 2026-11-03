/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.domain;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionGroup;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "champion_cross_system", comment = "冠军赛系统信息")
public class ChampionCrossSystem extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "当前轮数，第几次冠军赛举")
	private int round;
	@Column(name = "config_id", comment = "赛季配置ID")
	private int configId;
	@Column(name = "start_time", comment = "冠军赛开始时间")
	private int startTime;
	@Column(name = "period", comment = "冠军赛阶段，0未开始，1选拔赛阶段、2淘汰赛阶段")
	private int period;
	@Column(name = "battle_round", comment = "进行到的对战轮数")
	private int battleRound;
	
	@Column(name = "stage", comment = "比赛阶段，1准备阶段，2竞猜阶段，3战斗阶段")
	private int stage;
	@Column(name = "next_stage_time", comment = "比赛阶段，1准备阶段，2竞猜阶段，3战斗阶段")
	private int nextStageTime;
	
	@Column(name = "round_start_time", comment = "赛季开始时间")
	private int roundStartTime;
	@Column(name = "round_end_time", comment = "赛季结束时间")
	private int roundEndTime;
	@Column(name = "last_start_time", comment = "上一期冠军赛的开始时间")
	private int lastStartTime;
	
	@Column(name = "group_result", comment = "竞猜、前三的结果信息")
	private ConcurrentMap<Integer, ChampionGroup> groupResult = new ConcurrentHashMap<>();
	
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
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public int getStage() {
		return stage;
	}
	public void setStage(int stage) {
		this.stage = stage;
	}
	public int getBattleRound() {
		return battleRound;
	}
	public void setBattleRound(int battleRound) {
		this.battleRound = battleRound;
	}
	public int getPeriod() {
		return period;
	}
	public void setPeriod(int period) {
		this.period = period;
	}
	public int getNextStageTime() {
		return nextStageTime;
	}
	public void setNextStageTime(int nextStageTime) {
		this.nextStageTime = nextStageTime;
	}
	public String nextStageTime() {
		return TimeDateUtil.time2String(this.getNextStageTime() * 1000l);
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
	public int getConfigId() {
		return configId;
	}
	public void setConfigId(int configId) {
		this.configId = configId;
	}
	public int getLastStartTime() {
		return lastStartTime;
	}
	public void setLastStartTime(int lastStartTime) {
		this.lastStartTime = lastStartTime;
	}
	public ConcurrentMap<Integer, ChampionGroup> getGroupResult() {
		return groupResult;
	}
	public void setGroupResult(ConcurrentMap<Integer, ChampionGroup> groupResult) {
		this.groupResult = groupResult;
	}
}
