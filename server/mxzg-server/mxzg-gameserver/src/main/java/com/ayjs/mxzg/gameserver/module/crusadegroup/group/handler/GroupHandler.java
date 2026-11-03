package com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler;


import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.Nonnull;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupNpcSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.NpcFormation;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupation;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.converter.CrusadeGroupConverter;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.RoleCrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.EvaluationType;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.BossHurtEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.CityOccupyEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.CityOpenEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.message.module.crusadegroup.group.MapDataReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.MapDataResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.RegistrationReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.message.module.crusadegroup.map.AttackTerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.AttackTerritoryResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.BattleReportReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.BattleReportResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ChallengeRecordReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ChallengeRecordResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.EssenceSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.FightingSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GiveUpTerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GroupInfoReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GroupInfoResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ReclaimSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.RenameReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.SmallMapReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.SmallMapResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.StartBattleReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.StartBattleResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.ChallengeRecord;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.GroupMember;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.TerritoryGarrison;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Controller
public class GroupHandler extends ProtocolHandler {

    @Autowired
    private ClanService clanService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private GroupService groupService;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private OccupationSysCache occupationSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CrusadeGroupDao crusadeGroupDao;
    @Autowired
    private RoleCrusadeGroupDao roleCrusadeGroupDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CrusadeGroupConverter crusadeGroupConverter;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildSysCache;
    @Autowired
    private CrusadeGroupNpcSysCache crusadeGroupNpcSysCache;

