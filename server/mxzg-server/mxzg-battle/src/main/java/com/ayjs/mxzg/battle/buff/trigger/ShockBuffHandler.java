package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 冲击，超过一定的伤害量过后
 */
@Component
public class ShockBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_SHOCK;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(target.isDead() || beTrigger.getResult() == null){
            return;
        }
        long hpRate = buff.getBuff().getValue()[0];
        long maxHp = target.getAttributeInfo().getMaxHp();
        long damageThreshold = AttributeUtil.addPercent(maxHp, hpRate);
        double probability = AttributeUtil.calPercent(buff.getBuff().getValue()[1]);
        if(damageThreshold < Math.abs(beTrigger.getResult().getDamage()) && RandomUtils.isHit(probability)){
            int artId = buff.getBuff().getValue()[2];
            battleService.executeBuffArt(artId, target, beTrigger, context);
        }
    }
}
