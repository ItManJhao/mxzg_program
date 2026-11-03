/**
 *
 */
package com.ayjs.mxzg.gameserver.module.godequip.handler;

import java.util.List;

import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion010PrivilegeGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion010PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipLotteryInfo;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipLotteryService;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroFightingCommand;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.protocol.GodEquipGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.PageUtil;
import com.ayjs.mxzg.config.excel.constant.GodEquipConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipChangeEvent;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqDisboardGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqScanGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqWearGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GResDisboardGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GResScanGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GResWearGodEquip;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
@Controller
public class GodEquipHandler extends ProtocolHandler {

    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private WorldLevelManager worldLevelManager;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private Promotion010PrivilegeGiftSysCache promotion010PrivilegeGiftSysCache;
    @Autowired
    private GodEquipLotteryService godEquipLotteryService;
    @Autowired
    private ThingService thingService;


    @CMD(id = CmdCode._58001)
    public void scanEquips(PlayerContext playerContext, GReqScanGodEquip msg) {
        List<GodEquip> equips = godEquipService.getEquips(playerContext.getId());
        List<GodEquip> pageData = PageUtil.pageN(equips, msg.getPage(), 50);

        GResScanGodEquip.Builder builder = GResScanGodEquip.newBuilder();
        builder.setPage(msg.getPage());
        for (GodEquip equip : pageData) {
            builder.addEquips(godEquipService.buildGodEquip(equip));
        }
        playerContext.write(CmdCode._58001, builder.build());
    }

