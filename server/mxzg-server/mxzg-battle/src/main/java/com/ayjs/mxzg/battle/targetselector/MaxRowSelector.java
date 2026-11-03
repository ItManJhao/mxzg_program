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
 * 最多的行(排)
 *
 * @author meiyc
 */
@Component
public class MaxRowSelector extends AbstractTargetSelector {

    @Override
    public SelectorType getType() {
        return SelectorType.MAX_ROW;
    }

    @Override
    public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
        // row --> hero list
        if (CollectionUtils.isEmpty(targets)) {
            return;
        }
        Map<Integer, List<HeroDo>> rowMap = new HashMap<>();
        targets.forEach(heroDo -> {
            Tuple2<Integer, Integer> rowColumn = getRowColumn(heroDo.getPosition());
            rowMap.computeIfAbsent(rowColumn._1, k -> new ArrayList<>()).add(heroDo);
        });

        Optional<Map.Entry<Integer, List<HeroDo>>> entryOptional = rowMap.entrySet().stream()
                .max(Comparator.comparingInt(e -> e.getValue().size()));

        if (entryOptional.isPresent()) {
            targets.clear();
            targets.addAll(entryOptional.get().getValue());
        }
    }

}
