/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.struct;

/**
 * @author YY
 *
 */
public class TavernCondition {
	private int star;
	private int element;
	private int occupation;
	private boolean match;
	public int getStar() {
		return star;
	}
	public void setStar(int star) {
		this.star = star;
	}
	public int getElement() {
		return element;
	}
	public void setElement(int element) {
		this.element = element;
	}
	public int getOccupation() {
		return occupation;
	}
	public void setOccupation(int occupation) {
		this.occupation = occupation;
	}
	public boolean isMatch() {
		return match;
	}
	public void setMatch(boolean match) {
		this.match = match;
	}
}
