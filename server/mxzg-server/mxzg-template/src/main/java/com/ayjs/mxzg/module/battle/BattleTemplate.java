/**
 *
 */
package com.ayjs.mxzg.module.battle;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.HeroBaseCommand;
import com.ayjs.mxzg.battle.command.HeroInitCommand;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.model.mirror.*;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.config.struct.*;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.collect.Sets;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.Map.Entry;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Component
public class BattleTemplate implements Receivers {

    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroElemMulSysCache heroElemMulSysCache;
    @Autowired
    private ElementAdditionSysCache elementAdditionSysCache;
    @Autowired
    private HeroBaseSysCache heroBaseSysCache;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private EquipmentSetTypeSysCache equipmentSetTypeSysCache;
    @Autowired
    private BuffArtSysCache buffArtSysCache;
    @Autowired
    private BuffSysCache buffSysCache;
    @Autowired
    private RunesAbilitySysCache runesAbilitySysCache;
    @Autowired
    private ScoreCountSysCache scoreCountSysCache;
    @Autowired
    private HeroUpgradeRateSysCache heroUpgradeRateSysCache;
    @Autowired
    private BattleDefendSysCache battleDefendSysCache;
    @Autowired
    private BattleMatrixAdditionSysCache battleMatrixAdditionSysCache;
    @Autowired
    private RuneSkillTypeSysCache runeSkillTypeSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private LanguageSysCache languageSysCache;

    /**
     * 查询Battler信息，提供给由策划配置NPC生成的战斗使用
     * @param heroConfigs
     * @param battlerName
     * @param faction
     * @param unitType
     * @return
     */
    public <T extends HeroConfig> BattlerDo queryBattler(List<T> heroConfigs, String battlerName, Faction faction, UnitType unitType) {
        List<HeroInfo> heroInfos = heroConfigs.stream().map(HeroInfo::createOf).filter(hero -> hero.getHeroId() != 0).collect(Collectors.toList());
        HeroBaseCommand mosterCommand = HeroBaseCommand.createOf(unitType, heroInfos);
        commandBus.invoke(mosterCommand);

        //立哥说根据NPC的站位反推出阵型
        int resultFormationId = formationId(heroConfigs);

        return BattlerDo.createOf(-1, battlerName, faction, unitType, mosterCommand.getHeroDos(), null, resultFormationId, null);
    }

    /**
     * 查询Battler信息，提供给由策划配置NPC生成的战斗使用,并使用第一个npc的名字作为对手的名字
     * @param heroConfigs
     * @param faction
     * @param unitType
     * @return
     */
    public <T extends HeroConfig> BattlerDo queryNpcBattler(List<T> heroConfigs, Faction faction, UnitType unitType) {
        BattlerDo battlerDo = queryBattler(heroConfigs, "", faction, unitType);
        HeroDo heroDo = battlerDo.getAllHeros().get(0);
        battlerDo.setName(heroDo.getName());
        return battlerDo;
    }

    public <T extends HeroConfig> int formationId(List<T> heroConfigs) {
        int resultFormationId = 1;
        for (Entry<Integer, Map<Integer, CBattleMatrixAddition>> entry : battleMatrixAdditionSysCache.getAllMatrix().entrySet()) {
            Map<Integer, CBattleMatrixAddition> matrixMap = entry.getValue();
            boolean fullMatch = true;
            for (T t : heroConfigs) {
                CBattleMatrixAddition posConfig = matrixMap.get(t.getPos());
                if (posConfig != null && posConfig.getIs_open() == 0) {
                    fullMatch = false;
                    break;
                }
            }
            if (fullMatch) {
                resultFormationId = entry.getKey();
                break;
            }
        }
        return resultFormationId;
    }

