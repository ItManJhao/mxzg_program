package com.ayjs.mxzg.gameserver.module.runeStone.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.runeStone.RuneStoneExtraAptitudeSysCache;
import com.ayjs.mxzg.config.excel.cache.runeStone.RuneStoneSysCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStone;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneExtraAptitude;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.RuneStoneThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.runeStone.builder.RuneStoneBuilder;
import com.ayjs.mxzg.gameserver.module.runeStone.domain.RuneStone;
import com.ayjs.mxzg.gameserver.module.runeStone.service.RuneStoneService;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneAptitude;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneExtraGrid;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.RuneStoneGMsg;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/31
 **/
public class RuneStoneHandler extends ProtocolHandler {

    private RuneStoneService runeStoneService;

    private HeroService heroService;

    private RuneStoneSysCache runeStoneSysCache;

    private RuneStoneExtraAptitudeSysCache runeStoneExtraAptitudeSysCache;

    private ThingService thingService;

    public void getList(PlayerContext playerContext, RuneStoneGMsg.GReqRuneStoneList req) {
        List<RuneStone> runeStones = runeStoneService.getRuneStones(playerContext.getId());
        playerContext.write(110, RuneStoneBuilder.builder(runeStones));
    }

    public void equip(PlayerContext playerContext, RuneStoneGMsg.GReqRuneStoneEquip req) {
        req.getEquipInfoList().forEach(equipInfo -> {
            RuneStone runeStone = runeStoneService.get(playerContext.getId(), equipInfo.getId());
            Asserts.isTrue(Objects.nonNull(runeStone), 3000, String.format("符石{%s}不存在！", equipInfo.getId()));
            if (req.getEquip()) {
                Hero hero = heroService.getHero(playerContext.getId(), equipInfo.getHeroId());
                Asserts.isTrue(Objects.nonNull(hero), 3000, String.format("英雄不存在{%s}不存在！", equipInfo.getHeroId()));
//                Asserts.isTrue(hero.runeStonePlaceOpen(equipInfo.getPlace()), 3000,
//                        String.format("位置{%s}未开启,开启列表{%s}！", equipInfo.getPlace(), GsonUtils.toJson(hero.getRuneStoneEquip().keySet())));
                Asserts.isTrue(runeStone.getHeroId() <= 0, 3000,
                        String.format("符石{%s}已穿戴{%s}！", equipInfo.getId(), runeStone.getHeroId()));
            } else {
                Asserts.isTrue(runeStone.getHeroId() > 0, 3000,
                        String.format("符石{%s}未穿戴{%s}！", equipInfo.getId(), runeStone.getHeroId()));
            }
        });

        List<RuneStone> updates = Lists.newArrayList();
        req.getEquipInfoList().forEach(equipInfo -> {
            RuneStone runeStone = runeStoneService.get(playerContext.getId(), equipInfo.getId());
            if (req.getEquip()) {
                Hero hero = heroService.getHero(playerContext.getId(), equipInfo.getHeroId());
//                Long oldEquip = hero.equipRuneStone(equipInfo.getPlace(), equipInfo.getId());
//                heroService.updateHero(hero);
//                if (Objects.nonNull(oldEquip) && oldEquip > 0) {
//                    RuneStone oldRuneStone = runeStoneService.get(playerContext.getId(), oldEquip);
//                    if (Objects.nonNull(oldRuneStone) && oldRuneStone.getHeroId() == equipInfo.getHeroId() &&
//                            oldRuneStone.getPlace() == equipInfo.getPlace()) {
//                        oldRuneStone.equip(0, 0);
//                        updates.add(oldRuneStone);
//                    }
//                }
//                runeStone.equip(equipInfo.getPlace(), equipInfo.getHeroId());
            } else {
                runeStone.equip(0, 0);
            }
            updates.add(runeStone);
        });

        runeStoneService.update(updates);
        playerContext.write(110, RuneStoneBuilder.builder(updates));
    }

