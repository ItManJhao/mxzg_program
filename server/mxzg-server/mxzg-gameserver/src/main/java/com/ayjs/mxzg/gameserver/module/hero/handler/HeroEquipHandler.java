/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.excel.cache.heroEquipSoul.HeroEquipSoulExtraSysCache;
import com.ayjs.mxzg.config.excel.cache.heroEquipSoul.HeroEquipSoulSysCache;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoul;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoulExtra;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEquipChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEquipSoulChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroEquipService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg.GReqHeroEquip;
import com.ayjs.mxzg.protocol.HeroGMsg.GReqHeroEquipChange;
import com.ayjs.mxzg.protocol.HeroGMsg.GReqHeroEquipDisboard;
import com.ayjs.mxzg.protocol.HeroGMsg.GReqHeroEquipOneKeyDisboard;
import com.ayjs.mxzg.protocol.HeroGMsg.GReqHeroEquipOneKeyWear;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroEquip;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroEquipChange;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroEquipDisboard;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroEquipOneKeyDisboard;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroEquipOneKeyWear;
import com.ayjs.mxzg.protocol.HeroGMsg.PSHeroEquipData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Controller
public class HeroEquipHandler extends ProtocolHandler {
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroEquipService heroEquipService;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroEquipSoulExtraSysCache heroEquipSoulExtraSysCache;
    @Autowired
    private HeroEquipSoulSysCache heroEquipSoulSysCache;
    @Autowired
    private HeroMagicWandService heroMagicWandService;

    @CMD(id = CmdCode._4022)
    public void heroEquip(PlayerContext playerContext, GReqHeroEquip msg) {
        List<Hero> heros = heroService.getHeros(playerContext.getId());
        List<HeroEquip> equips = heroEquipService.getRoleParts(playerContext.getId());
        Map<Long, List<HeroEquip>> heroEquips = ListMapUtil.fillListMap(equips, HeroEquip::getHeroId);

        GResHeroEquip.Builder builder = GResHeroEquip.newBuilder();
        for (Hero hero : heros) {
            PSHeroEquipData.Builder hEquips = PSHeroEquipData.newBuilder();
            hEquips.setHeroId(hero.getId());
            List<HeroEquip> list = heroEquips.get(hero.getId());
            if (list != null) {
                for (HeroEquip equip : list) {
                    // 没有按装备的部位进行排序
                    hEquips.addEquipList(PbUtil.buildEquip(equip));
                }
            }
            hEquips.setMagicInfo(heroMagicWandService.convertItemInfo(heroMagicWandService.getMagicWandByHeroId(playerContext.getId(), hero.getId())));
            builder.addEquipList(hEquips.build());
        }
        playerContext.write(CmdCode._4022, builder.build());
    }

