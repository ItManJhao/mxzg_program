package com.ayjs.mxzg.battle.targetselector;

import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 全部敌人
 * @author meiyc
 *
 */
@Component
public class EnemySelector extends AbstractTargetSelector {

	@Override
	public SelectorType getType() {
		return SelectorType.ENEMY;
	}

	@Override
	public void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {
		BattlerDo enemy = context.getEnemy(attacker.getFaction());
		targets.addAll(enemy.getHeros());
	}

}
