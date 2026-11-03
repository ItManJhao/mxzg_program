package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 战意，生命值每降低百分比，伤害提升一定百分比
 *
 */
@Component
public class WarIntentBuffHandler extends AbstractArtTriggerBuffHandler{

    @Override
    public BuffType getType() {
        return BuffType.BT_WAR_INTENT;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        double hp = beTrigger.getHpRate();
        long hpRatio = buff.getBuff().getValue()[0];
        long damageRatio = buff.getBuff().getValue()[1];
        double hpLossRatio = AttributeUtil.calPercent(hpRatio);
        int count = (int)((1 - hp) / hpLossRatio);
        if(count > 0){
            DamageResult result = beTrigger.getResult();
            long damageAddRatio = damageRatio * count;
            long damage = AttributeUtil.addPercent(result.getDamage(), damageAddRatio);
            result.updateDamage(damage);
        }
    }
}