    @CMD(id = CmdCode._58002)
    public void equipChange(PlayerContext playerContext, GReqWearGodEquip msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= GodEquipConst.MAIN_LEVEL, ErrorCode.GODEQUIP_LEVEL_LACK.getValue(),
                "角色等级还未满足神装穿戴要求");
        Asserts.isTrue(worldLevelManager.getWorldLevel() >= GodEquipConst.WORLD_LEVEL, ErrorCode.GODEQUIP_WORLD_LACK.getValue(),
                "角色等级还未满足神装穿戴要求");

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());
        Asserts.isTrue(hero.getStar() >= GodEquipConst.HERO_STAR, ErrorCode.GODEQUIP_STAR_LACK.getValue(), "该英雄星级还没有达到穿戴神装的要求");

        GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), msg.getEquipId());
        Asserts.isTrue(godEquip != null, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), "该神装不存在" + msg.getEquipId());
        Asserts.isTrue(godEquip.getHeroId() == 0, ErrorCode.GODEQUIP_WEARING.getValue(), "该神装已经装备在英雄身上");

        GodEquip oriEquip = godEquipService.getPlaceEquip(playerContext.getId(), hero.getId(), godEquip.getPlace());
        if (oriEquip != null) {
            oriEquip.setHeroId(0);
            godEquipService.updateEquip(oriEquip);
        }

        godEquip.setHeroId(hero.getId());
        godEquipService.updateEquip(godEquip);

        GResWearGodEquip.Builder builder = GResWearGodEquip.newBuilder();
        builder.setHeroId(hero.getId());
        builder.addEquips(godEquipService.buildGodEquip(godEquip));
        if (oriEquip != null) {
            builder.addEquips(godEquipService.buildGodEquip(oriEquip));
        }
        playerContext.write(CmdCode._58002, builder.build());

        //战力事件
        eventBus.post(GodEquipChangeEvent.of(hero, GameEvent.GODEQUIP_CHANGE));
    }

    @CMD(id = CmdCode._58003)
    public void equipDisboard(PlayerContext playerContext, GReqDisboardGodEquip msg) {
        GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), msg.getEquipId());
        Asserts.isTrue(godEquip != null, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), "该神装不存在" + msg.getEquipId());
        Asserts.isTrue(godEquip.getHeroId() != 0, ErrorCode.GODEQUIP_NOT_WEARING.getValue(), "该神装没有装备在英雄身上");

        Hero hero = heroService.getHero(playerContext.getId(), godEquip.getHeroId());
        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + godEquip.getHeroId());

        godEquip.setHeroId(0);
        godEquipService.updateEquip(godEquip);

        GResDisboardGodEquip.Builder builder = GResDisboardGodEquip.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setEquipId(godEquip.getId());
        playerContext.write(CmdCode._58003, builder.build());

        //战力事件
        eventBus.post(GodEquipChangeEvent.of(hero, GameEvent.GODEQUIP_DISBOARD));
    }
    //神装目前没有一键穿、脱的操作需求
    //58004 协议号保留用于一键穿
    //58005 协议号保留用于一键脱

    /**
     * 神装总览战力推送
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58016)
    public void sendGodEquipFighting(PlayerContext playerContext, GodEquipGMsg.GReqGodEquipFighting msg) {

        GodEquipGMsg.GResGodEquipFighting.Builder builder = GodEquipGMsg.GResGodEquipFighting.newBuilder();

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("找不到该英雄：%s", msg.getHeroId()));

        QueryHeroFightingCommand queryHeroFightingCommand = QueryHeroFightingCommand.createOf(hero, ModuleType.GOD_EQUIP);
        commandBus.invoke(queryHeroFightingCommand);

        builder.setFighting(queryHeroFightingCommand.getFighting());
        playerContext.write(CmdCode._58016, builder.build());

    }

    /**
     * 神装特权数据
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58017)
    public void sendGodEquipPrivilegeData(PlayerContext playerContext, GodEquipGMsg.GReqGodEquipPrivilege msg) {

        GodEquipGMsg.GResGodEquipPrivilege.Builder builder = GodEquipGMsg.GResGodEquipPrivilege.newBuilder();

        GodEquipLotteryInfo godEquipLotteryInfo = godEquipLotteryService.select(playerContext.getId());

        builder.setBuyStatus(godEquipLotteryInfo.getPrivilege());
        builder.setGetDay(godEquipLotteryInfo.getReceiveTime() > DateTimeUtil.dayBreak() ? 1 : 0);

        playerContext.write(CmdCode._58017, builder.build());
    }

    /**
     * 领取神装特权奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58018)
    public void getGodEquipPrivilegeReward(PlayerContext playerContext, GodEquipGMsg.GReqGetPrivilegeReward msg) {

        Asserts.isTrue(promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.GOD_EQUIP),
                ErrorCode.GODEQUIP_PRIVILEGE_NOT_BUY.getValue(), "神装特权未购买");

        GodEquipLotteryInfo godEquipLotteryInfo = godEquipLotteryService.select(playerContext.getId());

        Asserts.isTrue(godEquipLotteryInfo.getReceiveTime() < DateTimeUtil.dayBreak(),
                ErrorCode.GODEQUIP_PRIVILEGE_REWARD_RECEIVE.getValue(), "当天的神装特权奖励已领取");

        CPromotion010PrivilegeGift cPromotion010PrivilegeGift = promotion010PrivilegeGiftSysCache.getOrThrow(PrivilegeType.GOD_EQUIP.getValue());
        Asserts.isTrue(godEquipLotteryInfo.getReceiveDay() < cPromotion010PrivilegeGift.getLimit_day(),
                ErrorCode.GODEQUIP_PRIVILEGE_RECEIVE_DAY_MAX.getValue(), "神装特权奖励领取天数已达上限");

        godEquipLotteryInfo.setReceiveTime(DateTimeUtil.currentSecond());
        godEquipLotteryInfo.setReceiveDay(godEquipLotteryInfo.getReceiveDay() + 1);
        godEquipLotteryService.update(godEquipLotteryInfo);

        thingService.add(playerContext.getId(), cPromotion010PrivilegeGift.getItem(), GameEvent.GOD_EQUIP_PRIVILEGE_REWARD);

        GodEquipGMsg.GResGetPrivilegeReward.Builder builder = GodEquipGMsg.GResGetPrivilegeReward.newBuilder();
        builder.setGetDay(1);
        playerContext.write(CmdCode._58018, builder.build());

    }

}
