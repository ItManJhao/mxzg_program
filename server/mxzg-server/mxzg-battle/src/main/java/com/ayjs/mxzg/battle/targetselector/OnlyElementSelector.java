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
 * @author YY
 *
 */
@Component
public class OnlyElementSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.ONLY_ELEMENT_SELECTOR;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum, List<Integer> targetValue) {
		List<HeroDo> selectTargets = targets.stream().filter(heroDo-> targetValue.contains(heroDo.getElementMul().getIdx())).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
