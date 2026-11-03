package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 烈焰护盾,反弹攻击者受到伤害的百分比
 */
@Component
public class FlameShieldBuffHandler extends AbstractArtTriggerBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_FLAME_SHIELD;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int bounceRatio = buff.getBuff().getValue()[0];
        DamageResult result = target.getResult();
        long damage = result.getInitialDamage();
        long bounceDamage = AttributeUtil.addPercent(damage, bounceRatio);
        DamageResult bounceDamageResult = DamageResult.builder().damage(bounceDamage).buffId(result.getBuffId()).fixedAttack(true).build();
        addDamageBuff(buff.getBuff(), bounceDamageResult, beTrigger, target, context);

    }
}
