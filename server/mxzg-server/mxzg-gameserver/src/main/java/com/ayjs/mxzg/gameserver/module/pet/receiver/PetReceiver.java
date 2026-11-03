package com.ayjs.mxzg.gameserver.module.pet.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.pet.PetLevelSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.pet.CPetLevel;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author hyx
 */
@Component
public class PetReceiver implements Receivers {

    @Autowired
    private PetService petService;
    @Autowired
    private PetLevelSysCache petLevelSysCache;
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
            Pet pet = petService.getHeroCarryPet(playerId, heroDo.getId());
            if (pet != null) {
                //基础属性
                CPetLevel cPetLevel = petLevelSysCache.getPetConfig(pet.getSysId(), pet.getLevel());
                heroDo.getAttributeInfo().addAllAttribute(cPetLevel.getAttr());
                //技能
                if (cPetLevel.getSkill() > 0) {
                    CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cPetLevel.getSkill(), cPetLevel.getSkill_level());
                    SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                    heroDo.getSkillInfo().addSkill(skillDo);
                }
            }
        }
    }

}
