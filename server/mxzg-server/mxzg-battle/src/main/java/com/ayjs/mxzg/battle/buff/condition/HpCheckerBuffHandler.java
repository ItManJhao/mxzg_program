package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 目标血量是否大于或小于指定的百分比
 *
 * @author meiyc
 */
@Component
public class HpCheckerBuffHandler extends AbstractConditionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_HP_CHECKER;
    }

    @Override
    protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext battleContext) {
        int value = buff.getValue()[0];
        int condition = buff.getValue()[1];
        int targetType = buff.getValue()[2];
        double hpRate = AttributeUtil.calPercent(value);
        double targetRate = 0;
        if(targetType == 0){
            targetRate = defender.getHpRate();
        } else if(targetType == 1){
            targetRate = attacker.getHpRate();
        } else {
            BattlerDo battlerDo = battleContext.getSelf(attacker.getFaction());
            long maxHp = battlerDo.getHeros().stream().mapToLong(hero-> hero.getAttributeInfo().getMaxHp()).sum();
            long currentHp = battlerDo.getHeros().stream().mapToLong(hero-> hero.getHp()).sum();
            targetRate = currentHp * 1D / maxHp;
        }

        return condition == 0 ? targetRate < hpRate : targetRate >= hpRate;
    }
}
