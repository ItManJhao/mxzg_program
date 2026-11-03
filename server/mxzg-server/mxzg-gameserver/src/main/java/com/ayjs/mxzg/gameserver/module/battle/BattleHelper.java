package com.ayjs.mxzg.gameserver.module.battle;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.command.HeroBaseCommand;
import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.config.excel.cache.BattleTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleType;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 战斗帮助类
 *
 * @author meiyc
 */
@Slf4j
@Component
public class BattleHelper {


    @Autowired
    private CommandBus commandBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private BattleTypeSysCache battleTypeSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageHelper languageHelper;

    /**
     * 查询BattlerDo信息
     *
     * @param lineUpType
     * @param playerId
     * @param faction
     * @param battleHeroIds 上阵的英雄id列表
     * @return
     */
    public BattlerDo queryPlayerBattler(LineUpType lineUpType, long playerId, Faction faction, List<Long> battleHeroIds) {
        QueryBattleCommand command = QueryBattleCommand.createOf(playerId, lineUpType);
        commandBus.invoke(command);
        Role role = roleService.getOrThrow(playerId);
        List<HeroDo> heroDos = command.getHeros().stream().filter(hero -> battleHeroIds.contains(hero.getId())).collect(Collectors.toList());
        BattlerDo battlerDo = BattlerDo.createOf(playerId, role.getNick(), faction, UnitType.HERO, heroDos, command.getGoddess(), command.getFormationId(), command.getDragonInfo());
        setRoleInfo(role, battlerDo);
        return battlerDo;
    }

    /**
     * 根据指定的英雄id生成BattlerDo，提供给没有阵型的战斗，比如月神庇护所
     *
     * @param rId
     * @param heroId
     * @param faction
     * @return
     */
    public BattlerDo queryPlayerBattler(long rId, long heroId, Faction faction) {
        Hero hero = heroService.getHero(rId, heroId);
        QueryHeroCommand heroCommand = QueryHeroCommand.createOf(hero);
        commandBus.invoke(heroCommand);
        List<HeroDo> heroDos = Lists.newArrayList(heroCommand.getHeroDo());
        CLanguage cLanguage = languageSysCache.getByKey(String.valueOf(hero.getType()));
        BattlerDo battlerDo = BattlerDo.createOf(rId, languageHelper.getLanguageBy(cLanguage), faction, UnitType.HERO, heroDos, null, 0, null);
        Role role = roleService.getOrThrow(rId);
        setRoleInfo(role, battlerDo);
        return battlerDo;
    }

    /**
     * 根据指定的英雄id集合生成BattlerDo，提供给没有阵型的战斗，比如月神庇护所
     *
     * @param rId
     * @param heroIds
     * @param faction
     * @param filterType
     * @return
     */
    public BattlerDo queryPlayerBattler(long rId, List<Long> heroIds, Faction faction, ModuleType filterType) {
        List<HeroDo> heroDos = Lists.newArrayList();
        for(long heroId : heroIds){
            Hero hero = heroService.getHero(rId, heroId);
            QueryHeroCommand heroCommand = QueryHeroCommand.createOf(hero,  filterType);
            commandBus.invoke(heroCommand);
            heroDos.add(heroCommand.getHeroDo());
        }
        Role role = roleService.getOrThrow(rId);
        BattlerDo battlerDo = BattlerDo.createOf(rId, role.getNick(), faction, UnitType.HERO, heroDos, null, 0, null);
        setRoleInfo(role, battlerDo);
        return battlerDo;
    }


    /**
     * 根据HeroDo列表创建BattlerDo
     *
     * @param battleType
     * @param heroDos
     * @param playerId
     * @param faction
     * @return
     */
    public BattlerDo queryPlayerBattler(BattleType battleType, List<HeroDo> heroDos, long playerId, Faction faction) {
        Role role = roleService.getOrThrow(playerId);
        CBattleType type = battleTypeSysCache.getOrThrow(battleType.getValue());
        CreateBattlerCommand command = CreateBattlerCommand.createOf(playerId, type.getLine_up_type(), heroDos);
        commandBus.invoke(command);
        BattlerDo battlerDo = BattlerDo.createOf(playerId, role.getNick(), faction, UnitType.HERO, command.getHeroDos(), command.getGoddess(), command.getFormationId(), command.getDragonInfo());
        setRoleInfo(role, battlerDo);
        return battlerDo;
    }

