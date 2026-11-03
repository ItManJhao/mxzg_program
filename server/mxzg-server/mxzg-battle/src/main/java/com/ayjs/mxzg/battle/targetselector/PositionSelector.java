package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 位置选择器
 * @author meiyc
 *
 */
@Component
public class PositionSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.POS;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		Tuple2<Integer, Integer> attackerRowColumn = getRowColumn(attacker.getPosition());
		Map<Integer, HeroDo> result = new TreeMap<>();
		targets.forEach(heroDo -> {
			Tuple2<Integer, Integer> targetsRowColumn = getRowColumn(heroDo.getPosition());
			int priority = 10 * (targetsRowColumn._1 * 10 + Math.abs(attackerRowColumn._2 - targetsRowColumn._2)) - targetsRowColumn._2;
			result.put(priority, heroDo);
		});
		List<HeroDo> heroDos = result.entrySet().stream().limit(targetNum).map(Map.Entry::getValue).collect(Collectors.toList());
		targets.clear();
		targets.addAll(heroDos);
	}

}
