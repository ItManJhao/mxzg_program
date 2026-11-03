package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 存活的
 * @author meiyc
 *
 */
@Component
public class SurviveSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.SURVIVE;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> lastTargets, int targetNum) {
		//TODO 默认就是选择存活的，这里默认不处理
		if(targetNum < lastTargets.size()){
			List<HeroDo> targets = lastTargets.stream().limit(targetNum).collect(Collectors.toList());
			lastTargets.clear();
			lastTargets.addAll(targets);
		}
	}
}
