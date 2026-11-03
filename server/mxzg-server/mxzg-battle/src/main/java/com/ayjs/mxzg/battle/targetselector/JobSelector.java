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
 * 根据职业选择
 */
@Component
public class JobSelector extends AbstractTargetSelector  {
	
    @Override
    public SelectorType getType() {
        return SelectorType.JOB_SELECTOR;
    }

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum,
			List<Integer> targetValue) {
		Comparator<HeroDo> positiveComp = (o1, o2) -> {
			int job1 = targetValue.indexOf(o1.getJob().getValue());
			int job2 = targetValue.indexOf(o2.getJob().getValue());
			job1 = job1 < 0 ? 100 : job1;
			job2 = job2 < 0 ? 100 : job2;
			return Integer.compare(job1, job2);
		};
		List<HeroDo> selectTargets = targets.stream().sorted(positiveComp).limit(targetNum).collect(Collectors.toList());
		targets.clear();
		targets.addAll(selectTargets);
	}
}
