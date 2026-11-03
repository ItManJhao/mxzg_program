package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.PageUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.MagicWandStrengthenSysCache;
import com.ayjs.mxzg.config.excel.cache.MagicWandTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CMagicWandStrengthen;
import com.ayjs.mxzg.config.excel.entity.CMagicWandType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.event.MagicWandChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.MagicAttrData;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqHeroMagicWandList;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqHeroMagicWandOff;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqHeroMagicWandOn;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqMagicWandBaptism;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqMagicWandDecompose;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqMagicWandSave;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GReqMagicWandStrengthen;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResHeroMagicWandList;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResHeroMagicWandOff;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResHeroMagicWandOn;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResMagicWandBaptism;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResMagicWandDecompose;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResMagicWandSave;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResMagicWandStrengthen;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class HeroMagicWandHandler extends ProtocolHandler {

    @Autowired
    private HeroMagicWandService heroMagicWandService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private MagicWandStrengthenSysCache magicWandStrengthenSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private MagicWandTypeSysCache magicWandTypeSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private EventBus eventBus;

    private static final int BAG_REDUCE = 0;
    private static final int BAG_INCREASE = 1;
    private static final int PAGE_SIZE = 150;

    @CMD(id = CmdCode._4601)
    public void reqHeroMagicWandList(PlayerContext playerContext, GReqHeroMagicWandList req) {
        List<HeroMagicWand> allMagicWands = heroMagicWandService.getAllMagicWands(playerContext.getId());
        int page = req.getPage();
        if (page <= 0) {
            page = 1;
        }
        List<HeroMagicWand> pageList = PageUtil.pageN(allMagicWands, page, PAGE_SIZE);
        GResHeroMagicWandList.Builder proto = GResHeroMagicWandList.newBuilder();
        proto.addAllList(heroMagicWandService.convert(pageList));
        proto.setPage(page);

        playerContext.write(CmdCode._4601, proto.build());
    }

    @CMD(id = CmdCode._4602)
    public void reqHeroMagicWandOn(PlayerContext playerContext, GReqHeroMagicWandOn req) {
        long rid = playerContext.getId();
        long heroId = req.getHeroId();
        long magicId = req.getMagicId();
        Role role = roleService.getOrThrow(rid);

        // 条件检查
        Hero hero = heroService.getHero(rid, heroId);
        HeroMagicWand readyWearMagicWand = heroMagicWandService.getMagicWand(rid, magicId);
        int need_role_level = openConditionSysCache.getCondition("hero_magic_wand").getCondition_value();
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getDesc());
        Asserts.notNull(readyWearMagicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getDesc());
        Asserts.isTrue(role.getLevel() >= need_role_level, ErrorCode.MAGIC_WAND_NEED_LEVEL_LOW.getValue(),
                String.format("玩家等级{%s}小于所需等级{%s}", role.getLevel(), need_role_level));
        Asserts.isTrue(hero.getStar() >= systemSysCache.getOpenMagicWandHeroStar(), ErrorCode.HERO_STAR_UNABLE_WEAR_MAGIC_WAND.getValue(),
                String.format("英雄星级不足{%s},需要星级{%s}", hero.getStar(), systemSysCache.getOpenMagicWandHeroStar()));
        Asserts.isTrue(readyWearMagicWand.getHeroId() != heroId, ErrorCode.MAGIC_WAND_HAVE_WEARING.getValue(),
                String.format("魔杖{%s}已经穿戴在英雄{%s}身上", magicId, heroId));
        Asserts.isTrue(readyWearMagicWand.getHeroId() == 0, ErrorCode.MAGIC_WAND_IS_WEAR_ON_OTHER.getValue(),
                String.format("魔杖{%s}穿戴在其他英雄身上", magicId));

        // 穿戴前判断该英雄身上是否有穿戴魔杖
        HeroMagicWand takeOffMagic = heroMagicWandService.getMagicWandByHeroId(rid, heroId);
        List<HeroMagicWand> updateList = new ArrayList<>();
        if (Objects.nonNull(takeOffMagic)) {
            // 脱下
            takeOffMagic.setHeroId(0);
            updateList.add(takeOffMagic);
        }
        // 穿戴
        readyWearMagicWand.setHeroId(heroId);
        updateList.add(readyWearMagicWand);
        heroMagicWandService.update(updateList);
        // 计算穿戴魔杖的战力
        eventBus.post(MagicWandChangeEvent.of(rid, readyWearMagicWand.getHeroId(), GameEvent.MAGIC_WAND_TAKE_ON));
        // 把脱下的那一件放入背包并通知前端
        if (Objects.nonNull(takeOffMagic)) {
            heroMagicWandService.sendUpdateBackPack(rid, Collections.singletonList(takeOffMagic), BAG_INCREASE);
        }
        // 穿戴时删除背包中这一件
        heroMagicWandService.sendUpdateBackPack(rid, Collections.singletonList(readyWearMagicWand), BAG_REDUCE, false);
        GResHeroMagicWandOn.Builder proto = GResHeroMagicWandOn.newBuilder();
        proto.setHeroId(heroId);
        proto.setMagicId(Objects.nonNull(takeOffMagic) ? takeOffMagic.getId() : 0);
        proto.setMagicInfo(heroMagicWandService.convertItemInfo(readyWearMagicWand));
        playerContext.write(CmdCode._4602, proto.build());
    }

    @CMD(id = CmdCode._4603)
    public void reqHeroMagicWandOff(PlayerContext playerContext, GReqHeroMagicWandOff req) {
        long rid = playerContext.getId();
        long heroId = req.getHeroId();
        long magicId = req.getMagicId();

        // 条件检查
        Hero hero = heroService.getHero(rid, heroId);
        HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWandByHeroId(rid, heroId);
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", heroId));
        Asserts.notNull(heroMagicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getValue(), String.format("背包中没有这个魔杖{%s}", magicId));
        Asserts.isTrue(heroMagicWand.getId() == magicId, ErrorCode.THE_MAGIC_WAND_NOT_IN_HERO.getValue(),
                String.format("英雄{%s}身上没有魔杖{%s}, 无法卸下", heroId, magicId));

        // 脱下
        heroMagicWand.setHeroId(0);
        heroMagicWandService.update(heroMagicWand);

        eventBus.post(MagicWandChangeEvent.of(rid, hero.getId(), GameEvent.MAGIC_WAND_TAKE_OFF));
        heroMagicWandService.sendUpdateBackPack(rid, Collections.singletonList(heroMagicWand), BAG_INCREASE);
        GResHeroMagicWandOff.Builder proto = GResHeroMagicWandOff.newBuilder();
        proto.setHeroId(heroId);
        playerContext.write(CmdCode._4603, proto.build());
    }


    @CMD(id = CmdCode._4604)
    public void reqMagicWandStrengthen(PlayerContext playerContext, GReqMagicWandStrengthen req) {
        long heroId = req.getHeroId();
        long magicId = req.getMagicId();
        long rid = playerContext.getId();

        HeroMagicWand heroMagicWand;
        if (heroId != 0) {
            Hero hero = heroService.getHero(rid, heroId);
            Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", heroId));
            heroMagicWand = heroMagicWandService.getMagicWandByHeroId(rid, heroId);
            Asserts.isTrue(heroMagicWand.getId() == magicId,
                    ErrorCode.THE_MAGIC_WAND_NOT_IN_HERO.getValue(), String.format("英雄{%s}身上没有魔杖{%s}", heroId, magicId));
        } else {
            heroMagicWand = heroMagicWandService.getMagicWand(rid, magicId);
            Asserts.notNull(heroMagicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getValue(), String.format("背包中没有这个魔杖{%s}", magicId));
        }

        // 强化等级和配置表id
        int strengthen = heroMagicWand.getStrengthen();
        int typeId = heroMagicWand.getTypeId();
        CMagicWandStrengthen strengthenConfig = magicWandStrengthenSysCache.getDataByTypeAndLevel(typeId, strengthen);
        Asserts.isTrue(!strengthenConfig.getCost().isEmpty(), ErrorCode.THE_MAGIC_WAND_IS_MAX_STRENGTHEN_LV.getValue(), String.format("魔杖{%s}已是最大等级{%s}", magicId, strengthen));

        thingService.cost(rid, strengthenConfig.getCost(), GameEvent.MAGIC_WAND_STRENGTHEN_COST);
        // 基础属性重新赋予
        Map<Integer, MagicAttrData> base_attrs = heroMagicWand.getBase_attrs();
        base_attrs.clear();
        ImmutableMap<AttributeType, Long> baseAttrConfig = strengthenConfig.getAttrs();
        for (Map.Entry<AttributeType, Long> entry : baseAttrConfig.entrySet()) {
            MagicAttrData newAttr = new MagicAttrData(entry.getKey(), entry.getValue());
            base_attrs.put(base_attrs.size(), newAttr);
        }
        heroMagicWand.setStrengthen(strengthen + 1);
        heroMagicWandService.tryToActiveRandomAttr(heroMagicWand);
        heroMagicWandService.update(heroMagicWand);
        if (heroId != 0) {
            eventBus.post(MagicWandChangeEvent.of(rid, heroMagicWand.getHeroId(), GameEvent.MAGIC_WAND_STRENGTHEN));
        }

        // 协议返回
        GResMagicWandStrengthen.Builder proto = GResMagicWandStrengthen.newBuilder();
        proto.setMagicInfo(heroMagicWandService.convertItemInfo(heroMagicWand));
        playerContext.write(CmdCode._4604, proto.build());
    }

    @CMD(id = CmdCode._4605)
    public void reqMagicWandBaptism(PlayerContext playerContext, GReqMagicWandBaptism req) {
        long rid = playerContext.getId();
        long magicId = req.getMagicId();
        long heroId = req.getHeroId();

        // 条件检查
        HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWand(rid, magicId);
        CMagicWandType magicWandTypeConfig = magicWandTypeSysCache.getById(heroMagicWand.getTypeId());
        if (heroId != 0) {
            Asserts.isTrue(heroMagicWand.getHeroId() == heroId,
                    ErrorCode.THE_MAGIC_WAND_NOT_IN_HERO.getValue(), String.format("英雄{%s}身上没有魔杖{%s}", heroId, magicId));
        }
        Asserts.notNull(heroMagicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getValue(), String.format("背包中没有这个魔杖{%s}", magicId));
        Asserts.isTrue(magicWandTypeConfig.getRandom_attr_max() > 0,
                ErrorCode.MAGIC_WAND_BAPTISM_CONDITION_NOT_SATISFIED.getValue(), String.format("魔杖品质无法进行洗练，品质={%s}", heroMagicWand.getRare()));
        // 准备洗练
        ImmutableList<ImmutableThing> cost = magicWandTypeConfig.getCost();
        thingService.cost(rid, cost, GameEvent.MAGIC_WAND_BAPTISM_COST);
        heroMagicWand.setWash_times(heroMagicWand.getWash_times() + 1);
        // 先确定要不要洗练属性
        Map<Integer, MagicAttrData> washAttrs = heroMagicWand.getWash_attrs();
        if (washAttrs.isEmpty()) {
            // 洗练属性是空的，这一次洗练必要要重置属性类型和数值，且数值要大于基本属性
            heroMagicWandService.setNewWashAttrTypeAndVal(heroMagicWand, false);
        } else {
            // 洗练属性是不是空的，根据概率来判断
            int random_num = RandomUtil.rand(0, 100) + 1;
            if (random_num <= systemSysCache.getMagicWandBaptismResetProbability()) {
                // 属性重新刷新
                heroMagicWandService.setNewWashAttrTypeAndVal(heroMagicWand, true);
            } else {
                // 更新数值，如果数值到达最大则更新属性
                heroMagicWandService.resetWashAttrVal(heroMagicWand);
            }
        }
        heroMagicWandService.update(heroMagicWand);

        // 只更新，保存时才需要更新战力
        GResMagicWandBaptism.Builder proto = GResMagicWandBaptism.newBuilder();
        proto.setMagicInfo(heroMagicWandService.convertItemInfo(heroMagicWand));

        playerContext.write(CmdCode._4605, proto.build());
    }

    @CMD(id = CmdCode._4606)
    public void reqMagicWandSave(PlayerContext playerContext, GReqMagicWandSave req) {
        long rid = playerContext.getId();
        long heroId = req.getHeroId();
        long magicId = req.getMagicId();

        HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWand(rid, magicId);
        Map<Integer, MagicAttrData> washAttr = heroMagicWand.getWash_attrs();
        if (heroId != 0) {
            Asserts.isTrue(heroMagicWand.getHeroId() == heroId, ErrorCode.THE_MAGIC_WAND_NOT_IN_HERO.getValue(),
                    String.format("英雄{%s}身上没有魔杖{%s}", heroId, magicId));
        }
        Asserts.notNull(heroMagicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getValue(), String.format("背包中没有这个魔杖{%s}", magicId));
        Asserts.notNull(washAttr, ErrorCode.MAGIC_WAND_HAVE_NOT_NEW_WASH_ATTR.getValue(), String.format("魔杖{%s}没有可以保存的属性", magicId));
        CMagicWandType magicWandTypeConfig = magicWandTypeSysCache.getById(heroMagicWand.getTypeId());
        Asserts.notNull(magicWandTypeConfig.getRandom_attrs(), ErrorCode.MAGIC_WAND_HAVE_NOT_RANDOM_ATTR.getValue(),
                String.format("魔杖{%s}没有随机属性", magicId));

        Map<Integer, MagicAttrData> randomAttrs = heroMagicWand.getRandom_attrs();
        for (Map.Entry<Integer, MagicAttrData> entry : washAttr.entrySet()) {
            // 把洗练未保存的属性类型和数值放到随机属性上面去，key值代表位置。
            randomAttrs.put(entry.getKey(), entry.getValue());
        }
        // 清空洗练属性
        washAttr.clear();

        heroMagicWandService.update(heroMagicWand);
        if (heroId != 0) {
            eventBus.post(MagicWandChangeEvent.of(rid, heroMagicWand.getHeroId(), GameEvent.MAGIC_WAND_BAPTISM_SAVE));
        }
        GResMagicWandSave.Builder proto = GResMagicWandSave.newBuilder();
        proto.setMagicInfo(heroMagicWandService.convertItemInfo(heroMagicWand));
        playerContext.write(CmdCode._4606, proto.build());

    }

    @CMD(id = CmdCode._4607)
    public void reqMagicWandDecompose(PlayerContext playerContext, GReqMagicWandDecompose req) {
        long rid = playerContext.getId();
        List<Long> delMagicIds = req.getMagicIdsList();
        // 检查是否可以分解
        List<Long> canDelIds = new ArrayList<>();
        for (Long delMagicId : delMagicIds) {
            HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWand(rid, delMagicId);
            if (heroMagicWand == null || heroMagicWand.getHeroId() != 0) {
                continue;
            }
            canDelIds.add(delMagicId);
        }
        // 扣除并返回了强化，洗练和本身材料
        heroMagicWandService.costAndReturn(rid, canDelIds, GameEvent.MAGIC_WAND_STRENGTHEN_BAPTISM);
        GResMagicWandDecompose.Builder proto = GResMagicWandDecompose.newBuilder();
        proto.addAllDelIds(canDelIds);
        playerContext.write(CmdCode._4607, proto.build());

    }
}
