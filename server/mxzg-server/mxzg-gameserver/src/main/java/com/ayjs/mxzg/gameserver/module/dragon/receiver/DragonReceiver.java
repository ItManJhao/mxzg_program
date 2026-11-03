package com.ayjs.mxzg.gameserver.module.dragon.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.AttributeInfo;
import com.ayjs.mxzg.battle.model.DragonInfo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.battle.model.SkillInfo;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.DragonLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRelicSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.entity.CDragonLevel;
import com.ayjs.mxzg.config.excel.entity.CDragonRelic;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.dragon.domain.Dragon;
import com.ayjs.mxzg.gameserver.module.dragon.service.DragonService;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonSlot;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 神龙
 *
 * @author meiyc
 */
@Component
public class DragonReceiver implements Receivers {



    @Autowired
    private DragonService dragonService;
    @Autowired
    private DragonLevelSysCache dragonLevelSysCache;
    @Autowired
    private DragonRelicSysCache dragonRelicSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;


    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        DragonInfo dragonInfo = getAndAddHero(command.getPlayerId(), command.getLineUpType(), command.getHeros());
        command.setDragonInfo(dragonInfo);
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        DragonInfo dragonInfo = getAndAddHero(command.getPlayerId(), command.getLineUpType(), command.getHeroDos());
        command.setDragonInfo(dragonInfo);
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        getAndAddHero(command.getHero().getRid(), null, Lists.newArrayList(command.getHeroDo()));
    }

    /**
     * 获取神龙并给指定的英雄列表加成
     *
     * @param playerId
     * @param lineUpType
     * @param heroDos
     * @return
     */
    private DragonInfo getAndAddHero(long playerId, LineUpType lineUpType, List<HeroDo> heroDos) {
        if(lineUpType == LineUpType.LANG_UP){
            return null;
        }

        RoleService roleService = SpringProxy.getBean(RoleService.class);
        Role role = roleService.getOrThrow(playerId);
        OpenConditionSysCache openConditionSysCache = SpringProxy.getBean(OpenConditionSysCache.class);
        COpenCondition openCondition = openConditionSysCache.getCondition("main_dragon");
        if(openCondition == null || openCondition.getCondition_value() > role.getLevel()){
            return null;
        }

        Dragon dragon = dragonService.getDragon(playerId);

        CDragonLevel cDragonLevel = dragonLevelSysCache.getOrThrow(dragon.getAttrLevel());

        AttributeInfo attributeInfo = AttributeInfo.valueOf(cDragonLevel.getAbility());
        List<SkillDo> skillDos = new ArrayList<>();
        int initialRound = 0;
        boolean initialization = false;
        for(DragonSlot slot : dragon.getSlots().values()) {
            initialRound++;
            if(slot.getSysId() == 0) {
                SkillDo skill = SkillDo.createOf(null, initialRound);
                skillDos.add(skill);
            } else {
                CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(slot.getSysId());
                attributeInfo.addAllAttribute(cDragonRelic.getAbility());
                CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cDragonRelic.getSkill(), cDragonRelic.getStar());
                SkillDo skill = SkillDo.createOf(heroSkill, initialRound);
                skillDos.add(skill);
            }
        }
        if(skillDos.isEmpty() && initialization){
            return null;
        }
        SkillInfo skillInfo = SkillInfo.createOf(skillDos);
        return DragonInfo.of(cDragonLevel.getIdx(), skillInfo, attributeInfo);
    }

}
