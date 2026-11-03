package com.ayjs.mxzg.battle.buff.trigger.mark;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

@Component
public class MarkHpDamageBuffHandler extends AbstractArtTriggerBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_MARK_HP_DAMAGE;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int hpRate = buff.getBuff().getValue()[0];
        long maxHp = target.getAttributeInfo().getMaxHp();
        long damage = AttributeUtil.addPercent(maxHp, hpRate);
        DamageResult result = DamageResult.createRealDamage(damage);
        addDamageBuff(buff.getBuff(), result, beTrigger, target, context);

        buffHelper.removeBuff(buff, beTrigger, context);
    }
}
