package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.protocol.BattleGMsg.GoddessUnit;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.Map;

/**
 * 女神
 * @author meiyc
 *
 */
@Getter
@Setter
public class Goddess {

	private int unitId;	//单位id	
	private int goddessId;	//羁绊女神id
	private int energy;	//能量
	private int maxEnergy;	//最大能量
	private SkillDo skill;	//技能
	private long attack;	// 攻击
	private int uplimitLevel;	//突破等级
	private HeroDo camouflage;	//伪装成一个英雄
	private int fashionId;		//皮肤id
	
	public static Goddess createOf(int goddessId, long attack , SkillDo skill, int uplimitLevel, int energy, int fashionId){
		Goddess goddess = new Goddess();
		goddess.setGoddessId(goddessId);
		goddess.setAttack(attack);
		goddess.setSkill(skill);
		goddess.setUplimitLevel(uplimitLevel);
		goddess.setEnergy(energy);
		goddess.setFashionId(fashionId);
		return goddess;
	}

	/**
	 * 初始化女神
	 * @param unitId
	 * @param faction
	 */
	public void initialize(int unitId, Faction faction){
		this.unitId = unitId;
		this.maxEnergy = BattleConstant.GODDESS_MAX_ENERGY;
		
		Map<AttributeType, Long> attributes = Maps.newHashMap();
		attributes.put(AttributeType.ATTACK, this.attack);
		attributes.put(AttributeType.HP, 1L);
		AttributeInfo attributeInfo = AttributeInfo.valueOf(attributes);
		HeroDo.HeroDoBuilder builder = HeroDo.builder();
		builder.unitId(unitId).faction(faction).attributeInfo(attributeInfo);
		builder.skillInfo(SkillInfo.createOf(Collections.emptyList())).actionInfo(ActionInfo.getInstance());
		this.camouflage = builder.build();
		this.camouflage.initAttribute();
	}
	
	/**
	 * 恢复能量
	 */
	public void restoreEnergy(){
		this.energy += BattleConstant.GODDESS_ROUND_RESTORE_ENERGY;		
	}
	
	/**
	 * 清空能量
	 */
	public void cleanEnergy(){
		this.energy = 0;
	}
	
	/**
	 * 能量是否满了
	 * @return
	 */
	public boolean energyIsFull(){
		return this.energy >= this.maxEnergy;
	}
	
	/**
	 * 转换成协议对象
	 * @return
	 */
	public GoddessUnit toGoddessUnit(){
		GoddessUnit.Builder builder = GoddessUnit.newBuilder();
		builder.setUnitId(this.unitId).setGoddessId(this.goddessId);
		builder.setEnergy(this.energy).setMaxEnergy(this.maxEnergy).setUplimitLevel(this.uplimitLevel).setFashionId(this.fashionId);
		return builder.build();
	}
	
}
