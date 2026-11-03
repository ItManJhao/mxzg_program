package com.ayjs.mxzg.battle.condition;

import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.ConditionType;
import org.springframework.stereotype.Component;

/**
 * 回合数检测
 */
@Component
public class RoundChecker implements ConditionChecker {

    @Override
    public ConditionType type() {
        return ConditionType.ROUND;
    }

    @Override
    public boolean checker(BattleContext context, BattleCondition condition) {
        return context.currentRound() < condition.getUnique();
    }
}
