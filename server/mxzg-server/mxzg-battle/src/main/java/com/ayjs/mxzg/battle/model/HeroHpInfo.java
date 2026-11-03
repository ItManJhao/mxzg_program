package com.ayjs.mxzg.battle.model;

import lombok.Value;

/**
 * 血量信息
 * @author meiyc
 *
 */
@Value
public class HeroHpInfo {

	/**
	 * 当前剩余血量
	 */
	private long currentHp;
	
	/**
	 * 最大血量
	 */
	private long maxHp;
	
	
	public static HeroHpInfo createOf(HeroDo heroDo){
		return new HeroHpInfo(heroDo.getHp(), heroDo.getAttributeInfo().getMaxHp());
	}
	
	/**
	 * 获取血量剩余百分比
	 * @return
	 */
	public int getPercentageRemaining(){
		return (int)(currentHp / maxHp);
	}
}
