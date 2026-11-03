/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * @author YY
 *
 */
@Component
public class ElementSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.ELEMENT_SELECTOR;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		Comparator<HeroDo> positiveComp = (o1, o2) -> {
			int elem1 = targetValue.indexOf(o1.getElementMul().getIdx());
			int elem2 = targetValue.indexOf(o2.getElementMul().getIdx());
			elem1 = elem1 < 0 ? 100 : elem1;
			elem2 = elem2 < 0 ? 100 : elem2;
			return Integer.compare(elem1, elem2);
		};
		List<HeroDo> selectTargets = targets.stream().sorted(positiveComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
