package com.ayjs.mxzg.gameserver.module.tweakCube.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.tweakCube.TweakCubeConst;
import com.ayjs.mxzg.config.excel.cache.tweakCube.TweakCubeTrenchOpenSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.tweakCube.dao.TweakCubeDao;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.Trench;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.TweakCube;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Service
@Slf4j
public class TweakCubeService {
    @Autowired
    private TweakCubeDao tweakCubeDao;
    @Autowired
    private HeroService heroService;
    @Autowired
    private TweakCubeConst tweakCubeConst;
    @Autowired
    private TweakCubeTrenchOpenSysCache tweakCubeTrenchOpenSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private SystemSysCache systemSysCache;

    @Getter
    private Comparator<Hero> comparator = new Comparator<Hero>() {
        @Override
        public int compare(Hero o1, Hero o2) {
            int compare = Integer.compare(o2.getLevel(), o1.getLevel());
            if (compare == 0) {
                compare = Long.compare(o2.getFighting(), o1.getFighting());
            }
            return compare;
        }
    };


    public TweakCube get(long rid) {
        TweakCube tweakCube = tweakCubeDao.get(rid);
        if (tweakCube == null) {
            tweakCube = doCreate(rid);
            tweakCubeDao.add(tweakCube);
        }
        return tweakCube;
    }

    @NotNull
    private TweakCube doCreate(long rid) {
        TweakCube tweakCube;
        tweakCube = new TweakCube();
        tweakCube.setRid(rid);

        long count = tweakCubeTrenchOpenSysCache.getAll().stream().filter(config -> config.getCost().size() <= 0).count();
        for (int i = 0; i < count; i++) {
            tweakCube.getTrenches().add(new Trench());
        }
        //创建的时候，将当前所有英雄添加到供奉列表中
        List<Hero> heroRanks = heroService.getHeros(rid);
        heroRanks.sort(comparator);
        List<Hero> heroes = heroRanks.subList(0, Math.min(tweakCubeConst.getTweakCubeRankHeroNum(), heroRanks.size()));
        if (heroes.size() > 0) {
            List<Long> newHeroIdRanks = heroes.stream().mapToLong(Hero::getId).collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
            tweakCube.setHeroRanks(newHeroIdRanks);
        }
        return tweakCube;
    }

    public void update(TweakCube tweakCube) {
        tweakCubeDao.update(tweakCube);
    }

    /***
     * 获取魔方供奉列表最低的英雄
     * @param rid
     * @return
     */
    public long getTweakCubeRankLastHeroId(long rid) {
        List<Long> heroRanks = get(rid).getHeroRanks();
        if (heroRanks.size() == 0) {
            return 0;
        }
        return heroRanks.get(heroRanks.size() - 1);
    }

    /***
     * 英雄是否上阵到槽位中
     * @param rid
     * @param heroId
     * @return
     */
    public boolean isInTrench(long rid, long heroId) {
        return get(rid).getTrenchHeroes().containsKey(heroId);
    }

    /***
     * 获取英雄的等级,未添加到槽位的英雄，返回原始等级
     *
     * @param hero
     * @return
     */
    public int[] getTweakCubeLvAndStage(Hero hero) {
        if (!isInTrench(hero.getRid(), hero.getId())) {
            return new int[]{hero.getLevel(), hero.getStage()};
        }
        long tweakCubeRankLastHeroId = getTweakCubeRankLastHeroId(hero.getRid());
        Hero tweakCubeLastHero = heroService.getHero(hero.getRid(), tweakCubeRankLastHeroId);
        if (Objects.isNull(tweakCubeLastHero)) {
            log.error("魔方供奉列表上的英雄{}不存在", tweakCubeRankLastHeroId);
        } else {
            CHeroStar cHeroStar = heroStarSysCache.getOrThrow(hero.getStar());
            int stage = Integer.min(tweakCubeLastHero.getStage(), hero.getStar());
            int levelLimit = cHeroStar.getLevel_limit();
            return new int[]{Math.min(levelLimit, tweakCubeLastHero.getLevel()), stage};
        }
        return new int[]{hero.getLevel(), hero.getStage()};
    }

    public long removeHeroFromTrench(long rid, int trenchIndex, boolean inCd) {
        long removeId = 0;
        TweakCube tweakCube = get(rid);
        removeId = tweakCube.removeFromTrench(trenchIndex, inCd);

        Hero hero = heroService.getHero(rid, removeId);

        if (systemSysCache.getElf1UnlockLevel() > getTweakCubeLvAndStage(hero)[0]) {
            runeInfoService.clearPlaceHeroRunes(rid, Arrays.asList(hero), 1);
        }

        heroService.computeStrength(hero, GameEvent.TWEAK_CUBE_TRENCH);

        return removeId;
    }

}