    public void combine(PlayerContext playerContext, RuneStoneGMsg.GReqCombine req) {
        CRuneStone config = runeStoneSysCache.getOrThrow(req.getTargetIdx());

        Asserts.isTrue(config.getCombine_cost_item().size() > 0 || config.getCombine_cost_stone().size() > 0, 3000,
                String.format("符石{%s}不能合成", req.getTargetIdx()));

        if (config.getCombine_cost_item().size() > 0) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), config.getCombine_cost_item()), 3000,
                    String.format("符石消耗不满足{%s}", GsonUtils.toJson(config.getCombine_cost_item())));
        }

        Map<Integer, List<RuneStone>> consumeMap = new HashMap<>();
        req.getConsumeList().forEach(consume -> {
            consume.getRuneStoneIdList().forEach(runeStoneId -> {
                RuneStone runeStone = runeStoneService.get(runeStoneId, playerContext.getId());
                Asserts.isTrue(Objects.nonNull(runeStone), 3000, String.format("符石{%s}不存在！", runeStoneId));
                consumeMap.computeIfAbsent(consume.getCostIdx(), key -> Lists.newArrayList()).add(runeStone);
            });
        });

        Asserts.isTrue(runeStoneService.isMatch(config.getCombine_cost_stone(), consumeMap), 3000,
                String.format("符石消耗不满足{%s}", GsonUtils.toJson(req.getConsumeList())));

        thingService.cost(playerContext.getId(), config.getCombine_cost_item(), GameEvent.GODDESS);

        runeStoneService.deleteRuneStone(playerContext.getId(),
                consumeMap.values().stream().flatMap(Collection::stream).collect(Collectors.toList()), GameEvent.GODDESS);
        RuneStone runeStone = runeStoneService.addRuneStone(playerContext.getId(), config.getIdx(), GameEvent.GODDESS);

        RuneStoneGMsg.GResCombine.Builder builder = RuneStoneGMsg.GResCombine.newBuilder();
        builder.setRuneStone(RuneStoneBuilder.builder(runeStone));
        playerContext.write(110, builder.build());
    }

    public void intensify(PlayerContext playerContext, RuneStoneGMsg.GReqIntensify req) {
        RuneStone runeStone = runeStoneService.get(playerContext.getId(), req.getId());

        Asserts.isTrue(Objects.nonNull(runeStone), 3000,
                String.format("符石{%s}不存在", req.getId()));

        CRuneStone config = runeStoneSysCache.getOrThrow(runeStone.getIdx());

        CRuneStone nextLevelConfig = runeStoneSysCache.getByIntensify(config.getKind(), config.getQuality(), config.getIntensify() + 1);

        Asserts.isTrue(Objects.nonNull(nextLevelConfig), 3000,
                String.format("符石{%s}消耗不存在下一等级{%s}", runeStone.getIdx(), config.getIntensify() + 1));

        Map<Integer, List<RuneStone>> consumeMap = new HashMap<>();
        req.getConsumeList().forEach(consume -> {
            consume.getRuneStoneIdList().forEach(runeStoneId -> {
                RuneStone runeStone_ = runeStoneService.get(runeStoneId, playerContext.getId());
                Asserts.isTrue(Objects.nonNull(runeStone_), 3000, String.format("符石{%s}不存在！", runeStoneId));
                consumeMap.computeIfAbsent(consume.getCostIdx(), key -> Lists.newArrayList()).add(runeStone_);
            });
        });

        Asserts.isTrue(runeStoneService.isMatch(config.getCombine_cost_stone(), consumeMap), 3000,
                String.format("符石消耗不满足{%s}", GsonUtils.toJson(req.getConsumeList())));

        thingService.cost(playerContext.getId(), config.getCombine_cost_item(), GameEvent.GODDESS);

        runeStoneService.deleteRuneStone(playerContext.getId(),
                consumeMap.values().stream().flatMap(Collection::stream).collect(Collectors.toList()), GameEvent.GODDESS);

        runeStone.setIdx(nextLevelConfig.getIdx());
        runeStoneService.update(Arrays.asList(runeStone));

        RuneStoneGMsg.GResIntensify.Builder builder = RuneStoneGMsg.GResIntensify.newBuilder();
        builder.setRuneStone(RuneStoneBuilder.builder(runeStone));
        playerContext.write(110, builder.build());
    }

    public void aptitudeChange(PlayerContext playerContext, RuneStoneGMsg.GReqAptitudeExchange req) {
        RuneStone source = runeStoneService.get(playerContext.getId(), req.getSourceId());
        RuneStone target = runeStoneService.get(playerContext.getId(), req.getTargetId());

        Asserts.isTrue(Objects.nonNull(source), 3000, String.format("源符石{%s}不存在！", req.getSourceId()));
        Asserts.isTrue(Objects.nonNull(target), 3000, String.format("目标符石{%s}不存在！", req.getTargetId()));

        RuneStoneExtraGrid sourceGrid = source.getGridByPlace(req.getSourcePlace());
        RuneStoneExtraGrid targetGrid = source.getGridByPlace(req.getTargetPlace());

        Asserts.isTrue(sourceGrid != null && sourceGrid.getExtraAptitude().getIdx() > 0, 3000,
                String.format("源符石{%s}格子{%s}未开放！", req.getSourceId(), req.getSourcePlace()));
        Asserts.isTrue(targetGrid != null, 3000,
                String.format("目标符石{%s}格子{%s}未开放！", req.getTargetId(), req.getTargetPlace()));

        //当前符石过滤掉被替换资质的资质列表
        ArrayList<Integer> allConfigId = target.getExtraGrid().values().stream().filter(grid -> grid.getPlace() != req.getTargetPlace() &&
                grid.getExtraAptitude().getIdx() > 0).mapToInt(grid -> grid.getExtraAptitude().getIdx())
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        //判定资质是否可以交换
        CRuneStoneExtraAptitude sourceAptitudeConfig = runeStoneExtraAptitudeSysCache.getOrThrow(sourceGrid.getExtraAptitude().getIdx());

        allConfigId.forEach(configId -> {
            CRuneStoneExtraAptitude config_ = runeStoneExtraAptitudeSysCache.getOrThrow(configId);
            Asserts.isTrue(isSameKindAndJob(config_, sourceAptitudeConfig),
                    3000, String.format("种类冲突{%s}-{%s}", configId, sourceGrid.getExtraAptitude().getIdx()));
        });

        if (targetGrid.getExtraAptitude().getIdx() > 0) {
            CRuneStoneExtraAptitude targetAptitudeConfig = runeStoneExtraAptitudeSysCache.getOrThrow(targetGrid.getExtraAptitude().getIdx());
            //同种类同职业的资质需要判定品质
            if (isSameKindAndJob(targetAptitudeConfig, sourceAptitudeConfig)) {
                Asserts.isTrue(sourceAptitudeConfig.getQuality() >= targetAptitudeConfig.getQuality(), 3000,
                        String.format("资质品质{%s}低于目标品质{%s}", sourceGrid.getExtraAptitude().getIdx(), targetGrid.getExtraAptitude().getIdx()));
            }
        }

        RuneStoneAptitude temp = targetGrid.getExtraAptitude();
        targetGrid.setExtraAptitude(sourceGrid.getExtraAptitude());
        sourceGrid.setExtraAptitude(temp);
        runeStoneService.update(Arrays.asList(source, target));

        RuneStoneGMsg.GResAptitudeExchange.Builder builder = RuneStoneGMsg.GResAptitudeExchange.newBuilder();
        builder.setSource(RuneStoneBuilder.builder(source));
        builder.setTarget(RuneStoneBuilder.builder(target));
        playerContext.write(110, builder.build());
    }

    private boolean isSameKindAndJob(CRuneStoneExtraAptitude config1, CRuneStoneExtraAptitude config2) {
        return config1.getKind() == config2.getKind() && config1.getJob() == config2.getJob();
    }

    public void resolve(PlayerContext playerContext, RuneStoneGMsg.GReqResolve req) {
        RuneStone runeStone = runeStoneService.get(playerContext.getId(), req.getId());
        Asserts.isTrue(Objects.nonNull(runeStone), 3000, String.format("符石{%s}不存在！", req.getId()));
        CRuneStone config = runeStoneSysCache.getOrThrow(runeStone.getIdx());

        ImmutableList<RuneStoneThing> stoneReward = config.getBreak_stone();
        ImmutableList<ImmutableThing> itemReward = config.getBreak_item();

        runeStoneService.deleteRuneStone(playerContext.getId(), Arrays.asList(runeStone), GameEvent.GODDESS);
        if (itemReward.size() > 0) {
            thingService.add(playerContext.getId(), itemReward, GameEvent.GODDESS);
        }
        List<RuneStone> addList = null;
        if (stoneReward.size() > 0) {
            addList = runeStoneService.add(playerContext.getId(), stoneReward, GameEvent.GODDESS);
        }

        RuneStoneGMsg.GResResolve.Builder builder = RuneStoneGMsg.GResResolve.newBuilder();
        if (itemReward.size() > 0) {
            builder.addAllItemReward(PbUtil.buildReward(itemReward));
        }
        if (!CollectionUtil.isEmpty(addList)) {
            addList.forEach(runeStone1 -> builder.addStoneReward(RuneStoneBuilder.builder(runeStone1)));
        }
        playerContext.write(110, builder.build());
    }


}
