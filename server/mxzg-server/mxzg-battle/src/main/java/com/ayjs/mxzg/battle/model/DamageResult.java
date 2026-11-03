package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.util.AttributeUtil;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * 计算伤害结果
 * @author meiyc
 *
 */
@Getter
@Setter
@Builder
public class DamageResult {

	/** 伤害 */
	private long damage;

	/** 初始伤害 */
	private long initialDamage;

	/** 累计后的总伤害 */
	private long totalDamage;
	
	/** 命中类型 */
	private HitType hitType;

	/**	是否是固定攻击 */
	private boolean fixedAttack;
	
	/** 是否格挡 */
	private boolean block;

	/**主动技能造成伤害时的bufId*/
	private int buffId;

	/** 是否有小熊格挡 */
	private boolean bear;
	
	/**
	 * 触发暴击时
	 * @return
	 */
	public boolean isCrit(){
		return this.hitType == HitType.CRIT;
	}

	/**
	 * 是否闪避
	 * @return
	 */
	public boolean isMiss(){
		return this.hitType == HitType.MISSING;
	}

	/**
	 * 是否没有结果
	 * @return
	 */
	public boolean isEmpty(){
		return this.hitType == null;
	}
	
	/**
	 * 创建一个不能被反击的伤害结果
	 * @param damage
	 * @return
	 */
	public static DamageResult createRealDamage(long damage){
		DamageResult.DamageResultBuilder result = DamageResult.builder();
		result.damage(damage).hitType(HitType.HIT).fixedAttack(true);
		return result.build();
	}

	/**
	 * 设置主动技能造成伤害的buffId
	 * @param buffId
	 */
	public void setBuffId(int buffId){
		this.buffId =  buffId;
	}

	/**
	 * 增加伤害倍数
	 * @param multiple
	 */
    public void increaseMultiple(int multiple) {
        this.damage *= multiple;
    }

	/**
	 * 获取击中类型
	 * @return
	 */
	public int getType(){
    	return this.hitType == null ? 0 : this.hitType.ordinal();
	}


	/**
	 * 增加伤害比例
	 * @param percent
	 */
	public void increasePercent(long percent) {
		this.damage += AttributeUtil.addPercent(this.damage, percent);
	}

	/**
	 * 增量修改伤害
	 * @param updateDamage
	 */
	public void updateDamage(long updateDamage){
		this.damage += updateDamage;
	}

	/**
	 * 修改总伤害
	 * @param damage
	 */
	public void updateTotalDamage(long damage){
		this.totalDamage += damage;
	}

	/**
	 * 设置伤害
	 * @param damage
	 */
	public void setDamage(long damage){
		this.damage = damage;
	}

}
