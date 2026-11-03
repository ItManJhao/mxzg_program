package com.ayjs.mxzg.battle.model;

import lombok.Data;

/**
 * 英雄战斗日志
 * @author meiyc
 *
 */
@Data(staticConstructor="instance")
public class HeroFightLog {

	/**
	 * 总伤害
	 */
	private long totalDamage;

    /**
     * 总承受伤害
     */
    private long totalTakeDamage;
	/**
	 * 总治疗量
	 */
	private long totalRecovery;
	
	/**
	 * 增加伤害
	 * @param damage
	 */
    public void addDamage(long damage){
        this.totalDamage += Math.abs(damage);
    }

    /**
     * 增加承担伤害
     *
     * @param takeDamage
     */
    public void addTakeDamage(long takeDamage) {
        this.totalTakeDamage += Math.abs(takeDamage);
    }
	
	/**
	 * 恢复血量
	 * @param value
	 */
	public void addRecovery(long value){
		this.totalRecovery += value;
	}
	
}
