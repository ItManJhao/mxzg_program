package com.ayjs.mxzg.gameserver.module.tweakCube.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.tweakCube.TweakCubeConst;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.tweakCube.converter.TweakCubePB;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.TweakCube;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Observer
public class TweakCubeObserver {

    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private TweakCubeConst tweakCubeConst;
    @Autowired
    private ContextManager contextManager;


    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroGetEvent event) {
        tryResetLevel(event.getRid(), event.getHeros());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroUpLevelEvent event) {
        tryResetLevel(event.getHero().getRid(), Arrays.asList(event.getHero()));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroFightChangeEvent event) {
        tryResetLevel(event.getHero().getRid(), Arrays.asList(event.getHero()));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroStarUpEvent event) {
        long rid = event.getHero().getRid();
        long heroId = event.getHero().getId();
        if (tweakCubeService.isInTrench(rid, heroId)) {
            Map<Long, int[]> updateTweakCubeMap = Maps.newHashMap();
            updateTweakCubeMap.put(heroId, tweakCubeService.getTweakCubeLvAndStage(event.getHero()));
            contextManager.write(rid, CmdCode._75506, TweakCubePB.builderUpdateTweakCubeLv(updateTweakCubeMap));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroDeleteEvent event) {
        deleteTryResetLevel(event.getRid(), event.getHeros());
    }

    /***
     * 添加英雄和英雄等级改变的时候，重置共鸣魔方
     * @param rid
     * @param sourceHeroes
     */
    private void tryResetLevel(long rid, List<Hero> sourceHeroes) {
        TweakCube tweakCube = tweakCubeService.get(rid);
        List<Long> heroIdRanks = tweakCube.getHeroRanks();
        if (heroIdRanks.size() >= tweakCubeConst.getTweakCubeRankHeroNum()) {
            //当已经上阵6个英雄之后，过滤掉等级,战力不满足不满足的情况
            Hero basicHero = heroService.getHero(rid, heroIdRanks.get(heroIdRanks.size() - 1));

            sourceHeroes = sourceHeroes.stream().filter(hero ->
                    tweakCubeService.getComparator().compare(basicHero, hero) > 0 || hero.getId() == basicHero.getId())
                    .collect(Collectors.toList());
            if (sourceHeroes.size() <= 0) {
                return;
            }
        }

        List<Hero> heroRanks = Lists.newArrayList();
        heroIdRanks.forEach(heroId -> heroRanks.add(heroService.getHero(rid, heroId)));
        //过滤掉包含的英雄
        sourceHeroes = sourceHeroes.stream().filter(hero -> !heroIdRanks.contains(hero.getId())).collect(Collectors.toList());
        heroRanks.addAll(sourceHeroes);
        resetRankHero(tweakCube, heroRanks, true);
    }

    /****
     * 重置供奉英雄
     * @param tweakCube
     * @param heroRanks
     * @param updateTrench
     */
    private void resetRankHero(TweakCube tweakCube, List<Hero> heroRanks, boolean updateTrench) {
        heroRanks.sort(tweakCubeService.getComparator());
        List<Hero> heroes = heroRanks.subList(0, Math.min(tweakCubeConst.getTweakCubeRankHeroNum(), heroRanks.size()));
        List<Long> newHeroIdRanks = heroes.stream().mapToLong(Hero::getId).collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        tweakCube.setHeroRanks(newHeroIdRanks);

        Map<Long, int[]> updateTweakCubeMap = Maps.newHashMap();
        if (updateTrench) {
            Map<Long, Integer> map = Maps.newHashMap();
            newHeroIdRanks.forEach(heroId -> {
                Integer trenchIndex = tweakCube.getTrenchHeroes().get(heroId);
                if (Objects.nonNull(trenchIndex)) {
                    map.put(heroId, trenchIndex);
                }
            });

            map.forEach((heroId, trenchIndex) -> {
                tweakCubeService.removeHeroFromTrench(tweakCube.getRid(), trenchIndex, false);
                updateTweakCubeMap.put(heroId, new int[]{0, 0});
            });
        }

        tweakCubeService.update(tweakCube);

        contextManager.write(tweakCube.getRid(), CmdCode._75501, TweakCubePB.builder(tweakCube));

        tweakCube.getTrenchHeroes().keySet().forEach(heroId -> {
            Hero hero = heroService.getHero(tweakCube.getRid(), heroId);
            updateTweakCubeMap.put(heroId, tweakCubeService.getTweakCubeLvAndStage(hero));
        });

        if (updateTweakCubeMap.size() > 0) {
            contextManager.write(tweakCube.getRid(), CmdCode._75506, TweakCubePB.builderUpdateTweakCubeLv(updateTweakCubeMap));
        }

    }

    /***
     * 删除英雄时，重置共鸣魔方
     * @param rid
     * @param deleteHeroes
     */
    private void deleteTryResetLevel(long rid, List<Hero> deleteHeroes) {
        TweakCube tweakCube = tweakCubeService.get(rid);
        List<Long> heroIdRanks = tweakCube.getHeroRanks();

        long count = deleteHeroes.stream().filter(hero -> heroIdRanks.contains(hero.getId())).count();
        if (count <= 0) {
            return;
        }
        List<Hero> heroRanks = Lists.newArrayList();
        heroRanks.addAll(heroService.getHeros(rid));
        resetRankHero(tweakCube, heroRanks, true);
    }

}
