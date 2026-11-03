package com.ayjs.mxzg.battle.buff.trigger.attack;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.DamageType;
import org.springframework.stereotype.Component;

/**
 * 爆追，使用物理攻击造成暴击时有一定概率在攻击一次
 */
@Component
public class ExplosiveChaseBuffHandler extends AbstractAttackBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_EXPLOSIVE_CHASE;
    }

    @Override
    protected DamageType triggerDamageType() {
        return DamageType.PHYSICAL;
    }

    @Override
    protected SkillDo getChaseSkill(HeroDo beTrigger) {
        return beTrigger.getSkillInfo().getGeneralAttack();
    }
}
