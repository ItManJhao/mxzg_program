package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 攻击正序
 * @author meiyc
 *
 */
@Component
public class AttackPositiveSelector extends AbstractTargetSelector {

    private Comparator<HeroDo> attackReverseComp = (o1, o2) -> Double.compare(o2.getAttribute(AttributeType.ATTACK), o1.getAttribute(AttributeType.ATTACK));

	@Override
	public SelectorType getType() {
		return SelectorType.HIGHEST_ATTACK;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> selectTargets = targets.stream().sorted(attackReverseComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
