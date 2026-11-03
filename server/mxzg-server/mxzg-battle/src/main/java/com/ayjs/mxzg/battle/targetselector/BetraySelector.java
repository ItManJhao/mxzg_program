/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * @author YY
 * 离间选择器
 */
@Component
public class BetraySelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.BETRAY_SELECTOR;
	}

	@Override
	protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		targets.clear();
		List<HeroDo> friends = context.getSelf(attacker.getFaction()).getHeros().stream().filter(hero -> hero !=attacker).collect(Collectors.toList());
		targets.addAll(RandomUtil.randomList(friends, 1));
	}

}
