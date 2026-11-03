package com.ayjs.mxzg.gameserver.module.stagematch.battle.handler;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.GreatStyleLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.GreatStyleLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.MatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.event.StageMatchBattleEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.service.StageMatchHelper;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.service.StageMatchService;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesRankService;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageMatchSeasonBattleEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageTokenSettleEvent;
import com.ayjs.mxzg.gameserver.module.title.event.RecoverTitleEvent;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.stagematch.ChallengeResMessage;
import com.ayjs.mxzg.message.module.stagematch.GreatStyleMessage;
import com.ayjs.mxzg.message.module.stagematch.OpenNewSeasonMessage;
import com.ayjs.mxzg.message.module.stagematch.RankSettlementMessage;
import com.ayjs.mxzg.message.module.stagematch.SeasonSettlementMessage;
import com.ayjs.mxzg.message.module.stagematch.StageMatchReqMessage;
import com.ayjs.mxzg.message.module.stagematch.StageMatchResMessage;
import com.ayjs.mxzg.message.module.stagematch.StageMathFinishMessage;
import com.ayjs.mxzg.message.module.stagematch.StartMatchingMessage;
import com.ayjs.mxzg.message.module.stagematch.SynchronizeOpponentMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.BattleGMsg.BattlerFightLog;
import com.ayjs.mxzg.protocol.BattleGMsg.HeroLog;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResChallenge;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 段位赛消息处理器
 */
@Slf4j
@Component
public class StageMatchMessageHandler implements MessageHandler {

    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private StageMatchDao stageMatchDao;
    @Autowired
    private RoleStageMatchDao roleStageMatchDao;
    @Autowired
    private StageMatchService stageMatchService;
    @Autowired
    private StageMatchHelper stageMatchHelper;
    @Autowired
    private GreatStyleLogDao greatStyleLogDao;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private PreliminariesRankService preliminariesRankService;

    @Value("${server.id}")
    private int serverId;

    @RemoteMethod
    public void handleStageMatchResMessage(StageMatchResMessage message){
        StageMatch stageMatch = stageMatchDao.get();
        if(message != null && message.getSeasonId() != 0){
            stageMatch.updateInfo(message.getSerialNumber(), message.getSeasonId(), message.getStageType(), message.getStartTime(), message.getEndTime());
            stageMatchDao.update(stageMatch);
        }
    }

    @RemoteMethod
    public void handleSynchronizeOpponentMessage(SynchronizeOpponentMessage message){
        OpponentDto opponentDto = message.getOpponentDto();
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(opponentDto.getRid());
        roleStageMatch.updateInfo(opponentDto.getStageId(), opponentDto.getIntegral(), opponentDto.getEliteIntegral(), opponentDto.getRank());
        roleStageMatchDao.update(roleStageMatch);
    }

    @RemoteMethod
    public void handleOpenNewSeasonMessage(OpenNewSeasonMessage message){
        log.info("段位赛开启新赛季{}赛季周期{}至{}", message.getSeason(), message.getStartTime(), message.getEndTime());
        StageMatch stageMatch = stageMatchDao.get();
        stageMatch.openStageMatch(message.getSerialNumber(), message.getSeason(), message.getStartTime(), message.getEndTime());
        stageMatchDao.update(stageMatch);

        log.info("重置所有玩家赛季数据");
        stageMatchHelper.openNewSeason();
        log.info("清空排行榜數據");
        preliminariesRankService.clean();
        log.info("赛季开启完成");
    }


    @RemoteMethod
    public void handleStageMathFinishMessage(StageMathFinishMessage message){
        log.info("收到赛季结束消息，赛季结束匹配");
        StageMatch stageMatch = stageMatchDao.get();
        stageMatch.closeStageMatch(message.getSerialNumber());
        stageMatchDao.update(stageMatch);
        eventBus.post(RecoverTitleEvent.valueOf(TitleType.SUPER_STAGE));
        log.info("回收称号完毕");
    }

