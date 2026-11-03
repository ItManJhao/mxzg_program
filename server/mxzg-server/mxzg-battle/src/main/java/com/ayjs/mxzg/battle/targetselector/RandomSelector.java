package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.struct.SelectorType;
import com.google.common.collect.Lists;

/**
 * 随机
 * @author meiyc
 *
 */
@Component
public class RandomSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.RAND;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		if(targets.size() <= targetNum){return;}
		
		List<HeroDo> randomTargets = RandomUtil.randomList(Lists.newArrayList(targets.iterator()), targetNum);       
		targets.clear();
		targets.addAll(randomTargets);
	}

}
