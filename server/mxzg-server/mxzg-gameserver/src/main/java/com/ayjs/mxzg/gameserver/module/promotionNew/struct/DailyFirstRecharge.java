/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

/**
 * @author YY
 *
 */
public class DailyFirstRecharge {
	/**
	 * 类型
	 */
	private int type;
	/**
	 * 当天已充值金额
	 */
	private long money;
	/**
	 * 领奖状态，0未领取，1已领取
	 */
	private int status;
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public long getMoney() {
		return money;
	}
	public void setMoney(long money) {
		this.money = money;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
}
