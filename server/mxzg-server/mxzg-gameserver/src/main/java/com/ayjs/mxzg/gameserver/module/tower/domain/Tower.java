/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.tower.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tower", comment = "环境之塔玩家数据")
public class Tower extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "stage", comment = "可以挑战的下一层")
	private int stage;
	@Column(name = "energy",comment = "体力")
	private int energy;
	@Column(name = "energy_time", comment = "体力回复时间")
	private int energyTime;
	@Column(name = "sweep_times", comment = "扫荡次数")
	private int sweepTimes;
	@Column(name = "stage_reward", comment = "已领取的关卡目标奖励")
	private List<Integer> stageReward = new ArrayList<>();
	@Column(name = "stage_reward_id", comment = "新的已领取的关卡id")
	private List<Integer> stageRewardId = new ArrayList<>();
	@Column(name = "time", comment = "到达当前层数的时间")
	private int time;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "last_raiders", comment = "最近的通关攻略")
	private TowerRaiders lastRaiders;
	
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getStage() {
		return stage;
	}
	public void setStage(int stage) {
		this.stage = stage;
	}
	public int getEnergy() {
		return energy;
	}
	public void setEnergy(int energy) {
		this.energy = energy;
	}
	public int getTime() {
		return time;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public int getEnergyTime() {
		return energyTime;
	}
	public void setEnergyTime(int energyTime) {
		this.energyTime = energyTime;
	}
	public int getSweepTimes() {
		return sweepTimes;
	}
	public void setSweepTimes(int sweepTimes) {
		this.sweepTimes = sweepTimes;
	}
	public List<Integer> getStageReward() {
		return stageReward;
	}
	public void setStageReward(List<Integer> stageReward) {
		this.stageReward = stageReward;
	}
	public int getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(int dailyTime) {
		this.dailyTime = dailyTime;
	}

	public List<Integer> getStageRewardId() {
		return stageRewardId;
	}

	public void setStageRewardId(List<Integer> stageRewardId) {
		this.stageRewardId = stageRewardId;
	}

	public TowerRaiders getLastRaiders() {
		return lastRaiders;
	}

	public void setLastRaiders(TowerRaiders lastRaiders) {
		this.lastRaiders = lastRaiders;
	}
}
