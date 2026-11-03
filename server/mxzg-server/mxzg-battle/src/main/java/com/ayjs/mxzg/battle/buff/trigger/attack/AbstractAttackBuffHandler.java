package com.ayjs.mxzg.battle.buff.trigger.attack;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.DamageType;

/**
 * 抽象的触发攻击类父类
 */
public abstract class AbstractAttackBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        chase(buff, beTrigger, target, context);
    }

    /**
     * 追击
     * @param buff
     * @param beTrigger
     * @param target
     * @param context
     */
    protected boolean chase(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context){
        if(beTrigger.getDamageType() != triggerDamageType() || beTrigger.getResult() == null){
            return false;
        }

        int probability = buff.getBuff().getValue()[0];
        double chaseRatio = AttributeUtil.calPercent(probability);
        SkillDo skillDo = getChaseSkill(beTrigger);
        if(!beTrigger.isExistActionSkill(skillDo) && RandomUtils.isHit(chaseRatio)){
            beTrigger.addContinuousTarget(skillDo, getSkillEffectPercent(buff.getBuff()));
            context.addContinuousAttack(beTrigger);
            return true;
        }

        return false;
    }

    /**
     * 触发的伤害类型
     * @return
     */
    protected abstract DamageType triggerDamageType();

    /**
     * 追击的技能
     * @param beTrigger
     * @return
     */
    protected abstract SkillDo getChaseSkill(HeroDo beTrigger);

    /**
     * 获取技能效果
     * @param buff
     * @return
     */
    protected long getSkillEffectPercent(CBuff buff){
        return 0;
    };

}
