/**
 * 
 */
package com.ayjs.mxzg.battle.targetselector;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.SelectorType;

import cn.hutool.core.util.RandomUtil;

/**
 * @author YY
 * 位置正序
 */
@Component
public class FrontBackSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.FRONT_BACK_SELECTOR;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		List<Tuple2<HeroDo, Integer>> randomList = new ArrayList<>();
		for(HeroDo target : targets) {
			int rowIndex = targetValue.indexOf(getRowColumn(target.getPosition())._1);
			if(rowIndex < 0) {
				rowIndex = 100;
			}
			int positionValue = rowIndex * 1000 + RandomUtil.randomInt(1, 900);
			Tuple2<HeroDo, Integer> sorter = new Tuple2<HeroDo, Integer>(target, positionValue);
			randomList.add(sorter);
		}
		Comparator<Tuple2<HeroDo, Integer>> positiveComp = (o1, o2) -> {
			return Integer.compare(o1._2, o2._2);
		};
		List<HeroDo> selectTargets = randomList.stream().sorted(positiveComp).limit(targetNum).map(Tuple2::get_1).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}
}
