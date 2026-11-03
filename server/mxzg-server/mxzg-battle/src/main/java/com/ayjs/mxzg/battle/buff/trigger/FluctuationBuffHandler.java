package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.DamageType;
import org.springframework.stereotype.Component;

/**
 * 伤害波动,造成魔法伤害时，最终伤害效果会在90%-110%之间随机波动
 */
@Component
public class FluctuationBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_FLUCTUATION;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(beTrigger.getDamageType() != DamageType.MAGIC){
            return;
        }

        int lowerLimit = buff.getBuff().getValue()[0];
        int upLimit = buff.getBuff().getValue()[1];
        int rate = RandomUtil.rand(lowerLimit, upLimit);
        DamageResult result = beTrigger.getResult();
        long damage = AttributeUtil.addPercent(result.getDamage(), rate);
        result.setDamage(damage);
    }
}
