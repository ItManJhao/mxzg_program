package com.ayjs.mxzg.battle.buff.trigger.attack;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.DamageType;
import org.springframework.stereotype.Component;

/**
 * 法连，使用魔法攻击时有一定概率在攻击一次
 */
@Component
public class MagicBatterBuffHandler extends AbstractAttackBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_MAGIC_BATTER;
    }

    @Override
    protected DamageType triggerDamageType() {
        return DamageType.MAGIC;
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
