package com.ayjs.mxzg.gameserver.module.hero.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.AttributeInfo;
import com.ayjs.mxzg.battle.model.EvolveData;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.command.annotation.Invoker.Priority;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroAwakenSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroUpGradeSysCache;
import com.ayjs.mxzg.config.excel.cache.TalentSysCache;
import com.ayjs.mxzg.config.excel.cache.heroEquipSoul.HeroEquipSoulExtraSysCache;
import com.ayjs.mxzg.config.excel.cache.heroEquipSoul.HeroEquipSoulSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
import com.ayjs.mxzg.config.excel.entity.CHeroAwaken;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.CHeroUpGrade;
import com.ayjs.mxzg.config.excel.entity.CTalent;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoul;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoulExtra;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.ayjs.mxzg.gameserver.module.hero.command.CalHerosFightingCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroFightingCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroEquipService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 英雄指令接收者
 *
 * @author meiyc
 */
@Component
@Slf4j
public class HeroReceivers implements Receivers {

    @Autowired
    private TalentSysCache talentSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroEquipService heroEquipService;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private HeroAwakenSysCache heroAwakenSysCache;
    @Autowired
    private HeroEquipSoulSysCache heroEquipSoulSysCache;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private HeroEquipSoulExtraSysCache heroEquipSoulExtraSysCache;


