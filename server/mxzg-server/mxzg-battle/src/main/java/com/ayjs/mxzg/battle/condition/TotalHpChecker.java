package com.ayjs.mxzg.battle.condition;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.ConditionType;
import com.ayjs.mxzg.config.struct.AttributeType;
import org.springframework.stereotype.Component;

/**
 * 检测总血量
 */
@Component
public class TotalHpChecker implements ConditionChecker {

    @Override
    public ConditionType type() {
        return ConditionType.BLOOD_VOLUME_RATIO;
    }

    @Override
    public boolean checker(BattleContext context, BattleCondition condition) {
        BattlerDo attacker = context.getAttacker();
        long totalMaxHp = attacker.getAllHeros().stream().mapToLong(heroDo-> heroDo.getAttributeInfo().getMaxHp()).sum();
        long totalHp = attacker.getHeros().stream().mapToLong(heroDo-> heroDo.getAttributeInfo().getAttribute(AttributeType.HP)).sum();
        long hpRatio = totalHp * BattleConstant.LONG_PERCENTAGE_RATIO / totalMaxHp;
        return hpRatio >= condition.getUnique();
    }
}
