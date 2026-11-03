package com.ayjs.mxzg.battle.buff.trigger.restraint;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import com.google.common.collect.Sets;
import org.springframework.stereotype.Component;

import java.util.Set;

/**
 * 精准
 */
@Component
public class PreciseBuffHandler extends AbstractArtTriggerBuffHandler {

    private Set<BuffType> buffTypes = Sets.newHashSet(BuffType.BT_DODGE, BuffType.BT_SWIFT);

    @Override
    public BuffType getType() {
        return BuffType.BT_PRECISE;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(target.haveBuff(buffTypes)){
            int promoteRatio = buff.getBuff().getValue()[0];
            DamageResult result = beTrigger.getResult();
            long damage = AttributeUtil.addPercent(result.getDamage(), promoteRatio);
            result.updateDamage(damage);
        }
    }
}
