package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.config.struct.ActiveType;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 技能信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class SkillInfo {
	
	/** 普攻 */
	private SkillDo generalAttack;

	/** 主动技能 */
	private List<SkillDo> activeSkills = new ArrayList<>();
	
	/** 被动技能列表 */
	private List<SkillDo> skills = new ArrayList<>();

	/** 本次技能目标单位id */
	private List<Integer> skillGoal = new ArrayList<>();

	/** 临时增加的目标个数 */
	private int temporarilyTargetNum;

	/** 目标是否有变更 */
	private boolean targetUpdate;
	
	
	public static SkillInfo createOf(List<SkillDo> skills){
		SkillInfo skillInfo = new SkillInfo();
		for(SkillDo skill : skills){
			if(skill.getSkill() == null){
				skillInfo.getActiveSkills().add(skill);
			} else if(skill.getSkill().getActive_type() == ActiveType.ORDINARY){
				skillInfo.setGeneralAttack(skill);
			} else if(skill.getSkill().getActive_type() == ActiveType.SKILL){
				skillInfo.getActiveSkills().add(skill);
			} else {
				skillInfo.getSkills().add(skill);
			}
		}
		return skillInfo;
	}

	/**
	 * 添加技能列表
	 * @param skillDos
	 */
	public void addAllSkill(List<SkillDo> skillDos){
		for (SkillDo skillDo : skillDos) {
			addSkill(skillDo);
		}
	}
	
	/**
	 * 添加被动技能
	 * @param skillDo
	 */
	public void addSkill(SkillDo skillDo){
		if(skillDo.getSkillType() == ActiveType.SKILL.ordinal()) {
			Optional<SkillDo> existSkill = this.getActiveSkills().stream().filter(skill-> skill.getSkillId() == skillDo.getSkillId()).findFirst();
			if(existSkill.isPresent()){
				if(skillDo.getSkill().getLevel() > existSkill.get().getSkill().getLevel()){
					this.activeSkills.remove(existSkill.get());
					this.activeSkills.add(skillDo);
				}
			} else {
				this.activeSkills.add(skillDo);
			}
		} else {
			Optional<SkillDo> oldSkill = this.getSkills().stream().filter(skill-> skill.getSkillId() == skillDo.getSkillId()).findFirst();
			if (oldSkill.isPresent()) {
				if (skillDo.getSkill().getLevel() > oldSkill.get().getSkill().getLevel()) {
					this.skills.remove(oldSkill.get());
					this.skills.add(skillDo);
				}
			} else {
				this.skills.add(skillDo);
			}
		}
	}

	
	/**
	 * 根据是否计算面板属性获取技能列表
	 * @param countAttribute 是否是结算面板属性
	 * @return
	 */
	public List<SkillDo> getSkillsBy(boolean countAttribute){
		return this.skills.stream().filter(skill-> skill.getSkill().count_stats == countAttribute).collect(Collectors.toList());
	}

	/**
	 * 获取被动技能
	 *
	 * @return
	 */
	public List<SkillDo> getPassiveSkills(){
		return this.skills.stream().filter(skill-> skill.getSkill().getActive_type() == ActiveType.PASSIVE
				|| skill.getSkill().getActive_type() == ActiveType.HALO).collect(Collectors.toList());
	}
	
	/**
	 * 获取所有技能
	 * @return
	 */
	public List<SkillDo> getAllSkills(){
		List<SkillDo> skillDos = Lists.newArrayList(this.skills);
		skillDos.addAll(this.activeSkills);
		skillDos.add(this.generalAttack);
		return skillDos;
	}

	/**
	 * 根据当前回合获取可以释放的技能
	 * @param currentRound
	 * @return
	 */
	public SkillDo getSkillBy(int currentRound){
		for (SkillDo activeSkill : this.activeSkills) {
			if(activeSkill.isCanRelease(currentRound)){
				return activeSkill;
			}
		}

		return this.generalAttack;
	}

	/**
	 * 增加临时目标个数
	 * @param targetNum
	 */
	public void addTemporarilyTargetNum(int targetNum){
		this.temporarilyTargetNum += targetNum;
	}

	/**
	 * 获取并且清除临时目标数量
	 * @return
	 */
	public int getAndCleanTemporarilyTargetNum(){
		int targetNum = this.temporarilyTargetNum;
		this.temporarilyTargetNum = 0;
		return targetNum;
	}

	/**
	 * 添加技能目标
	 * @param targetIds
	 */
	public void addSkillGold(List<Integer> targetIds){
		this.targetUpdate = false;
		if(this.skillGoal.isEmpty()){
			this.skillGoal.addAll(targetIds);
		}
	}

	/**
	 * 清除技能目标
	 */
	public void cleanSkillGold(){
		this.skillGoal.clear();
	}

	/**
	 * 获取指定技能
	 *
	 * @param skillId
	 * @return
	 */
	public SkillDo getSkill(int skillId) {
		Optional<SkillDo> skillDoOptional = this.getAllSkills().stream().filter(skillDo -> skillDo.getSkillId() == skillId).findFirst();
		if(skillDoOptional.isPresent()){
			return skillDoOptional.get();
		}
		return null;
	}

	/**
	 * 移除目标
	 *
	 * @param skillDo
	 */
	public void removeSkill(SkillDo skillDo) {
		this.activeSkills.remove(skillDo);
		this.skills.remove(skillDo);
	}

	/**
	 * 切换技能
	 *
	 * @param oldSkill
	 * @param newSkill
	 */
	public void switchSkill(SkillDo oldSkill, SkillDo newSkill) {
		if(this.generalAttack.getSkillId() == oldSkill.getSkillId()){
			this.generalAttack = newSkill;
			return;
		}

		removeSkill(oldSkill);
		addSkill(newSkill);
	}
}
