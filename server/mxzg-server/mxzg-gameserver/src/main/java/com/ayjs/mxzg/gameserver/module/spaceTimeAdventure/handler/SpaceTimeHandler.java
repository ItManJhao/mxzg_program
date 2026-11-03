package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.handler;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeAdventureSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeBoxSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeShopSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeAdventure;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBox;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleet;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetSkill;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeShop;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetSkillEnum;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingEndEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingProgressEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingStartEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeChooseInfoReqMessage;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeChooseInfoResMessage;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Component
public class SpaceTimeHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeAdventureSysCache spaceTimeAdventureSysCache;
    @Autowired
    private SpaceTimeFleetSysCache spaceTimeFleetSysCache;
    @Autowired
    private SpaceTimeFleetSkillSysCache spaceTimeFleetSkillSysCache;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private SpaceTimeShopSysCache spaceTimeShopSysCache;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SpaceTimeBoxSysCache spaceTimeBoxSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroLineUpService heroLineUpService;

    /**
     * 发送时空航线数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74120)
    public void sendSpaceTimeInfo(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqSpaceTimeAdventureInfo msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        SpaceTimeAdventureGMsg.GResSpaceTimeAdventureInfo.Builder builder = SpaceTimeAdventureGMsg.GResSpaceTimeAdventureInfo.newBuilder();
        builder.setNotRoute(spaceTimeInfo.getRouteId());
        builder.addAllUnlockRoute(spaceTimeInfo.getUnlockRoutes());
        builder.setEnergy(spaceTimeInfo.getEnergy());
        builder.setNotProgress(spaceTimeInfoService.getSailingProgress(spaceTimeInfo));
        builder.setEndTime(spaceTimeInfoService.getSailingEndTime(spaceTimeInfo));
        builder.setShopEndTime(spaceTimeInfo.getShopEndTime());
        builder.setStatus(builder.getEndTime() < DateTimeUtil.currentSecond() && builder.getEndTime() > 0 ? 1 : 0);
        spaceTimeInfo.getShopItems().forEach((key, value) -> {
            SpaceTimeAdventureGMsg.PSShopItemData.Builder item = SpaceTimeAdventureGMsg.PSShopItemData.newBuilder();
            item.setIdx(key);
            item.setBuyNum(value);
            builder.addShopList(item);
        });
        builder.setProductEndTime(spaceTimeInfo.getProductEndTime());
        builder.setProductId(spaceTimeInfo.getProductIdx());
        builder.setProductBuy(spaceTimeInfo.getProductBuy());
        builder.setSpeedBuff(spaceTimeInfo.getSpeedBuff() > 0 ? 1 : 0);
        playerContext.write(CmdCode._74120, builder.build());
    }

    /**
     * 发送航队信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74121)
    public void sendFleetInfo(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqFleetInfo msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        SpaceTimeAdventureGMsg.GResFleetInfo.Builder builder = SpaceTimeAdventureGMsg.GResFleetInfo.newBuilder();
        builder.setLevel(spaceTimeInfo.getFleetLevel());
        builder.setExp(spaceTimeInfo.getFleetExp());
        builder.setNick(spaceTimeInfo.getFleetName());
        builder.setDurability(spaceTimeInfo.getDurability());
        builder.setSkillNum(spaceTimeInfo.getSkillNum());
        spaceTimeInfo.getSkillMap().forEach((key, value) -> {
            builder.addSkill(spaceTimeInfoService.builderFleetSkill(key, value));
        });
        playerContext.write(CmdCode._74121, builder.build());
    }

    /**
     * 发送货航数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74122)
    public void sendCargoHoldInfo(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqCargoHoldInfo msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        SpaceTimeAdventureGMsg.GResCargoHoldInfo.Builder builder = SpaceTimeAdventureGMsg.GResCargoHoldInfo.newBuilder();
        spaceTimeInfo.getCargoHoldItem().forEach(immutableThing -> {
            builder.addItemList(PbUtil.buildReward(immutableThing));
        });
        spaceTimeInfo.getCargoHoldBox().forEach(fleetBoxInfo -> {
            builder.addGoodsList(spaceTimeInfoService.builderGoodsData(fleetBoxInfo.getBoxId(), fleetBoxInfo.getTime()));
        });
        playerContext.write(CmdCode._74122, builder.build());
    }

    /**
     * 选择航线
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74123)
    public void sendChooseRoute(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqChooseRoute msg) {
        CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(msg.getIdx());

        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.SPACE_TIME_WEAPON);
        Asserts.isTrue(heroLineUp.getFormationMap().size() > 0, ErrorCode.SPACE_TIME_HERO_LINEUP_NULL.getValue(),
                String.format("武器系统英雄阵容:{%s}为空", LineUpType.SPACE_TIME_WEAPON));

        heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.SPACE_TIME_IMPETUS);
        Asserts.isTrue(heroLineUp.getFormationMap().size() > 0, ErrorCode.SPACE_TIME_HERO_LINEUP_NULL.getValue(),
                String.format("动力系统英雄阵容:{%s}为空", LineUpType.SPACE_TIME_IMPETUS));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        Asserts.isTrue(spaceTimeInfo.getRouteId() == 0, ErrorCode.SPACE_TIME_FLEET_SAILING.getValue(),
                String.format("航队已在航行线路{%s}", spaceTimeInfo.getRouteId()));

        Asserts.isTrue((cSpaceTimeAdventure.getRoute_type() == 1 && cSpaceTimeAdventure.getFleet_level() <= spaceTimeInfo.getFleetLevel())
                        || spaceTimeInfo.getUnlockRoutes().contains(msg.getIdx()), ErrorCode.SPACE_TIME_ROUTE_NOT_UNLOCK.getValue(),
                String.format("航线:{%s}未解锁", msg.getIdx()));

        spaceTimeInfo.setRouteId(msg.getIdx());
        spaceTimeInfo.setStartTime(DateTimeUtil.currentSecond());
        spaceTimeInfo.setRemakeTime(DateTimeUtil.currentSecond());
        spaceTimeInfoService.update(spaceTimeInfo);
        SpaceTimeAdventureGMsg.GResChooseRoute.Builder builder = SpaceTimeAdventureGMsg.GResChooseRoute.newBuilder();
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._74123, builder.build());

        eventBus.post(SailingStartEvent.of(playerContext.getId()));
    }

    /**
     * 技能升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74124)
    public void fleetSkillUp(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqFleetUpSkill msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        Asserts.notNull(FleetSkillEnum.valueOf(msg.getSkillType()), ErrorCode.SPACE_TIME_SKILL_NOT_EXISTS.getValue(),
                String.format("技能类型不存在{%s}", msg.getSkillType()));

        Asserts.isTrue(spaceTimeInfo.getRouteId() == 0, ErrorCode.SPACE_TIME_FLEET_SAILING.getValue(),
                String.format("舰队航行:{%s}中不可升级舰队技能", spaceTimeInfo.getRouteId()));

        Asserts.isTrue(spaceTimeInfo.getSkillMap().get(msg.getSkillType()) < spaceTimeFleetSkillSysCache.maxLevel(msg.getSkillType()),
                ErrorCode.SPACE_TIME_SKILL_MAX_LEVEL.getValue(), String.format("技能等级已达最大值{%s}", spaceTimeInfo.getSkillMap().get(msg.getSkillType())));

        Asserts.isTrue(spaceTimeInfo.getSkillNum() > 0, ErrorCode.SPACE_TIME_SKILL_NUM.getValue(), "技能点不足，不能升级");

        spaceTimeInfo.setSkillNum(spaceTimeInfo.getSkillNum() - 1);
        int newLevel = spaceTimeInfo.getSkillMap().get(msg.getSkillType()) + 1;
        spaceTimeInfo.getSkillMap().put(msg.getSkillType(), newLevel);
        //升级耐久度
        if (msg.getSkillType() == FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType()) {
            CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType(), newLevel);
            spaceTimeInfo.setDurability(cSpaceTimeFleetSkill.getFleet_endurance());
        }
        spaceTimeInfoService.update(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResFleetUpSkill.Builder builder = SpaceTimeAdventureGMsg.GResFleetUpSkill.newBuilder();
        builder.setSkillInfo(spaceTimeInfoService.builderFleetSkill(msg.getSkillType(), spaceTimeInfo.getSkillMap().get(msg.getSkillType())));
        builder.setSkillNum(spaceTimeInfo.getSkillNum());
        playerContext.write(CmdCode._74124, builder.build());
    }

    /**
     * 舰队维修
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74125)
    public void fleetRepair(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqFleetRepair msg) {

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");


        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType()
                , spaceTimeInfo.getSkillMap().getOrDefault(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType(), 1));
        Asserts.isTrue(spaceTimeInfo.getDurability() < cSpaceTimeFleetSkill.getFleet_endurance(), ErrorCode.SPACE_TIME_DURABILITY_MAX.getValue(),
                "舰队耐久度已满，无需维修");

        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        thingService.cost(playerContext.getId(), cSpaceTimeFleet.getRepair_cost(), GameEvent.FLEET_REPAIR_COST);

        //恢复耐久度
        spaceTimeInfoService.addDurability(spaceTimeInfo, cSpaceTimeFleet.getRegain_durability());

        SpaceTimeAdventureGMsg.GResFleetRepair.Builder builder = SpaceTimeAdventureGMsg.GResFleetRepair.newBuilder();
        builder.setDurability(spaceTimeInfo.getDurability());
        playerContext.write(CmdCode._74125, builder.build());

        eventBus.post(SailingProgressEvent.of(spaceTimeInfo.getRid()));
    }


    /**
     * 土著商店购买
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74126)
    public void buyShopItem(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqSpaceTimeShopBuy msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        Asserts.isTrue(spaceTimeInfo.getShopEndTime() > DateTimeUtil.currentSecond(), ErrorCode.SPACE_TIME_SHOP_CLOSE.getValue(),
                "商店已关闭");
        Asserts.isTrue(spaceTimeInfo.getShopItems().get(msg.getIdx()) != null, ErrorCode.SPACE_TIME_SHOP_NOT_ITEM.getValue(),
                "商店无该商品数据");
        CSpaceTimeShop cSpaceTimeShop = spaceTimeShopSysCache.getById(msg.getIdx());
        Asserts.isTrue(spaceTimeInfo.getShopItems().get(msg.getIdx()) < cSpaceTimeShop.getBuy_limit(),
                ErrorCode.SHOP_BUY_TIMES_NOT_ENOUGH.getValue(), "商品无达购买次数上限");

        thingService.cost(playerContext.getId(), cSpaceTimeShop.getCost(), GameEvent.SPACE_TIME_SHOP_COST);

        CSpaceTimeBox cSpaceTimeBox = spaceTimeBoxSysCache.getOrThrow(cSpaceTimeShop.getBox_id());
        spaceTimeInfoService.addFleetBox(playerContext.getId(), cSpaceTimeBox.getIdx());

        spaceTimeInfo.getShopItems().put(msg.getIdx(), spaceTimeInfo.getShopItems().get(msg.getIdx()) + 1);
        spaceTimeInfoService.update(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResSpaceTimeShopBuy.Builder builder = SpaceTimeAdventureGMsg.GResSpaceTimeShopBuy.newBuilder();
        spaceTimeInfo.getShopItems().forEach((key, value) -> {
            SpaceTimeAdventureGMsg.PSShopItemData.Builder item = SpaceTimeAdventureGMsg.PSShopItemData.newBuilder();
            item.setIdx(key);
            item.setBuyNum(value);
            builder.addShopList(item);
        });
        builder.setIdx(msg.getIdx());
        builder.setEndTime(spaceTimeInfo.getShopEndTime());
        playerContext.write(CmdCode._74126, builder.build());

    }

    /**
     * 修改航队名字
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74127)
    public void modifyFleetNick(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqModifyName msg) {

        String fleetName = msg.getName();
        //字节长度限制
        int size = StringUtil.getShowLength(fleetName);
        final String fleetNameTemp = fleetName;
        Asserts.isTrue(size >= 1 && size <= SpaceTimeAdventureConst.SPACETIME_NAME_MAX,
                ErrorCode.SPACE_TIME_FLEET_NAME_LENGTH_LIMIT.getValue(), () -> String.format("fleet name:%s", fleetNameTemp));

        //敏感字符验证
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(sensitiveWordService.wordCanUse(fleetName,role), ErrorCode.ROLE_NICK_SENSITIVE.getValue(),
                () -> String.format("航队名字出现敏感字符{%s},{%s}", fleetName, sensitiveWordService.findConfigSensitiveWord(fleetName,role)));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        spaceTimeInfo.setFleetName(fleetName);
        spaceTimeInfoService.update(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResModifyName.Builder builder = SpaceTimeAdventureGMsg.GResModifyName.newBuilder();
        builder.setName(fleetName);
        playerContext.write(CmdCode._74127, builder.build());
    }

    /**
     * 航队探索
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74128)
    public void fleetExplore(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqFleetRepair msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        // Asserts.isTrue(spaceTimeInfo.getEventId() == 0, ErrorCode.SPACE_TIME_EVENT.getValue(), "上一个事件尚未执行或没放弃");
        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");
        Asserts.isTrue(spaceTimeInfo.getEnergy() > 0, ErrorCode.SPACE_TIME_ENERGY_NULL.getValue(), "舰队体力值为空");

        //获取航线事件
        List<CSpaceTimeEventShow> eventList = spaceTimeEventShowSysCache.getMap(spaceTimeInfo.getRouteId()).stream().filter(config -> {
            //若有隐藏航线事件，则检查当前航线所有的隐藏隐线是否已解锁
            FleetEventType fleetEventType = FleetEventType.valueOf(config.getEvent_id());

            if (config.getEvent_id() == FleetEventType.YIN_CANG_HANG_XIAN.getEventId()) {
                return spaceTimeInfoService.containsRoute(spaceTimeInfo, config);
            } else if (config.getEvent_id() == FleetEventType.TU_ZHU_SHANG_REN.getEventId()) {
                return spaceTimeInfo.getShopEndTime() == 0 || spaceTimeInfo.getShopEndTime() < DateTimeUtil.currentSecond();
            } else if (fleetEventType.getUnique() == 1 && fleetEventType.getEventId() != FleetEventType.HANG_XIAN_LI_BAO.getEventId()) {
                return !spaceTimeInfo.getEventIds().contains(config.getEvent_id());
            } else {
                return fleetEventType.getEventId() != FleetEventType.HANG_XIAN_LI_BAO.getEventId();
            }
        }).collect(Collectors.toList());
        //查看是否触发有航线礼包事件
        CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(spaceTimeInfo.getRouteId());
        int progress = (int) ((double) spaceTimeInfoService.getSailingProgress(spaceTimeInfo) / (double) cSpaceTimeAdventure.getTotalProgress()
                * (double) GameConstant.WAN);
        if (progress >= SpaceTimeAdventureConst.SPACETIME_OPEN_PRODUCT_SAIL_PROGRESS &&
                !spaceTimeInfo.getEventIds().contains(FleetEventType.HANG_XIAN_LI_BAO.getEventId())) {
            spaceTimeEventShowSysCache.getMap(spaceTimeInfo.getRouteId()).stream().filter(config ->
                    config.getEvent_id() == FleetEventType.HANG_XIAN_LI_BAO.getEventId()).forEach(config -> {
                eventList.clear();
                eventList.add(config);
            });
        }
        //抽取事件
        CSpaceTimeEventShow cSpaceTimeEventShow = DropUtil.randomDrop(eventList);

        //设置体力恢复起始时间点
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        spaceTimeInfo.setEnergyTime(spaceTimeInfo.getEnergy() == cSpaceTimeFleet.getEnergy() ? DateTimeUtil.currentSecond() : spaceTimeInfo.getEnergyTime());

        if (spaceTimeInfo.getNextEvent() > 0) {
            spaceTimeInfo.setEventId(spaceTimeInfo.getNextEvent());
            spaceTimeInfo.setNextEvent(0);
        } else {
            spaceTimeInfo.setEventId(cSpaceTimeEventShow.getEvent_id());
        }

        spaceTimeInfo.setEnergy(spaceTimeInfo.getEnergy() - 1);
        //若事件是不需执行事件。需添加要事件遭遇列表
        if (FleetEventType.valueOf(spaceTimeInfo.getEventId()).getUnique() == 1 &&
                !spaceTimeInfo.getEventIds().contains(spaceTimeInfo.getEventId())) {
            spaceTimeInfo.getEventIds().add(spaceTimeInfo.getEventId());
        }
        spaceTimeInfoService.update(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResFleetExplore.Builder builder = SpaceTimeAdventureGMsg.GResFleetExplore.newBuilder();
        builder.setEnergy(spaceTimeInfo.getEnergy());
        builder.setEventType(spaceTimeInfo.getEventId());
        playerContext.write(CmdCode._74128, builder.build());

        eventBus.post(SailingExploreEvent.of(playerContext.getId(), spaceTimeInfo.getRouteId(), spaceTimeInfo.getEventId()));
    }

    /**
     * 放弃事件
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74129)
    public void quiteEvent(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqQuitEvent msg) {
        SpaceTimeAdventureGMsg.GResQuiteEvent.Builder builder = SpaceTimeAdventureGMsg.GResQuiteEvent.newBuilder();

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        builder.setEventId(spaceTimeInfo.getEventId());
        spaceTimeInfo.setEventId(0);
        spaceTimeInfoService.update(spaceTimeInfo);

        playerContext.write(CmdCode._74129, builder.build());
    }

    /**
     * 查看掠夺航队信息(匹配)
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74130)
    public void chooseEnemyInfo(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqEnemyInfo msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");
        Asserts.isTrue(spaceTimeInfo.getEventId() == FleetEventType.QI_TA_JIAN_DUI.getEventId(),
                ErrorCode.SPACE_TIME_FLEET_EVENT_NOT_MATCHING.getValue(), String.format("执行事件{%s}与目标事件不匹配", spaceTimeInfo.getEventId()));

        Role role = roleService.getOrThrow(playerContext.getId());

        SpaceTimeChooseInfoReqMessage.SpaceTimeChooseInfoReqMessageBuilder message = SpaceTimeChooseInfoReqMessage.builder();
        message.rid(role.getId());
        message.fighting(role.getMaxFighting());
        message.level(role.getLevel());
        message.serverId(role.getServerId());
        message.lastEnemy(spaceTimeInfo.getLastEnemy());
        messageDispatcher.dispatch(message.build());
    }

    @RemoteMethod
    public void chooseEnemyInfo(SpaceTimeChooseInfoResMessage message) {
        SpaceTimeAdventureGMsg.GResEnemyInfo.Builder builder = SpaceTimeAdventureGMsg.GResEnemyInfo.newBuilder();

        Asserts.isTrue(message.isTurn(), ErrorCode.SPACE_TIME_NOT_ENEMY.getValue(), String.format("尚未匹配到敌人无法挑战,rid:{%s}", message.getRid()));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(message.getRid());
        spaceTimeInfo.getEnemyInfo().setNick(message.getNick());
        spaceTimeInfo.getEnemyInfo().setServerId(message.getServerId());
        for (Map.Entry<Integer, byte[]> entry : message.getBattlerMap().entrySet()) {
            spaceTimeInfo.getEnemyInfo().getEnemyMap().put(entry.getKey(), ProtostuffUtil.deserialize(entry.getValue(), BattlerVo.class));
        }
        spaceTimeInfo.setLastEnemy(message.getNick());
        spaceTimeInfoService.update(spaceTimeInfo);

        builder.setServiceId(spaceTimeInfo.getEnemyInfo().getServerId());
        builder.setEnemyNick(spaceTimeInfo.getEnemyInfo().getNick());
        contextManager.write(message.getRid(), CmdCode._74130, builder.build());
    }

    /**
     * 执行事件
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74131)
    public void executeEvent(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqExecuteEvent msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");
        Asserts.isTrue(spaceTimeInfo.getEventId() == msg.getEventType(), ErrorCode.SPACE_TIME_FLEET_EVENT_NOT_MATCHING.getValue(),
                String.format("执行事件：{%s}与当前事件：{%s}不匹配", msg.getEventType(), spaceTimeInfo.getEventId()));
        Asserts.notNull(FleetEventType.valueOf(msg.getEventType()), ErrorCode.SPACE_TIME_FLEET_EVENT_NOT_EXISTS.getValue(),
                String.format("航行事件不存在{%s}", msg.getEventType()));
        Asserts.isTrue(FleetEventType.valueOf(msg.getEventType()).getIs_executor() == 1, ErrorCode.SPACE_TIME_FLEET_NOT_EVENT.getValue(),
                "该事件不需要执行");
        //执行事件
        spaceTimeInfoService.executor(FleetEventType.valueOf(msg.getEventType()), spaceTimeInfo, msg.getBattleType());

        //清除事件
        spaceTimeInfo.setEventId(0);
        //增加遭遇事件
        if (!spaceTimeInfo.getEventIds().contains(msg.getEventType())) {
            spaceTimeInfo.getEventIds().add(msg.getEventType());
        }
        spaceTimeInfoService.update(spaceTimeInfo);
    }

    /**
     * 验证上阵重复
     *
     * @param playerContext
     * @param msg
     */
