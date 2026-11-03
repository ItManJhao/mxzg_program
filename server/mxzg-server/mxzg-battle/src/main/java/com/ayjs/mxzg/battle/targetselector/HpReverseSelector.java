package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 血量倒序
 * @author meiyc
 *
 */
@Component
public class HpReverseSelector  extends AbstractTargetSelector  {

    private Comparator<HeroDo> hpReverseComp = (o1, o2) -> Double.compare(o1.getHpRate(), o2.getHpRate());

	@Override
	public SelectorType getType() {
		return SelectorType.HP_REVERSE;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		List<HeroDo> selectTargets = targets.stream().sorted(hpReverseComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}

}