    /**
     * 根据BattleVo来创建BattlerDo
     *
     * @param battleVo
     * @param battlerName
     * @param faction
     * @param unitType
     * @return
     */
    public BattlerDo queryBattler(BattlerVo battleVo, String battlerName, Faction faction, UnitType unitType) {
        HeroInitCommand command = HeroInitCommand.createOf(battleVo.getHeros());
        commandBus.invoke(command);
        Goddess goddess = battleVo.getGoddess() == null ? null : createGoddessWith(battleVo.getGoddess());
        DragonInfo dragonInfo = createDragonWith(battleVo.getDragonVo());
        return BattlerDo.createOf(battleVo.getPlayerId(), battlerName, faction, unitType, command.getHeroDos(), goddess, battleVo.getFormationId(), dragonInfo);
    }

    /**
     * 根据GoddessVo创建Goddess
     *
     * @param goddessVo
     * @return
     */
    private Goddess createGoddessWith(GoddessVo goddessVo) {
        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(goddessVo.getSkillId(), goddessVo.getLevel());
        SkillDo skill = SkillDo.createOf(heroSkill);
        return Goddess.createOf(goddessVo.getGoddessId(), goddessVo.getAttack(), skill, goddessVo.getUplimitLevel(), goddessVo.getEnergy(), goddessVo.getFashionId());
    }

    /**
     * 根据DragonVo创建DragonInfo
     *
     * @param dragonVo
     * @return
     */
    private DragonInfo createDragonWith(DragonVo dragonVo) {
        if (dragonVo == null || dragonVo.getSkills() == null || dragonVo.getAttributes() == null) {
            return null;
        }
        List<SkillDo> skillDos = new ArrayList<>();
        for (DragonSkill skillInfo : dragonVo.getSkills()) {
            SkillDo skillDo = null;
            if (skillInfo.getSkillId() == 0) {
                skillDo = SkillDo.createOf(null, skillInfo.getInitialRound());
            } else {
                CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(skillInfo.getSkillId(), skillInfo.getSkillLevel());
                skillDo = SkillDo.createOf(heroSkill, skillInfo.getInitialRound());
            }
            skillDos.add(skillDo);
        }
        SkillInfo skillInfo = SkillInfo.createOf(skillDos);
        AttributeInfo attributeInfo = AttributeInfo.createOf(dragonVo.getAttributes());
        return DragonInfo.of(dragonVo.getDragonId(), skillInfo, attributeInfo);
    }

    @Invoker
    public void onBattleInitCommand(HeroInitCommand command) {
        List<HeroVo> heroVos = command.getHeroVos();
        if (CollectionUtil.isNotEmpty(heroVos)) {
            List<HeroDo> heros = heroVos.stream().map(this::buildHeroDoBy).filter(hero -> hero.getHeroId() != 0).collect(Collectors.toList());
            command.setHeroDos(heros);
        } else {
            command.setHeroDos(Collections.emptyList());
        }
    }

    /**
     * 根据HeroVo获取HeroDo
     * @param heroVo
     * @return
     */
    public HeroDo buildHeroDoBy(HeroVo heroVo) {
        HeroDo heroDo = HeroDo.createOf(heroVo);
        CHeroType heroType = heroTypeSysCache.getOrThrow(heroVo.getHero_type());

        List<SkillDo> skillDos = heroVo.getSkills().entrySet().stream()
                .map(entry -> heroSkillSysCache.getHeroSkillByOrThrow(entry.getKey(), entry.getValue()))
                .map(skill -> SkillDo.createOf(skill)).collect(Collectors.toList());

        SkillInfo skillInfo = SkillInfo.createOf(skillDos);
        heroDo.setSkillInfo(skillInfo);
        CHeroElemMul heroElemMul = heroElemMulSysCache.getOrThrow(heroType.getElem());
        heroDo.setElementMul(heroElemMul);
        heroDo.setJob(ConvertUtils.toEnum(heroType.getOccupation(), Job.class));
        return heroDo;
    }

    @Invoker
    public void onHeroBaseCommand(HeroBaseCommand command) {
        List<HeroDo> heroDos = command.getHeros().stream().map(heroInfo -> convertFrom(heroInfo, command.getUnitType(), Collections.emptyList())).collect(Collectors.toList());
        setBattleHaloAttribute(heroDos);
        command.setHeroDos(heroDos);
    }