    @Invoker(Priority.HIGHEST)
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        List<Hero> heros = heroService.selectHeroList(command.getPlayerId(), command.getLineUpType());
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(command.getPlayerId(), command.getLineUpType());
        List<HeroDo> heroDos = heros.stream().map(hero -> buildHeroDo(hero, UnitType.HERO, heroLineUp)).collect(Collectors.toList());
        battleTemplate.setBattleHaloAttribute(heroDos);
        command.setHeros(heroDos);
    }

    @Invoker(Priority.HIGHEST)
    public void onQueryHeroCommand(QueryHeroCommand command) {
        if (Objects.nonNull(command.getHero())) {
            HeroDo heroDo = buildHeroDo(command.getHero(), UnitType.HERO, null);
            command.setHeroDo(heroDo);
        }
    }

    @Invoker
    public void onQueryHerosCommand(QueryHerosCommand command) {
        List<HeroDo> heroDos = new ArrayList<>();
        for (Hero hero : command.getHeros()) {
            QueryHeroCommand heroCommand = QueryHeroCommand.createOf(hero);
            commandBus.invoke(heroCommand);
            heroDos.add(heroCommand.getHeroDo());
        }

        if (!command.isOnlyHeroAttribute()) {
            battleTemplate.setBattleHaloAttribute(heroDos);
        }
        command.setHeroDos(heroDos);
    }

    @Invoker
    public void onQueryHeroFightingCommand(QueryHeroFightingCommand command) {
        QueryHeroCommand queryHeroCommand = QueryHeroCommand.createOf(command.getHero(), command.getType());
        commandBus.invoke(queryHeroCommand);
        int otherFighting = heroService.computeByHeroDo(queryHeroCommand.getHeroDo());
        int moduleFighting = command.getHero().getFighting() - otherFighting;
        if (moduleFighting < 0) {
            heroService.computeStrength(command.getHero(), GameEvent.HERO_REFRESH);
            moduleFighting = command.getHero().getFighting() - otherFighting;
        }
        moduleFighting = moduleFighting < 0 ? 0 : moduleFighting;
        command.setFighting(moduleFighting);
    }

    @Invoker
    public void onCalHerosFightingCommand(CalHerosFightingCommand command) {
        int totalFighting = command.getHeroDos().stream().mapToInt(heroService::computeByHeroDo).sum();
        command.setFighting(totalFighting);
    }

    @Invoker(Priority.HIGHEST)
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        battleTemplate.setBattleHaloAttribute(command.getHeroDos());
    }

    /**
     * 构建HeroDo对象
     *
     * @param hero
     * @param unitType
     * @param heroLineUp
     * @return
     */
    private HeroDo buildHeroDo(Hero hero, UnitType unitType, HeroLineUp heroLineUp) {
        List<SkillDo> skillDos = new ArrayList<>();
        HeroInfo heroInfo = hero.toHeroInfo();

        //重新替换共鸣魔方的等级
        int[] tweakCubeLvAndStage = tweakCubeService.getTweakCubeLvAndStage(hero);
        heroInfo.setLevel(tweakCubeLvAndStage[0]);
        heroInfo.setStage(tweakCubeLvAndStage[1]);

        if (heroLineUp != null && (heroLineUp.getType() == LineUpType.CRUSADE_GROUP.getValue() || heroLineUp.getType() == LineUpType.CRUSADE_GROUP_BOSS.getValue())) {
            heroInfo.setLevel(CrusadeGroupConst.CRUSADE_GROUP_HERO_LEVEL);
            CHeroUpGrade heroUpGrade = heroUpGradeSysCache.getHeroUpGradeOrThrow(heroInfo.getLevel());
            heroInfo.setStage(heroUpGrade.getGrade());
        }

        AttributeInfo attributeInfo = AttributeInfo.valueOf(new HashMap<AttributeType, Long>());
        for (Talent talent : hero.getTalents().values()) {
            if (talent.getSkillId() != 0) {
                CTalent cTalent = talentSysCache.getTalent(talent.getSkillId(), talent.getLevel());
                CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cTalent.getSkill_type(), cTalent.getLevel());
                skillDos.add(SkillDo.createOf(heroSkill));
                attributeInfo.addAllAttribute(cTalent.getAdd_combat());
            }
        }

        buildHeroInfo(hero.getRid(), heroInfo, heroLineUp);
        HeroDo heroDo = battleTemplate.convertFrom(heroInfo, unitType, skillDos);

        computerHeroAwaken(hero, heroDo);

        //增加附魂技能
        addSoulSkill(hero, heroDo);

        heroDo.setFashionId(hero.getFashionId());
        //设置进化数据
        heroDo.setEvolve(EvolveData.of(hero.getEvolve().getType(), hero.getEvolve().getLevel()));
        return heroDo;
    }

    private void computerHeroAwaken(Hero hero, HeroDo heroDo) {
        try {
            CHeroAwaken config = heroAwakenSysCache.getById(heroDo.getHeroId());
            if (hero.getAwaken().getBaseIndex().size() != 0 && !Objects.isNull(config)) {
                Map<AttributeType, Long> attributes = new HashMap<>();
                hero.getAwaken().getBaseIndex().forEach(index -> {
                    AttributeKind attr = config.getBase_attr().get(index);
                    attributes.put(AttributeType.valueOf(attr.getType()), attr.getValue());
                });
                hero.getAwaken().getSpecialIndex().forEach(index -> {
                    AttributeKind attr = config.getSpecial_attr().get(index);
                    attributes.put(AttributeType.valueOf(attr.getType()), attr.getValue());
                });
                heroDo.getAttributeInfo().addAllAttribute(attributes);
            }
        } catch (Exception e) {
            log.error("添加觉醒属性异常", e);
        }
    }

    private void addSoulSkill(Hero hero, HeroDo heroDo) {
        try {
            if (hero.getId() == 0) {
                return;
            }
            List<HeroEquip> heroEquips = heroEquipService.getHeroEquips(hero.getRid(), hero.getId());
            heroEquips.forEach(heroEquip -> {
                if (heroEquip.getSoulLv() > 0 && heroEquip.getSysId() != 0) {
                    CHeroEquipSoulExtra soulExtraConfig = heroEquipSoulExtraSysCache.getConfig();
                    CEquipmenttype equipConfig = equipmenttypeSysCache.getById(heroEquip.getSysId());
                    if (equipConfig.getRare() >= soulExtraConfig.getNeed_equip_rare() && equipConfig.getStar() >= soulExtraConfig.getNeed_equip_star()
                            && hero.getStar() >= soulExtraConfig.getNeed_star()) {
                        CHeroEquipSoul config = heroEquipSoulSysCache.getByPlaceAndLv(heroEquip.getPlace(), heroEquip.getSoulLv());
                        CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(config.getSkill(), config.getSkill_level());
                        SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                        heroDo.getSkillInfo().addSkill(skillDo);
                    }
                }
            });

        } catch (Exception e) {
            log.error("添加附魂技能异常", e);
        }
    }

    /**
     * 构造HeroInfo对象
     *
     * @param rid
     * @param heroInfo
     * @param heroLineUp
     * @return
     */
    private void buildHeroInfo(Long rid, HeroInfo heroInfo, HeroLineUp heroLineUp) {
        int pos = heroLineUp == null ? 1 : heroLineUp.getFormationMap().get(heroInfo.getId()).getPos();
        heroInfo.setPosition(pos);
        List<RunesVo> runesVos = runeInfoService.getRuneByHero(rid, heroInfo.getId());
        heroInfo.setRunes(runesVos);

        List<HeroEquip> equipList = heroEquipService.getHeroWearingEquips(rid, heroInfo.getId());
        List<EquipInfo> equipInfos = equipList.stream().map(HeroEquip::toEquipInfo).collect(Collectors.toList());
        heroInfo.setEquipment(equipInfos);
    }

}
