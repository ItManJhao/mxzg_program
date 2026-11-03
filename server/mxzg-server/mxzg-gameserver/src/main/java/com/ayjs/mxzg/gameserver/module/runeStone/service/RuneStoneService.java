package com.ayjs.mxzg.gameserver.module.runeStone.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.runeStone.RuneStoneExtraAptitudeSysCache;
import com.ayjs.mxzg.config.excel.cache.runeStone.RuneStoneQualitySysCache;
import com.ayjs.mxzg.config.excel.cache.runeStone.RuneStoneSysCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStone;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneExtraAptitude;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneQuality;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.RuneStoneThing;
import com.ayjs.mxzg.gameserver.module.runeStone.dao.RuneStoneDao;
import com.ayjs.mxzg.gameserver.module.runeStone.domain.RuneStone;
import com.ayjs.mxzg.gameserver.module.runeStone.event.RuneStoneAddEvent;
import com.ayjs.mxzg.gameserver.module.runeStone.event.RuneStoneDeleteEvent;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneAptitude;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneExtraGrid;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
public class RuneStoneService {

    private RuneStoneDao runeStoneDao;

    private RuneStoneSysCache runeStoneSysCache;

    private RuneStoneExtraAptitudeSysCache runeStoneExtraAptitudeSysCache;

    private RuneStoneQualitySysCache runeStoneQualitySysCache;

    private EventBus eventBus;


    public List<RuneStone> getRuneStones(long rid) {
        return runeStoneDao.list("rid", rid);
    }

    public RuneStone get(long id, long rid) {
        RuneStone runeStone = runeStoneDao.get(id);
        if (runeStone.getRid() == rid) {
            return runeStone;
        }
        return null;
    }

    public void update(List<RuneStone> entities) {
        runeStoneDao.update(entities);
    }

    /***
     * 增加符石
     * @param rid
     * @param idx
     */
    public RuneStone addRuneStone(long rid, int idx, GameEvent gameEvent) {
        RuneStone runeStone = createRuneStone(rid, idx);
        addRuneStone(Arrays.asList(runeStone), gameEvent);
        return runeStone;
    }

    public void addRuneStone(List<RuneStone> runeStones, GameEvent gameEvent) {
        runeStoneDao.add(runeStones);
        eventBus.post(RuneStoneAddEvent.of(runeStones, gameEvent));
    }

    @NotNull
    public RuneStone createRuneStone(long rid, int idx) {
        CRuneStone config = runeStoneSysCache.getOrThrow(idx);
        RuneStone runeStone = new RuneStone();
        runeStone.setRid(rid);
        runeStone.setIdx(idx);

        CRuneStoneQuality qualityConfig = runeStoneQualitySysCache.getOrThrow(config.getIdx());
        List<CRuneStoneExtraAptitude> selectList = Lists.newArrayList();
        for (int i = 0; i < config.getInit_extra_num(); i++) {
            RuneStoneExtraGrid grid = RuneStoneExtraGrid.valueOf(i);
            CRuneStoneExtraAptitude extraAttrConfig = randomAptitudeConfig(qualityConfig, selectList);
            if (extraAttrConfig != null) {
                grid.setExtraAptitude(RuneStoneAptitude.of(extraAttrConfig.getIdx(),
                        cn.hutool.core.util.RandomUtil.randomLong(extraAttrConfig.getMin_value(), extraAttrConfig.getMax_value())));
            } else {
                grid.setExtraAptitude(RuneStoneAptitude.defaultExtraAttr());
            }
            runeStone.getExtraGrid().put(grid.getPlace(), grid);
        }
        return runeStone;
    }

    /***
     * 资质随机
     * @param qualityConfig
     * @param selectList
     * @return
     */
    @Nullable
    private CRuneStoneExtraAptitude randomAptitudeConfig(CRuneStoneQuality qualityConfig, List<CRuneStoneExtraAptitude> selectList) {
        CRuneStoneExtraAptitude extraAttrConfig = null;
        for (int j = 0; j < 10; j++) {
            Integer quality = RandomUtil.getRandInteger(qualityConfig.getAttr_quality_rate());
            Integer job = RandomUtil.getRandInteger(qualityConfig.getJob_rate());
            Integer kind = RandomUtil.getRandInteger(qualityConfig.getKind_rate());
            extraAttrConfig = runeStoneExtraAptitudeSysCache.getByIndex(quality, job, kind);
            if (!selectList.contains(extraAttrConfig)) {
                selectList.add(extraAttrConfig);
            } else {
                extraAttrConfig = null;
            }
        }
        //10次概率随机之后，在随机品质之后随机选择一个
        if (extraAttrConfig == null) {
            Integer quality = RandomUtil.getRandInteger(qualityConfig.getAttr_quality_rate());
            List<CRuneStoneExtraAptitude> extraConfigs = runeStoneExtraAptitudeSysCache.getAll().stream().
                    filter(extraConfig_ -> extraConfig_.getQuality() == quality && !selectList.contains(extraConfig_))
                    .collect(Collectors.toList());
            if (!CollectionUtil.isEmpty(extraConfigs)) {
                Collections.shuffle(extraConfigs);
                extraAttrConfig = extraConfigs.get(0);
            }
        }
        return extraAttrConfig;
    }

    /***
     * 减少符石
     * @param rid
     * @param stones
     */
    public void deleteRuneStone(long rid, List<RuneStone> stones, GameEvent gameEvent) {
        if (CollectionUtil.isEmpty(stones)) {
            return;
        }
        runeStoneDao.remove(stones);
        eventBus.post(RuneStoneDeleteEvent.of(rid, stones, gameEvent));
    }


    public boolean isMatch(List<RuneStoneThing> thingList, Map<Integer, List<RuneStone>> runeStoneMap) {
        if (CollectionUtil.isEmpty(thingList) || CollectionUtil.isEmpty(runeStoneMap)) {
            return false;
        }
        if (thingList.size() != runeStoneMap.size()) {
            return false;
        }
        for (int i = 0; i < thingList.size(); i++) {
            RuneStoneThing runeStoneThing = thingList.get(i);
            List<RuneStone> runeStones = runeStoneMap.get(i);
            if (!isMatch(runeStoneThing, runeStones)) {
                return false;
            }
        }
        return true;

    }

    public boolean isMatch(RuneStoneThing thing, List<RuneStone> runeStones) {
        if (thing.getNum() != runeStones.size()) {
            return false;
        }
        if (thing.getType() != 0 && !runeStones.stream().allMatch(runeStone -> runeStone.getIdx() == thing.getType())) {
            return false;
        }

        return runeStones.stream().allMatch(runeStone -> {
            CRuneStone config = runeStoneSysCache.getById(runeStone.getIdx());
            return config.getQuality() == thing.getQuality() && config.getIntensify() >= thing.getIntensify();
        });

    }

    public List<RuneStone> add(long rid, ImmutableList<RuneStoneThing> stoneThings, GameEvent gameEvent) {
        List<RuneStone> addAll = Lists.newArrayList();
        stoneThings.forEach(stoneThing -> {
            for (int i = 0; i < stoneThing.getNum(); i++) {
                CRuneStone runeStoneConfig = runeStoneSysCache.getOrThrow(stoneThing.getType());
                addAll.add(createRuneStone(rid, runeStoneConfig.getIdx()));
            }
        });
        addRuneStone(addAll, gameEvent);
        return addAll;
    }
}
