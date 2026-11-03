package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchFirstPlayRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondBuyConsumeSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.entity.CTopMatchFirstPlayReward;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondBuyConsume;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.converter.StageMatchConverter;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao.PreliminariesGreatStyleLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao.PreliminariesRecordDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.*;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesRankService;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.*;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.PinnacleGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 巅峰赛
 */
@Slf4j
@Component
public class PreliminariesHandler extends ProtocolHandler {

    @Value("${server.id}")
    private int serverId;
    @Autowired
    private PreliminariesService preliminariesService;
    @Autowired
    private PreliminariesRankService preliminariesRankService;
    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private StageMatchConverter stageMatchConverter;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private StageMatchDao stageMatchDao;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private PreliminariesRecordDao preliminariesRecordDao;
    @Autowired
    private PreliminariesGreatStyleLogDao preliminariesGreatStyleLogDao;
    @Autowired
    private TopMatchSecondBuyConsumeSysCache topMatchSecondBuyConsumeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private TopMatchFirstPlayRewardSysCache topMatchFirstPlayRewardSysCache;


    /**
     * 请求段位赛基本信息
     *
     * @param req
     */
    @CMD(id = CmdCode._72501)
    public void reqPreliminaries(PlayerContext playerContext, GReqPreliminaries req) {
        PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(playerContext.getId());

        if (!CollectionUtils.isEmpty(preliminariesLadder.getDefends())) {
            playerContext.write(CmdCode._72501, stageMatchConverter.buildFrom(preliminariesLadder));
        } else {
            messageDispatcher.dispatch(PreliminariesDefendersReqMessage.of(playerContext.getId(), playerContext.getServerId()), result -> {
                PreliminariesDefendersResMessage message = (PreliminariesDefendersResMessage) result;
                preliminariesLadder.setDefends(message.getDefenders());
                preliminariesLadderDao.update(preliminariesLadder);
                playerContext.write(CmdCode._72501, stageMatchConverter.buildFrom(preliminariesLadder));
            });
        }
    }

    /**
     * 刷新对手
     *
     * @param req
     */
    @CMD(id = CmdCode._72502)
    public void reqRefresh(PlayerContext playerContext, GReqRefreshOpponent req) {
        messageDispatcher.dispatch(PreliminariesDefendersReqMessage.of(playerContext.getId(), playerContext.getServerId()), result -> {
            PreliminariesDefendersResMessage message = (PreliminariesDefendersResMessage) result;
            PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(playerContext.getId());
            preliminariesLadder.setDefends(message.getDefenders());
            preliminariesService.updateLadder(preliminariesLadder);
            GResRefreshOpponent.Builder builder = GResRefreshOpponent.newBuilder();
            for (RankDto defender : message.getDefenders()) {
                builder.addOpponent(stageMatchConverter.buildRoleInfo(defender));
            }
            playerContext.write(CmdCode._72502, builder.build());
        });
    }

