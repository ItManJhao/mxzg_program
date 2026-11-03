/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "signday", comment = "签到")
public class Signday extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "today_sign", comment = "今天是否已经签到，0未签到，1已签到，2已双倍签到")
	private int todaySign;
	@Column(name = "daily_time", comment = "每日重置时间")
	private long dailyTime;
	@Column(name = "day", comment = "本月已签到多少天")
	private int day;
	@Column(name = "month_time", comment = "每月重置时间")
	private long monthTime;
	@Column(name = "today_charge", comment = "今天是否有过充值，0没充值，1充过值")
	private int todayCharge;
	
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getTodaySign() {
		return todaySign;
	}
	public void setTodaySign(int todaySign) {
		this.todaySign = todaySign;
	}
	public long getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(long dailyTime) {
		this.dailyTime = dailyTime;
	}
	public int getDay() {
		return day;
	}
	public void setDay(int day) {
		this.day = day;
	}
	public long getMonthTime() {
		return monthTime;
	}
	public void setMonthTime(long monthTime) {
		this.monthTime = monthTime;
	}
	public int getTodayCharge() {
		return todayCharge;
	}
	public void setTodayCharge(int todayCharge) {
		this.todayCharge = todayCharge;
	}
}
