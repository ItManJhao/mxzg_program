/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.RechargeDays;

import java.util.Map;

/**
 * @author YY
 * 积天豪礼
 */
@Entity
@Table(name = "promotion060_recharge_days", comment = "积天豪礼2数据")
public class Promotion060RechargeDays extends AbstractEntity {
	@Id
    @Column(name = "rid")
	private long rid;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "curr_day", comment = "当前第几天")
	private int currDay;
	@Column(name = "days_map", comment = "每天的充值领奖信息")
	private Map<Integer, RechargeDays> daysMap;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(int dailyTime) {
		this.dailyTime = dailyTime;
	}
	public int getCurrDay() {
		return currDay;
	}
	public void setCurrDay(int currDay) {
		this.currDay = currDay;
	}
	public Map<Integer, RechargeDays> getDaysMap() {
		return daysMap;
	}
	public void setDaysMap(Map<Integer, RechargeDays> daysMap) {
		this.daysMap = daysMap;
	}
}
