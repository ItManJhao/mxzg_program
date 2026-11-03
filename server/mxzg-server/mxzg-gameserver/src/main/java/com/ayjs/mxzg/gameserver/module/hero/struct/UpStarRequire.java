/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.struct;

/**
 * @author YY
 *
 */
public class UpStarRequire {
	private int type;
	private int elem;
	private int star;
	private int num;
    private int replace_item; // 所需英雄的替代道具
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getElem() {
		return elem;
	}
	public void setElem(int elem) {
		this.elem = elem;
	}
	public int getStar() {
		return star;
	}
	public void setStar(int star) {
		this.star = star;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getReplace_item() {
		return replace_item;
	}
	public void setReplace_item(int replace_item) {
		this.replace_item = replace_item;
	}
}
