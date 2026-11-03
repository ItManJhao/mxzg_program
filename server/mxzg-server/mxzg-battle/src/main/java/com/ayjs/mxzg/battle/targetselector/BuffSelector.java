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
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * @author YY
 * buff正序
 */
@Component
public class BuffSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.BUFF_SELECTOR;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		Comparator<HeroDo> positiveComp = (o1, o2) -> {
			int buff1 = 100;
			int buff2 = 100;
			for(int i = 0; i < targetValue.size(); i++) {
				BuffType buffType = BuffType.valueOf(targetValue.get(i));
				if(o1.haveBuff(buffType) && i < buff1) {
					buff1 = i;
				}
				if(o2.haveBuff(buffType) && i < buff2) {
					buff2 = i;
				}
			}
			return Integer.compare(buff1, buff2);
		};
		List<HeroDo> selectTargets = targets.stream().sorted(positiveComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
