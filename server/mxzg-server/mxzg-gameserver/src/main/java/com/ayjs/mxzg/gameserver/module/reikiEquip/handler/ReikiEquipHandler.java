package com.ayjs.mxzg.gameserver.module.reikiEquip.handler;

import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipActiveSysCache;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquip;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquipActive;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.UpStarRequire;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipActiveEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipUpStarEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.gameserver.module.reikiEquip.struct.ReplaceTypeEnum;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ReikiEquipGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ReikiEquipHandler extends ProtocolHandler {

    @Autowired
    private ReikiEquipService reikiEquipService;
    @Autowired
    private ReikiEquipActiveSysCache reikiEquipActiveSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ReikiEquipSysCache reikiEquipSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroLineUpService heroLineUpService;

    /**
     * 灵器数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._70001)
    public void reikiEquipInfo(PlayerContext playerContext, ReikiEquipGMsg.GReqReikiEquipData msg) {
        List<ReikiEquip> reikiEquipList = reikiEquipService.selectAll(playerContext.getId());

        ReikiEquipGMsg.GResReikiEquipData.Builder builder = ReikiEquipGMsg.GResReikiEquipData.newBuilder();
        for (ReikiEquip reikiEquip : reikiEquipList) {
            builder.addList(PbUtil.builderReikiEquip(reikiEquip));
        }

        playerContext.write(CmdCode._70001, builder.build());
    }

    /**
     * 灵器槽位激活
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._70002)
    public void activeReikiEquipPlace(PlayerContext playerContext, ReikiEquipGMsg.GReqActiveReikiEquipPlace msg) {
        CReikiEquipActive cReikiEquipActive = reikiEquipActiveSysCache.getOrThrow(msg.getPlace());

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", msg.getHeroId()));

        Asserts.isTrue(!hero.getReikiPlaces().contains(msg.getPlace()), ErrorCode.REIKI_EQUIP_NOT_PLACE.getValue(),
                String.format("英雄:{%s}灵器槽位{%s}已激活", msg.getHeroId(), msg.getPlace()));
        Asserts.isTrue(hero.getStar() >= cReikiEquipActive.getStart(), ErrorCode.REIKI_EQUIP_PLACE_NOT_ACTIVE_STAR.getValue(),
                String.format("英雄:{%s}星级{%s}未达开启条件", msg.getHeroId(), hero.getStar()));
        Asserts.isTrue(hero.getLevel() >= cReikiEquipActive.getLevel(), ErrorCode.REIKI_EQUIP_PLACE_NOT_ACTIVE_LEVEL.getValue(),
                String.format("英雄:{%s}等级{%s}未达开启条件", msg.getHeroId(), hero.getLevel()));

        thingService.cost(playerContext.getId(), cReikiEquipActive.getCost_item(), GameEvent.REIKI_EQUIP_ACTIVE);

        hero.getReikiPlaces().add(cReikiEquipActive.getPlace());
        heroService.updateHero(hero);

        //此次添加不走加背包道具方式
        ReikiEquip reikiEquip = reikiEquipService.add(cReikiEquipActive.getReiki_equip_id(), playerContext.getId());
        reikiEquipService.changeStatus(reikiEquip.getId(), hero, 0);

        ReikiEquipGMsg.GResActiveReikiEquipPlace.Builder builder = ReikiEquipGMsg.GResActiveReikiEquipPlace.newBuilder();
        builder.setHeroId(msg.getHeroId());
        builder.setPlace(msg.getPlace());
        builder.setData(PbUtil.builderReikiEquip(reikiEquip));
        playerContext.write(CmdCode._70002, builder.build());

        eventBus.post(ReikiEquipActiveEvent.of(playerContext.getId(), reikiEquip.getSysId(), GameEvent.REIKI_EQUIP_ACTIVE));
    }

    /**
     * 灵器穿戴（替换）
     *
     * @param playerContext
     * @param msg
     */

    @CMD(id = CmdCode._70003)
    public void wearReikiEquip(PlayerContext playerContext, ReikiEquipGMsg.GReqWearReikiEquip msg) {

        ReikiEquip reikiEquip = reikiEquipService.select(playerContext.getId(), msg.getReikiEquipId());
        Asserts.isTrue(reikiEquip.getHeroId() == 0, ErrorCode.REIKI_EQUIP_USED.getValue(), "该灵器已装备在英雄身上");

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", msg.getHeroId()));

        CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
        Asserts.isTrue(hero.getReikiPlaces().contains(cReikiEquip.getPlace()), ErrorCode.REIKI_EQUIP_PLACE_NOT_ACTIVE.getValue(),
                String.format("英雄{%s}灵器槽位{%s}未激活", msg.getHeroId(), cReikiEquip.getPlace()));

        List<ReikiEquip> reikiEquipList = reikiEquipService.heroReikiEquip(playerContext.getId(), msg.getHeroId());
        long oldReikiId = 0L;//原先装备的灵器id
        CReikiEquip cReikiEquip1 = null;
        for (ReikiEquip reikiEquip1 : reikiEquipList) {
            cReikiEquip1 = reikiEquipSysCache.getOrThrow(reikiEquip1.getSysId());
            if (cReikiEquip.getPlace() == cReikiEquip1.getPlace()) {
                //若本槽位已经穿戴灵器，便卸下
                reikiEquipService.changeStatus(reikiEquip1.getId(), hero, 1);
                oldReikiId = reikiEquip1.getId();
            }
        }

        //穿上灵器
        reikiEquipService.changeStatus(reikiEquip.getId(), hero, 0);

        ReikiEquipGMsg.GResWearReikiEquip.Builder builder = ReikiEquipGMsg.GResWearReikiEquip.newBuilder();
        builder.setHeroId(msg.getHeroId());
        builder.setReikiEquipId(msg.getReikiEquipId());
        builder.setOldReikiId(oldReikiId);
        playerContext.write(CmdCode._70003, builder.build());

    }

    /**
     * 灵器卸下
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._70004)
    public void disboardReikiEquip(PlayerContext playerContext, ReikiEquipGMsg.GReqDisboardReikiEquip msg) {

        ReikiEquip reikiEquip = reikiEquipService.select(playerContext.getId(), msg.getReikiEquipId());

        Asserts.isTrue(reikiEquip.getHeroId() > 0, ErrorCode.REIKI_EQUIP_NOT_WEAR.getValue(), "灵器未穿戴在英雄身上");

        Hero hero = heroService.getHero(playerContext.getId(), reikiEquip.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", hero.getId()));
        //卸下
        reikiEquipService.changeStatus(reikiEquip.getId(), hero, 1);

        ReikiEquipGMsg.GResDisboardReikiEquip.Builder builder = ReikiEquipGMsg.GResDisboardReikiEquip.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setReikiEquipId(reikiEquip.getId());
        playerContext.write(CmdCode._70004, builder.build());

    }

    /**
     * 完美灵器转换
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._70005)
    public void reikiEquipTransform(PlayerContext playerContext, ReikiEquipGMsg.GReqTransformReikiEquip msg) {

        ReikiEquip reikiEquip = reikiEquipService.select(playerContext.getId(), msg.getReikiEquipId());

        CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
        Asserts.isTrue(cReikiEquip.getTransform_target() > 0, ErrorCode.REIKI_EQUIP_TRANSFORM_TARGET_NOT_EXIST.getValue(),
                "该灵器不能转换为其他目标");

        thingService.cost(playerContext.getId(), cReikiEquip.getTransform_cost(), GameEvent.REIKI_EQUIP_TRANSFORM);

        reikiEquip.setSysId(cReikiEquip.getTransform_target());
        reikiEquipService.update(reikiEquip);

        ReikiEquipGMsg.GResTransformReikiEquip.Builder builder = ReikiEquipGMsg.GResTransformReikiEquip.newBuilder();
        builder.setData(PbUtil.builderReikiEquip(reikiEquip));
        playerContext.write(CmdCode._70005, builder.build());
    }

    /**
     * 灵器合成
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._70006)
    public void combineReikiEquip(PlayerContext playerContext, ReikiEquipGMsg.GReqCombineReikiEquip msg) {
        //本体灵器
        ReikiEquip reikiEquip = reikiEquipService.select(playerContext.getId(), msg.getReikiId());

        CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
        Asserts.isTrue(cReikiEquip.getUp_star_target().contains(msg.getSysId()), ErrorCode.REIKI_EQUIP_TARGET_NOT_EXIT.getValue(),
                String.format("本体灵器{%s}不能升级为目标灵器{%s}", reikiEquip.getSysId(), msg.getSysId()));
        //目标灵器
        cReikiEquip = reikiEquipSysCache.getOrThrow(msg.getSysId());
        //消耗道具列表
        List<ImmutableThing> costItemList = new ArrayList<>();
        //消耗英雄
        List<UpStarRequire> baseList = JSONArray.parseArray(cReikiEquip.getCost_star_hero(), UpStarRequire.class);
        if (!baseList.isEmpty()) {//合成需要消耗英雄或傀儡羊
            //检查素材英雄与实际需求数量是否相同
            int needHero = baseList.stream().mapToInt(UpStarRequire::getNum).sum();
            Asserts.isTrue(needHero == msg.getHeroesCount() + msg.getReplaceItemCount(),
                    ErrorCode.REIKI_EQUIP_COMBINE_NEED_HERO.getValue(), "需要的英雄素材量与实际的不符");
            //素材英雄
            List<Hero> heroList = new ArrayList<>();
            for (long heroId : msg.getHeroesList()) {
                Hero hero = heroService.getUnlockInLineUpHero(playerContext.getId(), heroId);
                Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在,或在阵列上无法用作素材", heroId));
                Asserts.isTrue(!heroList.contains(hero), ErrorCode.REIKI_EQUIP_COMBINE_HERO_IDENTICAL.getValue(), "素材英雄中有相同的英雄");
                heroList.add(hero);
            }
            //验证素材英雄后剩下不满足要求的星级
            List<UpStarRequire> needRequires = isHeroInfo(baseList, heroList);
            if (!needRequires.isEmpty()) {
                int needHeroNum = needRequires.stream().mapToInt(UpStarRequire::getNum).sum();
                Asserts.isTrue(msg.getReplaceItemCount() == needHeroNum, ErrorCode.REIKI_EQUIP_COMBINE_NEED_HERO.getValue(),
                        "素材英雄不符合灵器升级需求");
                //验证背包傀儡羊数量是否足够
                isEnoughReplaceItem(playerContext.getId(), msg.getReplaceItemList(), costItemList);
                //检验傀儡羊是否符合素材需求
                isReplaceItem(needRequires, msg.getReplaceItemList());
            }
        }

        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), msg.getHeroesList()),
                ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(), "不能删除指定阵型上的所有英雄");

        List<Integer> idxList = reikiEquipSysCache.getAll().stream().map(CReikiEquip::getIdx).collect(Collectors.toList());
        List<ImmutableThing> costReikiType = new ArrayList<>();//需求素材灵器
        for (ImmutableThing immutableThing : cReikiEquip.getUp_star_cost()) {//将合成需求素材分为灵器素材和道具素材
            if (idxList.contains(immutableThing.getItem_type())) {
                costReikiType.add(immutableThing);
            } else {
                costItemList.add(immutableThing);
            }
        }

        //验证材料灵器
        if (!costReikiType.isEmpty()) {

            long needReikiCount = costReikiType.stream().mapToLong(ImmutableThing::getItem_num).sum();
            Asserts.isTrue(needReikiCount == msg.getReikiEquipIdsCount(), ErrorCode.REIKI_EQUIP_COMBINE_NEED_ITEM.getValue(),
                    "需要的灵器素材量与实际的不符");

            Map<Integer, Integer> map = new HashMap<>();
            for (long equipId : msg.getReikiEquipIdsList()) {
                Asserts.isTrue(equipId != msg.getReikiId(), ErrorCode.REIKI_EQUIP_COMBINE_IDENTICAL.getValue(), "本体灵器不能用作素材灵器");
                ReikiEquip equip = reikiEquipService.select(playerContext.getId(), equipId);
                Asserts.isTrue(equip.getHeroId() == 0, ErrorCode.REIKI_EQUIP_USED.getValue(), "该灵器已装备在英雄身上");
                map.put(equip.getSysId(), map.getOrDefault(equip.getSysId(), 0) + 1);
            }
            for (ImmutableThing immutableThing : costReikiType) {
                Asserts.isTrue(map.containsKey(immutableThing.getItem_type()) &&
                                immutableThing.getItem_num() == map.get(immutableThing.getItem_type()), ErrorCode.REIKI_EQUIP_COMBINE_NEED_ITEM.getValue(),
                        String.format("素材灵器不符合升级灵器材料列表，目标灵器{%s},当前素材灵器{%s}", msg.getSysId(), msg.getReikiEquipIdsList()));
            }
        }

        //消耗道具素材
        if (!costItemList.isEmpty()) {
            thingService.cost(playerContext.getId(), costItemList, GameEvent.REIKI_EQUIP_COMBINE);
        }
        //消耗灵器素材
        if (!costReikiType.isEmpty()) {
            // 删除灵器
            reikiEquipService.deletes(playerContext.getId(), msg.getReikiEquipIdsList(), GameEvent.REIKI_EQUIP_COMBINE);
        }
        //消耗英雄
        if (!msg.getHeroesList().isEmpty() && !baseList.isEmpty()) {
            List<Hero> heroList = heroService.heroList(playerContext.getId(), msg.getHeroesList());
            heroService.deleteHeros(playerContext.getId(), heroList, GameEvent.REIKI_EQUIP_COMBINE);
        }

        reikiEquip.setSysId(msg.getSysId());
        reikiEquipService.update(reikiEquip);

        ReikiEquipGMsg.GResCombineReikiEquip.Builder builder = ReikiEquipGMsg.GResCombineReikiEquip.newBuilder();
        builder.setReikiEquip(PbUtil.builderReikiEquip(reikiEquip));
        playerContext.write(CmdCode._70006, builder.build());

        eventBus.post(ReikiEquipUpStarEvent.of(playerContext.getId(), reikiEquip.getId()));

    }

    private void isEnoughReplaceItem(long rid, List<Integer> replaceIds, List<ImmutableThing> costItemList) {

        List<ImmutableThing> thingList = new ArrayList<>();
        for (int replace : replaceIds) {
            ImmutableThing immutableThing = ImmutableThing.of(replace, 1);
            thingList.add(immutableThing);
        }

        ImmutableThingUtil.mergeThing(thingList);
        Asserts.isTrue(thingService.enough(rid, thingList), ErrorCode.REIKI_EQUIP_COMBINE_NEED_ITEM.getValue(), "傀儡羊道具不足");
        costItemList.addAll(thingList);
    }

    private List<UpStarRequire> isHeroInfo(List<UpStarRequire> heroRequires, List<Hero> heroList) {
        //将素材需求按类型和元素倒序排序，先验证特定类型和元素的素材需求
        heroRequires = heroRequires.stream().sorted(Comparator.comparingInt(UpStarRequire::getType).
                thenComparingInt(UpStarRequire::getElem).reversed()).collect(Collectors.toList());

        for (UpStarRequire upStarRequire : heroRequires) {
            List<Hero> costHeroList = new ArrayList<>();
            for (Hero hero : heroList) {
                //该素材需求已执行验证完，执行下一个素材需求
                if (upStarRequire.getNum() == 0) {
                    break;
                }
                CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                if ((upStarRequire.getType() == 0 || cHeroType.getType() == upStarRequire.getType()) &&
                        (upStarRequire.getElem() == 0 || upStarRequire.getElem() == cHeroType.getElem()) &&
                        hero.getStar() == upStarRequire.getStar()) {
                    //满足条件将素材需求数减一并将符合条件的英雄保存
                    upStarRequire.setNum(upStarRequire.getNum() - 1);
                    costHeroList.add(hero);
                }
            }
            //清除本轮符合素材需求的英雄
            heroList.removeAll(costHeroList);
            //已没有英雄素材则结束
            if (heroList.isEmpty()) {
                break;
            }
        }
        //返回剩下的素材需求
        return heroRequires.stream().filter(upStarRequire -> upStarRequire.getNum() > 0).collect(Collectors.toList());
    }

    private void isReplaceItem(List<UpStarRequire> list, List<Integer> replaceList) {
        Map<Integer, Integer> starMap = new HashMap<>();
        for (UpStarRequire upStarRequire : list) {
            starMap.put(upStarRequire.getStar(), starMap.getOrDefault(upStarRequire.getStar(), 0) + upStarRequire.getNum());
        }
        for (Integer itemId : replaceList) {
            ReplaceTypeEnum replaceTypeEnum = ReplaceTypeEnum.of(itemId);
            Asserts.isTrue(starMap.containsKey(replaceTypeEnum.getStar()) && starMap.get(replaceTypeEnum.getStar()) > 0,
                    ErrorCode.REIKI_EQUIP_COMBINE_NEED_HERO.getValue(), "使用不符合素材英雄需求的傀儡羊");
            starMap.put(replaceTypeEnum.getStar(), starMap.get(replaceTypeEnum.getStar()) - 1);
        }
        int num = starMap.values().stream().mapToInt(Integer::intValue).sum();
        Asserts.isTrue(num == 0, ErrorCode.REIKI_EQUIP_COMBINE_NEED_HERO.getValue(), "素材英雄不满足灵器升级需求英雄数");
    }

}
