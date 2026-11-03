package com.ayjs.mxzg.largecross.module.stagematch.preliminaries.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroup;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.converter.PreliminariesConverter;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.service.PreliminariesService;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.*;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * 跨服天梯
 */
@Slf4j
@Component
public class PreliminariesHandler implements MessageHandler {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private PreliminariesService preliminariesService;
    @Autowired
    private PreliminariesConverter preliminariesConverter;

    /**
     * 跨服天梯点赞锁
     */
    private final static String CROSS_LADDER_LIKE_LOCK = "CROSS_LADDER_LIKE_LOCK";

    /**
     * 报告天梯消息
     * @param message
     */
    @RemoteMethod
    public void handleReportLadderMessage(ReportLadderMessage message){
        PreliminariesLadder preliminariesLadder = preliminariesLadderDao.getOrCreate(message.getRid());
        preliminariesLadder.setBattlerVo(message.getBattlerVo());
        preliminariesLadder.setFighting(message.getFighting());
        preliminariesLadderDao.update(preliminariesLadder);
    }

    /**
     * 获取全部排行榜
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public void getAllRanks(LeaderBoardReqMessage message, Connection connection) {
        CrossGroup group = sessionManager.getGroupByClientId(connection.getClientId());
        OpponentGroup opponentGroup = opponentGroupHolder.getGroup(group.getGroupId());
        if(opponentGroup == null){
            connection.send(LeaderBoardResMessage.of(Collections.emptyList()));
            return;
        }
        List<RankDto> ranking = opponentGroup.getPreliminariesRanking(PreliminariesConst.PRELIMINARIES_RANKS_NUMBER);
        connection.send(LeaderBoardResMessage.of(ranking));
    }

    /**
     * 获取防守队伍
     *
    * @param message
     * @return
     */
    @RemoteMethod
    public PreliminariesDefendersResMessage ladderDefenders(PreliminariesDefendersReqMessage message) {
        OpponentGroup opponentGroup = opponentGroupHolder.getGroupBy(message.getServerId());
        long rid = message.getRid();
        List<RankDto> defenderLadderList = preliminariesService.match(opponentGroup.getGroupId(), rid);
        return PreliminariesDefendersResMessage.of(defenderLadderList);
    }

