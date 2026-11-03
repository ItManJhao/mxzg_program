/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.struct;

/**
 * @author YY
 *
 */
public class PvpRecord {
	/**
	 * 战斗ID
	 */
	private String battleId;
	private long atkId;
	/**
	 * 我的等级
	 */
	private int atkLv;
	private String defName;
	/**
	 * 对方的等级
	 */
	private int defLv;
	private int defHead;
	private int defBorder;
	/**
	 * 奖杯变化量
	 */
	private int cupDelta;
	/**
	 * 战斗结果，0负1胜
	 */
	private int result;
	/**
	 * 挑战还是防御，1挑战，2防御
	 */
	private int type;
	
	public String getBattleId() {
		return battleId;
	}
	public void setBattleId(String battleId) {
		this.battleId = battleId;
	}
	public int getAtkLv() {
		return atkLv;
	}
	public void setAtkLv(int atkLv) {
		this.atkLv = atkLv;
	}
	public String getDefName() {
		return defName;
	}
	public void setDefName(String defName) {
		this.defName = defName;
	}
	public int getDefLv() {
		return defLv;
	}
	public void setDefLv(int defLv) {
		this.defLv = defLv;
	}
	public int getCupDelta() {
		return cupDelta;
	}
	public void setCupDelta(int cupDelta) {
		this.cupDelta = cupDelta;
	}
	public int getResult() {
		return result;
	}
	public void setResult(int result) {
		this.result = result;
	}
	public int getDefHead() {
		return defHead;
	}
	public void setDefHead(int defHead) {
		this.defHead = defHead;
	}
	public long getAtkId() {
		return atkId;
	}
	public void setAtkId(long atkId) {
		this.atkId = atkId;
	}
	public int getDefBorder() {
		return defBorder;
	}
	public void setDefBorder(int defBorder) {
		this.defBorder = defBorder;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
}