    /**
     * 挑战对手
     *
     * @param req
     */
    @CMD(id = CmdCode._72503)
    public void reqChallenge(PlayerContext playerContext, GReqChallengeOpponent req) {
        StageMatch stageMatch = stageMatchDao.get();
        Asserts.isTrue(stageMatch.getStage() == StageType.PRELIMINARIES.ordinal(), ErrorCode.PRELIMINARIES_NOT_OPEN.getValue(),
                ()->String.format("预赛未开启%s", stageMatch.getStage()));

        PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(playerContext.getId());
        Asserts.isTrue(preliminariesLadder.getRemainingChallenges() > 0, ErrorCode.NOT_ENOUGH_CHALLENGES.getValue(),
                ()->String.format("预赛挑战次数不足"));
        PreliminariesChallengeReqMessage.PreliminariesChallengeReqMessageBuilder messageBuilder = PreliminariesChallengeReqMessage.builder();
        messageBuilder.attackRid(playerContext.getId()).attackServerId(playerContext.getServerId());
        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.PINNACLE, playerContext.getId(), Faction.ATTACKER);
        messageBuilder.attackBattlerVo(JSON.toJSONString(battlerDo.toBattlerVo())).atkFighting(battlerDo.getFighting());
        messageBuilder.defendRid(req.getRid()).defendRank(req.getRank());
        int oldRank = preliminariesRankService.getRank(playerContext.getId());
        messageDispatcher.dispatch(messageBuilder.build(), result -> {
            PreliminariesChallengeResMessage message = (PreliminariesChallengeResMessage) result;
            if(message.getLanguageId() != 0){
                playerContext.write(CmdCode._72503, GResChallengeOpponent.newBuilder().setReport(BattleReport.getDefaultInstance()).setLanguageId(message.getLanguageId()).build());
                return;
            }

            PreliminariesLadder ladder = preliminariesService.getLadder(playerContext.getId());

            ladder.updateResultInfo(message.getNewAttackerLadder());
            preliminariesLadderDao.update(ladder);

            GResChallengeOpponent.Builder builder = GResChallengeOpponent.newBuilder();
            builder.setAtkRank(message.getAttackRank()).setDefRank(message.getDefendRank()).setRemainingTimes(ladder.getRemainingChallenges()).setAtkOldRank(oldRank);
            for (RankDto rankDto : ladder.getDefends()) {
                builder.addOpponent(stageMatchConverter.buildRoleInfo(rankDto));
            }
            try {
                BattleReport report = BattleReport.parseFrom(message.getBattleReport());
                builder.setReport(report);

                CTopMatchFirstPlayReward rewardConfig = DropUtil.randomDrop(topMatchFirstPlayRewardSysCache.getAll());
                thingService.add(playerContext.getId(), rewardConfig.getReward(), GameEvent.PRELIMINARIES_CHALLENGE_REWARD, NoticeType.SLIENT);
                builder.addAllReward(PbUtil.buildReward(rewardConfig.getReward()));

                MyRecord myRecord = stageMatchConverter.buildMyRecord(message.getAttackRank(), oldRank, report.getLog(), report.getLog().getDefenderLog(), playerContext.getId());
                PreliminariesRecord preliminariesRecord = preliminariesRecordDao.getOrCreate(playerContext.getId());
                preliminariesRecord.addLog(myRecord);
                preliminariesRecordDao.update(preliminariesRecord);

                commandBus.invoke(SaveBattleReportCommand.of(report));
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
            playerContext.write(CmdCode._72503, builder.build());
        });
    }

    /**
     * 购买次数
     *
     * @param req
     */
    @CMD(id = CmdCode._72504)
    public void reqPurchases(PlayerContext playerContext, GReqPreliminariesPurchases req) {
        PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(playerContext.getId());
        Asserts.isTrue(preliminariesLadder.notPurchaseLimit(), ErrorCode.PURCHASE_LIMIT.getValue(), () -> String.format("达到购买次数上限%s", playerContext.getId()));

        CTopMatchSecondBuyConsume consume = topMatchSecondBuyConsumeSysCache.getOrThrow(preliminariesLadder.getPurchases() + 1);
        thingService.cost(playerContext.getId(), consume.getConsume(), GameEvent.PURCHASE_MATCHES);

        preliminariesLadder.addPurchases();
        preliminariesLadderDao.update(preliminariesLadder);

        GResPreliminariesPurchases.Builder builder = GResPreliminariesPurchases.newBuilder();
        builder.setRemainingPurchases(preliminariesLadder.getRemainingPurchases()).setRemainingTimes(preliminariesLadder.getRemainingChallenges());
        playerContext.write(CmdCode._72504, builder.build());
    }

    /**
     * 我的记录
     *
     * @param req
     */
    @CMD(id = CmdCode._72505)
    public void reqMyCord(PlayerContext playerContext, GReqPreliminariesRecord req) {
        PreliminariesRecord preliminariesRecord = preliminariesRecordDao.getOrCreate(playerContext.getId());

        GResPreliminariesRecord.Builder builder = GResPreliminariesRecord.newBuilder();
        for (MyRecord record : preliminariesRecord.getRecords()) {
            builder.addRecord(stageMatchConverter.buildPSMyRecordFrom(record));
        }
        playerContext.write(CmdCode._72505, builder.build());
    }

