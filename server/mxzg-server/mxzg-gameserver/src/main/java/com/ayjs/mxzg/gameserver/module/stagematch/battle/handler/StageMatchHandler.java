package com.ayjs.mxzg.gameserver.module.stagematch.battle.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageBuyConsumeSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageBuyConsume;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.StageMathConstant;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.converter.StageMatchConverter;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.GreatStyleLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.GreatStyleLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.MatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.service.StageMatchService;
import com.ayjs.mxzg.message.module.stagematch.ChallengeReqMessage;
import com.ayjs.mxzg.message.module.stagematch.MatchingReqMessage;
import com.ayjs.mxzg.message.module.stagematch.MatchingResMessage;
import com.ayjs.mxzg.message.module.stagematch.RanksReqMessage;
import com.ayjs.mxzg.message.module.stagematch.RanksResMessage;
import com.ayjs.mxzg.message.module.stagematch.SeasonLegendReqMessage;
import com.ayjs.mxzg.message.module.stagematch.SeasonLegendResMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.LegendInfo;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.protocol.StageMatchGMsg;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GReqMatchInfo;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GReqMatchOpponent;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GReqStageMatchData;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResGreatStyle;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResMatchOpponent;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResMyVideo;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResPurchases;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResRankInfo;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResReceiveAward;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResSeasonLegend;
import com.ayjs.mxzg.protocol.StageMatchGMsg.GResStageMatchData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 段位赛协议处理器
 */
@Component
public class StageMatchHandler extends ProtocolHandler {

    @Autowired
    private GreatStyleLogDao greatStyleLogDao;
    @Autowired
    private RoleStageMatchLogDao roleStageMatchLogDao;
    @Autowired
    private StageMatchDao stageMatchDao;
    @Autowired
    private RoleStageMatchDao roleStageMatchDao;
    @Autowired
    private StageMatchService stageMatchService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private StageMatchConverter stageMatchConverter;
    @Autowired
    private SuperStageSysCache superStageSysCache;
    @Autowired
    private SuperStageCycleSysCache superStageCycleSysCache;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private SuperStageBuyConsumeSysCache superStageBuyConsumeSysCache;


