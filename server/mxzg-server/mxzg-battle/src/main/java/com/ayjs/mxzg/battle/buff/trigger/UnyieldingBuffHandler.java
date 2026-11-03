package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 不屈
 */
@Component
public class UnyieldingBuffHandler extends AbstractArtTriggerBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_UNYIELDING;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int hpRate = buff.getBuff().getValue()[0];
        double lossHpRate = 1 - beTrigger.getHpRate();
        int count = lossHpRate == 0 ? 0 : (int) (lossHpRate / (hpRate / BattleConstant.PERCENTAGE_RATIO));

        int baseDamageRate = buff.getBuff().getValue()[1];

        double reduceDamageRate = AttributeUtil.calPercent(baseDamageRate);
        double totalReduceDamageRate = count * reduceDamageRate;

        DamageResult result = target.getResult();
        long reduceDamage = (long) (target.getResult().getDamage() * totalReduceDamageRate);

        result.updateDamage(-reduceDamage);
    }
}
