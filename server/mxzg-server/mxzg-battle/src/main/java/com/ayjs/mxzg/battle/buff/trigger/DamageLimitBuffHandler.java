package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 受到伤害上限限制
 */
@Component
public class DamageLimitBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_DAMAGE_LIMIT;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        long hpLimitRate = buff.getBuff().getValue()[1];
        long maxHp = beTrigger.getAttributeInfo().getMaxHp();
        long maxDamage = AttributeUtil.addPercent(maxHp, hpLimitRate);
        DamageResult result = target.getResult();
        maxDamage = Math.max(-maxDamage, result.getInitialDamage());
        result.setDamage(maxDamage);
    }
}