    /**
     * 请求讨伐团信息
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75650)
    public void handleReqCrusadeGroupInfo(PlayerContext context, CrusadeGroupGMsg.GReqCrusadeGroupInfo message){
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        CrusadeGroupGMsg.GResCrusadeGroupInfo.Builder builder = CrusadeGroupGMsg.GResCrusadeGroupInfo.newBuilder();
        boolean registration = crusadeGroup.isClosed() ? false : roleCrusadeGroup.isRegistration();
        builder.setStage(crusadeGroup.getStage()).setRegistration(registration);
        builder.setRegistrationStartTime(LocalDateTimeUtil.toEpochSecond(crusadeGroup.getRegistrationStartTime()));
        builder.setRegistrationEndTime(LocalDateTimeUtil.toEpochSecond(crusadeGroup.getRegistrationEndTime()));
        builder.setBattleStartTime(LocalDateTimeUtil.toEpochSecond(crusadeGroup.getBattleStartTime()));
        builder.setBattleEndTime(LocalDateTimeUtil.toEpochSecond(crusadeGroup.getBattleEndTime()));
        context.write(CmdCode._75650, builder.build());
    }

    /**
     * 报名
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75651)
    public void handleReqCrusadeGroupInfo(PlayerContext context, CrusadeGroupGMsg.GReqRegistration message){
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_REGISTRATION.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_REGISTRATION_STAGE.getValue(),
                ()->String.format("讨伐团不处于报名阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        Asserts.isTrue(!roleCrusadeGroup.isRegistration(), ErrorCode.ALREADY_SIGNED_UP.getValue(),
                ()->String.format("讨伐团已经报名%s", roleCrusadeGroup.isRegistration()));

        Clan clan = clanService.getRole2Clan(context.getId());
        Asserts.notNull(clan, ErrorCode.MUST_JOIN_THE_GUILD_FIRST.getValue(),
                ()->String.format("必须先加入公会%s", context.getId()));

        messageDispatcher.dispatch(RegistrationReqMessage.valueOf(context.getId(), clan.getClanIcon()), result-> {
            Role role = roleService.getOrThrow(context.getId());
            roleCrusadeGroup.setRegistration(true);
            roleCrusadeGroup.setMaxFighting(role.getMaxFighting());
            roleCrusadeGroupDao.update(roleCrusadeGroup);
            context.write(CmdCode._75651, CrusadeGroupGMsg.GResRegistration.getDefaultInstance());
        });
    }

    /**
     * 请求主界面数据
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75653)
    public void handleResCrusadeGroupMain(PlayerContext context, CrusadeGroupGMsg.GResCrusadeGroupMain message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());

        CrusadeGroupGMsg.GResCrusadeGroupMain.Builder builder = CrusadeGroupGMsg.GResCrusadeGroupMain.newBuilder();
        builder.setGroupId(crusadeGroup.getGroupId());
        builder.setLastOccupationId(roleCrusadeGroup.getLastOccupationId());
        builder.setProductivity(roleCrusadeGroup.getProductivity());
        builder.setKnighthoodId(roleCrusadeGroup.getKnighthoodId());
        builder.setForceNature(roleCrusadeGroup.getForceNature());
        builder.addAllTerritoryMark(crusadeGroupConverter.buildMarkList(roleCrusadeGroup.getMarks()));
        builder.addAllHero(crusadeGroupConverter.buildHeroBoxList(roleCrusadeGroup.getHeroes().values()));
        builder.setLastAcquisitionTime(LocalDateTimeUtil.toEpochSecond(roleCrusadeGroup.getLastSettlementTime()));
        context.write(CmdCode._75653, builder.build());
    }

    /**
     * 设置英雄
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75654)
    public void handleReqSetHeroes(PlayerContext context, CrusadeGroupGMsg.GReqSetHeroes message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        Hero hero = heroService.getHero(context.getId(), message.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), ()->String.format("英雄不存在%s", message.getHeroId()));

        CrusadeGroupHero boxHero = roleCrusadeGroup.getHeroes().get(message.getBoxId());
        Asserts.notNull(boxHero, ErrorCode.BACKPACK_BOX_ID_NOT_EXIST.getValue(), ()->String.format("背包id不存在%s", message.getBoxId()));

        Asserts.notNull(roleCrusadeGroup.verificationHeroId(message.getHeroId()), ErrorCode.HERO_ALREADY_SET.getValue(),
                ()->String.format("背包id不存在%s", message.getBoxId()));

        boxHero.setHeroId(message.getHeroId());
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.PSHeroBox heroBox = crusadeGroupConverter.buildHeroBox(boxHero);
        CrusadeGroupGMsg.GResSetHeroes builder = CrusadeGroupGMsg.GResSetHeroes.newBuilder().setHero(heroBox).build();
        context.write(CmdCode._75654, builder);
    }

    /**
     * 取消英雄上阵
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75655)
    public void handleReqCancelHero(PlayerContext context, CrusadeGroupGMsg.GReqCancelHero message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());

        Asserts.isTrue(roleCrusadeGroup.cancelHero(message.getBoxId(), true), ErrorCode.HERO_NOT_SET.getValue(),
                ()->String.format("英雄上阵取消失败boxId:%s", message.getBoxId()));

        groupService.refreshProductivity(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupHero boxHero = roleCrusadeGroup.getHero(message.getBoxId());
        CrusadeGroupGMsg.PSHeroBox heroBox = crusadeGroupConverter.buildHeroBox(boxHero);
        CrusadeGroupGMsg.GResCancelHero response = CrusadeGroupGMsg.GResCancelHero.newBuilder().setHero(heroBox).build();
        context.write(CmdCode._75655, response);
    }


    /**
     * 刷新英雄列表
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75656)
    public void handleReqRefreshHero(PlayerContext context, CrusadeGroupGMsg.GReqRefreshHero message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        groupService.recoveryPhysical(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.GResRefreshHero.Builder builder = CrusadeGroupGMsg.GResRefreshHero.newBuilder();
        for (CrusadeGroupHero hero : roleCrusadeGroup.getHeroes().values()) {
            CrusadeGroupGMsg.PSHeroBox heroBox = crusadeGroupConverter.buildHeroBox(hero);
            builder.addHeroBox(heroBox);
        }
        context.write(CmdCode._75656, builder.build());
    }


    /**
     * 请求地图数据
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75657)
    public void handleReqMapData(PlayerContext context, CrusadeGroupGMsg.GReqMapData message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal() ||
                        crusadeGroup.getStage() == CrusadeGroupStage.END_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        messageDispatcher.dispatch(MapDataReqMessage.valueOf(message.getBottomLeft().getX(), message.getBottomLeft().getY(), message.getUpperRight().getX(), message.getUpperRight().getY()), result->{
            MapDataResMessage res = (MapDataResMessage) result;
            CrusadeGroupGMsg.GResMapData.Builder builder = CrusadeGroupGMsg.GResMapData.newBuilder();
            builder.setMarkId(message.getMarkId());
            for (Territory territory : res.getTerritories()) {
                builder.addTerritory(crusadeGroupConverter.buildTerritory(territory));
            }
            context.write(CmdCode._75657, builder.build());
        });

    }


    /**
     * 查看领地(未占领的)
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75658)
    public void handleReqViewTerritory(PlayerContext context, CrusadeGroupGMsg.GReqViewTerritory message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal() ||
                        crusadeGroup.getStage() == CrusadeGroupStage.END_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        AttackTerritoryReqMessage req = AttackTerritoryReqMessage.valueOf(message.getTerritoryId());
        messageDispatcher.dispatch(req, result -> {
            AttackTerritoryResMessage resMessage = (AttackTerritoryResMessage)result;
            CrusadeGroupGMsg.GResViewTerritory.Builder builder = CrusadeGroupGMsg.GResViewTerritory.newBuilder();
            builder.setTerritoryId(message.getTerritoryId());
            builder.setElement(resMessage.getElement());
            builder.setRefreshCountdown(resMessage.getRefreshCountdown());
            builder.setOccupied(resMessage.isOccupied());
            builder.setStar(resMessage.getStar());
            builder.setGuardTime(resMessage.getGuardTime());
            builder.setChallengerName(Nonnull.or(resMessage.getChallengerName(), ""));
            builder.addAllDeadHeroId(resMessage.getDeadHeroIds());
            EvaluationType type = null;
            for (TerritoryGarrison garrison : resMessage.getGarrisons()) {
                builder.addFormation(crusadeGroupConverter.buildFrom(garrison));
                if (Objects.isNull(type)) {
                    type = roleCrusadeGroup.getEvaluation(garrison.getFighting());
                }
            }

            type = Nonnull.or(type, EvaluationType.SIMPLE);

            builder.setEvaluation(type.ordinal());
            context.write(CmdCode._75658, builder.build());
        });
    }

    /**
     * 请求被占领的领地信息
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75659)
    public void handleReqOccupiedTerritory(PlayerContext context, CrusadeGroupGMsg.GReqOccupiedTerritory message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal() ||
                        crusadeGroup.getStage() == CrusadeGroupStage.END_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        TerritoryReqMessage reqMessage = TerritoryReqMessage.valueOf(message.getTerritoryId());
        messageDispatcher.dispatch(reqMessage, result -> {
            TerritoryResMessage resMessage = (TerritoryResMessage)result;
            CrusadeGroupGMsg.GResOccupiedTerritory.Builder builder = CrusadeGroupGMsg.GResOccupiedTerritory.newBuilder();
            builder.setBorderId(resMessage.getBorderId()).setElement(resMessage.getElement());
            builder.setHeadId(resMessage.getHeadId()).setServerId(resMessage.getServerId());
            builder.setNick(resMessage.getNick()).setOccupiedId(resMessage.getOccupiedId());
            context.write(CmdCode._75659, builder.build());
        });
    }

    /**
     * 开始战斗
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75660)
    public void handleReqStartFighting(PlayerContext context, CrusadeGroupGMsg.GReqStartFighting message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        Role role = roleService.getOrThrow(context.getId());

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());

        groupService.recoveryPhysical(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(message.getTerritoryId());
        CCrusadeGroupBuild crusadeGroupBuild = crusadeGroupBuildSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());

        BattleType battleType = ConvertUtils.toEnum(crusadeGroupBuild.getBattletype(), BattleType.class);
        BattlerDo battlerDo = battleHelper.queryPlayerBattler(battleType, context.getId(), Faction.ATTACKER);

        List<Long> heroIds = battlerDo.getHeros().stream().map(HeroDo::getId).collect(Collectors.toList());
        Asserts.isTrue(roleCrusadeGroup.checkPhysicalStrength(crusadeGroupBuild.getCost_energy(), heroIds), ErrorCode.THE_HERO_IS_WEAK.getValue(),
                () -> String.format("英雄体力不足%s", crusadeGroupBuild.getCost_energy()));

        NpcFormation npc = crusadeGroupNpcSysCache.getFormation(message.getFormationId());
        Asserts.notNull(npc, ErrorCode.TERRITORY_DATA_ERROR.getValue(), () -> String.format("%s阵容数据错误", message.getFormationId()));

        COccupation occupation = occupationSysCache.getOrThrow(roleCrusadeGroup.getKnighthoodId());
        Asserts.isTrue(roleCrusadeGroup.getTerritoryNum() < occupation.getLandNum(), ErrorCode.TERRITORY_UP_LIMIT.getValue(),
                () -> String.format("领地达到上限%s，COccupation:%s", roleCrusadeGroup.getTerritoryNum(), occupation.getLandNum()));

        int fighting = battleTemplate.computeStrength(battlerDo);
        if (roleCrusadeGroup.updateMaxFighting(fighting)) {
            messageDispatcher.dispatch(FightingSynchMessage.valueOf(context.getId(), roleCrusadeGroup.getMaxFighting()));
        }

        String battleVo = JSON.toJSONString(battlerDo.toBattlerVo());
        StartBattleReqMessage req = StartBattleReqMessage.valueOf(context.getId(), role.getNick(), message.getTerritoryId(), message.getFormationId(), battleVo);
        messageDispatcher.dispatch(req, result -> {

            StartBattleResMessage resMessage = (StartBattleResMessage)result;
            CrusadeGroupGMsg.GResStartFighting.Builder builder = CrusadeGroupGMsg.GResStartFighting.newBuilder();
            if (resMessage.getLanguageId() != 0) {
                builder.setLanguageId(resMessage.getLanguageId());
                context.write(CmdCode._75660, builder.build());
                return;
            }

            builder.setFormationId(message.getFormationId());
            builder.setOccupied(resMessage.isOccupied());
            builder.setTerritoryId(message.getTerritoryId());
            builder.setNum(resMessage.getNum());
            builder.setTotalNum(resMessage.getTotalNum());
            builder.setRefreshCountdown(resMessage.getRefreshCountdown());
            builder.setGuardTime(resMessage.getGuardTime());
            builder.setBossTotalDamage(resMessage.getBossTotalDamage());
            builder.setBossDamage(resMessage.getBossDamage());
            BattleGMsg.BattleReport battleReport = null;
            try {
                battleReport = BattleGMsg.BattleReport.parseFrom(resMessage.getBattleReport());
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
            builder.setReport(battleReport);

            int costEnergy = crusadeGroupBuild.getCost_energy();
            if(battleReport.getWinId() == battleReport.getAttacker().getPlayerId()){
                List<Integer> stars = groupService.buildEvaluationBy(battleReport);
                builder.addAllStart(stars);
                costEnergy -= groupService.getPhysicalRecoveryBy(stars);
            }

            roleCrusadeGroup.costEnergy(costEnergy, heroIds);

            if(npc.isFinalBoss()){
                long totalDamage = battleReport.getLog().getAttackerLog().getHeroLogList().stream().mapToLong(BattleGMsg.HeroLog::getTotalDamage).sum();
                eventBus.post(BossHurtEvent.of(context.getId(), totalDamage));
                roleCrusadeGroup.updateBossHurt(totalDamage);
            }

            if (resMessage.isOccupied() && crusadeGroupBuild.isSpace()) {

                Territory territory = Territory.valueOf(message.getTerritoryId(), context.getId(), resMessage.getElement(), 0);
                roleCrusadeGroup.occupationTerritory(territory);

                eventBus.post(CityOccupyEvent.of(context.getId(), map.getArea_level(), map.getBuilding_level(), 1));
            }
            roleCrusadeGroupDao.update(roleCrusadeGroup);

            context.write(CmdCode._75660, builder.build());
        });
    }

    /**
     * 开发领地
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75661)
    public void handleReqDevelopment(PlayerContext context, CrusadeGroupGMsg.GReqDevelopment message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());

        CCrusadeGroupMap crusadeGroupMap = crusadeGroupMapSysCache.getMap(message.getTerritoryId());

        Optional<CrusadeGroupHero> hero = roleCrusadeGroup.getHeroBy(message.getHeroId());
        if (hero.isPresent()) {
            int territoryId = hero.get().getDevelopmentTerritoryId();
            if (territoryId != 0) {
                roleCrusadeGroup.cancelDevelopment(territoryId);
                messageDispatcher.dispatch(ReclaimSynchMessage.valueOf(context.getId(), territoryId, 0));
            }
        }

        Asserts.isTrue(roleCrusadeGroup.developmentTerritory(message.getTerritoryId(), message.getHeroId()), ErrorCode.TERRITORY_RECLAMATION_FAILED.getValue(),
                ()-> String.format("领地开发失败英雄id:%s,领地id：%s", message.getHeroId(), message.getTerritoryId()));

        Territory territory = roleCrusadeGroup.getTerritory(message.getTerritoryId());
        territory.development(message.getHeroId());
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        eventBus.post(CityOpenEvent.of(context.getId(), crusadeGroupMap.getBuilding_level(),1));

        CrusadeGroupGMsg.GResDevelopment.Builder builder = CrusadeGroupGMsg.GResDevelopment.newBuilder();
        builder.setTerritory(crusadeGroupConverter.buildTerritory(territory));
        context.write(CmdCode._75661, builder.build());

        messageDispatcher.dispatch(ReclaimSynchMessage.valueOf(context.getId(), message.getTerritoryId(), message.getHeroId()));
    }

    /**
     * 放弃领地开发
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75662)
    public void handleReqCancelDevelopment(PlayerContext context, CrusadeGroupGMsg.GReqCancelDevelopment message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());

        roleCrusadeGroup.cancelDevelopment(message.getTerritoryId());
        groupService.refreshProductivity(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.GResCancelDevelopment.Builder builder = CrusadeGroupGMsg.GResCancelDevelopment.newBuilder();
        Territory territory = roleCrusadeGroup.getTerritory(message.getTerritoryId());
        builder.setTerritory(crusadeGroupConverter.buildTerritory(territory));
        context.write(CmdCode._75662, builder.build());

        messageDispatcher.dispatch(ReclaimSynchMessage.valueOf(context.getId(), message.getTerritoryId(), 0));
    }

    /**
     * 收取资源
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75664)
    public void handleReqCollectResources(PlayerContext context, CrusadeGroupGMsg.GReqCollectResources message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        int essenceNumber = groupService.collectEssence(roleCrusadeGroup);
        Asserts.isTrue(essenceNumber > 0, ErrorCode.NO_RESOURCES_TO_CHARGE.getValue(), ()-> String.format("没有资源可以收取:%s", essenceNumber));

        groupService.addShenBinItem(context.getId(), essenceNumber);

        Map<Integer, Long> shenBinMap = groupService.collectShenBin(roleCrusadeGroup);

        groupService.addShenBin(context.getId(), shenBinMap);

        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.GResCollectResources.Builder builder = CrusadeGroupGMsg.GResCollectResources.newBuilder();
        builder.setForceNature(essenceNumber);
        builder.setLastAcquisitionTime(LocalDateTimeUtil.toEpochSecond(roleCrusadeGroup.getLastSettlementTime()));
        shenBinMap.forEach((id, num) -> {
            builder.addShenBin(CrusadeGroupGMsg.PSShenBin.newBuilder().setId(id).setNum(num).build());
        });

        messageDispatcher.dispatch(EssenceSynchMessage.valueOf(context.getId(), essenceNumber));

        context.write(CmdCode._75664, builder.build());
    }

    /**
     * 请求小地图
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75665)
    public void handleReqViewSmallMap(PlayerContext context, CrusadeGroupGMsg.GReqViewSmallMap message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        if(message.getPage() == 0){
            CrusadeGroupGMsg.GResViewSmallMap.Builder builder = CrusadeGroupGMsg.GResViewSmallMap.newBuilder();
            builder.setPage(message.getPage()).setTotalPage(1);
            builder.addAllTerritoryId(roleCrusadeGroup.getTerritoryInfo().keySet());
            context.write(CmdCode._75665, builder.build());
            return;
        }

        messageDispatcher.dispatch(SmallMapReqMessage.valueOf(context.getId(), message.getPage()), result->{
            SmallMapResMessage res = (SmallMapResMessage) result;
            CrusadeGroupGMsg.GResViewSmallMap.Builder builder = CrusadeGroupGMsg.GResViewSmallMap.newBuilder();
            builder.setPage(res.getPage());
            builder.setTotalPage(res.getTotalPage());
            builder.addAllTerritoryId(res.getTerritoryIds());
            context.write(CmdCode._75665, builder.build());
        });
    }


    /**
     * 放弃领地
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75666)
    public void handleReqGiveUpTerritory(PlayerContext context, CrusadeGroupGMsg.GReqGiveUpTerritory message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        Asserts.isTrue(roleCrusadeGroup.getTerritoryNum() > 1, ErrorCode.CANT_GIVE_UP_THE_ONLY_TERRITORY.getValue(),
                () -> String.format("不能放弃唯一领地"));

        messageDispatcher.dispatch(GiveUpTerritoryReqMessage.valueOf(message.getTerritoryId()), result-> {
            roleCrusadeGroup.giveUpTerritory(message.getTerritoryId());

            groupService.refreshProductivity(roleCrusadeGroup);
            roleCrusadeGroupDao.update(roleCrusadeGroup);
            CrusadeGroupGMsg.GReqGiveUpTerritory.Builder builder = CrusadeGroupGMsg.GReqGiveUpTerritory.newBuilder();
            builder.setTerritoryId(message.getTerritoryId());
            context.write(CmdCode._75666, builder.build());
        });

    }


    /**
     * 刷新领地列表
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75667)
    public void handleReqTerritory(PlayerContext context, CrusadeGroupGMsg.GReqTerritory message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal() ||
                        crusadeGroup.getStage() == CrusadeGroupStage.END_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        CrusadeGroupGMsg.GResTerritory.Builder builder = CrusadeGroupGMsg.GResTerritory.newBuilder();
        for (Territory territory : roleCrusadeGroup.getTerritoryInfo().values()) {
            builder.addTerritory(crusadeGroupConverter.buildTerritory(territory));
        }
        context.write(CmdCode._75667, builder.build());
    }

    /**
     * 标记
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75668)
    public void handleReqMark(PlayerContext context, CrusadeGroupGMsg.GReqMark message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        Asserts.isTrue(StringUtil.isNotBlank(message.getName()), ErrorCode.TERRITORY_NAME_ILLEGAL.getValue(),
                () -> String.format("领地名字不合法%s", message.getName()));

        Role role = roleService.getOrThrow(context.getId());
        Asserts.isTrue(sensitiveWordService.wordCanUse(message.getName(), role), ErrorCode.TERRITORY_NAME_ILLEGAL.getValue(),
                () -> String.format("领地名字不合法%s", message.getName()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        roleCrusadeGroup.mark(message.getTerritoryId(), message.getName());

        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.GResMark.Builder builder = CrusadeGroupGMsg.GResMark.newBuilder();
        builder.setMark(CrusadeGroupGMsg.PSTerritoryMark.newBuilder().setTerritoryId(message.getTerritoryId()).setName(message.getName()).build());
        context.write(CmdCode._75668, builder.build());
    }

    /**
     * 取消标记
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75669)
    public void handleReqUnmark(PlayerContext context, CrusadeGroupGMsg.GReqUnmark message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(context.getId());
        roleCrusadeGroup.unMark(message.getTerritoryId());
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        CrusadeGroupGMsg.GResUnmark.Builder builder = CrusadeGroupGMsg.GResUnmark.newBuilder();
        builder.setTerritoryId(message.getTerritoryId());
        context.write(CmdCode._75669, builder.build());
    }


    /**
     * 请求讨伐团信息
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75671)
    public void handleGReqGroupInfo(PlayerContext context, CrusadeGroupGMsg.GReqGroupInfo message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal() ||
                        crusadeGroup.getStage() == CrusadeGroupStage.END_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        messageDispatcher.dispatch(GroupInfoReqMessage.getInstance(), result-> {
            GroupInfoResMessage resMessage = (GroupInfoResMessage)result;
            CrusadeGroupGMsg.GResGroupInfo.Builder builder = CrusadeGroupGMsg.GResGroupInfo.newBuilder();
            builder.setEmblem(resMessage.getEmblem()).setGroupId(resMessage.getGroupId()).setName(resMessage.getGroupName())
                    .setRenameNumber(resMessage.getRenameNumber()).setEndTime(LocalDateTimeUtil.toEpochSecond(crusadeGroup.getBattleEndTime()));
            for (GroupMember member : resMessage.getMembers()) {
                CrusadeGroupGMsg.PSCrusaders.Builder crusaders = CrusadeGroupGMsg.PSCrusaders.newBuilder();
                crusaders.setBorderId(member.getBorder_id()).setHeadId(member.getHead_id()).setKnighthoodId(member.getKnighthoodId());
                crusaders.setPosition(member.getPosition()).setLastOfflineTime(member.getLast_offline_time()).setFighting(member.getFighting());
                crusaders.setGuildName(member.getGuild_name()).setRid(member.getRid()).setNick(member.getNick()).setLevel(member.getLevel()).setServerId(member.getServerId());
                builder.addCrusaders(crusaders.build());
            }
            context.write(CmdCode._75671, builder.build());
        });
    }


    /**
     * 请求boss挑战记录
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75672)
    public void handleGReqBossChallengeRecord(PlayerContext context, CrusadeGroupGMsg.GReqBossChallengeRecord message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        messageDispatcher.dispatch(ChallengeRecordReqMessage.valueOf(message.getTerritoryId()), result-> {
            ChallengeRecordResMessage resMessage = (ChallengeRecordResMessage)result;
            CrusadeGroupGMsg.GResBossChallengeRecord.Builder builder = CrusadeGroupGMsg.GResBossChallengeRecord.newBuilder();
            builder.setTerritoryId(message.getTerritoryId());

            for (ChallengeRecord record : Nonnull.orEmpty(resMessage.getRecords())) {
                CrusadeGroupGMsg.PSChallengeRecord.Builder psRecord = CrusadeGroupGMsg.PSChallengeRecord.newBuilder();
                psRecord.setBorderId(record.getBorder_id()).setHeadId(record.getHead_id()).setLevel(record.getLevel());
                psRecord.setDamage(record.getTotalDamage()).setRid(record.getRid()).setNick(record.getNick());
                psRecord.setBattleId(record.getBattleId()).setServerId(record.getServerId());
                builder.addRecords(psRecord);
            }
            context.write(CmdCode._75672, builder.build());
        });

    }

    /**
     * 请求boss挑战战报
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75673)
    public void handleGReqBossReport(PlayerContext context, CrusadeGroupGMsg.GReqBossReport message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        messageDispatcher.dispatch(BattleReportReqMessage.valueOf(context.getId(), message.getBattleId()), result-> {
            BattleReportResMessage resMessage = (BattleReportResMessage)result;
            CrusadeGroupGMsg.GResBossReport.Builder builder = CrusadeGroupGMsg.GResBossReport.newBuilder();
            try {
                BattleGMsg.BattleReport battleReport = BattleGMsg.BattleReport.parseFrom(resMessage.getReport());
                builder.setReport(battleReport);
                context.write(CmdCode._75673, builder.build());
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
        });
    }

    /**
     * 请求改名
     * @param context
     * @param message
     */
    @CMD(id = CmdCode._75674)
    public void handleGReqGroupRename(PlayerContext context, CrusadeGroupGMsg.GReqGroupRename message) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        Asserts.isTrue(crusadeGroup.getStage() == CrusadeGroupStage.START_BATTLE.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_OPEN_STAGE.getValue(),
                ()->String.format("讨伐团不处于战斗阶段%s", crusadeGroup.getStage()));

