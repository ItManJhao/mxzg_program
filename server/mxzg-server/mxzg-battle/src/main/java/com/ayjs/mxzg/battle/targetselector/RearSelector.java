package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 后排，如果后排没目标则选择前排
 * @author meiyc
 *
 */
@Component
public class RearSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.REAR;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> removed = targets.stream().filter(heroDo-> heroDo.isFront()).collect(Collectors.toList());
		if(!targets.isEmpty() && removed.size() == targets.size()){
			return;
		}
		targets.removeAll(removed);
	}

}
