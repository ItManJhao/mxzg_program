package com.ayjs.mxzg.battle.targetselector;

import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 移除自己
 * @author meiyc
 *
 */
@Component
public class RemoveSelfSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.REMOVE_SELF;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> lastTargets, int targetNum) {
		lastTargets.remove(attacker);
	}

}
