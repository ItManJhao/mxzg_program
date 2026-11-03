package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 目标是否拥有指定层数的debuff
 *
 * @author meiyc
 */
@Component
public class DebuffCheckerBuffHandler extends AbstractConditionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_DEBUFF_CHECKER;
    }

    @Override
    protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        int number = buff.getValue()[0];
        return defender.getDeBuffs().size() == number;
    }
}
