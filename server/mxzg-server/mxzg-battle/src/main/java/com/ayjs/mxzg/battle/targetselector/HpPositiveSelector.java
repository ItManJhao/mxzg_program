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
 * 血量正序
 * @author meiyc
 *
 */
@Component
public class HpPositiveSelector extends AbstractTargetSelector {

    private Comparator<HeroDo> hpPositiveComp = (o1, o2) -> Double.compare(o2.getHpRate(), o1.getHpRate());

	@Override
	public SelectorType getType() {
		return SelectorType.HP_POSITIVE;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> selectTargets = targets.stream().sorted(hpPositiveComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
