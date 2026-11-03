package com.ayjs.mxzg.battle.buff.trigger.restraint;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import com.google.common.collect.Sets;
import org.springframework.stereotype.Component;

import java.util.Set;

/**
 * 灭魂，攻击时一定概率给敌方添加封魂状态，并增加有神佑/保命技能的伤害
 */
@Component
public class ExterminationBuffHandler extends AbstractArtTriggerBuffHandler {

    private Set<BuffType> associatedBuff = Sets.newHashSet(BuffType.BT_LIFE_SAVING, BuffType.BT_GOD_BLESS);

    @Override
    public BuffType getType() {
        return BuffType.BT_EXTERMINATION;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(target.haveBuff(associatedBuff)){
            int damageAdd = buff.getBuff().getValue()[0];
            DamageResult result = beTrigger.getResult();
            long damage = AttributeUtil.addPercent(result.getDamage(), damageAdd);
            result.updateDamage(damage);
        }

        int probability = buff.getBuff().getValue()[1];
        double ratio = AttributeUtil.calPercent(probability);
        if(RandomUtils.isHit(ratio)){
            int artId = buff.getBuff().getValue()[2];
            battleService.executeBuffArt(artId, target, beTrigger, context);
        }
    }
}