    /**
     * 添加阵型激活属性
     * @param heroDos
     */
    public void setBattleHaloAttribute(List<HeroDo> heroDos) {
        List<Integer> currentTeam = heroDos.stream().map(hero -> hero.getElementMul().getIdx()).collect(Collectors.toList());
        List<CElementAddition> additions = elementAdditionSysCache.getElementAddition(currentTeam);
        for (CElementAddition addition : additions) {
            heroDos.stream().forEach(heroDo -> heroDo.getAttributeInfo().addAllAttribute(addition.getAbility()));
        }
    }

    /**
     * 将英雄信息转换为英雄领域对象
     *
     * @param heroInfo
     * @param unitType
     * @param extraSkillDos
     * @return
     */
    public HeroDo convertFrom(HeroInfo heroInfo, UnitType unitType, List<SkillDo> extraSkillDos) {
        HeroDo.HeroDoBuilder builder = HeroDo.builder();

        CHeroBase heroBase = heroBaseSysCache.getTypeStarOrThrow(heroInfo.getHeroId(), heroInfo.getStar());
        CHeroUpGrade heroUpGrade = unitType == UnitType.HERO ? heroUpGradeSysCache.getOrThrow(heroInfo.getStage())
                : heroUpGradeSysCache.getHeroUpGradeOrThrow(heroInfo.getLevel());
        CHeroStar heroStar = heroStarSysCache.getOrThrow(heroInfo.getStar());
        CHeroType heroType = heroTypeSysCache.getOrThrow(heroInfo.getHeroId());
        CHeroElemMul heroElemMul = heroElemMulSysCache.getOrThrow(heroType.getElem());
        CHeroUpgradeRate upgradeRate = heroUpgradeRateSysCache.getUpgradeRate(heroInfo.getHeroId(), heroUpGrade.getGrade());
        CBattleDefend cBattleDefend = battleDefendSysCache.getOrThrow(heroInfo.getStar());

        int levelDifference = heroInfo.getLevel() - heroUpGrade.getBegin_level();
        long attack = (long) (AttributeUtil.calPercent(heroBase.getAtk(), upgradeRate.getAtk_rate()) +
                AttributeUtil.calPercent(heroBase.getAtk() * levelDifference, upgradeRate.getAtk_grow()));
        long hp = (long) (AttributeUtil.calPercent(heroBase.getHp(), upgradeRate.getHp_rate()) +
                AttributeUtil.calPercent(heroBase.getHp() * levelDifference, upgradeRate.getHp_grow()));
        long defence = (long) (AttributeUtil.addPercent(heroBase.getDef(), upgradeRate.getDef_rate()) +
                AttributeUtil.calPercent(heroBase.getDef() * levelDifference, upgradeRate.getDef_grow()));
        long speed = (long) (AttributeUtil.addPercent(heroBase.getSpd(), upgradeRate.getSpd_rate()) +
                AttributeUtil.calPercent(heroBase.getSpd() * levelDifference, upgradeRate.getSpd_grow()));

        Map<AttributeType, Long> baseAttribute = new HashMap<>();
        baseAttribute.put(AttributeType.ATTACK, attack);
        baseAttribute.put(AttributeType.HP, hp);
        baseAttribute.put(AttributeType.DEFENSE, defence);
        baseAttribute.put(AttributeType.SPEED, speed);
        baseAttribute.put(AttributeType.DEFEND_RAGE, (long) cBattleDefend.getRate());
        AttributeInfo attributeInfo = AttributeInfo.valueOf(baseAttribute);
        if (CollectionUtils.isNotEmpty(heroInfo.getAttr())) {
            heroInfo.getAttr().forEach(attributeInfo::addAttributeKind);
        }
        if (CollectionUtils.isNotEmpty(heroInfo.getEquipment())) {
            addEquipmentAttr(attributeInfo, heroInfo.getEquipment());
        }

        List<CHeroSkill> skills = getSkillsBy(heroUpGrade, heroType, heroStar);
        List<SkillDo> skillDos = skills.stream().map(SkillDo::createOf).collect(Collectors.toList());
        SkillInfo skillInfo = SkillInfo.createOf(skillDos);
        ConfigAsserts.isTrue(!skillInfo.getActiveSkills().isEmpty(), String.format("英雄%s没有配置英雄技能", heroInfo.getHeroId()));
        ConfigAsserts.notNull(skillInfo.getGeneralAttack(), String.format("英雄%s没有配置普攻", heroInfo.getHeroId()));

        if (CollectionUtils.isNotEmpty(heroInfo.getRunes())) {
            heroInfo.getRunes().forEach(runes -> addRunes(skillInfo, attributeInfo, runes));
        }
        skillInfo.addAllSkill(extraSkillDos);
        addSkillAttribute(skillInfo, attributeInfo);

        CLanguage language = languageSysCache.getByKey(String.valueOf(heroType.getType()));
        String heroName = languageHelper.getLanguageBy(language);
        builder.id(heroInfo.getId()).heroId(heroInfo.getHeroId()).star(heroInfo.getStar()).level(heroInfo.getLevel());
        builder.name(heroName).position(heroInfo.getPosition()).damageType(heroType.getDamage_type());
        builder.job(ConvertUtils.toEnum(heroType.getOccupation(), Job.class)).elementMul(heroElemMul).stage(heroInfo.getStage());
        builder.attributeInfo(attributeInfo).actionInfo(ActionInfo.getInstance()).skillInfo(skillInfo);
        builder.evolve(EvolveData.of(0, 0));
        return builder.build();
    }

