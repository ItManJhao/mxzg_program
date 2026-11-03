/**
 * 
 */
package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.util.IDrop;

/**
 * @author YY
 *
 */
public class RollReward implements IDrop {
	private int type;
	private int chance;
	private int num = 1;
	public void setType(int type) {
		this.type = type;
	}

	public int getType() {
		return type;
	}

	public int getChance() {
		return chance;
	}

	@Override
	public int getRate() {
		return chance;
	}

	@Override
	public int getDropId() {
		return type;
	}

	public void setChance(int chance) {
		this.chance = chance;
	}
	public void setNum(int num) {
		this.num = num;
	}

	public ImmutableThing toReward() {
		return ImmutableThing.of(type, num, chance);
	}

	public int getNum() {
		return num;
	}
}