    /**
     * 查询BattlerDo信息，如果指定的阵容没有英雄则选择主线阵容
     *
     * @param battleType
     * @param playerId
     * @param faction
     * @return
     */
    public BattlerDo queryBattlerOrMain(BattleType battleType, long playerId, Faction faction) {
        return queryBattlerOr(battleType, BattleType.MAIN, playerId, faction);
    }

    /**
     * 查询BattlerDo信息，如果指定的阵容没有英雄则选择orType
     *
     * @param battleType
     * @param playerId
     * @param faction
     * @return
     */
    public BattlerDo queryBattlerOr(BattleType battleType, BattleType orType, long playerId, Faction faction) {
        CBattleType type = battleTypeSysCache.getOrThrow(battleType.getValue());
        BattlerDo battlerDo = queryPlayerBattler(type.getLine_up_type(), playerId, faction);
        if(battlerDo.getHeros().isEmpty() && battleType != orType){
            battlerDo = queryPlayerBattler(orType, playerId, faction);
        }
        return battlerDo;
    }

    /**
     * 查询BattlerDo信息
     *
     * @param battleType
     * @param playerId
     * @param faction
     * @return
     */
    public BattlerDo queryPlayerBattler(BattleType battleType, long playerId, Faction faction) {
        CBattleType type = battleTypeSysCache.getOrThrow(battleType.getValue());
        return queryPlayerBattler(type.getLine_up_type(), playerId, faction);
    }

    /**
     * 查询BattlerDo信息
     *
     * @param lineUpType
     * @param playerId
     * @param faction
     * @return
     */
    public BattlerDo queryPlayerBattler(LineUpType lineUpType, long playerId, Faction faction) {
        QueryBattleCommand command = QueryBattleCommand.createOf(playerId, lineUpType);
        commandBus.invoke(command);
        Role role = roleService.getOrThrow(playerId);
        BattlerDo battlerDo = BattlerDo.createOf(playerId, role.getNick(), faction, UnitType.HERO, command.getHeros(), command.getGoddess(), command.getFormationId(), command.getDragonInfo());
        setRoleInfo(role, battlerDo);
        return battlerDo;
    }

    /**
     * 查询npc战场信息
     *
     * @param heroConfigs
     * @param npcName
     * @return
     */
    public <T extends HeroConfig> BattlerDo queryNpcBattler(List<T> heroConfigs, String npcName) {
        return battleTemplate.queryBattler(heroConfigs, npcName, Faction.DEFENDER, UnitType.MOSTER);
    }

    /**
     * 调用pvp战斗
     *
     * @param battleType
     * @param attackerId
     * @param defenderId
     * @return
     */
    public BattleResult invokePVPBattle(BattleType battleType, long attackerId, long defenderId) {
        CBattleType type = battleTypeSysCache.getOrThrow(battleType.getValue());
        BattlerDo attacker = queryPlayerBattler(type.getLine_up_type(), attackerId, Faction.ATTACKER);
        BattlerDo defender = queryPlayerBattler(type.getLine_up_type(), defenderId, Faction.DEFENDER);
        BattleCommand battleCommand = BattleCommand.createOf(battleType, attacker, defender);
        commandBus.invoke(battleCommand);
        return battleCommand.getResult();
    }

    /**
     * 根据指定的配置列表调用战斗
     *
     * @param battleType
     * @param attackerHeros
     * @param defenderHeros
     * @return
     */
    public <T extends HeroConfig> BattleResult invokeBattle(BattleType battleType, List<T> attackerHeros, List<T> defenderHeros) {
        BattlerDo attacker = battleTemplate.queryBattler(attackerHeros, "", Faction.ATTACKER, UnitType.HERO);
        BattlerDo defender = battleTemplate.queryBattler(defenderHeros, "", Faction.DEFENDER, UnitType.HERO);
        BattleCommand battleCommand = BattleCommand.createOf(battleType, attacker, defender);
        commandBus.invoke(battleCommand);
        return battleCommand.getResult();
    }

    /**
     * 根据攻守放调用战斗
     *
     * @param battleType
     * @param attacker
     * @param defender
     * @return
     */
    public BattleResult invokeBattle(BattleType battleType, BattlerDo attacker, BattlerDo defender) {
        BattleCommand battleCommand = BattleCommand.createOf(battleType, attacker, defender);
        commandBus.invoke(battleCommand);
        return battleCommand.getResult();
    }

