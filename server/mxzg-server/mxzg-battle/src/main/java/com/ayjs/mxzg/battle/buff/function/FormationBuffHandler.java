package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 变形
 */
@Component
public class FormationBuffHandler extends AbstractBuffHandler {

    @Autowired
    private HeroSkillSysCache heroSkillSysCache;

    @Override
    public BuffType getType() {
        return BuffType.BT_FORMATION;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        addBuff(buff, attacker, attacker, builder, context);
        unleashTransformationSkills(buff, attacker, context);
    }

    @Override
    public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
        unleashTransformationSkills(buff.getBuff(), target, context);
    }

    /**
     * 释放变身技能
     *
     * @param buff
     * @param attacker
     * @param context
     */
    private void unleashTransformationSkills(CBuff buff, HeroDo attacker, BattleContext context) {
        int skillId = buff.getValues().get(0);
        int skillLevel = buff.getValues().get(1);
        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(skillId, skillLevel);
        SkillDo skill = SkillDo.createOf(heroSkill);
        skill.setSkillEnergy(9999);
        attacker.addCounterattackTarget(attacker, skill);
        context.addCounterattack(attacker);
    }

}