    @RemoteMethod
    public void handleSeasonSettlementMessage(SeasonSettlementMessage message){
        log.info("收到赛季结算消息，赛季开始结算！");
        StageMatch stageMatch = stageMatchDao.get();
        if(stageMatch.getStage() != StageType.FINISH.ordinal()){
            log.error("赛季不处于结束状态，当次不结算stage:{}", stageMatch.getStage());
            return;
        }

        stageMatch.settlementStageMatch();
        stageMatchDao.update(stageMatch);

        log.info("赛季段位奖励开始结算...");
        stageMatchHelper.settlement();
        log.info("赛季段位奖励结算完毕...");

        eventBus.post(StageTokenSettleEvent.of(message.getSeason()));
        log.info("赛季结算完毕!!!");
    }

    @RemoteMethod
    public void handleRankSettlementMessage(RankSettlementMessage message){
        log.info("{}发放排名rank:{}奖励...", message.getRid(), message.getRank());
        stageMatchHelper.rankSettlement(message.getRid(), message.getRank());
        log.info("排名奖励结算完毕");
    }

    @RemoteMethod
    public void handleChallengeResMessage(ChallengeResMessage message){
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(message.getRid());

        roleStageMatch.matchReset();
        BattleReport battleReport = null;
        GResChallenge.Builder builder = GResChallenge.newBuilder();
        try {
            battleReport = BattleReport.parseFrom(message.getBattleReport());

            if(battleReport == null){
                log.error(String.format("%s段位赛挑战结果，战报为空", message.getRid()));
                return;
            }

            builder.setOldStageId(roleStageMatch.getStageId()).setOldIntegral(roleStageMatch.getIntegral()).setOldEliteIntegral(roleStageMatch.getEliteIntegral());
            boolean qualifyingMatch = roleStageMatch.isQualifyingMatch();
            roleStageMatch.getOpponentDto().setRank(message.getOpponentRank());
            roleStageMatch.updateResult(message.getStageId(), message.getIntegral(), message.getEliteIntegral(), message.getRank(), message.isQualifyingMatch(), message.getResultSet());
            builder.setNewStageId(message.getStageId()).setNewIntegral(message.getIntegral()).setNewEliteIntegral(message.getEliteIntegral()).setReport(battleReport);
            builder.addAllAdvanceResult(roleStageMatch.getAdvanceRecord(qualifyingMatch));
            List<ImmutableThing> reward = stageMatchHelper.getThingByResult(message.getResultType(), message.getStageId());
            Rewards rewards = thingService.add(message.getRid(), reward, GameEvent.STAGE_MATCH_BATTLE_REWARD, NoticeType.SLIENT);
            builder.addAllReward(PbUtil.buildReward(rewards));

        } catch (Exception ex){
            ex.printStackTrace();
        }

        roleStageMatchDao.update(roleStageMatch);
        contextManager.write(message.getRid(), CmdCode._72005, builder.build());

        postEvent(roleStageMatch, battleReport);

    }

    /**
     * 下半段开启匹配
     * @param message
     */
    @RemoteMethod
    public void handleStartMatchingMessage(StartMatchingMessage message){
        log.info("段位赛下半赛季重新开启匹配");
        StageMatch stageMatch = stageMatchDao.get();
        stageMatch.openMatching(message.getSerialNumber());
        stageMatchDao.update(stageMatch);
        log.info("重新请求段位赛");
        messageDispatcher.dispatch(StageMatchReqMessage.getInstance());
    }

