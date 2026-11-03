package com.ayjs.mxzg.cross.module.crusadegroup.group.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupCycleSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupNpcSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.NpcFormation;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.crusadegroup.converter.CrusadeGroupConverter;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeGroupRegistrationDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeGroupRegistration;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.BossHurtChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.BossHurtPChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemPChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.CrusadeGroupDataManager;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.CrusadeWorker;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadeGroupMapDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadersDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusadeGroupMap;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusaders;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.NpcForce;
import com.ayjs.mxzg.message.module.chat.message.CrossCruGroupChatMessage;
import com.ayjs.mxzg.message.module.crusadegroup.CrusadeGroupReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.CrusadeGroupResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmCleanBeaterMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteNextReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteNextResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteOccupiedReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteOccupiedResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteResetReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteResetResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.MapDataReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.MapDataResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.RegistrationReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.RegistrationResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.message.module.crusadegroup.map.AttackTerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.AttackTerritoryResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.BattleReportReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.BattleReportResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.BossBeatMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ChallengeRecordReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ChallengeRecordResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.EssenceSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.FightingSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GiveUpTerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GiveUpTerritoryResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GroupInfoReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.GroupInfoResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.KnighthoodSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.ReclaimSynchMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.RenameReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.RenameResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.SmallMapReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.SmallMapResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.StartBattleReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.StartBattleResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryUpdateMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.ChallengeRecord;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.GroupMember;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.TerritoryGarrison;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleReportManager;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.google.common.collect.Lists;
import io.netty.util.internal.StringUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 跨服讨伐团消息处理器
 */
@Slf4j
@Component
public class CrossCrusadeGroupMessageHandler implements MessageHandler {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private CrusadeSystemDao crusadeSystemDao;
    @Autowired
    private CrossCrusadersDao crossCrusadersDao;
    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;
    @Autowired
    private CrusadeGroupRegistrationDao crusadeGroupRegistrationDao;
    @Autowired
    private CrossCrusadeGroupMapDao crossCrusadeGroupMapDao;
    @Autowired
    private CrusadeWorker crusadeWorker;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private CrusadeGroupDataManager crusadeGroupDataManager;
    @Autowired
    private CrusadeGroupConverter crusadeGroupConverter;
    @Autowired
    private CrusadeGroupCycleSysCache crusadeGroupCycleSysCache;

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private BattleReportManager battleReportManager;
    @Autowired
    private CrusadeGroupNpcSysCache crusadeGroupNpcSysCache;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildSysCache;
    /**
     * gm执行下一个阶段
     * @return
     */
    @RemoteMethod
    public GmExecuteNextResMessage handleGmExecuteNextMessage(GmExecuteNextReqMessage message){
        CrusadeSystem system = crusadeSystemDao.get();
        CCrusadeGroupCycle next = crusadeGroupCycleSysCache.getById(system.getCycleId()+ 1);
        crusadeWorker.executeCycle(next);
        crusadeWorker.openDebug();
        return GmExecuteNextResMessage.valueOf(system.getStage());
    }

    /**
     * gm重置阶段
     * @return
     */
    @RemoteMethod
    public GmExecuteResetResMessage handleGmExecuteResetMessage(GmExecuteResetReqMessage message){
        CrusadeSystem system = crusadeSystemDao.get();
        CCrusadeGroupCycle next = crusadeGroupCycleSysCache.getFirstCycle();
        crusadeWorker.executeCycle(next);
        crusadeWorker.openDebug();
        return GmExecuteResetResMessage.valueOf(system.getStage());
    }

    /**
     * gm占领指定领地
     *
     * @return
     */
    @RemoteMethod
    public GmExecuteOccupiedResMessage handleGmExecuteOccupiedReqMessage(GmExecuteOccupiedReqMessage message, Connection connection) {
        CrusadeSystem system = crusadeSystemDao.get();
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);

        map.occupiedTerritory(message.getRid(), message.getTerritoryId(), false);
        int element = system.getElement(message.getTerritoryId());
        messageHelper.pushToServers(TerritoryUpdateMessage.valueOf(message.getTerritoryId(), element, message.getRid(), 0), map.getServer_id());

