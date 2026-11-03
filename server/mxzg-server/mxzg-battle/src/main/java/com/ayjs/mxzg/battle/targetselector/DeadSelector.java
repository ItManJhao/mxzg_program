package com.ayjs.mxzg.battle.targetselector;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.SelectorType;
import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.stream.Collectors;

/**
 * 获取死亡目标，如果没有死亡目标则选择存活目标
 * @author meiyc
 *
 */
@Component
public class DeadSelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.DEAD;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		BattlerDo self = context.getSelf(attacker.getFaction());
		targets.clear();
		if(self.getDeads().isEmpty()){
			targets.addAll(self.getHeros().stream().limit(targetNum).collect(Collectors.toList()));
		} else {
			targets.addAll(self.getDeads().stream().filter(heroDo -> !heroDo.haveBuff(BuffType.BT_SEAL_SOUL)).limit(targetNum).collect(Collectors.toList()));
		}
	}

}