/*    @CMD(id = CmdCode._74141)
    public void verifyHeroLineUp(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqVerifyHeroLineUP msg) {
        List<Long> heroIds = new ArrayList<>();
        for (BattleGMsg.PSLineUpData psLineUpData : msg.getLineDataList()) {
            for (BattleGMsg.PSLineUpHeroData upHeroData : psLineUpData.getHeroListList()) {
                Asserts.isTrue(!heroIds.contains(upHeroData.getHeroId()), ErrorCode.SPACE_TIME_HERO_LINEUP.getValue(),
                        String.format("英雄上阵重复{%s}", upHeroData.getHeroId()));
                heroIds.add(upHeroData.getHeroId());
            }
        }
        //英雄上阵
        for (BattleGMsg.PSLineUpData psLineUpData : msg.getLineDataList()) {
            heroLineUpService.saveLineUpFormation(playerContext.getId(), psLineUpData);
        }
        playerContext.write(CmdCode._74141, SpaceTimeAdventureGMsg.GResVerifyHeroLineUp.getDefaultInstance());

    }*/

    /**
     * 航行结算
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74142)
    public void sendSailingEnd(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqSailingEnd msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");

        int endTime = spaceTimeInfoService.getSailingEndTime(spaceTimeInfo);
        Asserts.isTrue(DateTimeUtil.currentSecond() >= endTime, ErrorCode.SPACE_TIME_SAILING_NOT_FINISHED.getValue(),
                String.format("当前航行未结束,endTime:{%s}", endTime));

        //结算
        List<ImmutableThing> rewardList = spaceTimeInfoService.settlement(spaceTimeInfo);

        //清除当前航行数据
        spaceTimeInfoService.cleanSailingData(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResSailingEnd.Builder builder = SpaceTimeAdventureGMsg.GResSailingEnd.newBuilder();
        rewardList.forEach(immutableThing -> {
            ObjectGMsg.PSBackpackData.Builder data = ObjectGMsg.PSBackpackData.newBuilder();
            data.setType(immutableThing.getItem_type());
            data.setNum(immutableThing.getItem_num());
            builder.addItemList(data);
        });
        builder.setExp(spaceTimeInfo.getFleetExp());
        builder.setLevel(spaceTimeInfo.getFleetLevel());
        playerContext.write(CmdCode._74142, builder.build());

        eventBus.post(SailingEndEvent.of(spaceTimeInfo.getRid()));
    }

    /**
     * 发送解锁图鉴
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74144)
    public void sendIllustrate(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqSailingIllustrate msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());

        SpaceTimeAdventureGMsg.GResSailingIllustrate.Builder builder = SpaceTimeAdventureGMsg.GResSailingIllustrate.newBuilder();
        builder.addAllUnlockEvent(spaceTimeInfo.getUnlockEvent());
        playerContext.write(CmdCode._74144, builder.build());
    }


    @CMD(id = CmdCode._74146)
    public void sendSailingInfo(PlayerContext playerContext, SpaceTimeAdventureGMsg.GReqSailingInfo msg) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(playerContext.getId());
        SpaceTimeAdventureGMsg.GResSailingInfo.Builder builder = SpaceTimeAdventureGMsg.GResSailingInfo.newBuilder();
        builder.setEnergy(spaceTimeInfo.getEnergy());
        builder.setNotProgress(spaceTimeInfoService.getSailingProgress(spaceTimeInfo));
        builder.setEndTime(spaceTimeInfoService.getSailingEndTime(spaceTimeInfo));
        playerContext.write(CmdCode._74146, builder.build());
    }
}
