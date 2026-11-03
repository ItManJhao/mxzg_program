package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 前排，前排如果没英雄则选择后排
 * @author meiyc
 *
 */
@Component
public class FrontSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.FRONT;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> removed = targets.stream().filter(heroDo-> !heroDo.isFront()).collect(Collectors.toList());
		if(!targets.isEmpty() && removed.size() == targets.size()){
			return;
		}
		targets.removeAll(removed);
	}

}
