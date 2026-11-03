package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.ActiveType;
import lombok.Getter;
import lombok.Setter;

/**
 * 技能信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class SkillDo {

	/**	技能id */
	private int skillId;

	/** 英雄技能 */
	private CHeroSkill skill;

	/** 当次技能的能量 */
	private long skillEnergy;

	/** 神龙初始回合 */
	private int initialRound;

	/**
	 * 通过CHeroSkill 来创建SkillDo对象
	 * @param skill
	 * @return
	 */
	public static SkillDo createOf(CHeroSkill skill){
		SkillDo skillDo = new SkillDo();
		if(skill != null){
			skillDo.setSkillId(skill.getType());
		}
		skillDo.setSkill(skill);
		return skillDo;
	}

	/**
	 * 通过CHeroSkill 来创建SkillDo对象
	 * @param skill
	 * @param initialRound
	 * @return
	 */
	public static SkillDo createOf(CHeroSkill skill, int initialRound){
		SkillDo skillDo = createOf(skill);
		skillDo.setInitialRound(initialRound);
		return skillDo;
	}

	/**
	 * 是否是攻击技能
	 * @return
	 */
	public boolean isAttackSkill(){
		return this.skill.active_type == ActiveType.SKILL || this.skill.active_type == ActiveType.ORDINARY;
	}

	/**
	 * 是否是光环
	 * @return
	 */
	public boolean isHalo(){
		return this.skill.active_type == ActiveType.HALO;
	}

	/**
	 * 获取技能类型
	 * @return
	 */
	public int getSkillType(){
		return this.skill.getActive_type().ordinal();
	}

	/**
	 * 获取下次执行的回合
	 * @currentRound
	 * @return
	 */
	public int nextRound(int currentRound){
		if(this.getSkill().getInitial_round() > currentRound){
			return this.getSkill().getInitial_round();
		} else {
			return currentRound +  this.getSkill().getCool_round();
		}
	}

	/**
	 * 根据当前回合数是否能释放技能
	 * @param currentRound
	 * @return
	 */
	public boolean isCanRelease(int currentRound){
		if(this.skill == null){
			return false;
		}
		int initialRound = this.getSkill().getInitial_round() == 0 ? this.initialRound : this.getSkill().getInitial_round();
		return (currentRound - initialRound) % (this.getSkill().getCool_round() + 1) == 0;
	}

	@Override
	public String toString() {
		return "SkillDo [" + skill + "]";
	}

}