    /**
     * 请求排名信息
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public PreliminariesRankResMessage ladderRank(PreliminariesRankReqMessage message) {
        PreliminariesLadder preliminariesLadder = preliminariesLadderDao.get(message.getRid());
        int rank = 0;
        if (Objects.nonNull(preliminariesLadder)) {
            rank = preliminariesLadder.getRank();
        }
        PreliminariesRankResMessage resMessage = new PreliminariesRankResMessage();
        resMessage.setRid(message.getRid());
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
    public PreliminariesChallengeResMessage ladderChallenge(PreliminariesChallengeReqMessage message) {
        PreliminariesChallengeResMessage attackerResMessage = new PreliminariesChallengeResMessage();

        long attackRid = message.getAttackRid();
        try {
            OpponentGroup opponentGroup = opponentGroupHolder.getGroupBy(message.getAttackServerId());

            if(opponentGroup == null){
                log.info("没有找到跨服分组{}", message.getAttackServerId());
                return PreliminariesChallengeResMessage.createOf(ErrorCode.NO_GROUP.getValue());
            }

            synchronized (opponentGroup) {
                PreliminariesLadder defenderPreliminariesLadder = preliminariesLadderDao.get(message.getDefendRid());
                PreliminariesLadder attackerPreliminariesLadder = preliminariesLadderDao.getOrCreate(message.getAttackRid());

                attackerPreliminariesLadder.updateBattleInfo(message.getAttackBattlerVo(), message.getAtkFighting());
                preliminariesLadderDao.update(attackerPreliminariesLadder);

                int defendOldRank = defenderPreliminariesLadder.getRank();

                if (defendOldRank == 0 || defenderPreliminariesLadder.getRank() != message.getDefendRank()) {
                    log.info("目标排名{}已经发生变化，请重新挑战", message.getDefendRank(), defendOldRank);
                    return PreliminariesChallengeResMessage.createOf(ErrorCode.THE_RANKING_HAS_CHANGED.getValue());
                }

                Opponent attackerOpponent = opponentDao.get(message.getAttackRid());
                Opponent defenderOpponent = opponentDao.get(message.getDefendRid());

                BattlerVo attackBattlerVo = JsonUtil.parseJson(message.getAttackBattlerVo(), BattlerVo.class);
                BattlerDo attacker = battleTemplate.queryBattler(attackBattlerVo, attackerOpponent.getName(), Faction.ATTACKER, UnitType.HERO);
                attacker.setRoleInfo(attackerOpponent.getServerId(), attackerOpponent.getHeadId(), attackerOpponent.getBorderId(), attackerOpponent.getLevel(), attackerOpponent.getFighting());

                String defenderBattleVo = StringUtil.isBlank(defenderPreliminariesLadder.getBattlerVo()) ? defenderOpponent.getBattlerVo() : defenderPreliminariesLadder.getBattlerVo();
                BattlerVo defenderBattlerVo = JsonUtil.parseJson(defenderBattleVo, BattlerVo.class);
                BattlerDo defender = battleTemplate.queryBattler(defenderBattlerVo, defenderOpponent.getName(), Faction.DEFENDER, UnitType.HERO);
                defender.setRoleInfo(defenderOpponent.getServerId(), defenderOpponent.getHeadId(), defenderOpponent.getBorderId(), defenderOpponent.getLevel(), defenderOpponent.getFighting());
                BattleCommand battleCommand = BattleCommand.createOf(BattleType.PINNACLE, attacker, defender);
                commandBus.invoke(battleCommand);
                BattleResult battleResult = battleCommand.getResult();

                boolean exchangeRank = false;

                int newRank = opponentGroup.getMaxPinnacleRank();
                if(attackerPreliminariesLadder.getRank() == 0 && newRank != 0){
                    attackerPreliminariesLadder.setRank(newRank);
                    preliminariesLadderDao.update(attackerPreliminariesLadder);
                    RankDto rankDto = RankDto.createOf(newRank, attackRid, attackerOpponent.getStageId(), attackerOpponent.getHeadId(), attackerOpponent.getBorderId(), attackerOpponent.getImage_id(), attackerOpponent.getName()
                            , attackerOpponent.getFighting(), attackerOpponent.getLevel(), attackerOpponent.getServerId(), attackerPreliminariesLadder.getLikes());
                    opponentGroup.addLadder(rankDto);
                    exchangeRank = true;
                }

                int attackOldRank = attackerPreliminariesLadder.getRank();
                List<RankDto> newAttackerLadder = Collections.emptyList();
                List<RankDto> newDefenderLadder = Collections.emptyList();
                // 比防守方排名高时才替换排名，并且重新匹配

                if (battleResult.isWin()) {
                    if (attackOldRank <= 0 || attackOldRank > defendOldRank) {
                        attackerPreliminariesLadder.setRank(defendOldRank);
                        defenderPreliminariesLadder.setRank(attackOldRank);
                        preliminariesLadderDao.update(attackerPreliminariesLadder);
                        preliminariesLadderDao.update(defenderPreliminariesLadder);
                        opponentGroup.exchangeRank(attackOldRank, defendOldRank, attackerOpponent, attackerPreliminariesLadder);
                        newAttackerLadder = preliminariesService.match(opponentGroup.getGroupId(), attackRid);
                        newDefenderLadder = preliminariesService.match(opponentGroup.getGroupId(), message.getDefendRid());
                        exchangeRank = true;
                    }
                }

                int attackNewRank = attackerPreliminariesLadder.getRank();
                int defendNewRank = defenderPreliminariesLadder.getRank();

                attackerResMessage = preliminariesConverter.buildPreliminariesChallengeResMessage(battleResult.getReport(), attackerOpponent, attackNewRank, defendNewRank, newAttackerLadder, exchangeRank);
                PreliminariesChallengeResMessage defenderResMessage = preliminariesConverter.buildPreliminariesChallengeResMessage(battleResult.getReport(), defenderOpponent, attackNewRank, defendNewRank, newDefenderLadder, exchangeRank);

                messageHelper.pushToMessage(defenderResMessage);

                if (exchangeRank) {
                    // 广播跨服组所有游戏服
//                    RankDto attackRankDto = opponentGroup.getPinnacleRankBy(attackNewRank);
//                    PushRankExchangeMessage exchangeMessage = PushRankExchangeMessage.of(attackRankDto, opponentRankDto);
//                    messageHelper.pushToGroupMessage(opponentGroup.getGroupId(), exchangeMessage);

                    // 广播跨服组所有游戏服
                    List<RankDto> ranks = opponentGroup.getPreliminariesRanking(PreliminariesConst.PRELIMINARIES_RANKS_NUMBER);
                    LeaderBoardResMessage rankResMessage = LeaderBoardResMessage.of(ranks);
                    messageHelper.pushToGroupMessage(opponentGroup.getGroupId(), rankResMessage);

                    LocalDateTime now = LocalDateTime.now();
                    if(now.getMinute() % 5 == 0){
                        log.info("排行榜重新校正排名");
                        // 重新排序依次
                        for (RankDto rank : ranks) {
                            PreliminariesLadder ladder = preliminariesLadderDao.getOrCreate(rank.getRid());
                            if(ladder.getRank() != rank.getRank()){
                                log.info("玩家[{}]排名校正前{}校正后{}", rank.getName(), ladder.getRank(), rank.getRank());
                                ladder.setRank(rank.getRank());
                                preliminariesLadderDao.update(ladder);
                            }
                        }
                    }

                }
                // 大神战斗
                if ((attackNewRank > 0 && attackNewRank <= PreliminariesConst.PRELIMINARIES_SUPERIOR_RANK) ||
                        (defendNewRank <= PreliminariesConst.PRELIMINARIES_SUPERIOR_RANK && defendNewRank > 0)) {
                    PreliminariesSuperiorBattleMessage superiorMessage = PreliminariesSuperiorBattleMessage.of(attackOldRank, defendOldRank, battleResult.getReport().toByteArray());
                    messageHelper.pushToGroupMessage(opponentGroup.getGroupId(), superiorMessage);
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        return attackerResMessage;
    }

    /**
     * 点赞计数
     *
     * @param message
     * @return
     */
    @RemoteMethod
    public PreliminariesLikeNumAddResMessage likeNumAdd(PreliminariesLikeNumAddReqMessage message, Connection connection) {
        int rank = message.getRank();
        CrossGroup crossGroup = sessionManager.getGroupByClientId(connection.getClientId());
        if (Objects.isNull(crossGroup)) {
            log.error("group is null clientId:{}", connection.getClientId());
            return PreliminariesLikeNumAddResMessage.of(null);
        }
        OpponentGroup group = opponentGroupHolder.getGroup(crossGroup.getGroupId());
        if (Objects.isNull(group)) {
            log.error("group is null groupId:{}", crossGroup.getGroupId());
            return PreliminariesLikeNumAddResMessage.of(null);
        }

        RankDto rankDto = group.getPinnacleRankBy(rank);
        if (Objects.isNull(rankDto)) {
            log.error("rankDto is null rank:{}", rank);
            return PreliminariesLikeNumAddResMessage.of(null);
        }

        PreliminariesLadder preliminariesLadder = preliminariesLadderDao.getOrCreate(rankDto.getRid());
        synchronized (this){
            preliminariesLadder.setLikes(preliminariesLadder.getLikes() + 1);
            rankDto.setLikes(rankDto.getLikes() + 1);
        }

        preliminariesLadderDao.update(preliminariesLadder);
        return PreliminariesLikeNumAddResMessage.of(rankDto);
    }

}
