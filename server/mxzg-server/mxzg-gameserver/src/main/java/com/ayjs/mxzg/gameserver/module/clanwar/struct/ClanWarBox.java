/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.struct;

/**
 * @author YY
 *
 */
public class ClanWarBox {
	private int pos;
	private long rid;
	private String name;
	private int item;
	private long num;
	public int getPos() {
		return pos;
	}
	public void setPos(int pos) {
		this.pos = pos;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getItem() {
		return item;
	}
	public void setItem(int item) {
		this.item = item;
	}
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public long getNum() {
		return num;
	}
	public void setNum(long num) {
		this.num = num;
	}
}
