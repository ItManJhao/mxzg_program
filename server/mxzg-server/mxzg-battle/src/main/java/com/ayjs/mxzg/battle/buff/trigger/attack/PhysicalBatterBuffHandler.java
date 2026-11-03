package com.ayjs.mxzg.battle.buff.trigger.attack;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.DamageType;
import org.springframework.stereotype.Component;

/**
 * 物连，使用物理攻击时有一定概率在攻击一次
 */
@Component
public class PhysicalBatterBuffHandler extends AbstractAttackBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_PHYSICAL_BATTER;
    }

    @Override
    protected DamageType triggerDamageType() {
        return DamageType.PHYSICAL;
    }

    @Override
    protected SkillDo getChaseSkill(HeroDo beTrigger) {
        return beTrigger.getCurrentSkill();
    }

    @Override
    protected long getSkillEffectPercent(CBuff buff) {
        return buff.getValue()[1];
    }
}