    /**
     * 大神风采
     *
     * @param req
     */
    @CMD(id = CmdCode._72506)
    public void reqGreatDemeanor(PlayerContext playerContext, GReqGreatDemeanor req) {
        PreliminariesGreatStyleLog greatStyleLog = preliminariesGreatStyleLogDao.get();
        GResGreatDemeanor.Builder builder = GResGreatDemeanor.newBuilder();
        for (BattleRecord record : greatStyleLog.getRecords()) {
            builder.addDemeanor(stageMatchConverter.buildPSGreatDemeanorFrom(record));
        }
        playerContext.write(CmdCode._72506, builder.build());
    }

    /**
     *
     * 请求阵容信息
     * @param req
     */
    @CMD(id = CmdCode._72507)
    public void reqPinnacleLineUpData(PlayerContext playerContext, GReqPinnacleLineUpData req){
        RankDto rankDto = preliminariesRankService.getRankDto(req.getRid());
        Asserts.notNull(rankDto, ErrorCode.THE_RANKING_HAS_CHANGED.getValue(), () -> String.format("该玩家排名已经变化，请刷新后重新挑战%s", playerContext.getId()));

        if (rankDto.getServerId() == serverId) {
            playerContext.write(CmdCode._72507, preliminariesService.builderLineup(req.getRid()).build());
        } else {
            messageDispatcher.dispatch(PreliminariesGetLineUpReqMessage.of(rankDto.getRid(), rankDto.getServerId()), res -> {
                PreliminariesGetLineUpResMessage resMessage = (PreliminariesGetLineUpResMessage) res;
                try {
                    playerContext.write(CmdCode._72507, GResPinnacleLineData.parseFrom(resMessage.getLineUpData()));
                } catch (InvalidProtocolBufferException e) {
                    log.error("解析阵容数据失败", e);
                }
            });
        }
    }

    /**
     *
     * 请求排行榜信息
     * @param req
     */
    @CMD(id = CmdCode._72508)
    public void reqPreliminariesRanks(PlayerContext playerContext, GReqPreliminariesRank req){
        GResPreliminariesRank.Builder builder = GResPreliminariesRank.newBuilder();
        List<PSPinnacleRanker> ranks = preliminariesRankService.getShowRank();
        builder.addAllRanks(ranks);
        playerContext.write(CmdCode._72508, builder.build());
    }

    /**
     *
     * 点赞
     * @param req
     */
    @CMD(id = CmdCode._72509)
    public void reqPreliminariesLike(PlayerContext playerContext, GReqPreliminariesLike req){
        PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(playerContext.getId());

        Asserts.isTrue(!preliminariesLadder.getLikes().contains(req.getRid()), ErrorCode.ALREADY_LIKED.getValue(),
                () -> String.format("已经给该玩家%s点过赞%s", req.getRid(), preliminariesLadder.getLikes()));

        Asserts.isTrue(preliminariesLadder.getLikes().size() < PinnacleConst.PINNACLE_MAX_LIKE, ErrorCode.PINNACLE_MAX_LIKE.getValue(),
                () -> String.format("已经达到每日点赞次数上限", preliminariesLadder.getLikes().size()));

        int rank = preliminariesRankService.getRank(req.getRid());
        PreliminariesLikeNumAddReqMessage message = PreliminariesLikeNumAddReqMessage.of(rank);
        messageDispatcher.dispatch(message, result -> {
            PreliminariesLikeNumAddResMessage res = (PreliminariesLikeNumAddResMessage)result;
            if(res.getRankDto() != null){
                preliminariesRankService.updateRanker(res.getRankDto());
            }
            preliminariesLadder.addLikes(req.getRid());
            preliminariesService.updateLadder(preliminariesLadder);

            thingService.add(playerContext.getId(), PinnacleConst.PINNACLE_LIKE_REWARD, GameEvent.PRELIMINARIES_LIKE_REWARD, NoticeType.TIPS);

            GResPreliminariesLike.Builder builder = GResPreliminariesLike.newBuilder();
            builder.setRid(req.getRid());
            playerContext.write(CmdCode._72509, builder.build());
        });
    }

}
