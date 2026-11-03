/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.struct;

/**
 * @author YY
 *
 */
public class HeroSnapshot {
	private long rid;
	private long id;
	private int level;
	private int type;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
}
