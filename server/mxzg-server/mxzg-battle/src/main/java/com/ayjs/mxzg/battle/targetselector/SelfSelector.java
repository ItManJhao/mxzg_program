package com.ayjs.mxzg.battle.targetselector;

import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 选择自己
 * @author meiyc
 *
 */
@Component
public class SelfSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.SELF;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		targets.add(attacker);
	}

}
