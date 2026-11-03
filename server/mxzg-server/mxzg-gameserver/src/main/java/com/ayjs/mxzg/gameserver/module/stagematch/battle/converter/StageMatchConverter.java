package com.ayjs.mxzg.gameserver.module.stagematch.battle.converter;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.MatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.BattleRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.MyRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesRankService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattlerFightLog;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPreliminaries;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSGreatDemeanor;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSMyRecord;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPreliminariesRoleInfo;
import com.ayjs.mxzg.protocol.StageMatchGMsg.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class StageMatchConverter {

    @Autowired
    private PreliminariesRankService preliminariesRankService;

    /**
     * 根据跨服匹配消息构建匹配响应协议
     * @param opponentDto
     * @param battleTime
     * @return
     */
    public GResMatchOpponent.Builder buildWith(OpponentDto opponentDto, int battleTime){
        GResMatchOpponent.Builder builder = GResMatchOpponent.newBuilder();
        MatchInfo.Builder matchInfoBuilder = MatchInfo.newBuilder();
        BattlerVo battlerVo = JSON.parseObject(opponentDto.getBattlerVo(), BattlerVo.class);
        List<HeroData> heroes = battlerVo.getHeros().stream().map(this::buildHeroData).collect(Collectors.toList());
        matchInfoBuilder.setCountdown(battleTime).setFighting(opponentDto.getFighting()).setServerId(opponentDto.getServerId()).setStageId(opponentDto.getStageId());
        matchInfoBuilder.setFormationId(battlerVo.getFormationId()).addAllHero(heroes).setName(opponentDto.getName());
        builder.setMatchInfo(matchInfoBuilder.build());
        return builder;
    }

    /**
     * 构造一个英雄基本数据对象
     * @param heroVo
     * @return
     */
    private HeroData buildHeroData(HeroVo heroVo){
        HeroData.Builder builder = HeroData.newBuilder();
        builder.setFashionId(heroVo.getFashionId()).setHeroId(heroVo.getHeroId()).setLevel(heroVo.getLevel());
        builder.setPos(heroVo.getPos()).setStar(heroVo.getStar());
        builder.setEvolve(PbUtil.builderEvolve(heroVo));
        return builder.build();
    }

    /**
     * 构造挑战记录
     * @param matchLog
     * @return
     */
    public ChallengeLog buildChallengeLogFrom(MatchLog matchLog){
        ChallengeLog.Builder builder = ChallengeLog.newBuilder();
        builder.setAttacker(buildOpponentInfo(matchLog.getAttacker()));
        builder.setDefender(buildOpponentInfo(matchLog.getDefender()));
        builder.setBattleLog(matchLog.parseLog()).setBattleTime(matchLog.getBattleTime()).setWin(matchLog.isWin());
        return builder.build();
    }
    /**
     * 构造挑战记录
     * @param record
     * @return
     */
    public PSMyRecord buildPSMyRecordFrom(MyRecord record){
        PSMyRecord.Builder builder = PSMyRecord.newBuilder();
        builder.setBattleTime(record.getBattleTime()).setBorderId(record.getBorderId()).setHeadId(record.getHeadId());
        builder.setFighting(record.getFighting()).setName(record.getName()).setRank(record.getRank()).setServerId(record.getServerId());
        builder.setWin(record.isWin()).setAttack(record.isAttacker()).setBattleId(record.getBattleId()).setLevel(record.getLevel()).setOldRank(record.getOldRank());
        return builder.build();
    }

    /**
     * 构造挑战记录
     * @param record
     * @return
     */
    public PSGreatDemeanor buildPSGreatDemeanorFrom(BattleRecord record){
        PSGreatDemeanor.Builder builder = PSGreatDemeanor.newBuilder();
        builder.setWin(record.isWin()).setBattleId(record.getBattleId()).setBattleTime(record.getBattleTime());
        Opponent attacker = record.getAttacker();
        Opponent defender = record.getDefender();
        builder.setAttackerBorderId(attacker.getBorderId()).setAttackerHeadId(attacker.getHeadId()).setAttackerName(attacker.getName());
        builder.setAttackerRank(attacker.getRank()).setAttackerServerId(attacker.getServerId());
        builder.setDefenderBorderId(defender.getBorderId()).setDefenderHeadId(defender.getHeadId()).setDefenderName(defender.getName());
        builder.setDefenderRank(defender.getRank()).setDefenderServerId(defender.getServerId());
        return builder.build();
    }

    /**
     * 构造挑战者对象
     * @param opponent
     * @return
     */
    public OpponentInfo buildOpponentInfo(Opponent opponent){
        OpponentInfo.Builder builder = OpponentInfo.newBuilder();
        builder.setBorderId(opponent.getBorderId()).setHeadId(opponent.getHeadId()).setLevel(opponent.getLevel());
        builder.setRank(opponent.getRank()).setStageId(opponent.getStageId()).setName(opponent.getName());
        builder.setServerId(opponent.getServerId());
        return builder.build();
    }

    /**
     * 构造传奇信息
     * @param legendInfo
     * @return
     */
    public LegendInfo buildLegendInfo(com.ayjs.mxzg.message.module.stagematch.dto.LegendInfo legendInfo){
        LegendInfo.Builder builder = LegendInfo.newBuilder();
        builder.setFighting(legendInfo.getFighting()).setServerId(legendInfo.getServer_id());
        builder.setImageId(legendInfo.getImage_id()).setName(legendInfo.getName());
        builder.setRank(legendInfo.getRank()).setStageId(legendInfo.getStage_id());
        return builder.build();
    }

    /**
     * 排行榜等级信息
     * @param rankDto
     * @return
     */
    public RankInfo buildRankInfo(RankDto rankDto){
        RankInfo.Builder builder = RankInfo.newBuilder();
        builder.setRank(rankDto.getRank()).setBorderId(rankDto.getBorderId()).setEliteIntegral(rankDto.getEliteIntegral());
        builder.setFighting(rankDto.getFighting()).setHeadId(rankDto.getHeadId()).setImageId(rankDto.getImageId()).setLevel(rankDto.getLevel());
        builder.setServerId(rankDto.getServerId()).setStageId(rankDto.getStageId()).setName(rankDto.getName());
        return builder.build();
    }

    /**
     * 构建预赛信息
     * @param preliminariesLadder
     * @return
     */
    public GResPreliminaries buildFrom(PreliminariesLadder preliminariesLadder){
        GResPreliminaries.Builder builder = GResPreliminaries.newBuilder();
        builder.setRefreshCool(LocalDateTimeUtil.toEpochSecond(preliminariesLadder.getLastRefreshDefend()));
        builder.setRemainingPurchases(preliminariesLadder.getRemainingPurchases());
        builder.setRemainingTimes(preliminariesLadder.getRemainingChallenges());
        int roleRank = 0;
        StageMatchDao crossStageMatchDao = SpringProxy.getBean(StageMatchDao.class);
        StageMatch crossStageMatch = crossStageMatchDao.get();
        if(crossStageMatch.getStage() == StageType.PRELIMINARIES.ordinal()){
            roleRank = preliminariesRankService.getRank(preliminariesLadder.getRid());
        }
        builder.setRank(roleRank);
        builder.addAllLikeRank(preliminariesLadder.getLikes());
        for (RankDto defender : preliminariesLadder.getDefends()) {
            builder.addOpponent(buildRoleInfo(defender));
        }
        return builder.build();
    }

    /**
     * 构建敌方角色信息
     * @param rankDto
     * @return
     */
    public PSPreliminariesRoleInfo buildRoleInfo(RankDto rankDto){
        PSPreliminariesRoleInfo.Builder builder = PSPreliminariesRoleInfo.newBuilder();
        builder.setRid(rankDto.getRid()).setBorderId(rankDto.getBorderId()).setFight(rankDto.getFighting()).setHeadId(rankDto.getHeadId());
        builder.setImageId(rankDto.getImageId()).setLadderRank(rankDto.getRank()).setNick(rankDto.getName()).setServerId(rankDto.getServerId());
        builder.setLevel(rankDto.getLevel());
        return builder.build();
    }

    /**
     *
     * @param roleStageMatch
     * @param log
     * @return
     */
    public MatchLog buildMatchLog(RoleStageMatch roleStageMatch, BattleLog log){
        MatchLog matchLog = new MatchLog();
        BattlerFightLog attackerLog = log.getAttackerLog();
        BattlerFightLog defenderLog = log.getDefenderLog();
        matchLog.setLog(log.toByteArray());
        matchLog.setWin(log.getWinId() == attackerLog.getRid());
        matchLog.setBattleTime(DateTimeUtil.currentSecond());
        Opponent attackerOpponent = buildOpponent(roleStageMatch.getRank(), roleStageMatch.getStageId(), attackerLog);
        Opponent defenderOpponent = buildOpponent(roleStageMatch.getOpponentDto().getRank(), roleStageMatch.getOpponentDto().getStageId(), defenderLog);
        matchLog.setAttacker(attackerOpponent);
        matchLog.setDefender(defenderOpponent);
        return matchLog;
    }

    /**
     * 构建战斗日志
     * @param newRank
     * @param oldRank
     * @param log
     * @param opponentLog
     * @param rid
     * @return
     */
    public MyRecord buildMyRecord(int newRank, int oldRank, BattleLog log, BattlerFightLog opponentLog, long rid){
        MyRecord myRecord = new MyRecord();
        myRecord.setRank(newRank);
        myRecord.setOldRank(oldRank);
        myRecord.setBattleId(log.getBattleId());
        myRecord.setBattleTime(DateTimeUtil.currentSecond());
        myRecord.setBorderId(opponentLog.getBorderId());
        myRecord.setHeadId(opponentLog.getHeadId());
        myRecord.setFighting(opponentLog.getFighting());
        myRecord.setName(opponentLog.getName());
        myRecord.setServerId(opponentLog.getServerId());
        myRecord.setWin(log.getWinId() == rid);
        myRecord.setAttacker(log.getAttackerLog().getRid() == rid);
        myRecord.setLevel(log.getAttackerLog().getRid() == rid ? log.getDefenderLog().getLevel() : log.getAttackerLog().getLevel());
        return myRecord;
    }


    /**
     * 构建战斗日志
     * @param attackerRank
     * @param defenderRank
     * @param log
     * @return
     */
    public BattleRecord buildBattleRecord(int attackerRank, int defenderRank, BattleLog log){
        BattleRecord battleRecord = new BattleRecord();
        BattlerFightLog attackerLog = log.getAttackerLog();
        BattlerFightLog defenderLog = log.getDefenderLog();
        battleRecord.setBattleId(log.getBattleId());
        battleRecord.setWin(log.getWinId() == attackerLog.getRid());
        battleRecord.setBattleTime(DateTimeUtil.currentSecond());
        Opponent attackerOpponent = buildOpponent(attackerRank, 0, attackerLog);
        Opponent defenderOpponent = buildOpponent(defenderRank, 0, defenderLog);
        battleRecord.setAttacker(attackerOpponent);
        battleRecord.setDefender(defenderOpponent);
        return battleRecord;
    }


    /**
     * 构造对手
     * @param rank
     * @param fightLog
     * @return
     */
    public Opponent buildOpponent(int rank, int stageId, BattlerFightLog fightLog){
        Opponent opponent = new Opponent();
        opponent.setRank(rank);
        opponent.setBorderId(fightLog.getBorderId());
        opponent.setHeadId(fightLog.getHeadId());
        opponent.setLevel(fightLog.getLevel());
        opponent.setName(fightLog.getName());
        opponent.setServerId(fightLog.getServerId());
        opponent.setStageId(stageId);
        opponent.setFighting(fightLog.getFighting());
        return opponent;
    }

    /**
     * 构造对手
     * @param opponentDto
     * @param fightLog
     * @return
     */
    public Opponent buildOpponent(OpponentDto opponentDto, BattlerFightLog fightLog){
        Opponent opponent = new Opponent();
        opponent.setRank(opponentDto.getRank());
        opponent.setBorderId(fightLog.getBorderId());
        opponent.setHeadId(fightLog.getHeadId());
        opponent.setLevel(fightLog.getLevel());
        opponent.setName(fightLog.getName());
        opponent.setServerId(fightLog.getServerId());
        opponent.setStageId(opponentDto.getStageId());
        opponent.setFighting(fightLog.getFighting());
        return opponent;
    }

}
