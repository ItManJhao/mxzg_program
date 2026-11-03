/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroUpGradeSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CHeroUpGrade;
import com.ayjs.mxzg.config.excel.entity.CRunesType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanSkillService;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanSkillData;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroScoreDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroScore;
import com.ayjs.mxzg.gameserver.module.hero.event.AllHeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroEvolve;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.HeroScoreGMsg.PSHeroScore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Observer
@Service
public class HeroScoreService implements Lifecycle {

    @Autowired
    private HeroScoreDao heroScoreDao;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private FetterService fetterService;
    @Autowired
    private ClanSkillService clanSkillService;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroEquipService heroEquipService;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private HeroService heroService;

    public HeroScore getScore(int heroType) {
        return heroScoreDao.get((long) heroType);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("HeroScoreService");
    }

    @Override
    public void start() throws Exception {
        List<HeroScore> scoreList = heroScoreDao.listAll();
        Map<Integer, HeroScore> scoreMap = new HashMap<>();
        for (HeroScore heroScore : scoreList) {
            scoreMap.put((int) heroScore.getId(), heroScore);
        }
        //新增的数据列表
        List<HeroScore> newList = new ArrayList<>();
        for (CHeroType heroType : heroTypeSysCache.getAll()) {
            if (scoreMap.containsKey(heroType.getType())) {
                continue;
            }
            HeroScore heroScore = new HeroScore();
            heroScore.setId(heroType.getType());
            newList.add(heroScore);
        }
        if (!newList.isEmpty()) {
            heroScoreDao.add(newList);
        }
    }

    public PSHeroScore countScore(Hero hero, int fetterType) {
        int level = 50 * (1 + hero.getLevel());
        int star = 100 * hero.getStar();

        //装备评分
        List<HeroEquip> equipList = heroEquipService.getHeroEquips(hero.getRid(), hero.getId());
//		long atkTotal = 0;
//		long hpTotal = 0;
//		long defTotal = 0;
        int equip = 0;
        for (HeroEquip heroEquip : equipList) {
            if (heroEquip.getSysId() <= 0) {
                continue;
            }
            CEquipmenttype equipmenttype = equipmenttypeSysCache.getOrThrow(heroEquip.getSysId());

            long atkTotal = equipmenttype.getAbility().getOrDefault(AttributeType.ATTACK, 0l);
            long hpTotal = equipmenttype.getAbility().getOrDefault(AttributeType.HP, 0l);
            long defTotal = equipmenttype.getAbility().getOrDefault(AttributeType.DEFENSE, 0l);
            //需要一件件计算，不然会跟前端的计算结果有误差
            equip += battleTemplate.computeScore(atkTotal, hpTotal, defTotal, 0);
        }

        //英雄阶级评分
        CHeroUpGrade cHeroUpGrade = heroUpGradeSysCache.getOrThrow(hero.getStage());
        int grade = cHeroUpGrade.getScore();

        //羁绊评分
//		int fetter = 0;
//		FetterGoddess fetterGoddess = fetterService.selectFetterGoddess(hero.getRid(), fetterType);
//		if(fetterGoddess != null) {
//			fetter = 100 * fetterGoddess.getLevel();
//		}
        int fetter = fetterService.load(hero.getRid()).getLevel();

        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());

        //公会科技评分
        ClanSkill clanSkill = clanSkillService.selectClanSkill(hero.getRid());
        ClanSkillData skillData = clanSkill.getSkillList().get(cHeroType.getOccupation());
        int clanSkillScore = 0;
        if (skillData != null) {
            int sort1Level = skillData.getLevel();
            if (skillData.getSkillType() >= 1) {
                sort1Level += 1;
            }
            int sort2Level = skillData.getLevel();
            if (skillData.getSkillType() >= 2) {
                sort2Level += 1;
            }
            int sort5Level = skillData.getLevel();
            if (skillData.getSkillType() >= 5) {
                sort5Level += 1;
            }
            clanSkillScore = 1 * (sort1Level - 1) + 6 * (sort2Level - 1) + 19 * (sort5Level - 1);
        }

        //精灵评分
        int runes = 0;
        List<RuneInfo> runeList = runeInfoService.getRuneOnHero(hero.getRid(), hero.getId());
        for (RuneInfo runeInfo : runeList) {
            CRunesType runesType = runesTypeSysCache.getByType(runeInfo.getTypeId());
            runes += runesType.getScore();
        }
        int score = level + star + equip + grade + fetter + clanSkillScore + runes;

        PSHeroScore.Builder builder = PSHeroScore.newBuilder();
        builder.setType(hero.getType());
        builder.setScore(score);
        builder.setLevel(level);
        builder.setStar(star);
        builder.setEquip(equip);
        builder.setGrade(grade);
        builder.setFetter(fetter);
        builder.setClanSkill(clanSkillScore);
        builder.setRunes(runes);
        return builder.build();
    }


    @Subscribe(async = AsyncType.Async)
    private void listen(HeroFightChangeEvent event) {
        Hero hero = event.getHero();
        if (!heroLineUpService.isHeroInLineUp(hero.getRid(), hero.getId(), LineUpType.MAIN)) {
            return;
        }
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(hero.getRid(), LineUpType.MAIN);
        updateScore(hero, heroLineUp.getGoddessType());
    }

    private void updateScore(Hero hero, int fetterType) {
        PSHeroScore builder = countScore(hero, fetterType);

        HeroScore heroScore = this.getScore(hero.getType());
        if (heroScore.getScore() >= builder.getScore()) {
            return;
        }
        heroScore.setScore(builder.getScore());
        heroScore.setLevel(builder.getLevel());
        heroScore.setStar(builder.getStar());
        heroScore.setEquip(builder.getEquip());
        heroScore.setGrade(builder.getGrade());
        heroScore.setFetter(builder.getFetter());
        heroScore.setClanSkill(builder.getClanSkill());
        heroScore.setRunes(builder.getRunes());

        heroScoreDao.update(heroScore);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(AllHeroFightChangeEvent event) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(event.getRid(), LineUpType.MAIN);
        for (Long heroId : heroLineUp.getFormationMap().keySet()) {
            Hero hero = heroService.getHero(event.getRid(), heroId);
            if (hero == null) {
                continue;
            }
            updateScore(hero, heroLineUp.getGoddessType());
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(GoddessLevelUpOperatorEvent event) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(event.getRid(), LineUpType.MAIN);
        if (heroLineUp.getGoddessType() != event.getConfigId()) {
            return;
        }
        for (Long heroId : heroLineUp.getFormationMap().keySet()) {
            Hero hero = heroService.getHero(event.getRid(), heroId);
            if (hero == null) {
                continue;
            }
            updateScore(hero, heroLineUp.getGoddessType());
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listne(LineUpChangeEvent event) {
        if (event.getHeroLineUp().getType() != LineUpType.MAIN.getValue()) {
            return;
        }
        for (Long heroId : event.getHeroLineUp().getFormationMap().keySet()) {
            Hero hero = heroService.getHero(event.getHeroLineUp().getRid(), heroId);
            if (hero == null) {
                continue;
            }
            updateScore(hero, event.getHeroLineUp().getGoddessType());
        }
    }
}
