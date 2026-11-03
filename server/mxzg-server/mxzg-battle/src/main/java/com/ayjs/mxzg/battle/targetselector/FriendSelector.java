package com.ayjs.mxzg.battle.targetselector;

import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 选择友方
 * @author meiyc
 *
 */
@Component
public class FriendSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.FRIEND;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		BattlerDo self = context.getSelf(attacker.getFaction());
		targets.addAll(self.getHeros());
	}

}