    /**
     * 添加装备属性
     *
     * @param attributeInfo
     * @param equipInfos
     */
    private void addEquipmentAttr(AttributeInfo attributeInfo, List<EquipInfo> equipInfos) {
        Multimap<Integer, Integer> equipSet = ArrayListMultimap.create();
        for (EquipInfo equipInfo : equipInfos) {
            CEquipmenttype equipmenttype = equipmenttypeSysCache.getOrThrow(equipInfo.getEquipId());
            attributeInfo.addAllAttribute(equipmenttype.getAbility());
            if (equipmenttype.getSet_type() != 0) {
                equipSet.put(equipmenttype.getSet_type(), equipmenttype.getEquipment_type());
            }
        }

        Set<Integer> equipSets = Sets.newHashSet(equipSet.keys());
        for (int setId : equipSets) {
            Collection<Integer> set = equipSet.get(setId);
            List<CEquipmentSetType> setTypes = equipmentSetTypeSysCache.getEquipmentSetBy(setId, set.size());
            setTypes.forEach(setType -> attributeInfo.addAllAttribute(setType.getAttr()));
        }
    }

    /**
     * 添加增加面板属性的技能到初始属性
     *
     * @param skillInfo
     * @param attributeInfo
     */
    private void addSkillAttribute(SkillInfo skillInfo, AttributeInfo attributeInfo) {
        for (SkillDo skill : skillInfo.getSkillsBy(true)) {
            for (Integer artId : skill.getSkill().getArt_list()) {
                CBuffArt cBuffArt = buffArtSysCache.getOrThrow(artId);
                for (Integer buffType : cBuffArt.getBuff_list()) {
                    CBuff cBuff = buffSysCache.getOrThrow(buffType);
                    if (cBuff.isAttributeType()) {
                        attributeInfo.addInitAttribute(cBuff.getAttributeType(), cBuff.getAttributeValue());
                    }
                }
            }
        }
    }

    /**
     * 添加符文技能
     *
     * @param skillInfo
     * @param attributeInfo
     * @param runesInfo
     */
    private void addRunes(SkillInfo skillInfo, AttributeInfo attributeInfo, RunesVo runesInfo) {
        CRunesType runesType = runesTypeSysCache.getByType(runesInfo.getRunesId());
        CRunesAbility ability = runesAbilitySysCache.getByTypeRare(runesInfo.getAbilityType(), runesType.getRare());
        attributeInfo.addAllAttribute(ability.getAbility());
        if (CollectionUtils.isNotEmpty(runesInfo.getSkill())) {
            for (Integer[] skillArray : runesInfo.getSkill()) {
                CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(skillArray[0], skillArray[1]);
                skillInfo.addSkill(SkillDo.createOf(heroSkill));
                CRuneSkillType cRuneSkillType = runeSkillTypeSysCache.getByIdLv(skillArray[0], skillArray[1]);
                if (cRuneSkillType != null) {
                    attributeInfo.addInitAttribute(AttributeType.EXTRA_ABILITY, cRuneSkillType.getScore_count());
                }
            }
        }
    }

