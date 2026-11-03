package com.ayjs.mxzg.battle.util;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHeroElemMul;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ActiveType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.Element;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 战斗公式帮助类
 * @author meiyc
 *
 */
public class FightUtil {


	/**
	 * 计算伤害
	 * @param skillDamage 技能伤害
	 * @param attacker
	 * @param defender
	 * @param fixedAttack 固定攻击不能暴击，格挡，能量加成
	 * @return
	 */
	public static DamageResult calDamage(int skillDamage, HeroDo attacker, HeroDo defender, boolean fixedAttack){
		DamageResult.DamageResultBuilder builder = DamageResult.builder().hitType(HitType.HIT);
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		long fixedDamage = attacker.getAttribute(AttributeType.DAMAGE);
		double armorRate = attacker.getRate(AttributeType.ARMOR_PERCENT);
		double damageAddRate = attacker.getRate(AttributeType.FINAL_DAMAGE_ADD_PERCENT);
		double skillDamageRate = AttributeUtil.calPercent(skillDamage);
		double elementRestraintRate = getElementRestraintRate(attacker, defender);
		double defenseRate = calDefenseRate(defender);
		double damageReduceRate = Math.min(defender.getRate(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT), 0.75);
		double addSkillDamageRate = calSkillDamageAddRate(attacker);
		double precisionDamageAddRate = calPrecisionDamageAddRate(attacker, defender);
		double weakDamageAddRate = defender.getRate(AttributeType.WEAK);
		double adversarialAttributes = getAdversarialAttributes(attacker, defender);
		double damageTypeAdd = getDamageAddPercent(attacker);

		boolean isHit = isHitRate(attacker, defender);
		if(!isHit){
			builder.damage(-1).hitType(HitType.MISSING);
			return builder.build();
		}

		boolean isCrit = isCrit(attacker, defender);
		double critRate = 1.0;
        if (!fixedAttack && isCrit && !attacker.isSeal()) {
            List<BuffDo> buffs = attacker.getBuffInfo().getBuffersByType(BuffType.BT_COUNTER_CRIT);
            if(!CollectionUtils.isEmpty(buffs)){
                attacker.removeBuff(buffs.get(0));
            } else {
                critRate = calCritRate(attacker);
                builder.hitType(HitType.CRIT);
            }
        } else {
            calCritRate(attacker);    // 这里清除掉临时暴击伤害属性
        }

		double blockReduceRate = 0;
		if (!fixedAttack && isBlook(attacker, defender)) {
			blockReduceRate = BattleConstant.BLOOK_REDUCE_RATE;
			builder.block(true);
			if(isCrit){
				blockReduceRate += BattleConstant.CRIT_BLOOK_REDUCE_RATE;
			}
		}

		double energyDamageAddRate = 1.0;
		if (!fixedAttack) {
			energyDamageAddRate = calEnergyAddRate(attacker);
		}
		double spellDefenseRate = calSpellDefenseRate(attacker, defender);

		double damage = attack * (1 - (defenseRate + spellDefenseRate) * (1 - Math.min(armorRate, 1)));
		double sacredDamage = calSacredDamage(attacker);
		double buffDamageAdd = calBuffDamageRate(attacker, defender);
		double jobDamageAdd = calJobDamageRate(attacker, defender);
		double damageEffect = calDamageEffect(attacker);
		double spellDamage = calSpellDamageRate(attacker);

		double finalDamage = (damage + sacredDamage) * (1 - damageReduceRate) * (1 - blockReduceRate) * (1 + damageAddRate + precisionDamageAddRate) * critRate
				* elementRestraintRate * (skillDamageRate + addSkillDamageRate + energyDamageAddRate)  * (1 + weakDamageAddRate) * (1 + buffDamageAdd) * (1 + jobDamageAdd)
				* (1 - adversarialAttributes) * (1 + damageTypeAdd) * (1 + damageEffect) * (1 + spellDamage);
		finalDamage += fixedDamage;
		finalDamage = -finalDamage;
		finalDamage = finalDamage > -1 ? -1 : finalDamage;
		builder.damage((long) finalDamage).initialDamage((long) finalDamage).totalDamage((long)finalDamage).fixedAttack(fixedAttack);
		return builder.build();
	}