    @CMD(id = CmdCode._4023)
    public void heroEquipChange(PlayerContext playerContext, GReqHeroEquipChange msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST);
            return;
        }
        CEquipmenttype cEquipmenttype = equipmenttypeSysCache.getOrThrow(msg.getSysId());
        if (cEquipmenttype == null) {
            // 没找到装备配置数据
            playerContext.writeError(ErrorCode.HERO_EQUIP_MISS);
            return;
        }

        HeroEquip currEquip = heroEquipService.partChange(playerContext.getId(), msg.getHeroId(),
                cEquipmenttype, GameEvent.EQUIP_CHANGE);

        GResHeroEquipChange.Builder builder = GResHeroEquipChange.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setEquip(PbUtil.buildEquip(currEquip));
        playerContext.write(CmdCode._4023, builder.build());

        //英雄换装备
        eventBus.post(HeroEquipChangeEvent.of(hero, GameEvent.EQUIP_CHANGE));
    }

    @CMD(id = CmdCode._4024)
    public void heroEquipDisboard(PlayerContext playerContext, GReqHeroEquipDisboard msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST);
            return;
        }
        HeroEquip currEquip = heroEquipService.getPlacePart(playerContext.getId(), hero.getId(), msg.getEquipId());
        if (currEquip == null || currEquip.getSysId() == 0) {
            // 没有装备着的装备
            playerContext.writeError(ErrorCode.HERO_EQUIP_EMPTY);
            return;
        }
        // 将脱下的装备转换回道具
        ImmutableThing equipItem = ImmutableThing.of(currEquip.getSysId(), 1);
        thingService.add(playerContext.getId(), equipItem, GameEvent.EQUIP_OFF, NoticeType.SLIENT);
        currEquip.setSysId(0);
        heroEquipService.updateHeroPart(currEquip);

        GResHeroEquipDisboard.Builder builder = GResHeroEquipDisboard.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setEquip(PbUtil.buildEquip(currEquip));
        playerContext.write(CmdCode._4024, builder.build());

        //英雄换装备
        eventBus.post(HeroEquipChangeEvent.of(hero, GameEvent.EQUIP_OFF));
    }

    @CMD(id = CmdCode._4025)
    public void heroEquipOneKeyWear(PlayerContext playerContext, GReqHeroEquipOneKeyWear msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST, msg.getHeroId());
            return;
        }

        Set<Integer> sysIdSet = new HashSet<>(msg.getSysIdList());
        if (sysIdSet.isEmpty()) {
            playerContext.writeError(ErrorCode.ERROR_PARAM);
            return;
        }

        List<HeroEquip> changeEquips = heroEquipService.oneKeyPartChange(playerContext.getId(), msg.getHeroId(),
                sysIdSet, GameEvent.EQUIP_ALL_WEAR);

        GResHeroEquipOneKeyWear.Builder builder = GResHeroEquipOneKeyWear.newBuilder();
        builder.setHeroId(hero.getId());
        for (HeroEquip equip : changeEquips) {
            builder.addEquip(PbUtil.buildEquip(equip));
        }
        playerContext.write(CmdCode._4025, builder.build());

        //英雄换装备
        eventBus.post(HeroEquipChangeEvent.of(hero, GameEvent.EQUIP_ALL_WEAR));
    }

    @CMD(id = CmdCode._4026)
    public void heroEquipOneKeyDisboard(PlayerContext playerContext, GReqHeroEquipOneKeyDisboard msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 未找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST, msg.getHeroId());
            return;
        }

        List<HeroEquip> equipList = heroEquipService.clearHeroPlaingParts(playerContext.getId(),
                Collections.singletonList(hero), GameEvent.EQUIP_ALL_OFF);

        GResHeroEquipOneKeyDisboard.Builder builder = GResHeroEquipOneKeyDisboard.newBuilder();
        builder.setHeroId(hero.getId());
        for (HeroEquip equip : equipList) {
            builder.addEquip(PbUtil.buildEquip(equip));
        }
        playerContext.write(CmdCode._4026, builder.build());

        //英雄换装备
        eventBus.post(HeroEquipChangeEvent.of(hero, GameEvent.EQUIP_ALL_OFF));
    }


    @CMD(id = CmdCode._4080)
    public void soulLvUp(PlayerContext playerContext, HeroGMsg.GReqHeroEquipSoulLvUp msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());

        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄{%s}不存在", msg.getHeroId()));

        CHeroEquipSoulExtra soulExtraConfig = heroEquipSoulExtraSysCache.getConfig();
        Asserts.isTrue(hero.getStar() >= soulExtraConfig.getNeed_star(),
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄星级{%s}不够", hero.getStar()));

        List<HeroEquip> heroEquips = heroEquipService.getHeroEquips(playerContext.getId(), msg.getHeroId());
        HeroEquip heroEquip = heroEquips.stream().filter(equip -> equip.getPlace() == msg.getPlace()).findFirst().orElse(null);

        Asserts.isTrue(heroEquip != null && heroEquip.getSysId() > 0, ErrorCode.HERO_EQUIP_EMPTY.getValue(),
                String.format("装备位置{%s}不存在", msg.getPlace()));

        CEquipmenttype equipConfig = equipmenttypeSysCache.getOrThrow(heroEquip.getSysId());
        Asserts.isTrue(equipConfig.getRare() >= soulExtraConfig.getNeed_equip_rare()
                        && equipConfig.getStar() >= soulExtraConfig.getNeed_equip_star(),
                ErrorCode.HERO_EQUIP_EMPTY.getValue(),
                String.format("装备星级不够{%s}不存在", heroEquip.getSysId()));

        CHeroEquipSoul soulConfig = heroEquipSoulSysCache.getByPlaceAndLv(msg.getPlace(), heroEquip.getSoulLv() + 1);
        Asserts.isTrue(soulConfig != null,
                ErrorCode.CONFIG_NOT_EXIST.getValue(),
                String.format("附魂等级{%s}不存在", heroEquip.getSoulLv() + 1));

        thingService.cost(playerContext.getId(), soulConfig.getCost(), GameEvent.HERO_EQUIP_SOUL);

        heroEquip.setSoulLv(heroEquip.getSoulLv() + 1);
        heroEquipService.updateHeroPart(heroEquip);

        HeroGMsg.GResHeroEquipSoulLvUp.Builder builder = HeroGMsg.GResHeroEquipSoulLvUp.newBuilder();
        builder.setEquipData(PbUtil.buildEquip(heroEquip));
        builder.setHeroId(msg.getHeroId());

        playerContext.write(CmdCode._4080, builder.build());

        eventBus.post(HeroEquipSoulChangeEvent.of(hero, GameEvent.HERO_EQUIP_SOUL));

    }

    @CMD(id = CmdCode._4081)
    public void soulReset(PlayerContext playerContext, HeroGMsg.GReqHeroEquipSoulReset msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());

        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄{%s}不存在", msg.getHeroId()));

        CHeroEquipSoulExtra soulExtraConfig = heroEquipSoulExtraSysCache.getConfig();
        Asserts.isTrue(hero.getStar() >= soulExtraConfig.getNeed_star(),
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄星级{%s}不够", hero.getStar()));

        List<HeroEquip> heroEquips = heroEquipService.getHeroEquips(playerContext.getId(), msg.getHeroId());
        HeroEquip heroEquip = heroEquips.stream().filter(equip -> equip.getPlace() == msg.getPlace()).findFirst().orElse(null);
        Asserts.isTrue(heroEquip != null && heroEquip.getSysId() > 0, ErrorCode.HERO_EQUIP_EMPTY.getValue(),
                String.format("装备位置{%s}不存在", msg.getPlace()));

        CEquipmenttype equipConfig = equipmenttypeSysCache.getOrThrow(heroEquip.getSysId());
        Asserts.isTrue(equipConfig != null && equipConfig.getRare() >= soulExtraConfig.getNeed_equip_rare()
                        && equipConfig.getStar() >= soulExtraConfig.getNeed_equip_star(),
                ErrorCode.HERO_EQUIP_STAR_LOW.getValue(),
                String.format("装备星级不够{%s}不存在", heroEquip.getSysId()));

        Asserts.isTrue(heroEquip.getSoulLv() > 0,
                ErrorCode.HERO_EQUIP_NOT_SOUL_LV.getValue(),
                String.format("没有附魂{%s}不存在", heroEquip.getSysId()));

        CHeroEquipSoul soulConfig = heroEquipSoulSysCache.getOrThrow(heroEquip.getSoulLv());
        thingService.cost(playerContext.getId(), soulConfig.getReset_cost(), GameEvent.HERO_EQUIP_SOUL_RESET);

        List<CHeroEquipSoul> backUpConfigs = heroEquipSoulSysCache.getByPlace(msg.getPlace()).values()
                .stream().filter(configTemp -> configTemp.getPlace() == msg.getPlace()
                        && configTemp.getLevel() <= heroEquip.getSoulLv()).collect(Collectors.toList());
        List<ImmutableThing> rewards = backUpConfigs.stream().map(CHeroEquipSoul::getCost).flatMap(Collection::stream).collect(Collectors.toList());

        heroEquip.setSoulLv(0);
        heroEquipService.updateHeroPart(heroEquip);

        thingService.add(playerContext.getId(), ImmutableThingUtil.mergeThing(rewards), GameEvent.HERO_EQUIP_SOUL_RESET);

        HeroGMsg.GResHeroEquipSoulReset.Builder builder = HeroGMsg.GResHeroEquipSoulReset.newBuilder();
        builder.setEquipData(PbUtil.buildEquip(heroEquip));
        builder.setHeroId(msg.getHeroId());

        playerContext.write(CmdCode._4081, builder.build());

        eventBus.post(HeroEquipSoulChangeEvent.of(hero, GameEvent.HERO_EQUIP_SOUL_RESET));

    }

}
