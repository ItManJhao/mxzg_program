package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 献祭
 */
@Component
public class SacrificeBuffHandler extends AbstractArtTriggerBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_SACRIFICE;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int hpRate = buff.getBuff().getValue()[0];
        DamageResult result = target.getResult();
        buff.addValue(Math.abs(result.getDamage()));
        long triggerDamage = AttributeUtil.addPercent(beTrigger.getAttributeInfo().getMaxHp(), hpRate);
        if(beTrigger.isDead() || buff.getValue() > triggerDamage){
            HeroDo source = context.getHero(buff.getSourceId());
            BattlerDo enemy = context.getEnemy(beTrigger.getFaction());
            if(!enemy.getDeads().isEmpty()){
                int deadArtId = buff.getBuff().getValue()[1];
                battleService.executeBuffArt(deadArtId, source, source, context);
            } else {
                int restoreArtId = buff.getBuff().getValue()[2];
                battleService.executeBuffArt(restoreArtId, source, source, context);
            }
        }
    }
}
