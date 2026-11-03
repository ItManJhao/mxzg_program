/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.struct;

/**
 * @author YY
 *
 */
public class DragonIdentity {
	//鉴定类型
	private int type;
	//鉴定开始时间
	private int startTime;
	//鉴定级别
	private int level;
	//鉴定增加加速鉴定值
	private int speedAdd;
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public int getSpeedAdd() {
		return speedAdd;
	}
	public void setSpeedAdd(int speedAdd) {
		this.speedAdd = speedAdd;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
}
