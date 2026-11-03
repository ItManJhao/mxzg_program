/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.marquee.struct;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 * 跑马灯
 */
public class Marquee {
	/** 唯一ID */
	private int id;
	/** 配置ID */
	private int sysId;
	/** 参数 */
	private List<String> params = new ArrayList<>();
	/** 最终的播报内容，现在前端没有做参数的解释，多语言版本时需要前端来解释参数 */
	private String finalContent;
	/** 需要播报多少次 */
	private int loopCount;
	/** 当前播到第几次 */
	private int currCount;
	/** 间隔时间 */
	private int spaceTime;
	/** 下一次播报时间 */
	private int nextTime;
	/** 播报范围 */
	private int scope;
	/** 播报目标 */
	private long targetId;
	/** 后台唯一ID */
	private long platformId;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getSysId() {
		return sysId;
	}
	public void setSysId(int sysId) {
		this.sysId = sysId;
	}
	public String getFinalContent() {
		return finalContent;
	}
	public void setFinalContent(String finalContent) {
		this.finalContent = finalContent;
	}
	public int getLoopCount() {
		return loopCount;
	}
	public void setLoopCount(int loopCount) {
		this.loopCount = loopCount;
	}
	public int getCurrCount() {
		return currCount;
	}
	public void setCurrCount(int currCount) {
		this.currCount = currCount;
	}
	public int getSpaceTime() {
		return spaceTime;
	}
	public void setSpaceTime(int spaceTime) {
		this.spaceTime = spaceTime;
	}
	public int getNextTime() {
		return nextTime;
	}
	public void setNextTime(int nextTime) {
		this.nextTime = nextTime;
	}
	public List<String> getParams() {
		return params;
	}
	public void setParams(List<String> params) {
		this.params = params;
	}
	public int getScope() {
		return scope;
	}
	public void setScope(int scope) {
		this.scope = scope;
	}
	public long getTargetId() {
		return targetId;
	}
	public void setTargetId(long targetId) {
		this.targetId = targetId;
	}
	public long getPlatformId() {
		return platformId;
	}
	public void setPlatformId(long platformId) {
		this.platformId = platformId;
	}
}