    /**
     * 根据英雄阶数和类型查找技能列表
     *
     * @param heroUpGrade
     * @param heroType
     * @param heroStar
     * @return
     */
    private List<CHeroSkill> getSkillsBy(CHeroUpGrade heroUpGrade, CHeroType heroType, CHeroStar heroStar) {
        List<CHeroSkill> skills = new ArrayList<>();
        if (heroUpGrade.getSkill1() == SkillStatus.UNLOCK.ordinal() && heroType.getSkill_1() != 0) {
            CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(heroType.getSkill_1(), heroStar.getSkill1());
            skills.add(heroSkill);
        }

        if (heroUpGrade.getSkill2() == SkillStatus.UNLOCK.ordinal() && heroType.getSkill_2() != 0) {
            CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(heroType.getSkill_2(), heroStar.getSkill2());
            skills.add(heroSkill);
        }

        if (heroUpGrade.getSkill3() == SkillStatus.UNLOCK.ordinal() && heroType.getSkill_3() != 0) {
            CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(heroType.getSkill_3(), heroStar.getSkill3());
            skills.add(heroSkill);
        }

        if (heroUpGrade.getSkill4() == SkillStatus.UNLOCK.ordinal() && heroType.getSkill_4() != 0) {
            CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(heroType.getSkill_4(), heroStar.getSkill4());
            skills.add(heroSkill);
        }
        if (heroType.getSkill_5() != 0) {
            CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(heroType.getSkill_5(), 0);
            skills.add(heroSkill);
        }
        return skills;
    }

    /**
     * 计算怪物的战力
     *
     * @param monsterList
     * @return
     */
    public <T extends HeroConfig> int computeMonsterStrength(List<T> monsterList) {
        List<HeroInfo> heroInfos = monsterList.stream().map(HeroInfo::createOf).filter(hero -> hero.getHeroId() != 0).collect(Collectors.toList());
        HeroBaseCommand command = HeroBaseCommand.createOf(UnitType.MOSTER, heroInfos);
        commandBus.invoke(command);

        int fighting = 0;
        for (HeroDo monster : command.getHeroDos()) {
            monster.initAttribute();
            fighting += computeStrength(monster);
        }
        return fighting;
    }

    /**
     * 计算战力
     *
     * @param battlerDo
     * @return
     */
    public int computeStrength(BattlerDo battlerDo) {
        return battlerDo.getAllHeros().stream().mapToInt(this::computeStrength).sum();
    }

    public int computeStrength(HeroDo heroDo) {
        double fighting = 0;
        for (CScoreCount cScoreCount : scoreCountSysCache.getAll()) {
            long attr = heroDo.getAttribute(AttributeType.valueOf(cScoreCount.getMapping()));
            fighting += attr * cScoreCount.getRatio() / 10000.0d;
        }
        fighting = HeroConst.FIGHT_MUL * (int) fighting;
        long extra = heroDo.getAttribute(AttributeType.EXTRA_ABILITY);
        return (int) (fighting + extra);
    }

    /**
     * 用于计算某一个战力物件，比如装备的战力评分
     * @param atkTotal
     * @param hpTotal
     * @param defTotal
     * @param extra_ability
     * @return
     */
    public int computeScore(long atkTotal, long hpTotal, long defTotal, long extra_ability) {
        double atk_ration = scoreCountSysCache.getAtk_ration();
        double hp_ration = scoreCountSysCache.getHp_ration();
        double def_ration = scoreCountSysCache.getDef_ration();

        double fighting = atkTotal * atk_ration / 10000 + hpTotal * hp_ration
                / 10000 + defTotal * def_ration / 10000;
        //向上取整
        return (int) (Math.ceil(fighting) + extra_ability);
    }
}
