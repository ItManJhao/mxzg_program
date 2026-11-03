package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * buff伤害加深
 */
@Component
public class BuffDamageAddBuffHandler extends AbstractArtTriggerBuffHandler{
    @Override
    public BuffType getType() {
        return BuffType.BT_BUFF_DAMAGE_ADD;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int attackRate = buff.getBuff().getValue()[1];
        HeroDo source = context.getHero(buff.getSourceId());
        if(source.isDead()){
            return;
        }

        long attack = source.getAttribute(AttributeType.ATTACK);
        long damage = AttributeUtil.addPercent(attack, attackRate);
        DamageResult result = target.getResult();
        result.updateDamage(-damage);
    }
}