    /**
     * 根据攻守双方的阵容来战斗
     *
     * @param battleType    当前战斗的阵容类型
     * @param atkLineUpType 进攻方使用的阵容
     * @param attackerId
     * @param defLineUpType 防守方使用的阵容
     * @param defenderId
     * @return
     */
    public BattleResult invokePVPBattle(BattleType battleType, LineUpType atkLineUpType, long attackerId, LineUpType defLineUpType, long defenderId) {
        BattlerDo attacker = queryPlayerBattler(atkLineUpType, attackerId, Faction.ATTACKER);
        BattlerDo defender = queryPlayerBattler(defLineUpType, defenderId, Faction.DEFENDER);
        BattleCommand battleCommand = BattleCommand.createOf(battleType, attacker, defender);
        commandBus.invoke(battleCommand);
        return battleCommand.getResult();
    }


    /**
     * 调用pve战斗
     *
     * @param battleType
     * @param playerId
     * @param defenderHeros
     * @param defenderName
     * @return
     */
    public <T extends HeroConfig> BattleResult invokePVEBattle(BattleType battleType, long playerId, List<T> defenderHeros, String defenderName) {
        return invokePVEBattle(battleType, playerId, defenderHeros, defenderName, Collections.emptyList());
    }
    /**
     * 调用pve战斗
     * @param battleType
     * @param playerId
     * @param defenderHeros
     * @param defenderName
     * @param conditions
     * @return
     */
    public <T extends HeroConfig> BattleResult invokePVEBattle(BattleType battleType, long playerId, List<T> defenderHeros, String defenderName, List<BattleCondition> conditions) {
        CBattleType type = battleTypeSysCache.getOrThrow(battleType.getValue());
        BattlerDo attacker = queryPlayerBattler(type.getLine_up_type(), playerId, Faction.ATTACKER);
        BattlerDo defender = queryNpcBattler(defenderHeros, defenderName);
        BattleCommand battleCommand = BattleCommand.createOf(battleType, attacker, defender, conditions);
        commandBus.invoke(battleCommand);
        return battleCommand.getResult();
    }
    

    /**
     * 调用战斗，gm调用
     *
     * @param heros
     * @return
     */
    public BattleResult invokerBattle(List<HeroInfo> heros) {
        int median = heros.size() / 2;
        List<HeroInfo> attackHeros = new ArrayList<>(heros.subList(0, median));
        List<HeroInfo> defendHeros = new ArrayList<>(heros.subList(median, heros.size()));
        setPosition(attackHeros);
        setPosition(defendHeros);

        HeroBaseCommand attackCommand = HeroBaseCommand.createOf(UnitType.MOSTER, attackHeros);
        commandBus.invoke(attackCommand);
        BattlerDo attacker = BattlerDo.createOf(1L, "", Faction.ATTACKER, UnitType.MOSTER, attackCommand.getHeroDos(), null, 1, null);

        HeroBaseCommand defendCommand = HeroBaseCommand.createOf(UnitType.MOSTER, defendHeros);
        commandBus.invoke(defendCommand);
        BattlerDo defender = BattlerDo.createOf(0L, "", Faction.DEFENDER, UnitType.MOSTER, defendCommand.getHeroDos(), null, 1, null);

        BattleCommand battleCommand = BattleCommand.createOf(BattleType.MAIN, attacker, defender);
        try {
            commandBus.invoke(battleCommand);
        } catch (Exception ex) {
            log.info(ex.getMessage());
        }
        return battleCommand.getResult();
    }

    /**
     * 设置角色信息
     *
     * @param role
     * @param battlerDo
     */
    public void setRoleInfo(Role role, BattlerDo battlerDo) {
        int fighting = battlerDo.getHeroAndContainHelper().stream().mapToInt(heroService::computeByHeroDo).sum();
        battlerDo.setRoleInfo(role.getServerId(), role.getHeadId(), role.getBorderId(), role.getLevel(), fighting);
    }

    /**
     * 设置位置
     *
     * @param heros
     */
    private void setPosition(List<HeroInfo> heros) {
        for (int i = 0; i < heros.size(); i++) {
            heros.get(i).setPosition(i + 1);
        }
    }
}