        String groupName = message.getName().trim().replaceAll("\r|\n", "");

        Asserts.isTrue(StringUtils.isNotBlank(groupName), ErrorCode.GROUP_NAME_NOT_EMPTY.getValue(),  () -> String.format("clan name is blank"));

        Role role = roleService.getOrThrow(context.getId());

        int size = StringUtil.getShowLength(groupName);
        final String finalGroupName = groupName;
        Asserts.isTrue(size >= 1 && size <= CrusadeGroupConst.GROUP_NAME_LENGTH,
                ErrorCode.GROUP_NAME_TOO_LONG.getValue(), () -> String.format("group name:%s", finalGroupName));

        Asserts.isTrue(GameConstant.NAME_PATTERN.matcher(groupName).matches(), ErrorCode.GROUP_NAME_UNAVAILABLE.getValue(),
                () -> String.format("讨伐团名格式不对!name:%s", finalGroupName));

        Asserts.isTrue(sensitiveWordService.wordCanUse(groupName, role), ErrorCode.GROUP_NAME_UNAVAILABLE.getValue(),
                () -> String.format("group name:%s contains sensitive word :%s", finalGroupName,
                        sensitiveWordService.findConfigSensitiveWord(finalGroupName, role)));

        Asserts.isTrue(crusadeGroup.getHead() == context.getId(), ErrorCode.ONLY_THE_GROUP_LEADER_CAN_RENAME.getValue(),
                ()-> String.format("只有团长%s可以重命名%s", crusadeGroup.getHead(), context.getId()));

        Asserts.isTrue(crusadeGroup.isInRenameTime(), ErrorCode.NOT_WITHIN_THE_RENAME_TIME.getValue(),
                ()-> String.format("不再重命名时间内"));
        messageDispatcher.dispatch(RenameReqMessage.valueOf(context.getId(), groupName), result-> {
            crusadeGroup.setGroupName(groupName);//名字
            crusadeGroupDao.update(crusadeGroup);
            CrusadeGroupGMsg.GResGroupRename.Builder builder = CrusadeGroupGMsg.GResGroupRename.newBuilder();
            builder.setName(finalGroupName);
            context.write(CmdCode._75674, builder.build());
        });
    }

}