	/**
	 * 计算伤害 
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param fixedAttack
	 * @return
	 */
	public static DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, boolean fixedAttack) {
		return calDamage(buff.getSkillDamageValue(),attacker, defender, fixedAttack);
	}
	
	
	/**
	 * 计算守方防御率  防御率=防守方护甲/（防守方护甲+配置中根据防守方星级读取的防御系数）
	 * @param defender
	 * @return
	 */
	private static double calDefenseRate(HeroDo defender){
		long defense = defender.getAttribute(AttributeType.DEFENSE);
		long defendRage = defender.getAttribute(AttributeType.DEFEND_RAGE);
		double defenseRate = 1.0D * defense/ (defense + defendRage);
		defenseRate = Math.min(defenseRate, 0.8);
		return defenseRate;
	}


	/**
	 * 计算精准伤害加成比例，最大为45%
	 * @return
	 */
	private static double calPrecisionDamageAddRate(HeroDo attacker, HeroDo defender){
		if(attacker.getElementMul() == null || defender.getElementMul() == null){
			return 0;
		}
		double precisionDamageAddRate = attacker.getRate(AttributeType.PRECISION_PERCENT);
		double restraintRate = AttributeUtil.calPercent(attacker.getElementMul().getHitPercent(defender.getElementMul().getIdx()));
		precisionDamageAddRate = Math.min(((precisionDamageAddRate + restraintRate) - 1) * 0.3, BattleConstant.PRECISION_DAMAGE_MAX_ADD_PERCENT);
		return precisionDamageAddRate;
	}
	
	/**
	 * 如果是技能则计算技能加成伤害
	 * @param attacker
	 * @return
	 */
	private static double calSkillDamageAddRate(HeroDo attacker){
		return attacker.currentSkillIs(ActiveType.SKILL) ? attacker.getRate(AttributeType.SKILL_DAMAGE) : 0;
	}
	
	/**
	 * 计算神圣伤害
	 * @param attacker
	 * @return
	 */
	private static double calSacredDamage(HeroDo attacker){
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		double sacredRage = attacker.getRate(AttributeType.SACRED_DAMAGE_PERCENT);
		return (attack * sacredRage * 0.7);
	}
	
	/**
	 * 是否暴击
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static boolean isCrit(HeroDo attacker, HeroDo defender){
		double attackCritRate = attacker.getRate(AttributeType.CRIT_PERCENT);
		double defenceCritRate = defender.getRate(AttributeType.RESIST_CRIT_PERCENT);
		double critRate = attackCritRate * (1 - defenceCritRate);
		return RandomUtils.isHit(critRate);
	}

	/**
	 * 计算是否命中
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static boolean isHitRate(HeroDo attacker, HeroDo defender){
		double attackHitRate = attacker.getRate(AttributeType.HIT);
		double defenceDodgeRate = defender.getRate(AttributeType.DODGE);
		double hitRate = (1d - (1d - attackHitRate) * defenceDodgeRate);
		return RandomUtils.isHit(hitRate);
	}


	/**
	 * 是否格挡
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static boolean isBlook(HeroDo attacker, HeroDo defender){
		if(attacker.getElementMul() == null || defender.getElementMul() == null){
			return false;
		}
		double attackPrecisionRate = attacker.getRate(AttributeType.PRECISION_PERCENT);
		double restraintRate = AttributeUtil.calPercent(attacker.getElementMul().getHitPercent(defender.getElementMul().getIdx()));
		double defenseBlockRate = defender.getRate(AttributeType.BLOCK_PERCENT);
		double blockRate = (1 - attackPrecisionRate - (restraintRate - 1)) * defenseBlockRate;
		return RandomUtils.isHit(blockRate);
	}
	
	/**
	 * 获取元素克制比例，包含攻方的元素加成比例
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static double getElementRestraintRate(HeroDo attacker, HeroDo defender){
		if(attacker.getElementMul() == null || defender.getElementMul() == null){
			return 1;
		}
		CHeroElemMul elemMul = defender.getElementMul();
		Element element = Element.valueOf(elemMul.getIdx());
		double damageAddRate = attacker.getRate(element.getDamageAddAttribute());
		double restraintRate = AttributeUtil.calPercent(attacker.getElementMul().getDamagePercent(defender.getElementMul().getIdx()));
		return damageAddRate + restraintRate;
	}
	
	/**
	 * 计算暴击比例，如果存在暴击
	 * @param attacker
	 * @return
	 */
	private static double calCritRate(HeroDo attacker){
		return 1.5 + (Math.min(attacker.getRate(AttributeType.CRIT_DAMAGE_PERCENT), 1.5));
	}
	
	/**
	 * 获取能量加成比例
	 * @param attacker
	 * @return
	 */
	private static double calEnergyAddRate(HeroDo attacker){
		if(attacker.currentSkillIs(ActiveType.SKILL)){
			long energy = attacker.getCurrentSkill().getSkillEnergy();
			return Math.max(0, (energy - BattleConstant.HERO_FULL_ENERGY) * 1.0 / BattleConstant.HERO_FULL_ENERGY);
		}
		return 0;
	}
	
	/**
	 * 获取技能伤害比例
	 * @param buff
	 * @return
	 */
	private static double getSkillDamageRate(CBuff buff){
		long damageValue = buff.getSkillDamageValue();
		return AttributeUtil.calPercent(damageValue);
	}

	/**
	 * 获取伤害类型的抗性属性
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static double getAdversarialAttributes(HeroDo attacker, HeroDo defender){
		return attacker.getDamageType() == null ? 0 : defender.getAttributeInfo().getRate(attacker.getDamageType().getAdversarialAttributes());
	}

	/**
	 * 获取伤害类型的加深属性
	 * @param attacker
	 * @return
	 */
	private static double getDamageAddPercent(HeroDo attacker){
		return attacker.getDamageType() == null ? 0 : attacker.getAttributeInfo().getRate(attacker.getDamageType().getDamageAddPercent());
	}
	
	/**
	 * 计算负面buff伤害加成
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static double calBuffDamageRate(HeroDo attacker, HeroDo defender){
		double buffDamageRate = 0;
		for(AttributeType type : AttributeType.class.getEnumConstants()){
			BuffType buffType = type.getActivationBuffType();
			if(buffType == null){continue;}
			double damageAddRate = attacker.getRate(type);
			if(damageAddRate != 0 && defender.haveBuff(buffType)){
				buffDamageRate += damageAddRate;
			}
		}
		return buffDamageRate;
	}
	
	/**
	 * 计算职业伤害加成
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private static double calJobDamageRate(HeroDo attacker, HeroDo defender){
		AttributeType type = defender.getJob().getRestraintAttribute();
		double jobDamageAddRage = attacker.getRate(type);
		return jobDamageAddRage;
	}

	/**
	 * 计算伤害效果，物连，法连之类的影响
	 * @param attacker
	 * @return
	 */
	private static double calSpellDamageRate(HeroDo attacker){
		long spell = attacker.getAttribute(attacker.getDamageType().getSpellType());
		double spellRate = 0.01 * Math.pow(spell , 0.45);
		return spellRate;
	}

	/**
	 * 计算伤害效果，物连，法连之类的影响
	 * @param attacker
	 * @return
	 */
	private static double calSpellDefenseRate(HeroDo attacker, HeroDo defender){
		long spell = defender.getAttribute(attacker.getDamageType().getSpellType());
		double spellRate = 0.01 * Math.pow(spell , 0.45);
		return spellRate;
	}

	/**
	 * 计算伤害效果，物连，法连之类的影响
	 * @param attacker
	 * @return
	 */
	private static double calDamageEffect(HeroDo attacker){
		return attacker.getRate(AttributeType.EFFECT_PERCENT);
	}

}
