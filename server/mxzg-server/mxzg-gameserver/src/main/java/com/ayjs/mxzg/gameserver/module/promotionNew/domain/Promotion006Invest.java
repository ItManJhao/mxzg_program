/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MonthCardInvest;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "promotion006_invest", comment = "月卡基金数据")
public class Promotion006Invest extends AbstractEntity {
	@Id
    @Column(name = "rid")
	private long rid;
	@Column(name = "show_type",comment = "0为正常显示模式，1为购买月卡后的显示模式")
	private int showType;
	@Column(name = "start_time",comment = "前端图标显示开始时间")
	private int startTime;
	@Column(name = "end_Time",comment = "前端图标显示结束时间")
	private int endTime;
	@Column(name = "invest", comment = "月卡基金信息", length = 500)
	private Map<Integer, MonthCardInvest> invest;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public Map<Integer, MonthCardInvest> getInvest() {
		return invest;
	}
	public void setInvest(Map<Integer, MonthCardInvest> invest) {
		this.invest = invest;
	}

	public int getStartTime() {
		return startTime;
	}

	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}

	public int getEndTime() {
		return endTime;
	}

	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}

	public int getShowType() {
		return showType;
	}

	public void setShowType(int showType) {
		this.showType = showType;
	}
}
