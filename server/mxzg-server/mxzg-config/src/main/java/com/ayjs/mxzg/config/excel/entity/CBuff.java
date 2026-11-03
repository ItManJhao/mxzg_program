package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.AttackType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffConstant;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import com.google.common.collect.Lists;
import lombok.Getter;

import java.util.Arrays;
import java.util.List;

/**
 * 英雄技能BUFF
 * 
 */
@Getter
public class CBuff implements BaseExcelModel {
	
	public int idx;	
	public BuffType type;	
	public int target_num;	
	public int round;	
	public int attach_percent;	
	public Integer[] value;	
	public List<Integer> art_list;
	public int conflict_type;	// 冲突类型
	public int stacking_max;	// 最大叠加次数
	private int buff_icon;
	private EffectType effecttype;	// buff效果类型
	private boolean dispelled;		// 是否可以驱散
	private boolean passive;		// 是否是被动，被动属性计算过就不在战斗中执行

	@Override
	public int getExcelId() {
		return idx;
	}

	/**
	 * 获取技能伤害比例值
	 * @return
	 */
	public int getSkillDamageValue(){
		return value[BuffConstant.SKILL_DAMAGE_INDEX];
	}
	
	/**
	 * 是否能触发反击
	 * @return
	 */
	public boolean isCounterattack(){
		Integer attackType = value[BuffConstant.COUNTERATTACK_INDEX];
		if(AttackType.NOT_COUNTERATTACK.ordinal() != attackType){
			return true;
		}
		return false;
	}

	/**
	 * 是否是带icon的buff
	 * @return
	 */
	public boolean isIconBuff(){
		return this.buff_icon != 0;
	}

	/**
	 * 起服标记改buff是不是计算面板属性时计算过了
	 */
	public void setPassive(){
		this.passive = true;
	}

	/**
	 * 目标是否死亡后还能执行
	 * @return
	 */
	public boolean isDeathExecute(){
		return !this.type.isLogic() || this.type.isDeathExecute();
	}
	
	/**
	 * 不是回合buff
	 * @return
	 */
	public boolean notRoundBuff(){
		return !this.type.isRoundBuff();
	}
	
	/**
	 * 不是触发类buff
	 * @return
	 */
	public boolean notTrigger(){
		return !this.type.triggerArt() && this.type.listenType() == null && this.type.listenType2() == null;
	}
	
	/**
	 * buff是否命中 debuff的概率另算
	 * @return
	 */
	public boolean isHit(){
        return isResistanceBuff() || RandomUtils.isHit(getAttchPercent());
	}

	/**
	 * 是否是抗性buff，能被抵抗的buff有各自抽象类单独算概率
	 * @return
	 */
	public boolean isResistanceBuff(){
		return (this.effecttype == EffectType.DEBUFF  && this.getType().buffResistanceAttribute() != null ) ||  this.effecttype == EffectType.CONTROL;
	}
	
	/**
	 * 获取buff命中概率
	 * @return
	 */
	public double getAttchPercent(){
		return this.attach_percent / BuffConstant.BUFF_PROBABILITY;
	}
	
	/**
	 * 获取位置列表
	 * @return
	 */
	public List<Integer> getValues(){
		return Lists.newArrayList(this.value);
	}

	/**
	 * 是否是属性buff类型
	 * @return
	 */
	public boolean isAttributeType(){
		return this.type == BuffType.BT_ABILITY_ADD || this.type == BuffType.BT_HP_MAX_CHANGE || this.type.stateAttributeBuff();
	}
	
	/**
	 * 获取属性类型
	 * @return
	 */
	public AttributeType getAttributeType(){
		if(this.type == BuffType.BT_HP_MAX_CHANGE){
			return AttributeType.HP_PERCENT;
		}
		int attributeType = this.value[0];
		return ConvertUtils.toEnum(attributeType, AttributeType.class);
	}
	
	/**
	 * 获取属性值
	 * @return
	 */
	public long getAttributeValue(){
		if(this.type == BuffType.BT_HP_MAX_CHANGE){
			return this.value[0];
		}
		return this.value[1];
	}
	/**
	 * 是否控制类BUFF
	 * @return
	 */
	public boolean isControlBuff() {
		return this.effecttype == EffectType.CONTROL;
	}

	/**
	 * 是否控制类BUFF
	 * @return
	 */
	public boolean isDeBuff() {
		return this.effecttype == EffectType.CONTROL || this.effecttype == EffectType.DEBUFF;
	}

	@Override
	public String toString() {
		return idx + ", " + type + ", " + Arrays.toString(value);
	}
}