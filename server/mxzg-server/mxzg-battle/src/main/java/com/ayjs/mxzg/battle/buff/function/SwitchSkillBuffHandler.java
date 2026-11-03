package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * 切换技能
 */
@Slf4j
@Component
public class SwitchSkillBuffHandler extends AbstractBuffHandler {

    @Autowired
    private HeroSkillSysCache heroSkillSysCache;

    @Override
    public BuffType getType() {
        return BuffType.BT_SWITCH_SKILLS;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        addBuff(buff, attacker, defender, builder, context);
        int oldSkillId = buff.getValue()[0];
        int newSkillId = buff.getValue()[1];
        SkillDo skillDo = attacker.getSkillInfo().getSkill(oldSkillId);
        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(newSkillId, skillDo.getSkill().getLevel());
        SkillDo newSkillDo = SkillDo.createOf(heroSkill);
        attacker.getSkillInfo().switchSkill(skillDo, newSkillDo);
    }

    @Override
    public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
        int oldSkillId = buff.getBuff().getValue()[0];
        int newSkillId = buff.getBuff().getValue()[1];
        SkillDo skillDo = target.getSkillInfo().getSkill(newSkillId);
        if (Objects.isNull(skillDo)) {
            log.error("SwitchSkillBuffHandler removeBuff skillDo is null. buff:{} target:{}",
                    GJsonUtils.toJson(buff), GJsonUtils.toJson(target));
            return;
        }
        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(oldSkillId, skillDo.getSkill().getLevel());
        SkillDo newSkillDo = SkillDo.createOf(heroSkill);
        target.getSkillInfo().switchSkill(skillDo, newSkillDo);
    }

}