        return GmExecuteOccupiedResMessage.valueOf(message.getTerritoryId(), element);
    }

    /**
     * gm占领指定领地
     *
     * @return
     */
    @RemoteMethod
    public void handleGmExecuteOccupiedReqMessage(GmCleanBeaterMessage message, Connection connection) {
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        int bossTerritoryId = 25066;
        NpcForce npcForce = map.getNpcForce(bossTerritoryId);
        if(Objects.isNull(npcForce)){
            npcForce = crusadeGroupDataManager.generateNpcForce(bossTerritoryId);
        }

        for (Integer formationId : npcForce.getBattlerVoMap().keySet()) {
            NpcFormation npc = crusadeGroupNpcSysCache.getFormation(formationId);
            if(!npc.isFinalBoss()){
                npcForce.beat(formationId);
            }
        }

        crossCrusadeGroupMapDao.update(map);

    }



    /**
     * 请求讨伐团信息
     * @param message
     */
    @RemoteMethod
    public void handleCrusadeGroupReqMessage(CrusadeGroupReqMessage message, Connection connection) {
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        log.info("服务器{}请求讨伐团信息", serverId);
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        if (crusadeSystem == null) {
            log.error("讨伐团数据为空，请求失败！");
            return;
        }

        CrusadeGroupResMessage.CrusadeGroupResMessageBuilder resMessage = CrusadeGroupResMessage.builder();
        resMessage.stage(crusadeSystem.getStage());
        resMessage.registrationStartTime(crusadeSystem.getRegistrationStartTime());
        resMessage.registrationEndTime(crusadeSystem.getRegistrationEndTime());
        resMessage.battleStartTime(crusadeSystem.getBattleStartTime());
        resMessage.battleEndTime(crusadeSystem.getBattleEndTime());

        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(serverId);
        if(group != null){
            resMessage.groupId(group.getId());
            resMessage.groupMapId(group.getMapId());
            resMessage.head(group.getHeadId());
            resMessage.commander(group.getCommander());
            resMessage.emblem(group.getEmblem());
            resMessage.groupName(group.getGroupName());
        }

        connection.send(resMessage.build());
    }

    /**
     * 请求报名
     * @param message
     */
    @RemoteMethod
    public RegistrationResMessage handleRegistrationReqMessage(RegistrationReqMessage message, Connection connection){
        log.info("玩家{}报名讨伐团", message.getRid());

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        Asserts.isTrue(crusadeSystem.getStage() == CrusadeGroupStage.START_REGISTRATION.ordinal(), ErrorCode.CRUSADE_GROUP_NOT_REGISTRATION_STAGE.getValue(),
                ()->String.format("讨伐团不处于报名阶段%s", crusadeSystem.getStage()));

        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrusadeGroupRegistration registration = crusadeGroupRegistrationDao.getOrCreate(serverId);
        Asserts.isTrue(!registration.isSignUp(message.getRid()), ErrorCode.ALREADY_SIGNED_UP.getValue(),
                ()->String.format("讨伐团已经报名%s", message.getRid()));

        registration.signUp(message.getRid(), message.getEmblem());
        crusadeGroupRegistrationDao.update(registration);

        return RegistrationResMessage.getInstance();
    }

    /**
     * 请求地图数据
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public MapDataResMessage handleMapDataResMessage(MapDataReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        List<Territory> rangeTerritory = crusadeGroupDataManager.getTerritoryRange(serverId, message.getBottomLeftX(), message.getBottomLeftY(), message.getUpperRightX(), message.getUpperRightY());
        return MapDataResMessage.valueOf(rangeTerritory);
    }

    /**
     * 请求领地数据
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public TerritoryResMessage handleTerritoryReqMessage(TerritoryReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        long occupiedId = map.getOccupiedId(message.getTerritoryId());

        int element = crusadeSystem.getElement(message.getTerritoryId());
        if(occupiedId != 0){
            CrossRole crossRole = crossRoleService.getNotThrow(occupiedId);
            if(crossRole != null){
                return TerritoryResMessage.valueOf(occupiedId, element, crossRole.getNick(), crossRole.getBorderId(), crossRole.getHeadId(), crossRole.getServerId());
            }
        }

        return TerritoryResMessage.valueOf(0, element, StringUtil.EMPTY_STRING, 0, 0, 0);
    }

    /**
     * 请求领地数据
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public AttackTerritoryResMessage handleAttackTerritoryReqMessage(AttackTerritoryReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);

        CCrusadeGroupMap crusadeGroupMap = crusadeGroupMapSysCache.getMap(message.getTerritoryId());

        AttackTerritoryResMessage result = new AttackTerritoryResMessage();

        result.setTerritoryId(message.getTerritoryId());
        result.setElement(crusadeSystem.getElement(message.getTerritoryId()));
        result.setOccupied(map.isOccupied(message.getTerritoryId()));

        CCrusadeGroupBuild crusadeGroupBuild = crusadeGroupBuildSysCache.getBuild(crusadeGroupMap.getArea_level(), crusadeGroupMap.getBuilding_level(), crusadeGroupMap.getFight_type());
        if(crusadeGroupBuild != null){
            result.setStar(crusadeGroupBuild.getDefend_star());
        }

        if (!result.isOccupied()) {
            List<TerritoryGarrison> garrisons = new ArrayList<>();
            NpcForce npcForce = map.getNpcForce(message.getTerritoryId());
            if(Objects.isNull(npcForce)){
                npcForce = crusadeGroupDataManager.generateNpcForce(message.getTerritoryId());
            }

            for (Map.Entry<Integer, BattlerVo> entry : npcForce.getBattlerVoMap().entrySet()) {
                int fighting = npcForce.getFighting(entry.getKey());
                NpcFormation npc = crusadeGroupNpcSysCache.getFormation(entry.getKey());
                garrisons.add(crusadeGroupConverter.buildFrom(entry.getKey(), fighting, npc.isBoss(), entry.getValue(), npcForce.isBeat(entry.getKey())));
            }

            result.setDeadHeroIds(npcForce.getDefeatedHeroes());
            result.setGarrisons(garrisons);
            result.setRefreshCountdown(npcForce.getRefreshTime());
            result.setGuardTime(npcForce.getGuardTime());
            if(npcForce.getChallengerId() != 0){
                CrossRole crossRole = crossRoleService.getNotThrow(npcForce.getChallengerId());
                if(crossRole != null){
                    result.setChallengerName(crossRole.getNick());
                }
            }

        }
        return result;
    }

    /**
     * 攻击领地
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public StartBattleResMessage handleStartBattleReqMessage(StartBattleReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(serverId);
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);

        synchronized (map) {

            if (map.isOccupied(message.getTerritoryId())) {
                return StartBattleResMessage.createOf(ErrorCode.ALREADY_OCCUPIED.getValue());
            }

            NpcFormation npc = crusadeGroupNpcSysCache.getFormation(message.getFormationId());
            if (npc == null) {
                return StartBattleResMessage.createOf(ErrorCode.TERRITORY_DATA_ERROR.getValue());
            }

            NpcForce npcForce = map.getNpcForce(message.getTerritoryId());
            if (Objects.isNull(npcForce)) {
                npcForce = crusadeGroupDataManager.generateNpcForce(message.getTerritoryId());
                map.addNpcForce(npcForce);
            }

            if(npcForce.getChallengerId() != 0 && npcForce.getChallengerId() != message.getRid()){
                return StartBattleResMessage.createOf(ErrorCode.TERRITORY_UNDER_PROTECTION.getValue());
            }

            if (npcForce.isBeat(message.getFormationId())) {
                return StartBattleResMessage.createOf(ErrorCode.ENEMY_HAS_BEEN_DEFEATED.getValue());
            }

            if (npc.isBoss() && !npcForce.isOnlyBoss()) {
                return StartBattleResMessage.createOf(ErrorCode.MUST_DEFEAT_THE_GUARDS_FIRST.getValue());
            }

            BattlerVo battlerVo = npcForce.getBattler(message.getFormationId());
            BattlerDo defender = battleTemplate.queryBattler(battlerVo, battlerVo.getFirstHeroName(), Faction.DEFENDER, UnitType.MOSTER);

            BattlerVo attackerVo = JSON.parseObject(message.getBattleVo(), BattlerVo.class);
            BattlerDo attacker = battleTemplate.queryBattler(attackerVo, message.getNick(), Faction.ATTACKER, UnitType.HERO);

            BattleCommand command = BattleCommand.createOf(BattleType.CRUSADE_GROUP, attacker, defender);
            commandBus.invoke(command);

            StartBattleResMessage.StartBattleResMessageBuilder builder = StartBattleResMessage.builder();

            BattleResult battleResult = command.getResult();
            boolean occupied = false;
            long occupiedId = 0;
            if(battleResult.isWin()){
                npcForce.beat(message.getFormationId());
                occupied = npcForce.isBeatAll();
                if(occupied){
                    occupiedId = npc.isSpace() ? message.getRid() : CrusadeGroupConst.DEFAULT_OCCUPIED_ID;
                    if (npc.isFinalBoss()) {
                        npcForce.bossRefreshCountdown();
                        log.info("最终boss被击败开始刷新倒计时{}", LocalDateTimeUtil.ofEpochSecond(npcForce.getRefreshTime()));
                        messageHelper.pushToServers(BossBeatMessage.getInstance(), map.getServer_id());
                    } else {
                        map.occupiedTerritory(occupiedId, message.getTerritoryId(), npc.isBoss());
                    }
                }
            } else {
                BattlerVo atkVo = battleResult.buildAttackerVo();
                if (!npc.isFinalBoss()){
                    npcForce.addBeatHeroIds(atkVo.deadIds());
                }
            }
            BattlerVo defenderVo = battleResult.buildDefenderVo();
            npcForce.replace(message.getFormationId(), defenderVo);

            if(npc.isBoss()){
                long currentTotalDamage = battleResult.getReport().getLog().getAttackerLog().getHeroLogList().stream().mapToLong(BattleGMsg.HeroLog::getTotalDamage).sum();
                npcForce.addDamage(message.getRid(), currentTotalDamage, battleResult.getReport().getBattleId());
                if(npc.isFinalBoss()){
                    group.updateBossHurt(currentTotalDamage);
                    CrossCrusaders crusaders = crossCrusadersDao.get(message.getRid());
                    crusaders.updateBossHurt(currentTotalDamage);
                    crossCrusadersDao.update(crusaders);

                    builder.bossDamage(currentTotalDamage);
                    long totalDamage = npcForce.getTotalDamage(message.getRid());
                    builder.bossTotalDamage(totalDamage);

                    eventBus.post(BossHurtPChangeEvent.of(message.getRid(), crusaders.getBossHurt(), serverId));
                    eventBus.post(BossHurtChangeEvent.of(group.getId(), group.getBossHurtAll()));
                    long totalHp = defender.getHeros().stream().map(heroDo -> heroDo.getHp()).count();
                    log.info("最终boss[{}]的血量更新为:{}", map.getId(), totalHp);
                }

                battleReportManager.save(battleResult.getReport());
            }

            if (npc.isSpace() && npcForce.getRefreshTime() == 0) {
                npcForce.setRefreshTime(DateTimeUtil.currentSecond() + CrusadeGroupConst.NPC_RECOVERY_TIME_S);
            }

            if (!battleResult.isWin() && npc.isSpace() && npcForce.getChallengerId() == 0) {
                npcForce.setChallengerId(message.getRid());
                npcForce.setGuardTime(DateTimeUtil.currentSecond() + CrusadeGroupConst.CHALLENGE_PROTECTION_TIME_S);
            }

            crossCrusadeGroupDao.update(group);
            crossCrusadeGroupMapDao.update(map);
            int element = crusadeSystem.getElement(message.getTerritoryId());
            if(occupied){
                npcForce.setGuardTime(0);
                messageHelper.pushToServers(TerritoryUpdateMessage.valueOf(message.getTerritoryId(), element, occupiedId, 0), map.getServer_id());
            }

            int num = npcForce.getDefeatedFormationIds().size();
            int totalNum = npcForce.getBattlerVoMap().size();


            builder.territoryId(message.getTerritoryId()).formationId(message.getFormationId()).occupied(occupied).battleReport(battleResult.getReport().toByteArray());
            builder.element(crusadeSystem.getElement(message.getTerritoryId())).num(num).totalNum(totalNum).refreshCountdown(npcForce.getRefreshTime());
            builder.guardTime(npcForce.getGuardTime());

            return builder.build();
        }
    }


    /**
     * 请求小地图数据
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public SmallMapResMessage handleSmallMapReqMessage(SmallMapReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        int totalPage = map.getOccupiedId().size() / CrusadeGroupConst.PAGE_SIZE_NUM;
        List<Integer> occupiedIds = Lists.newArrayList(map.getOccupiedId().keySet().iterator());
        int fromIndex = (message.getPage() - 1) * CrusadeGroupConst.PAGE_SIZE_NUM;
        int toIndex = message.getPage() * CrusadeGroupConst.PAGE_SIZE_NUM;
        toIndex = Math.min(toIndex, occupiedIds.size());
        List<Integer> pageOccupiedIds = occupiedIds.subList(fromIndex, toIndex);
        List<Integer> selfIds = new ArrayList<>();
        for (Integer occupiedId : pageOccupiedIds) {
            if(map.getOccupiedId(occupiedId) == message.getRid()){
                selfIds.add(occupiedId);
            }
        }
        pageOccupiedIds.removeAll(selfIds);

        return SmallMapResMessage.valueOf(message.getPage(), totalPage, pageOccupiedIds);
    }

    /**
     * 讨伐团聊天
     *
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public void sendChatMessage(CrossCruGroupChatMessage message, Connection connection) {
        int serverId = sessionManager.getServerIdBy(connection.getClientId());

        CrossCrusadeGroup crossCrusadeGroup = crusadeGroupDataManager.getGroupBy(serverId);
        if (crossCrusadeGroup == null) {
            return;
        }
        message.setCruGroupT(0);//默认成员
        //团长
        if (crossCrusadeGroup.getHeadId() == message.getRid()) {
            message.setCruGroupT(1);
        }
        //指挥官
        if (crossCrusadeGroup.getCommander().contains(message.getRid())) {
            message.setCruGroupT(2);
        }
        //转发给讨伐团服务器器
        messageHelper.pushToServers(message, crossCrusadeGroup.getServer_id());
    }

    /**
     * 处理放弃领地
     * @param message
     * @param connection
     */
    @RemoteMethod
    public GiveUpTerritoryResMessage handleGiveUpTerritoryMessage(GiveUpTerritoryReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        map.giveUpTerritory(message.getTerritoryId());
        crossCrusadeGroupMapDao.update(map);


        messageHelper.pushToServers(TerritoryUpdateMessage.valueOf(message.getTerritoryId(), 0, 0, 0), map.getServer_id());

        return GiveUpTerritoryResMessage.getInstance();
    }

    /**
     * 请求成员信息
     * @param message
     * @param connection
     */
    @RemoteMethod
    public GroupInfoResMessage handleGroupInfoReqMessage(GroupInfoReqMessage message, Connection connection){
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(serverId);
        List<GroupMember> members = new ArrayList<>();
        for (Long memberId : group.getMembers()) {
            CrossRole crossRole = crossRoleService.getNotThrow(memberId);
            CrossCrusaders crusaders = crossCrusadersDao.get(memberId);
            if(crossRole != null){
                GroupMember.GroupMemberBuilder member = GroupMember.builder();
                member.guild_name(crossRole.getClanName()).nick(crossRole.getNick());
                member.border_id(crossRole.getBorderId()).head_id(crossRole.getHeadId());
                member.knighthoodId(crusaders.getKnighthoodId()).rid(memberId).position(group.getPosition(memberId).ordinal());
                int lastOffLineTime = crossRole.isOnline() ? 0 : (int)(crossRole.getLastOfflineTime()/1000);
                member.last_offline_time(lastOffLineTime).serverId(crossRole.getServerId());
                int fighting = crusaders.getFighting() == 0 ? crossRole.getMaxFighting() : crusaders.getFighting();
                member.fighting(fighting).level(crossRole.getLevel());
                members.add(member.build());
            }
        }

        return GroupInfoResMessage.valueOf(group.getId(), group.getGroupName(), group.getEmblem(), members, group.getRenameNumber());
    }



    /**
     * 请求boss挑战记录
     * @param message
     * @param connection
     */
    @RemoteMethod
    public ChallengeRecordResMessage handleChallengeRecordReqMessage(ChallengeRecordReqMessage message, Connection connection) {
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        NpcForce npcForce = map.getNpcForce(message.getTerritoryId());

        List<ChallengeRecord> records = new ArrayList<>();
        if (Objects.nonNull(npcForce)) {
            for (Long challenger : npcForce.getChallengers()) {
                CrossRole crossRole = crossRoleService.getNotThrow(challenger);
                if (crossRole == null) {
                    log.info("跨服玩家数据缺失{}", challenger);
                    continue;
                }

                ChallengeRecord.ChallengeRecordBuilder builder = ChallengeRecord.builder();
                builder.battleId(npcForce.getBattleId(challenger)).totalDamage(npcForce.getDamage(challenger));
                builder.border_id(crossRole.getBorderId()).head_id(crossRole.getHeadId()).level(crossRole.getLevel());
                builder.serverId(crossRole.getServerId()).nick(crossRole.getNick()).rid(crossRole.getId());
                records.add(builder.build());
            }
        }

        return ChallengeRecordResMessage.valueOf(message.getTerritoryId(), records);
    }

    /**
     * 爵位同步
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleKnighthoodSynchMessage(KnighthoodSynchMessage message, Connection connection) {
        log.info("{}爵位提升到{}", message.getRid(), message.getKnighthood_id());
//        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusaders crusaders = crossCrusadersDao.get(message.getRid());
        crusaders.setKnighthoodId(message.getKnighthood_id());
        crossCrusadersDao.update(crusaders);
    }

    /**
     * 神兵精华同步
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleEssenceSynchMessage(EssenceSynchMessage message, Connection connection) {
        log.info("{}精华增加{}", message.getRid(), message.getEssence());
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(serverId);
        group.updateShenBin(message.getEssence());
        crossCrusadeGroupDao.update(group);
        eventBus.post(ShenBinItemChangeEvent.of(group.getId(), group.getShenBinAll()));

        CrossCrusaders crusaders = crossCrusadersDao.get(message.getRid());
        crusaders.updateShenBin(message.getEssence());
        crossCrusadersDao.update(crusaders);

        eventBus.post(ShenBinItemPChangeEvent.of(message.getRid(), crusaders.getShenBin(), serverId));
    }

    /**
     * 战力精华同步
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleFightingSynchMessage(FightingSynchMessage message, Connection connection) {
        log.info("{}战力更新{}", message.getRid(), message.getFighting());

        CrossCrusaders crusaders = crossCrusadersDao.get(message.getRid());
        crusaders.setFighting(message.getFighting());
        crossCrusadersDao.update(crusaders);
    }


    /**
     * 开垦同步
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleReclaimSynchMessage(ReclaimSynchMessage message, Connection connection) {
        log.info("{}领地开垦同步{}", message.getTerritoryId(), message.getHeroId());
        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        CrossCrusadeGroupMap map = crusadeGroupDataManager.getMapBy(serverId);
        synchronized (map){
            map.reclaimTerritory(message.getTerritoryId(), message.getHeroId());
        }
        int element = crusadeSystem.getElement(message.getTerritoryId());
        messageHelper.pushToServers(TerritoryUpdateMessage.valueOf(message.getTerritoryId(), element, message.getRid(), message.getHeroId()), map.getServer_id());
        crossCrusadeGroupMapDao.update(map);
    }

    /**
     * 查询战报
     * @param message
     */
    @RemoteMethod
    public BattleReportResMessage scanBattleReport(BattleReportReqMessage message) {
        BattleGMsg.BattleReport report = battleReportManager.getReport(message.getBattleId());
        return BattleReportResMessage.valueOf(report.toByteArray());
    }


    /**
     * 请求改名
     * @param message
     */
    @RemoteMethod
    public RenameResMessage scanBattleReport(RenameReqMessage message, Connection connection) {
        log.info("{}讨伐团改名{}", message.getRid(), message.getName());

        int serverId = sessionManager.getServerIdBy(connection.getClientId());
        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(serverId);

        Asserts.isTrue(group.getRenameNumber() < CrusadeGroupConst.RENAME_NUMBER_UP_LIMIT, ErrorCode.RENAME_UP_LIMIT.getValue(), ()->
                String.format("达到重命名次数上限%s", group.getRenameNumber()));

        group.rename(message.getName());
        crossCrusadeGroupDao.update(group);
        return RenameResMessage.getInstance();
    }

}
