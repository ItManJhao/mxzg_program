/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 剔除上一次的技能目标
 */
@Component
public class SkillGoalSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.SKILL_GOAL;
	}

	@Override
	protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,	List<Integer> targetValue) {
		List<Integer> targetIds = attacker.getSkillInfo().getSkillGoal();

		List<HeroDo> skillGold = targets.stream().filter(hero-> !targetIds.contains(hero.getUnitId())).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(skillGold);
	}

}
