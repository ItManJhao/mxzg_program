package com.ayjs.mxzg.cross.module.ladder.handler;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.constant.CrossLadderConstant;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadder;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderData;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRobot;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRole;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderRobotService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderRoleService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.ladder.dao.LadderLikeRedisDao;
import com.ayjs.mxzg.message.module.ladder.domain.LadderLike;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRankReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRankResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderChallengeReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderChallengeResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefenderData;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefendersReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefendersResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderLikeNumAddReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderLikeNumAddResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderRankReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderRankResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderSuperiorBattleMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 跨服天梯
 */
@Slf4j
@Component
public class CrossLadderHandler implements MessageHandler {

    @Autowired
    private CrossLadderService crossLadderService;
    @Autowired
    private CrossLadderRobotService crossLadderRobotService;
    @Autowired
    private LadderLikeRedisDao ladderLikeRedisDao;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private CrossLadderRoleService crossLadderRoleService;

    /**
     * 跨服天梯点赞锁
     */
    private final static String CROSS_LADDER_LIKE_LOCK = "CROSS_LADDER_LIKE_LOCK";

    /**
     * 获取全部排行榜
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public CrossLadderRankResMessage getAllRanks(CrossLadderRankReqMessage message, Connection connection) {
        CrossGroup crossGroup = crossServerGroupService.getCrossGroup(message.getServerId());

        CrossLadder crossLadder = crossLadderService.getCrossLadder(crossGroup.getGroupId());
        Map<Integer, CrossLadderRank> rankMap = crossLadderService.rankMapAll(crossLadder);
        return CrossLadderRankResMessage.of(rankMap, true, crossLadderService.getCrossLadderDateTime(), 0);
    }

    /**
     * 获取防守队伍
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public LadderDefendersResMessage ladderDefenders(LadderDefendersReqMessage message) {
        // 判断活动是否开启
        LadderDefendersResMessage resMessage = new LadderDefendersResMessage();
        if (!crossLadderService.isLadderOpen()) {
            log.error("ladder not open date time:{}", DateTimeUtil.date());
            return resMessage;
        }

        CrossGroup crossGroup = crossServerGroupService.getCrossGroup(message.getServerId());

        long rid = message.getRid();

        List<CrossLadderData> defenderLadderList = crossLadderService.match(crossGroup.getGroupId(), rid);

        List<LadderDefenderData> defenders = defenderLadderList.stream()
                .map(crossLadderService::toLadderDefenderData).collect(Collectors.toList());
        resMessage.setDefenders(defenders);
        return resMessage;
    }

    /**
     * 请求排名信息
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public LadderRankResMessage ladderRank(LadderRankReqMessage message) {
        long rid = message.getRid();
        int serverId = message.getServerId();
        CrossGroup crossGroup = crossServerGroupService.getCrossGroup(serverId);
        CrossLadder crossLadder = crossLadderService.getCrossLadder(crossGroup.getGroupId());
        int rank = 0;
        if (Objects.nonNull(crossLadder)) {
            rank = crossLadder.getRank(rid);
        }
        LadderRankResMessage resMessage = new LadderRankResMessage();
        resMessage.setRid(rid);
        resMessage.setRank(rank);
        return resMessage;
    }

    /**
     * 请求战斗信息
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public void ladderChallenge(LadderChallengeReqMessage message) {
        // 进攻方
        int attackServerId = message.getAttackServerId();
        long attackRid = message.getAttackRid();
        try {
            // 判断活动是否开启
            Asserts.isTrue(crossLadderService.isLadderOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(),
                    ()-> StrUtil.format("ladder not open date time:{}",
                            DateTimeUtil.date()));

            CrossGroup crossGroup = crossServerGroupService.getCrossGroup(message.getAttackServerId());

            Asserts.notNull(crossGroup, ErrorCode.LADDER_NOT_OPEN.getValue(),
                    ()-> StrUtil.format("ladderChallenge crossGroup is null serverId:{}",
                            message.getAttackServerId()));

            CrossLadder crossLadder = crossLadderService.getCrossLadder(crossGroup.getGroupId());
            Asserts.notNull(crossLadder, ErrorCode.LADDER_NOT_OPEN.getValue(),
                    ()-> StrUtil.format("crossLadder is null, serverId:{} groupId:{}",
                            message.getAttackServerId(), crossGroup.getGroupId()));


            CrossLadderData attackerLadder = crossLadder.getCrossLadderData(attackRid);
            CrossRole attackerRole = crossRoleService.getOrThrow(attackRid);

            long defendRid = message.getDefendRid();
            // 判断是否是机器人
            CrossLadderRobot robot = crossLadderRobotService.getRobot(defendRid);
            boolean isRobot = Objects.isNull(robot);
            CrossLadderData defenderLadder = crossLadder.getCrossLadderData(defendRid);

            String defenderNick = "";
            int defenderHeadId = 0;
            int defenderBorderId = 0;
            int defenderLevel = 0;
            int defenderFighting = 0;
            if (isRobot) {
                CrossRole defenderRole = crossRoleService.getOrThrow(defendRid);
                defenderNick = defenderRole.getNick();
                defenderHeadId = defenderRole.getHeadId();
                defenderBorderId = defenderRole.getBorderId();
                defenderLevel = defenderRole.getLevel();
                defenderFighting = defenderRole.getFighting();
            } else {
                defenderNick = robot.getNick();
                defenderHeadId = robot.getHeadId();
                defenderBorderId = robot.getBorderId();
                defenderLevel = robot.getLevel();
                defenderFighting = robot.getFighting();
            }

            int attackOldRank = crossLadder.getRank(attackRid);
            int defendOldRank = crossLadder.getRank(defendRid);
            // 大神战斗
            boolean superiorBattle = false;
            if (isRobot && attackOldRank > 0 && defendOldRank > 0
                    && attackOldRank <= CrossLadderConstant.SUPERIOR_BATTLE_RANK
                    && defendOldRank <= CrossLadderConstant.SUPERIOR_BATTLE_RANK) {
                superiorBattle = true;
            }

            // 判断排名是否有变化
            if (defendOldRank != message.getDefendRank()) {
                // 排名变化
                log.debug("defend rank change old rank:{}, new rank:{}", defendOldRank, message.getDefendRank());
                LadderChallengeResMessage attackerResMessage = new LadderChallengeResMessage();
                attackerResMessage.setOperatorCode(1);
                attackerResMessage.setServerId(attackServerId);
                attackerResMessage.setRid(attackRid);
                messageHelper.pushToMessage(attackerResMessage);
                return;
            }

            BattlerVo attackBattlerVo = ProtostuffUtil.deserialize(message.getAttackBattlerVo(), BattlerVo.class);
            BattlerDo attacker = battleTemplate.queryBattler(attackBattlerVo, attackerRole.getNick(), Faction.ATTACKER, UnitType.HERO);
            attacker.setRoleInfo(attackServerId, attackerRole.getHeadId(), attackerRole.getBorderId(), attackerRole.getLevel(), attackerRole.getFighting());

            CrossLadderRole atkRole = crossLadderRoleService.getLadderRole(attackRid);
            atkRole.setBattlerVo(attackBattlerVo);
            atkRole.setFighting(message.getAtkFighting());
            crossLadderRoleService.update(atkRole);

            // 防守方
            int defendServerId = message.getDefendServerId();
            BattlerVo defenderBattlerVo = ProtostuffUtil.deserialize(message.getDefendBattlerVo(), BattlerVo.class);
            BattlerDo defender = battleTemplate.queryBattler(defenderBattlerVo, defenderNick, Faction.DEFENDER, UnitType.HERO);
            defender.setRoleInfo(defendServerId, defenderHeadId, defenderBorderId, defenderLevel, defenderFighting);

            // 计算战斗
            BattleCommand battleCommand = BattleCommand.createOf(BattleType.LADDER_ATTACK, attacker, defender);
            commandBus.invoke(battleCommand);
            BattleResult battleResult = battleCommand.getResult();
            byte[] battleReportBytes = battleResult.getReport().toByteArray();

            List<LadderDefenderData> newAttackerLadder = Collections.emptyList();
            List<LadderDefenderData> newDefenderLadderList = Collections.emptyList();

            // 比防守方排名高时才替换排名，并且重新匹配
            boolean exchangeRank = false;
            if (battleResult.isWin()) {
                if (attackOldRank <= 0 || attackOldRank > defendOldRank) {
                    crossLadderService.exchangeRank(attackRid, attackServerId, defendRid, crossLadder);
                    List<CrossLadderData> attackerLadderList = crossLadderService.match(crossGroup.getGroupId(), attackRid);
                    newAttackerLadder = attackerLadderList.stream().map(crossLadderService::toLadderDefenderData).collect(Collectors.toList());
                    List<CrossLadderData> defenderLadderList = crossLadderService.match(crossGroup.getGroupId(), defendRid);
                    newDefenderLadderList = defenderLadderList.stream().map(crossLadderService::toLadderDefenderData).collect(Collectors.toList());
                    exchangeRank = true;
                } else {
                    log.debug("not change rank attackOldRank:{},defendOldRank:{}", attackOldRank, defendOldRank);
                }
            } else {
                log.debug("battle is win:{}", battleResult.isWin());
            }

            int attackNewRank = crossLadder.getRank(attackRid);
            int defendNewRank = crossLadder.getRank(defendRid);

            LadderChallengeResMessage attackerResMessage = new LadderChallengeResMessage();
            attackerResMessage.setBattleReport(battleReportBytes);
            attackerResMessage.setRid(attackRid);
            attackerResMessage.setServerId(attackServerId);
            attackerResMessage.setAttackNewDefends(newAttackerLadder);
            attackerResMessage.setAttackRank(attackNewRank);
            attackerResMessage.setDefendNewDefends(Collections.emptyList());// 给默认值
            attackerResMessage.setDefendRank(defendNewRank);// 给默认值
            attackerResMessage.setDefendReallyPlayer(isRobot);
            attackerResMessage.setSuperiorBattle(superiorBattle);
            attackerResMessage.setExchangeRank(exchangeRank);
            messageHelper.pushToMessage(attackerResMessage);

            if (isRobot) {
                LadderChallengeResMessage defenderResMessage = new LadderChallengeResMessage();
                defenderResMessage.setBattleReport(battleReportBytes);
                defenderResMessage.setRid(defendRid);
                defenderResMessage.setServerId(defendServerId);
                defenderResMessage.setAttackNewDefends(Collections.emptyList());// 给默认值
                defenderResMessage.setAttackRank(attackNewRank);// 给默认值
                defenderResMessage.setDefendNewDefends(newDefenderLadderList);
                defenderResMessage.setDefendRank(defendNewRank);
                defenderResMessage.setSuperiorBattle(superiorBattle);
                defenderResMessage.setExchangeRank(exchangeRank);
                messageHelper.pushToMessage(defenderResMessage);
            }

            if (battleResult.isWin()) {
                // 广播跨服组所有游戏服
                Map<Integer, CrossLadderRank> rankMap = new HashMap<>();
                rankMap.put(attackNewRank,
                        crossLadderService.toCrossLadderRank(attackRid, attackerLadder));
                rankMap.put(defendNewRank,
                        crossLadderService.toCrossLadderRank(defendRid, defenderLadder));
                CrossLadderRankResMessage rankResMessage = CrossLadderRankResMessage.of(rankMap, false, null, 0);
                messageHelper.pushToGroupMessage(crossGroup.getGroupId(), rankResMessage);
            }
            // 大神战斗
            if (superiorBattle) {
                LadderSuperiorBattleMessage superiorMessage = LadderSuperiorBattleMessage.of(attackOldRank, defendOldRank, battleReportBytes);
                messageHelper.pushToGroupMessage(crossGroup.getGroupId(), superiorMessage);
            }
        } catch (Exception e){
            e.printStackTrace();
            log.debug("defend rank change rid:{}, new rank:{}", message.getDefendRid(), message.getDefendRank());
            LadderChallengeResMessage attackerResMessage = new LadderChallengeResMessage();
            attackerResMessage.setOperatorCode(1);
            attackerResMessage.setServerId(attackServerId);
            attackerResMessage.setRid(attackRid);
            messageHelper.pushToMessage(attackerResMessage);
        }
    }

    /**
     * 点赞计数
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public LadderLikeNumAddResMessage likeNumAdd(LadderLikeNumAddReqMessage message) {
        int rank = message.getRank();
        LadderLikeNumAddResMessage resMessage = new LadderLikeNumAddResMessage();
        if (rank > CrossLadderConstant.LIKE_NUMBER) {
            log.error("likeNumAdd LadderLike rank too big rank:{}", rank);
            return resMessage;
        }
        CrossGroup crossGroup = crossServerGroupService.getCrossGroup(message.getServerId());
        if (Objects.isNull(crossGroup)) {
            log.error("crossGroup is null serverId:{}", message.getServerId());
            return resMessage;
        }

        synchronized (InternerPool.intern(CROSS_LADDER_LIKE_LOCK, crossGroup.getGroupId())) {
            LadderLike ladderLike = ladderLikeRedisDao.get(LadderLike.getKey(crossGroup.getGroupId(), rank));
            if (Objects.nonNull(ladderLike)) {
                ladderLike.setLikeNum(ladderLike.getLikeNum() + 1);
                ladderLikeRedisDao.addOrUpdate(ladderLike);
            } else {
                log.error("likeNumAdd LadderLike is null rank:{}", rank);
            }

        }
        return resMessage;
    }
}