    /**
     * 请求段位赛基本信息
     * @param req
     */
    @CMD(id = CmdCode._72001)
    public void reqStageMatchData(PlayerContext playerContext, GReqStageMatchData req){
        Role role = roleService.getOrThrow(playerContext.getId());
        COpenCondition openCondition = openConditionSysCache.getCondition(StageMathConstant.FUNCTION_OPEN_NAME);
        Asserts.notNull(openCondition, ErrorCode.FUNCTION_NOT_OPEN.getValue(), ()-> String.format("段位赛功能开关[%s]不存在", StageMathConstant.FUNCTION_OPEN_NAME));

        Asserts.isTrue(role.getLevel() >= openCondition.getCondition_value(), ErrorCode.FUNCTION_NOT_OPEN.getValue(), ()->String.format("%s功能未开启Level:%s", role.getId(), role.getLevel()));

        GResStageMatchData.Builder builder = GResStageMatchData.newBuilder();
        StageMatch stageMatch = stageMatchDao.get();
        if(stageMatch == null || stageMatch.getSeason() == 0){
            builder.setStageId(StageMathConstant.DEFAULT_STAGE_ID);
        } else {
            CSuperStageCycle finishStage = superStageCycleSysCache.getLastCycle(stageMatch.getSeason(), StageType.SETTLEMENT.ordinal());
            CSuperStageCycle preliminariesStage = superStageCycleSysCache.getCycleBy(stageMatch.getSeason(), StageType.PRELIMINARIES.ordinal());
            CSuperStageCycle finalsStartStage = superStageCycleSysCache.getCycleBy(stageMatch.getSeason(), StageType.FINALS.ordinal());
            CSuperStageCycle secondStartStage = superStageCycleSysCache.getCycleBy(stageMatch.getSeason(), StageType.MATCH.ordinal());

            Asserts.notNull(finishStage, ErrorCode.CONFIG_NOT_EXIST.getValue(), ()-> String.format("赛季数据查询失败，赛季[%s]阶段[%s]", stageMatch.getSeason(), StageType.FINISH.ordinal()));
            RoleStageMatch roleStageMatch = stageMatchService.getOrCreate(playerContext.getId(), req.getRoleRequest());
            boolean preliminaryQualification =  roleStageMatch.getMaxSeasonStageId() >= PreliminariesConst.PRELIMINARY_QUALIFICATION_STAGE_ID ? true : false;

            builder.setSeason(stageMatch.getSeason()).setStageId(roleStageMatch.getStageId()).setStartTime(stageMatch.getStartTimeS()).setEndTime(stageMatch.getEndTimeS())
                    .setSettlementTime(LocalDateTimeUtil.toEpochSecond(finishStage.getStart_time())).setIntegral(roleStageMatch.getIntegral()).setEliteIntegral(roleStageMatch.getEliteIntegral())
                    .setMatches(roleStageMatch.getRemainingMatches()).setRemainingPurchases(roleStageMatch.getRemainingPurchases()).setRank(roleStageMatch.getRank()).setReceivedId(roleStageMatch.getStageRewardId())
            .setQualifyingMatch(roleStageMatch.isQualifyingMatch()).addAllRecord(roleStageMatch.getAdvanceRecord()).setMatching(roleStageMatch.isMatching())
                    .setPreliminariesTime(LocalDateTimeUtil.toEpochSecond(preliminariesStage.getStart_time())).setFinalTime(LocalDateTimeUtil.toEpochSecond(finalsStartStage.getStart_time()));
            builder.setPinnacleStage(stageMatch.getPinnacleStage()).setPreliminaryQualification(preliminaryQualification).setSecondStartTime(LocalDateTimeUtil.toEpochSecond(secondStartStage.getStart_time()));
        }
        playerContext.write(CmdCode._72001, builder.build());
    }

    /**
     * 请求匹配对手
     *@param req
     */
    @CMD(id = CmdCode._72002)
    public void reqMatchOpponent(PlayerContext playerContext, GReqMatchOpponent req){
        StageMatch stageMatch = stageMatchDao.get();
        if(!stageMatch.isMatchStage()){
            playerContext.write(CmdCode._72002, GResMatchOpponent.newBuilder().setLanguageId(ErrorCode.NOT_MATCH_STAGE.getValue()).build());
            return;
        }
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(playerContext.getId());

        if(roleStageMatch.isMatchCool()){
            playerContext.write(CmdCode._72002, GResMatchOpponent.newBuilder().setLanguageId(ErrorCode.MATCHING_CD.getValue()).build());
            return;
        }

        if(!roleStageMatch.canMatch()){
            playerContext.write(CmdCode._72002, GResMatchOpponent.newBuilder().setLanguageId(ErrorCode.INSUFFICIENT_MATCHES.getValue()).build());
            return;
        }

        roleStageMatch.matchCool(req.getSkipArray());
        roleStageMatchDao.update(roleStageMatch);

        Role role = roleService.getOrThrow(playerContext.getId());
        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.STAGE_MATCH, playerContext.getId(), Faction.ATTACKER);
        String battleVoStr = JSON.toJSONString(battlerDo.toBattlerVo());