    /**
     * 大神风采
     * @param message
     */
    @RemoteMethod
    public void handleGreatStyleMessage(GreatStyleMessage message){
        MatchLog matchLog = new MatchLog();

        BattleReport battleReport = null;
        try {
            battleReport = BattleReport.parseFrom(message.getReport());
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        if(battleReport == null){
            log.info("大神风采日志解析失败");
            return;
        }

        BattleLog battleLog = battleReport.getLog();

        BattlerFightLog attackerLog = battleLog.getAttackerLog();
        BattlerFightLog defenderLog = battleLog.getDefenderLog();
        matchLog.setLog(battleLog.toByteArray());
        matchLog.setWin(battleLog.getWinId() == attackerLog.getRid());
        matchLog.setBattleTime(DateTimeUtil.currentSecond());
        Opponent attackerOpponent = buildOpponent(message.getAttacker(), attackerLog);
        Opponent defenderOpponent = buildOpponent(message.getDefender(), defenderLog);
        matchLog.setAttacker(attackerOpponent);
        matchLog.setDefender(defenderOpponent);

        GreatStyleLog greatStyleLog = greatStyleLogDao.get();
        greatStyleLog.addLog(matchLog);
        greatStyleLogDao.update(greatStyleLog);

        SaveBattleReportCommand command = SaveBattleReportCommand.of(battleReport);
        commandBus.invoke(command);
    }

    /**
     * 发布事件相关
     * @param roleStageMatch
     * @param battleReport
     *
     */
    public void postEvent(RoleStageMatch roleStageMatch, BattleReport battleReport){
        BattleLog log = battleReport.getLog();
        StageMatchSeasonBattleEvent battleEvent = buildBattleEvent(roleStageMatch, log, battleReport.getWinId() == roleStageMatch.getRid());
        eventBus.post(battleEvent);

        MatchLog matchLog = buildMatchLog(roleStageMatch, log);
        StageMatchBattleEvent event = StageMatchBattleEvent.createOf(roleStageMatch.getRid(), matchLog, battleReport);
        eventBus.post(event);
    }

    /**
     *
     * @param roleStageMatch
     * @param log
     * @return
     */
    private MatchLog buildMatchLog(RoleStageMatch roleStageMatch, BattleLog log){
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
     * 构造对手
     * @param rank
     * @param fightLog
     * @return
     */
    private Opponent buildOpponent(int rank, int stageId, BattlerFightLog fightLog){
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
    private Opponent buildOpponent(OpponentDto opponentDto, BattlerFightLog fightLog){
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

    /**
     * 构造段位赛赛季战斗事件
     * @param roleStageMatch
     * @param log
     * @param win
     * @return
     */
    private StageMatchSeasonBattleEvent buildBattleEvent(RoleStageMatch roleStageMatch, BattleLog log, boolean win){
        StageMatchSeasonBattleEvent event = new StageMatchSeasonBattleEvent();
        OpponentDto opponentDto = roleStageMatch.getOpponentDto();
        event.setRid(roleStageMatch.getRid());
        event.setCurrScore(roleStageMatch.getEliteIntegral());
        event.setDefendId(log.getDefenderLog().getRid());
        event.setDefendTeamFighting1(opponentDto.getFighting());
        event.setDmg(totalDamage(log));
        event.setStageId(roleStageMatch.getStageId());
        event.setWin(win);
        event.setNormal(true);

        HeroLog heroLog = getMvpHeroLog(log);
        HeroVo heroVo = new HeroVo();
        heroVo.setHeroId(heroLog.getHeroType());
        heroVo.setStar(heroLog.getStar());
        heroVo.setLevel(heroLog.getLevel());
        heroVo.setFashionId(heroLog.getFashionId());
        event.getMvpHeroVos().add(heroVo);
        return event;
    }

    /**
     * 战场日志
     * @param log
     * @return
     */
    private long totalDamage(BattleLog log){
        return log.getAttackerLog().getHeroLogList().stream().mapToLong(heroLog-> heroLog.getTotalDamage()).sum();
    }

    /**
     * 获取伤害最高的英雄日志
     * @param log
     * @return
     */
    private HeroLog getMvpHeroLog(BattleLog log){
        List<HeroLog> logs = log.getAttackerLog().getHeroLogList().stream().sorted((h1, h2)-> Long.compare(h2.getTotalDamage(), h1.getTotalDamage())).collect(Collectors.toList());
        return logs.get(0);
    }

}
