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
 * 速度倒序
 * @author meiyc
 *
 */
@Component
public class SpeedReverseSelector extends AbstractTargetSelector {

    private Comparator<HeroDo> speedReverseComp = (o1, o2) -> Double.compare(o1.getSpeed(), o2.getSpeed());

	@Override
	public SelectorType getType() {
		return SelectorType.LOWEST_SPEED;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> selectTargets = targets.stream().sorted(speedReverseComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
