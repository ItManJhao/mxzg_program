package com.ayjs.mxzg.battle.targetselector;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.SelectorType;

import cn.hutool.core.collection.CollectionUtil;

/**
 * 前方一列
 * @author meiyc
 *
 */
@Component
public class ForwardColumnSelector extends AbstractTargetSelector {

    private Comparator<HeroDo> positionComp = Comparator.comparingDouble(HeroDo::getPosition);

	@Override
	public SelectorType getType() {
        return SelectorType.FORWARD_COLUMN;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
        Map<Integer, List<HeroDo>> columnMap = new HashMap<>();
        targets.forEach(heroDo -> {
            Tuple2<Integer, Integer> rowColumn = getRowColumn(heroDo.getPosition());
            columnMap.computeIfAbsent(rowColumn._2, k -> new ArrayList<>()).add(heroDo);
        });
        Tuple2<Integer, Integer> attackerRowColumn = getRowColumn(attacker.getPosition());
        List<HeroDo> heroDos = columnMap.get(attackerRowColumn._2);
        if (CollectionUtil.isEmpty(heroDos)) {
            for (int i = 1; i < BattleConstant.ROW_NUMBER; i++) {
                int nextColumn = attackerRowColumn._2 + i;
                if (nextColumn >= 1 && nextColumn <= BattleConstant.ROW_NUMBER) {
                    heroDos = columnMap.get(nextColumn);
                    if (CollectionUtil.isNotEmpty(heroDos)) {
                        break;
                    }
                }
                int afterColumn = attackerRowColumn._2 - i;
                if (afterColumn >= 1 && afterColumn <= BattleConstant.ROW_NUMBER) {
                    heroDos = columnMap.get(afterColumn);
                    if (CollectionUtil.isNotEmpty(heroDos)) {
                        break;
                    }
                }
            }
        }
        if (CollectionUtil.isNotEmpty(heroDos)) {
            heroDos = heroDos.stream().sorted(positionComp).collect(Collectors.toList());
            targets.clear();
            targets.addAll(heroDos);
		}
	}

}
