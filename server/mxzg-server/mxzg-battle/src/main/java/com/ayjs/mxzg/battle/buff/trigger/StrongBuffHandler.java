package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

@Component
public class StrongBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_STRONG;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        DamageResult result = target.getResult();
        long maxHp = beTrigger.getAttributeInfo().getMaxHp();
        long rate = buff.getBuff().getValue()[0];
        long rateDamage = (long)(maxHp * rate / BattleConstant.PERCENTAGE_RATIO);
        if(result.getDamage() > rateDamage){
             long reductionDamage = result.getDamage() - rateDamage;
             int reductionRate = buff.getBuff().getValue()[1];
             reductionDamage = (long)(reductionDamage * (1 - (reductionRate / BattleConstant.PERCENTAGE_RATIO)));
             result.updateDamage(Math.abs(reductionDamage));
        }
    }
}
