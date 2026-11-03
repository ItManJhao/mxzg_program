///**
// *
// */
//package com.ayjs.mxzg.gameserver.module.achievement.domain;
//
//import com.ayjs.mxzg.common.persistence.AbstractEntity;
//import com.ayjs.mxzg.common.persistence.annotation.Column;
//import com.ayjs.mxzg.common.persistence.annotation.Entity;
//import com.ayjs.mxzg.common.persistence.annotation.Id;
//import com.ayjs.mxzg.common.persistence.annotation.Table;
//
///**
// * @author YY
// *
// */
//@Entity
//@Table(name = "daily_task_point", comment = "每日任务活跃度表")
//public class DailyTaskPoint extends AbstractEntity {
//	@Id
//	@Column(name = "rid", comment = "玩家ID")
//	private long rid;
//	@Column(name = "point", comment = "每日任务活跃度")
//	private int point;
//	@Column(name = "reward_1", comment = "活跃积分奖励。1档。未领取状态为0，已领取状态为1")
//	private int reward_1;
//	@Column(name = "reward_2", comment = "活跃积分奖励。2档。未领取状态为0，已领取状态为1")
//	private int reward_2;
//	@Column(name = "reward_3", comment = "活跃积分奖励。3档。未领取状态为0，已领取状态为1")
//	private int reward_3;
//	@Column(name = "reward_4", comment = "活跃积分奖励。4档。未领取状态为0，已领取状态为1")
//	private int reward_4;
//	@Column(name = "daily_time", comment = "每日重置时间")
//	private long dailyTime;
//
//	public long getRid() {
//		return rid;
//	}
//	public void setRid(long rid) {
//		this.rid = rid;
//	}
//	public int getPoint() {
//		return point;
//	}
//	public void setPoint(int point) {
//		this.point = point;
//	}
//	public int getReward_1() {
//		return reward_1;
//	}
//	public void setReward_1(int reward_1) {
//		this.reward_1 = reward_1;
//	}
//	public int getReward_2() {
//		return reward_2;
//	}
//	public void setReward_2(int reward_2) {
//		this.reward_2 = reward_2;
//	}
//	public int getReward_3() {
//		return reward_3;
//	}
//	public void setReward_3(int reward_3) {
//		this.reward_3 = reward_3;
//	}
//	public int getReward_4() {
//		return reward_4;
//	}
//	public void setReward_4(int reward_4) {
//		this.reward_4 = reward_4;
//	}
//	public long getDailyTime() {
//		return dailyTime;
//	}
//	public void setDailyTime(long dailyTime) {
//		this.dailyTime = dailyTime;
//	}
//}
