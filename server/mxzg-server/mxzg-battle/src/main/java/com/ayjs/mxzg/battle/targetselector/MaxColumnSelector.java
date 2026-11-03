package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

/**
 * 最多的一列
 *
 * @author meiyc
 */
@Component
public class MaxColumnSelector extends AbstractTargetSelector {

    @Override
    public SelectorType getType() {
        return SelectorType.MAX_COLUMN;
    }

    @Override
    public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
        // column --> hero list
        if (CollectionUtils.isEmpty(targets)) {
            return;
        }
        Map<Integer, List<HeroDo>> columnMap = new HashMap<>();
        targets.forEach(heroDo -> {
            Tuple2<Integer, Integer> rowColumn = getRowColumn(heroDo.getPosition());
            columnMap.computeIfAbsent(rowColumn._2, k -> new ArrayList<>()).add(heroDo);
        });

        Optional<Map.Entry<Integer, List<HeroDo>>> maxOptional = columnMap.entrySet().stream()
                .max(Comparator.comparingInt(e -> e.getValue().size()));

        if (maxOptional.isPresent()) {
            targets.clear();
            targets.addAll(maxOptional.get().getValue());
        }
    }

}
