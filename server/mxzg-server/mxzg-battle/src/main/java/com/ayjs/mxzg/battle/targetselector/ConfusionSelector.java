/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * @author YY
 * 混乱选择器
 */
@Component
public class ConfusionSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.CONFUSION_SELECTOR;
	}

	@Override
	protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		targets.clear();
		targets.addAll(RandomUtil.randomList(context.getAllSurviveHeros(), 1));
	}
}
