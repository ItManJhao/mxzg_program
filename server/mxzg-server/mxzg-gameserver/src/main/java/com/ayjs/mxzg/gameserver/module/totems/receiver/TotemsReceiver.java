package com.ayjs.mxzg.gameserver.module.totems.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.totems.CTotems;
import com.ayjs.mxzg.config.excel.entity.totems.CTotemsLevel;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import com.ayjs.mxzg.gameserver.module.totems.service.TotemsService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TotemsReceiver implements Receivers {
    @Autowired
    TotemsService totemsService;
    @Autowired
    private TotemsSysCache totemsSysCache;
    @Autowired
    private TotemsLevelSysCache totemsLevelSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;

    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttributeAddition(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }


    public void setAttributeAddition(long playerId, List<HeroDo> heroDos) {
        for (HeroDo heroDo : heroDos) {
            Totems totems = totemsService.getTotems_byHero(playerId, heroDo.getId());
            if (totems == null) {
                continue;
            }
            //当前等级等于升阶等级时，只取品质属性
            CTotems cTotems = totemsSysCache.getCTotems_key(totems.getTotems_id(), totems.getQuality());
            CTotemsLevel cTotemsLevel = totemsLevelSysCache.getCTotemsLevel_key(totems.getTotems_id(), totems.getLevel());
            if (totems.getLevel() > 1 && cTotems.getNeedlevel() == totems.getLevel()) {
                //**********品质属性
                //基础属性
                if (cTotems.getAttr() != null && !cTotems.getAttr().isEmpty()) {
                    heroDo.getAttributeInfo().addAllAttribute(cTotems.getAttr());
                }
                //技能
                if (cTotems.getSkill() > 0) {
                    CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cTotems.getSkill(), cTotems.getSkill_level());
                    SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                    heroDo.getSkillInfo().addSkill(skillDo);
                }
                continue;
            }
            //**********等级属性
            //基础属性
            if (cTotemsLevel.getAttr() != null && !cTotemsLevel.getAttr().isEmpty()) {
                heroDo.getAttributeInfo().addAllAttribute(cTotemsLevel.getAttr());
            }
            //技能
            if (cTotemsLevel.getSkill() > 0) {
                CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cTotemsLevel.getSkill(), cTotemsLevel.getSkill_level());
                SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                heroDo.getSkillInfo().addSkill(skillDo);
            }
        }
    }
}