        MatchingReqMessage reqMessage = MatchingReqMessage.createOf(role.getId(), req.getSkipArray(), battleVoStr, battlerDo.getFighting(), role.getHeadId(), role.getBorderId());
        messageDispatcher.dispatch(reqMessage, resMessage ->{
            MatchingResMessage message = (MatchingResMessage)resMessage;
           if(message == null || message.getOpponentDto() == null){
               playerContext.write(CmdCode._72002, GResMatchOpponent.newBuilder().setLanguageId(ErrorCode.NO_MATCH.getValue()).build());
               roleStageMatch.addErrorTimes();
            } else {
               roleStageMatch.match(message.getOpponentDto(), message.getAutoBattleTime());
               GResMatchOpponent.Builder resMatchOpponent = stageMatchConverter.buildWith(message.getOpponentDto(), message.getAutoBattleTime());
               resMatchOpponent.setMatches(roleStageMatch.getRemainingMatches()).setRemainingPurchases(roleStageMatch.getRemainingPurchases());
               playerContext.write(CmdCode._72002, resMatchOpponent.build());
            }
            roleStageMatchDao.update(roleStageMatch);
        });
    }

    /**
     * 请求段位赛匹配信息
     * @param req
     */
    @CMD(id = CmdCode._72003)
    public void reqMatchInfo(PlayerContext playerContext, GReqMatchInfo req){
        StageMatch stageMatch = stageMatchDao.get();
        Asserts.isTrue(stageMatch.isMatchStage(), ErrorCode.NOT_MATCH_STAGE.getValue(), ()-> String.format("%s不在匹配阶段", playerContext.getId()));
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(playerContext.getId());

        Asserts.notNull(roleStageMatch.getOpponentDto(), ErrorCode.OPPONENT_INFORMATION_NOT_EXIST.getValue(), ()-> String.format("%s对手信息不存在", playerContext.getId()));
        GResMatchOpponent.Builder resMatchOpponent = stageMatchConverter.buildWith(roleStageMatch.getOpponentDto(), roleStageMatch.getBattleTime());
        playerContext.write(CmdCode._72002, resMatchOpponent.build());
    }

    /**
     * 购买匹配次数
     * @param req
     */
    @CMD(id = CmdCode._72004)
    public void reqPurchases(PlayerContext playerContext, StageMatchGMsg.GReqPurchases req){
        StageMatch stageMatch = stageMatchDao.get();
        Asserts.isTrue(stageMatch.isMatchStage(), ErrorCode.NOT_MATCH_STAGE.getValue(), ()-> String.format("不在匹配阶段"));

        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(playerContext.getId());
        Asserts.isTrue(roleStageMatch.notPurchaseLimit() , ErrorCode.PURCHASE_LIMIT.getValue(), ()-> String.format("达到购买次数上限%s", playerContext.getId()));

        CSuperStageBuyConsume consume = superStageBuyConsumeSysCache.getOrThrow(roleStageMatch.getPurchases() + 1);
        thingService.cost(playerContext.getId(), consume.getConsume(), GameEvent.PURCHASE_MATCHES);

        roleStageMatch.addPurchases();
        roleStageMatchDao.update(roleStageMatch);

        GResPurchases.Builder builder = GResPurchases.newBuilder();
        builder.setRemainingPurchases(roleStageMatch.getRemainingPurchases()).setMatches(roleStageMatch.getRemainingMatches());
        playerContext.write(CmdCode._72004, builder.build());
    }

    /**
     * 主动挑战
     * @param req
     */
    @CMD(id = CmdCode._72005)
    public void reqChallenge(PlayerContext playerContext, StageMatchGMsg.GReqChallenge req){
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(playerContext.getId());
//        Asserts.isTrue(roleStageMatch.isMatching(), ErrorCode.OPPONENT_INFORMATION_NOT_EXIST.getValue(), ()-> String.format("%s对手信息不存在请重新匹配", playerContext.getId()));

        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.STAGE_MATCH, playerContext.getId(), Faction.ATTACKER);
        String battleVoStr = JSON.toJSONString(battlerDo.toBattlerVo());
        int serialNumber = TimeDateUtil.getCurrentTimeInt();
        ChallengeReqMessage message = ChallengeReqMessage.createOf(playerContext.getId(), serialNumber, battleVoStr, battlerDo.getFighting());
        messageDispatcher.dispatch(message);
    }

    /**
     * 我的录像
     * @param req
     */
    @CMD(id = CmdCode._72006)
    public void reqMyVideo(PlayerContext playerContext, StageMatchGMsg.GReqMyVideo req){
        RoleStageMatchLog roleStageMatchLog = roleStageMatchLogDao.getOrCreate(playerContext.getId());

        GResMyVideo.Builder builder = GResMyVideo.newBuilder();
        for (MatchLog matchLog : roleStageMatchLog.getMatchLogs()) {
            builder.addLog(stageMatchConverter.buildChallengeLogFrom(matchLog));
        }
        playerContext.write(CmdCode._72006, builder.build());
    }

    /**
     * 大神风采
     * @param req
     */
    @CMD(id = CmdCode._72007)
    public void reqGreatStyle(PlayerContext playerContext, StageMatchGMsg.GReqGreatStyle req){
        GreatStyleLog greatStyleLog = greatStyleLogDao.get();
        GResGreatStyle.Builder builder = GResGreatStyle.newBuilder();
        for (MatchLog matchLog : greatStyleLog.getMatchLogs()) {
            builder.addLog(stageMatchConverter.buildChallengeLogFrom(matchLog));
        }
        playerContext.write(CmdCode._72007, builder.build());
    }

    /**
     * 领取奖励
     * @param req
     */
    @CMD(id = CmdCode._72008)
    public void reqReceiveAward(PlayerContext playerContext, StageMatchGMsg.GReqReceiveAward req){
        RoleStageMatch roleStageMatch = stageMatchService.getRoleStageMatch(playerContext.getId());
        Asserts.isTrue(roleStageMatch.hasReward(), ErrorCode.NO_REWARDS_AVAILABLE.getValue(), ()-> String.format("%s没有奖励可以领取", playerContext.getId()));

        CSuperStage superStage = superStageSysCache.getOrThrow(roleStageMatch.getStageRewardId() + 1);
        Asserts.isTrue(superStage.hasFirstReward(), ErrorCode.NO_REWARDS_AVAILABLE.getValue(), ()-> String.format("没有配置可领取的奖励"));

        roleStageMatch.receiveReward();
        roleStageMatchDao.update(roleStageMatch);

        thingService.add(playerContext.getId(), superStage.getFirst_reward(), GameEvent.STAGE_MATCH_FIRST_REWARD);

        GResReceiveAward.Builder builder = GResReceiveAward.newBuilder();
        builder.setReceivedId(roleStageMatch.getStageRewardId());
        playerContext.write(CmdCode._72008, builder.build());
    }

    /**
     * 赛季传奇
     * @param req
     */
    @CMD(id = CmdCode._72009)
    public void reqSeasonLegend(PlayerContext playerContext, StageMatchGMsg.GReqSeasonLegend req){
        StageMatch stageMatch = stageMatchDao.get();
        if(req.getSeason() <= 0 || req.getSeason() > stageMatch.getSeason()){
            playerContext.write(CmdCode._72009, GResSeasonLegend.newBuilder().setSeason(req.getSeason()).build());
            return;
        }

        SeasonLegendReqMessage message = SeasonLegendReqMessage.createOf(req.getSeason());
        messageDispatcher.dispatch(message, result->{
            SeasonLegendResMessage resMessage = (SeasonLegendResMessage)result;
            GResSeasonLegend.Builder builder = GResSeasonLegend.newBuilder();
            builder.setSeason(req.getSeason());
            for (LegendInfo legendInfo : resMessage.getLegendInfos()) {
                builder.addLegendInfo(stageMatchConverter.buildLegendInfo(legendInfo));
            }
            playerContext.write(CmdCode._72009, builder.build());
        });
    }


    /**
     * 请求排行榜
     * @param req
     */
    @CMD(id = CmdCode._72010)
    public void reqRankInfo(PlayerContext playerContext, StageMatchGMsg.GReqRankInfo req){
        RanksReqMessage message = RanksReqMessage.getInstance();
        messageDispatcher.dispatch(message, result->{
            RanksResMessage resMessage = (RanksResMessage)result;
            GResRankInfo.Builder builder = GResRankInfo.newBuilder();

            for (RankDto rankDto : resMessage.getRanks()) {
                builder.addRankInfo(stageMatchConverter.buildRankInfo(rankDto));
            }
            playerContext.write(CmdCode._72010, builder.build());
        });
    }


}
