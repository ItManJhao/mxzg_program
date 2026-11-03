package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 附加百分比伤害
 *
 * @author meiyc
 */
@Component
public class AddRateDamageBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_ADD_HP_MAX_DAMAGE;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        long maxHp = target.getAttributeInfo().getMaxHp();
        long hpRate = buff.getBuff().getValue()[0];
        long attackRate = buff.getBuff().getValue()[1];
        long damage = AttributeUtil.addPercent(maxHp, hpRate);
        long maxDamage = AttributeUtil.addPercent(beTrigger.getAttributeInfo().getAttack(), attackRate);
        damage = Math.min(damage, maxDamage);

        DamageResult result = DamageResult.createRealDamage(-damage);
        addDamageBuff(buff.getBuff(), result, beTrigger, target, context);
        buffHelper.removeBuff(buff, beTrigger, context);
    }
}
