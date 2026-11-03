/**
 * 
 */
package com.ayjs.mxzg.config.struct;

/**
 * @author YY
 *
 */
public class GodAttr {
	/**
	 * 槽位号
	 */
	private int sort;
	/**
	 * 属性类型（ability_type）
	 */
	private int sysId;
	private int level;
	private int lock;
	public int getSort() {
		return sort;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public int getSysId() {
		return sysId;
	}
	public void setSysId(int sysId) {
		this.sysId = sysId;
	}
	public int getLock() {
		return lock;
	}
	public void setLock(int lock) {
		this.lock = lock;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
}
