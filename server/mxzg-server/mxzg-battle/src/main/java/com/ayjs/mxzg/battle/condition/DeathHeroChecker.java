package com.ayjs.mxzg.battle.condition;

import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.ConditionType;
import org.springframework.stereotype.Component;

/**
 * 检测存活的数量如果小于指定
 */
@Component
public class DeathHeroChecker implements ConditionChecker {

    @Override
    public ConditionType type() {
        return ConditionType.DEATH_HERO;
    }

    @Override
    public boolean checker(BattleContext context, BattleCondition condition) {
        BattlerDo attacker = context.getAttacker();
        long deadNum = attacker.getAllHeros().stream().filter(heroDo -> heroDo.isDead()).count();
        return deadNum < condition.getUnique();
    }
}
