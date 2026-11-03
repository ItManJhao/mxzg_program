/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.battle.command.HeroInitCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroUpGradeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroLevel;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CHeroUpGrade;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.AllHeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroHexagram;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleConst;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.message.module.role.message.HeroBriefData;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.HeroAwakenGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg.ResHeroBriefData;
import com.ayjs.mxzg.protocol.HeroGMsg.ResHeroData;
import com.ayjs.mxzg.protocol.HeroHexagramGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class HeroService {

    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private HeroDao heroDao;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroEquipService heroEquipService;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroLevelSysCache heroLevelSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private HeroJewelService heroJewelService;
    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private ReikiEquipService reikiEquipService;
    @Autowired
    private PetService petService;

    public List<Hero> getHeros(long rid) {
        return heroDao.list("rid", rid);
    }

    public Hero getHero(long rid, long heroId) {
        for (Hero hero : getHeros(rid)) {
            if (hero.getId() == heroId) {
                return hero;
            }
        }
        return null;
    }

    /**
     * 获取不是被阵型绑定的英雄
     *
     * @param rid
     * @param heroId
     * @return
     */
    public Hero getUnlockInLineUpHero(long rid, long heroId) {
        Hero hero = getHero(rid, heroId);
        if (hero == null) {
            return null;
        }
        if (heroLineUpService.isHeroLockInLineUp(rid, heroId)) {
            return null;
        }
        if (tweakCubeService.isInTrench(rid, heroId)) {
            return null;
        }
        return hero;
    }

    public void updateHero(Hero hero) {
        heroDao.update(hero);
    }

    public void updateHeros(List<Hero> heros) {
        heroDao.update(heros);
    }

    public void addHeros(List<Hero> list) {
        heroDao.add(list);
    }

    private void _deleteHeros(long rid, List<Hero> list, GameEvent gameEvent) {
        heroDao.remove(list);
        eventBus.post(HeroDeleteEvent.of(rid, list, gameEvent));
    }

    /**
     * 删除英雄
     *
     * @param rid
     * @param heroList
     * @param gameEvent
     */
    public void deleteHeros(long rid, List<Hero> heroList, GameEvent gameEvent) {
        for (Hero hero : heroList) {
            if (heroLineUpService.isHeroLockInLineUp(rid, hero.getId()) || tweakCubeService.isInTrench(rid, hero.getId())) {
                throw new ErrorCodeException(ErrorCode.HERO_CANT_DELETE_LINEUP.getValue(),
                        "英雄" + hero.getId() + "还在阵上，不能删除");
            }
        }

        // 清除英雄身上的装备
        heroEquipService.clearHeroPlaingParts(rid, heroList, gameEvent);
        // 清除英雄身上的宝石
        heroJewelService.clearHeroPlaingParts(rid, heroList, gameEvent);
        // 清除英雄身上的符文
        runeInfoService.clearHeroRunes(rid, heroList);
        // 清除英雄身上的神装
        godEquipService.clearHeroPlaingParts(rid, heroList, gameEvent);
        // 清除英雄所在的布阵
        heroLineUpService.clearHeroLineUp(rid, heroList);
        // 清除英雄身上的灵器
        reikiEquipService.cleanHeroReikiEquip(rid, heroList, gameEvent);
        // 清除英雄身上的宠物
        petService.cleanHeroPet(rid, heroList, gameEvent);
        // 删除英雄实体
        _deleteHeros(rid, heroList, gameEvent);
    }

    /**
     * 获取某个队伍的英雄信息
     *
     * @return
     */
    public List<Hero> selectHeroList(long rid, LineUpType lineupType) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(rid, lineupType);
        List<Hero> list = new ArrayList<>();
        Map<Long, HeroPosition> map = heroLineUp.getFormationMap();
        Iterator<Map.Entry<Long, HeroPosition>> iterator = map.entrySet().iterator();
        while (iterator.hasNext()){
            Map.Entry<Long, HeroPosition> entry = iterator.next();
            Hero hero = getHero(rid, entry.getKey());
            if (Objects.nonNull(hero)) {
                list.add(hero);
            }
        }
        return list;
    }

    /**
     * 根据元素和星际来获取英雄列表
     *
     * @param rid
     * @param element
     * @param star
     * @return
     */
    public List<Hero> selectHeroListBy(long rid, int element, int star) {
        List<Hero> heroList = new ArrayList<>();
        for (Hero hero : getHeros(rid)) {
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
            if (cHeroType.getElem() == element && hero.getStar() == star) {
                heroList.add(hero);
            }
        }
        return heroList;
    }

    /**
     * 根据英雄类型来获取英雄列表
     * @param rid
     * @param type
     * @return
     */
    public List<Hero> selectHeroListByType(long rid, int type) {
        List<Hero> heroList = new ArrayList<>();
        for (Hero hero : getHeros(rid)) {
            if (hero.getType() == type) {
                heroList.add(hero);
            }
        }
        return heroList;
    }

    /**
     * 获取指定星际以上的影响列表
     *
     * @param rid
     * @param star
     * @return
     */
    public List<Hero> selectHeroListBy(long rid, int star) {
        List<Hero> heroList = new ArrayList<>();
        for (Hero hero : getHeros(rid)) {
            if (hero.getStar() >= star) {
                heroList.add(hero);
            }
        }
        return heroList;
    }

    /**
     * 援助是否可以解锁
     * @param rid
     * @return
     */
    public boolean assistanceUnlock(long rid) {
        List<Hero> heroes = selectHeroListBy(rid, RoleConst.ASSISTANCE_UNLOCK_HERO_STAR);
        return heroes.size() >= RoleConst.ASSISTANCE_UNLOCK_HERO_NUM;
    }

    /**
     * 计算英雄战力
     *
     * @param hero
     * @return
     */
    public void computeStrength(Hero hero, GameEvent gameEvent) {
        if (Objects.isNull(hero)) {
            log.error("computeStrength hero is null, gameEvent:{}", gameEvent.getRemark());
            StackTraceElement[] elements = Thread.currentThread().getStackTrace();
            for (StackTraceElement element : elements) {
                log.error(element.toString());
            }
            return;
        }

        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        HeroDo heroDo = command.getHeroDo();
        heroDo.initAttribute();
        long atk = heroDo.getAttribute(AttributeType.ATTACK);
        long hp = heroDo.getAttribute(AttributeType.MAX_HP);
        long def = heroDo.getAttribute(AttributeType.DEFENSE);
        long spd = heroDo.getAttribute(AttributeType.SPEED);
        int fighting = battleTemplate.computeStrength(heroDo);

        int oriFighting = hero.getFighting();
        //更新属性
        if (fighting != oriFighting || hero.getHp() == 0) {
            hero.setFighting(fighting);
            hero.setAtk(atk);
            hero.setDef(def);
            hero.setHp(hp);
            hero.setSpd(spd);
            if (hero.getName() == null) {
                CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                hero.setName(cHeroType.getNote());
            }
            this.updateHero(hero);
        }
        if (fighting != oriFighting) {
            eventBus.post(HeroFightChangeEvent.of(hero, gameEvent, oriFighting, hero.getFighting()));
        }
    }

    public int computeByHeroDo(HeroDo heroDo) {
        heroDo.initAttribute();
        return battleTemplate.computeStrength(heroDo);
    }

    public int computeStrength(HeroVo hero) {
        HeroInitCommand command = HeroInitCommand.createOf(Arrays.asList(hero));
        commandBus.invoke(command);
        int fighting = 0;
        for (HeroDo heroDo : command.getHeroDos()) {
            heroDo.initAttribute();
            fighting += battleTemplate.computeStrength(heroDo);
        }
        return fighting;
    }

    /**
     * 序列化英雄数据
     *
     * @param hero
     * @return
     */
    public ResHeroBriefData serializeBriefData(Hero hero, int pos) {
        ResHeroBriefData.Builder builder = ResHeroBriefData.newBuilder();
        builder.setHeroType(hero.getType());
        builder.setLevel(tweakCubeService.getTweakCubeLvAndStage(hero)[0]);
        builder.setStar(hero.getStar());
        builder.setHeroId(hero.getId());
        builder.setPos(pos);
        builder.setFashionId(hero.getFashionId());
        builder.setEvolve(PbUtil.builderEvolve(hero));
        return builder.build();
    }

    public ResHeroData serialize(HeroVo hero) {
        ResHeroData.Builder builder = ResHeroData.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroType(hero.getHero_type());
        builder.setLevel(hero.getLevel());
        builder.setStage(hero.getStage());
        builder.setStar(hero.getStar());
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getHero_type());
        builder.setElem(cHeroType.getElem());
        builder.setOccupation(cHeroType.getOccupation());
        builder.setFighting(this.computeStrength(hero));
        builder.setAlive(hero.getHp() <= 0 ? 1 : 0);
        builder.setFashionId(hero.getFashionId());
        builder.setHp(hero.getHp());
        builder.setEvolve(PbUtil.builderEvolve(hero));
        return builder.build();
    }

    public HeroBriefData toHeroBriefData(Hero hero, int pos) {
        HeroBriefData heroBriefData = new HeroBriefData();
        heroBriefData.setType(hero.getType());
        heroBriefData.setLevel(hero.getLevel());
        heroBriefData.setStar(hero.getStar());
        heroBriefData.setPos(pos);
        heroBriefData.setHeroId(hero.getId());
        heroBriefData.setFashionId(hero.getFashionId());
        heroBriefData.setEvolveType(hero.getEvolve().getType());
        heroBriefData.setEvolveLevel(hero.getEvolve().getLevel());
        return heroBriefData;
    }

    public ResHeroBriefData serializeBriefData(HeroBriefData heroBriefData) {
        ResHeroBriefData.Builder builder = ResHeroBriefData.newBuilder();
        builder.setHeroType(heroBriefData.getType());
        builder.setLevel(heroBriefData.getLevel());
        builder.setStar(heroBriefData.getStar());
        builder.setHeroId(heroBriefData.getHeroId());
        builder.setPos(heroBriefData.getPos());
        builder.setFashionId(heroBriefData.getFashionId());
        builder.setEvolve(PbUtil.builderEvolve(heroBriefData.getEvolveType(), heroBriefData.getEvolveLevel()));
        return builder.build();
    }

    /**
     * 用户进行展示的机器人数据
     *
     * @return
     */
    public ResHeroData robotForShow() {
        ResHeroData.Builder builder = ResHeroData.newBuilder();
        builder.setHeroId(1);
        builder.setHeroType(10101001);
        builder.setLevel(1);
        builder.setStage(0);
        builder.setStar(1);
        builder.setElem(1);
        builder.setOccupation(1);
        builder.setIsLock(0);
        return builder.build();
    }

    /**
     * 根据英雄ID集得到想要的英雄列表
     *
     * @param rid
     * @param heroIds
     * @return
     */
    public List<Hero> heroList(long rid, List<Long> heroIds) {
        List<Hero> list = getHeros(rid);
        List<Hero> heroList = new ArrayList<>();
        for (Hero hero : list) {
            if (heroIds.contains(hero.getId())) {
                heroList.add(hero);
            }
        }
        return heroList;
    }

    /**
     * 创建英雄
     *
     * @param rid
     * @param cHeroType
     * @param star
     * @param level
     * @param stage
     * @return
     */
    public Hero createHero(long rid, CHeroType cHeroType, int star, int level, int stage) {
        Hero hero = new Hero();
        hero.setRid(rid);
        hero.setType(cHeroType.getType());
        hero.setStage(stage);
        hero.setStar(star == 0 ? cHeroType.getStar() : star);
        hero.setLevel(level == 0 ? 1 : level);

        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        HeroDo heroDo = command.getHeroDo();
        heroDo.initAttribute();
        long atk = heroDo.getAttribute(AttributeType.ATTACK);
        long hp = heroDo.getAttribute(AttributeType.MAX_HP);
        long def = heroDo.getAttribute(AttributeType.DEFENSE);
        long spd = heroDo.getAttribute(AttributeType.SPEED);
        int fighting = battleTemplate.computeStrength(heroDo);

        hero.setAtk(atk);
        hero.setDef(def);
        hero.setHp(hp);
        hero.setSpd(spd);
        hero.setFighting(fighting);
        hero.setName(cHeroType.getNote());
        hero.setCreateTime(TimeDateUtil.getCurrentTimeInt());
        return hero;
    }

    public Hero createHero(long rid, CHeroType cHeroType) {
        return createHero(rid, cHeroType, 0, 0, 0);
    }

    /**
     * 重新计算某一批英雄的战力
     *
     * @param rid
     * @param heros
     * @param gameEvent
     */
    public void computeStrength(long rid, List<Hero> heros, GameEvent gameEvent) {
        List<Hero> updateList = new ArrayList<>();

        Map<Long, Integer> oriMap = new HashMap<>();
        Map<Long, Integer> currMap = new HashMap<>();
        for (Hero hero : heros) {
            QueryHeroCommand command = QueryHeroCommand.createOf(hero);
            commandBus.invoke(command);
            HeroDo heroDo = command.getHeroDo();
            heroDo.initAttribute();
            long atk = heroDo.getAttribute(AttributeType.ATTACK);
            long hp = heroDo.getAttribute(AttributeType.MAX_HP);
            long def = heroDo.getAttribute(AttributeType.DEFENSE);
            long spd = heroDo.getAttribute(AttributeType.SPEED);
            int newFighting = battleTemplate.computeStrength(heroDo);

            int oriFighting = hero.getFighting();
            //更新属性
            if (newFighting != oriFighting || hero.getHp() == 0) {
                hero.setFighting(newFighting);
                hero.setAtk(atk);
                hero.setDef(def);
                hero.setHp(hp);
                hero.setSpd(spd);

                updateList.add(hero);
                oriMap.put(hero.getId(), oriFighting);
                currMap.put(hero.getId(), newFighting);
            }
        }
        if (!updateList.isEmpty()) {
            this.updateHeros(updateList);
            eventBus.post(AllHeroFightChangeEvent.of(rid, updateList, gameEvent, oriMap, currMap));
        }
    }

    /**
     * 重算玩家的所有英雄战力
     *
     * @param rid
     * @param gameEvent
     */
    public void computeStrengthBiggerThenFiveStar(long rid, GameEvent gameEvent) {
        List<Hero> heroList = this.getHeros(rid);
        //一个玩家计算所有英雄战力的时候，不计算小于5星的
        computeStrength(rid, heroList.stream().filter(hero -> hero.getStar() >= 5).collect(Collectors.toList()), gameEvent);
    }

    /**
     * 计算英雄升星，升阶，升级消耗
     *
     * @param hero
     * @return
     */
    public List<ImmutableThing> heroCost(Hero hero, int targetLv, int targetGrade, int targetStar) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        rewardList.addAll(heroCostByLevel(hero, targetLv, targetGrade));
        rewardList.addAll(heroCostByStar(hero, targetStar));
        return rewardList;
    }

    /**
     * 计算英雄升星，升阶，升级消耗
     *
     * @param hero
     * @return
     */
    public List<ImmutableThing> heroCostByLevel(Hero hero, int targetLv, int targetGrade) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        // 升级资源
        int gold = 0;
        int soul = 0;
        int heroExp = 0;
        for (int lv = targetLv; lv < hero.getLevel(); lv++) {
            CHeroLevel cHeroLevel = heroLevelSysCache.getOrThrow(lv);
            gold = gold + cHeroLevel.getGold_need();
            heroExp = heroExp + cHeroLevel.getExp_need();
        }
        // 升阶资源
        for (int grade = targetGrade; grade < hero.getStage(); grade++) {
            CHeroUpGrade cHeroUpGrade = heroUpGradeSysCache.getOrThrow(grade);
            gold = gold + cHeroUpGrade.getGold();
            soul = soul + cHeroUpGrade.getSoul();
        }
        if (gold > 0) {
            rewardList.add(ImmutableThing.of(ItemType.IT_GOLD, gold));
        }
        if (heroExp > 0) {
            rewardList.add(ImmutableThing.of(ItemType.IT_HERO_EXP, heroExp));
        }
        if (soul > 0) {
            rewardList.add(ImmutableThing.of(ItemType.IT_HERO_UP_STONE, soul));
        }
        return rewardList;
    }

    /**
     * 计算英雄升星，升阶，升级消耗
     *
     * @param hero
     * @return
     */
    public List<ImmutableThing> heroCostByStar(Hero hero, int targetStar) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        // 升星资源
        for (int star = targetStar; star < hero.getStar(); star++) {
            CHeroStar cHeroStar = heroStarSysCache.getOrThrow(star);
            rewardList.addAll(cHeroStar.getUpstar_cost());
        }
        return rewardList;
    }

    public ResHeroData serialize(ResHeroMessage hero) {
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getHeroType());
        ResHeroData.Builder builder = ResHeroData.newBuilder();
        builder.setHeroId(hero.getHeroId());
        builder.setHeroType(hero.getHeroType());
        builder.setLevel(hero.getLevel());
        builder.setStage(hero.getStage());
        builder.setStar(hero.getStar());
        builder.setFighting(hero.getFighting());
        builder.setElem(cHeroType.getElem());
        builder.setOccupation(cHeroType.getOccupation());
        builder.setFashionId(hero.getFashionId());
        builder.setEvolve(PbUtil.builderEvolve(hero.getEvolveType(), hero.getEvolveLevel()));

        return builder.build();
    }

    public ResHeroBriefData serializeBrief(ResHeroMessage hero) {
        ResHeroBriefData.Builder builder = ResHeroBriefData.newBuilder();
        builder.setHeroId(hero.getHeroId());
        builder.setHeroType(hero.getHeroType());
        builder.setLevel(hero.getLevel());
        builder.setStar(hero.getStar());
        builder.setFashionId(hero.getFashionId());
        builder.setPos(hero.getPos());
        builder.setEvolve(PbUtil.builderEvolve(hero.getEvolveType(), hero.getEvolveLevel()));
        return builder.build();
    }

    /**
     * 序列化英雄数据
     *
     * @param hero
     * @return
     */
    public ResHeroData buildHero(Hero hero) {
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        ResHeroData.Builder builder = ResHeroData.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroType(hero.getType());
        builder.setLevel(hero.getLevel());
        builder.setStage(hero.getStage());
        builder.setStar(hero.getStar());
        builder.setElem(cHeroType.getElem());
        builder.setOccupation(cHeroType.getOccupation());
        builder.setIsLock(hero.getIsLock());
        builder.setFighting(hero.getFighting());
        for (Talent talent : hero.getTalents().values()) {
            builder.addTalents(PbUtil.serializeTalent(talent));
        }
        builder.setAtk(hero.getAtk());
        builder.setDef(hero.getDef());
        builder.setHp(hero.getHp());
        builder.setSpd(hero.getSpd());
        builder.setFashionId(hero.getFashionId());
        builder.addAllReikiPlaces(hero.getReikiPlaces());
        //英雄进化
        builder.setEvolve(PbUtil.builderEvolve(hero));

        HeroAwakenGMsg.PSHeroAwaken.Builder awakenBuilder = HeroAwakenGMsg.PSHeroAwaken.newBuilder();
        awakenBuilder.addAllBaseIndex(hero.getAwaken().getBaseIndex());
        awakenBuilder.addAllSpecialIndex(hero.getAwaken().getSpecialIndex());
        builder.setAwaken(awakenBuilder);
        //六芒星
        for (HeroHexagram heroHexagram : hero.getHexagram()) {
            HeroHexagramGMsg.PSHeroHexagram.Builder hexagramBuilder = HeroHexagramGMsg.PSHeroHexagram.newBuilder();
            hexagramBuilder.setType(heroHexagram.getType());
            hexagramBuilder.setLevel(heroHexagram.getLevel());
            builder.addHexagram(hexagramBuilder);
        }

        if (tweakCubeService.isInTrench(hero.getRid(), hero.getId())) {
            int[] tweakCubeLvAndStage = tweakCubeService.getTweakCubeLvAndStage(hero);
            builder.setTweakCubeLv(tweakCubeLvAndStage[0]);
            builder.setTweakCubeStage(tweakCubeLvAndStage[1]);
        }

        return builder.build();
    }

    public List<ResHeroData> buildHero(Collection<Hero> heros) {
        List<ResHeroData> result = new ArrayList<>();
        heros.forEach(hero -> result.add(buildHero(hero)));
        return result;
    }

}
