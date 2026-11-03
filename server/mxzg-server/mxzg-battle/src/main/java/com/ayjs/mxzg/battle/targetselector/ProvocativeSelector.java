/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;

/**
 * 挑衅选择器
 */
@Component
public class ProvocativeSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.PROVOCATIVE;
	}

	@Override
	protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,	List<Integer> targetValue) {
		targets.clear();
		BuffDo buffDo = attacker.getBuffsBy(BuffType.BT_PROVOCATIVE).get(0);
		HeroDo source = context.getHero(buffDo.getSourceId());
		targets.add(source);
	}
}
