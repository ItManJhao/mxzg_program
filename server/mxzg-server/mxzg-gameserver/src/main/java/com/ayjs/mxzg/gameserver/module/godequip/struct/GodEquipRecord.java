/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.struct;

/**
 * @author YY
 *
 */
public class GodEquipRecord {
	private String name;
	private int itemType;
	private long itemNum;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public int getItemType() {
		return itemType;
	}

	public void setItemType(int itemType) {
		this.itemType = itemType;
	}

	public long getItemNum() {
		return itemNum;
	}

	public void setItemNum(long itemNum) {
		this.itemNum = itemNum;
	}
}
