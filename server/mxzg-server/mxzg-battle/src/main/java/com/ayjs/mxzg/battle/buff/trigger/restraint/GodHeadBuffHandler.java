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
 * 神体
 */
@Component
public class GodHeadBuffHandler extends AbstractArtTriggerBuffHandler {

    private Set<BuffType> associatedBuff = Sets.newHashSet(BuffType.BT_PHYSICAL_BATTER, BuffType.BT_MAGIC_BATTER, BuffType.BT_VIOLENT);

    @Override
    public BuffType getType() {
        return BuffType.BT_GODHEAD;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(target.haveBuff(associatedBuff)){
            int damageReduce = buff.getBuff().getValues().get(0);
            DamageResult result = target.getResult();
            long damage = AttributeUtil.addPercent(result.getDamage(), damageReduce);
            result.updateDamage(Math.abs(damage));
        }
    }
}
