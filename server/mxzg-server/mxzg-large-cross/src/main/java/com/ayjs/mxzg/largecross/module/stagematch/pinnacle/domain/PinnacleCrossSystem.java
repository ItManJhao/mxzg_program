/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleGroup;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;


@Entity
@Table(name = "pinnacle_cross_system", comment = "巅峰赛系统信息")
public class PinnacleCrossSystem extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "当前轮数，第几次巅峰赛举")
	private int round;
	@Column(name = "start_time", comment = "巅峰赛开始时间")
	private int startTime;
	@Column(name = "opening", comment = "是否开启中")
	private boolean opening;
	@Column(name = "period", comment = "巅峰赛阶段，0未开始，1淘汰赛阶段")
	private int period;
	@Column(name = "battle_round", comment = "进行到的对战轮数, 128, 64, 32, 16, 8, 4, 2")
	private int battleRound;
	@Column(name = "stage", comment = "比赛阶段，1准备阶段，2竞猜阶段，3战斗阶段")
	private int stage;
	@Column(name = "next_stage_time", comment = "比赛阶段，1准备阶段，2竞猜阶段，3战斗阶段")
	private int nextStageTime;
	@Column(name = "last_start_time", comment = "上一期冠军赛的开始时间")
	private int lastStartTime;
	
	@Column(name = "group_result", comment = "竞猜、前三的结果信息")
	private ConcurrentMap<Integer, PinnacleGroup> groupResult = new ConcurrentHashMap<>();
	
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
	public int getLastStartTime() {
		return lastStartTime;
	}
	public void setLastStartTime(int lastStartTime) {
		this.lastStartTime = lastStartTime;
	}
	public ConcurrentMap<Integer, PinnacleGroup> getGroupResult() {
		return groupResult;
	}
	public void setGroupResult(ConcurrentMap<Integer, PinnacleGroup> groupResult) {
		this.groupResult = groupResult;
	}

	public boolean isOpening() {
		return opening;
	}

	public void setOpening(boolean opening) {
		this.opening = opening;
	}
}
