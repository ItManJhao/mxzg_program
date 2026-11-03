package com.ayjs.mxzg.gameserver.module.ladder.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LadderFightTimesSysCache;
import com.ayjs.mxzg.config.excel.cache.LadderPlayRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CLadderFightTimes;
import com.ayjs.mxzg.config.excel.entity.CLadderPlayReward;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobot;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.ladder.constant.LadderConstant;
import com.ayjs.mxzg.gameserver.module.ladder.domain.Ladder;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderMyBattle;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderSuperiorBattle;
import com.ayjs.mxzg.gameserver.module.ladder.service.LadderRankService;
import com.ayjs.mxzg.gameserver.module.ladder.service.LadderService;
import com.ayjs.mxzg.gameserver.module.ladder.struct.LadderBattleRole;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.struct.LadderData;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.gameserver.remote.cross.dao.CrossServerGroupDao;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import com.ayjs.mxzg.message.module.ladder.dao.LadderLikeRedisDao;
import com.ayjs.mxzg.message.module.ladder.domain.LadderLike;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderLikeReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.message.module.ladder.message.LadderChallengeResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefenderData;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefendersReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefendersResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderGetLineUpReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderGetLineUpResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderLikeNumAddReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderSuperiorBattleMessage;
import com.ayjs.mxzg.message.module.study.ReqBattlerVOMessage;
import com.ayjs.mxzg.message.module.study.ResBattlerVOMessage;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.LadderGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 天梯
 */
@Controller
@Slf4j
public class LadderHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private LadderService ladderService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private LadderPlayRewardSysCache ladderPlayRewardSysCache;
    @Autowired
    private ServerLadderRobotSysCache serverLadderRobotSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private LadderFightTimesSysCache ladderFightTimesSysCache;
    @Autowired
    private LadderRankService ladderRankService;
    @Autowired
    private LadderLikeRedisDao ladderLikeRedisDao;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private BattleTemplate battleTemplate;
    /**
     * 排名分页一页条数
     */
    public static int RANK_PAGE_NUM = 200;


    @CMD(id = CmdCode._43001)
    public void ladderInfo(PlayerContext playerContext, LadderGMsg.GReqLadderInfo msg) {
        long rid = playerContext.getId();
        Ladder ladder = ladderService.getLadder(rid);
        LadderData ladderData = ladderService.getLadderData();
        if (ladderService.isOpen()) {
            if (ladder.getDefendsTime() < ladderData.getStartTime()) {
                LadderDefendersReqMessage message = new LadderDefendersReqMessage();
                message.setRid(playerContext.getId());
                message.setServerId(serverConfig.getServerId());
                messageDispatcher.dispatch(message, response -> {
                    if (!ladderService.updateDefends(ladder, (LadderDefendersResMessage) response)) return;
                    ladderService.sendData(playerContext, ladder);
                });
                return;
            }
        }
        ladderService.sendData(playerContext, ladder);
    }

    @CMD(id = CmdCode._43002)
    public void refreshDefends(PlayerContext playerContext, LadderGMsg.GReqRefreshDefends req) {

        Asserts.isTrue(ladderService.isOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(), String.format("活动未开启{%s}-{%s}",
                ladderService.getLadderData().getStartTime(), ladderService.getLadderData().getEndTime()));

        Ladder ladder = ladderService.getLadder(playerContext.getId());
//        Asserts.isTrue(ladder.getLastRefreshDefend().plusSeconds(systemSysCache.getCrossServerLadderMatchFreshCd()).isBefore(LocalDateTime.now()),
//                ErrorCode.LADDER_IN_CD.getValue(), String.format("刷新按钮cd中{%s}-{%s}", ladder.getLastRefreshDefend(), LocalDateTime.now()));

        LadderDefendersReqMessage message = new LadderDefendersReqMessage();
        message.setRid(playerContext.getId());
        message.setServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(message, res -> {
            if (!ladderService.updateDefends(ladder, (LadderDefendersResMessage) res)) return;

            LadderGMsg.GResRefreshDefends.Builder builder = LadderGMsg.GResRefreshDefends.newBuilder();
            ladder.getDefends().forEach(defend -> {
                LadderGMsg.PSLadderRankData.Builder defendBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                defendBuilder.setRank(defend.getRank());
                defendBuilder.setRoleInfo(ladderService.builderLadderRole(defend));
                builder.addDefends(defendBuilder);
            });
            playerContext.write(CmdCode._43002, builder.build());
        });
    }

    @CMD(id = CmdCode._43003)
    public void challenge(PlayerContext playerContext, LadderGMsg.GReqLadderChallenge req) {

        Asserts.isTrue(ladderService.isOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(), String.format("活动未开启{%s}-{%s}",
                ladderService.getLadderData().getStartTime(), ladderService.getLadderData().getEndTime()));

        long rid = playerContext.getId();
        Ladder ladder = ladderService.getLadder(rid);

        Asserts.isTrue(ladder.getBattleTimes() > 0, ErrorCode.LADDER_BATTLE_TIMES_NOT_ENOUGH.getValue(),
                String.format("挑战次数不足{%s}", ladder.getBattleTimes()));

        LadderDefenderData ladderDefenderData = ladder.getDefends().stream().filter(defend ->
                defend.getRid() == req.getDefendId()).findFirst().orElse(null);

        if (ladderDefenderData == null) {//
            LadderGMsg.GResLadderChallenge.Builder builder = LadderGMsg.GResLadderChallenge.newBuilder();
            builder.setCode(1);
            builder.setSelfRank(ladderRankService.getRank(playerContext.getId()));
            ladder.getDefends().forEach(defend -> {
                LadderGMsg.PSLadderRankData.Builder defendBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                defendBuilder.setRank(defend.getRank());
                defendBuilder.setRoleInfo(ladderService.builderLadderRole(defend));
                builder.addDefends(defendBuilder);
            });
            builder.setBattleTimes(ladder.getBattleTimes());
            playerContext.write(CmdCode._43003, builder.build());
            return;
        }

        if (ladderDefenderData.isRealPlayer()) {
            messageDispatcher.dispatch(ReqBattlerVOMessage.of(ladderDefenderData.getRid(), ladderDefenderData.getServerId(), BattleType.LADDER_DEFEND.getValue()), response -> {
                BattlerDo attackDo = null;
                attackDo = ladderService.toMyAttackDo(rid);
                ResBattlerVOMessage message = (ResBattlerVOMessage) response;
                BattlerVo battlerVo = ProtostuffUtil.deserialize(message.getBattlerVo(), BattlerVo.class);
                BattlerDo defender = battleTemplate.queryBattler(battlerVo, message.getNick(), Faction.DEFENDER, UnitType.HERO);
                defender.setRoleInfo(message.getServerId(), message.getHeadId(), message.getBorderId(), message.getLevel(), message.getFighting());

                ladderService.crossBattle(rid, ladderDefenderData, attackDo, defender);
            });
        } else {
            BattlerDo attackDo = ladderService.toMyAttackDo(rid);

            List<CServerLadderRobot> list = serverLadderRobotSysCache.getTeam((int) ladderDefenderData.getRid());
            BattlerDo defendDo = battleTemplate.queryBattler(list, ladderDefenderData.getNick(), Faction.DEFENDER, UnitType.MOSTER);
            defendDo.setRoleInfo(ladderDefenderData.getServerId(), ladderDefenderData.getHeadId(), ladderDefenderData.getBorderId(), ladderDefenderData.getLevel(), ladderDefenderData.getFighting());
            defendDo.setPlayerId(ladderDefenderData.getRid());

            ladderService.crossBattle(rid, ladderDefenderData, attackDo, defendDo);
        }

    }


    /***
     * 战斗回调
     * @param message
     */
    @RemoteMethod
    public void challengeCallBack(LadderChallengeResMessage message) {
        LadderGMsg.GResLadderChallenge.Builder builder = LadderGMsg.GResLadderChallenge.newBuilder();

        if (message.getOperatorCode() == 0) {
            BattleGMsg.BattleReport battleReport = null;
            try {
                battleReport = BattleGMsg.BattleReport.parseFrom(message.getBattleReport());

                BattleGMsg.BattlerFightLog attackLog = battleReport.getLog().getAttackerLog();
                BattleGMsg.BattlerFightLog defendLog = battleReport.getLog().getDefenderLog();

                LadderBattleRole attackRole = ladderService.getLadderBattleRole(message.getAttackRank(), attackLog);
                LadderBattleRole defendRole = ladderService.getLadderBattleRole(message.getDefendRank(), defendLog);

                Ladder ladder = ladderService.getLadder(message.getRid());

                boolean exchangeRank = message.isExchangeRank();
                int newAttackRank = message.getAttackRank();
                int oldAttackRank = message.getAttackRank();
                int newDefendRank = message.getDefendRank();
                int oldDefendRank = message.getDefendRank();

                if (exchangeRank) {
                    oldAttackRank = message.getDefendRank();
                    oldDefendRank = message.getAttackRank();
                }
                int battleTime = (int) (battleReport.getStartTime() / 1000);
                if (message.getRid() == attackLog.getRid()) {
                    LadderMyBattle ladderMyBattle = ladderService.createRecord(newAttackRank, oldAttackRank, battleTime, attackLog.getRid(), attackRole,
                            defendRole, battleReport.getWinId(), battleReport.getBattleId());
                    ladderService.addOrReplace(ladderMyBattle);

                    if (CollectionUtil.isNotEmpty(message.getAttackNewDefends())) {
                        ladder.setDefends(message.getAttackNewDefends());
                    }

                    ladder.setBattleTimes(ladder.getBattleTimes() - 1);
                    ladderService.updateLadder(ladder);
                    ladder.setDefendsTime(DateTimeUtil.currentSecond());
                    ladderService.updateLadder(ladder);

                    CLadderPlayReward rewardConfig = DropUtil.randomDrop(ladderPlayRewardSysCache.getAll());
                    thingService.add(attackLog.getRid(), rewardConfig.getReward(), GameEvent.LADDER_CHALLENGE_REWARD, NoticeType.SLIENT);

                    builder.setCode(0);
                    builder.setBattleResult(battleReport.getWinId() == attackLog.getRid() ? 1 : 2);
                    builder.setDefendName(defendLog.getName());
                    builder.setSelfRank(message.getAttackRank());
                    builder.setDefendRank(message.getDefendRank());
                    builder.setRankUp(exchangeRank);
                    builder.setReport(battleReport);
                    ladder.getDefends().forEach(defend -> {
                        LadderGMsg.PSLadderRankData.Builder defendBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                        defendBuilder.setRank(defend.getRank());
                        defendBuilder.setRoleInfo(ladderService.builderLadderRole(defend));
                        builder.addDefends(defendBuilder);
                    });
                    builder.addAllReward(PbUtil.buildReward(rewardConfig.getReward()));
                    builder.setBattleTimes(ladder.getBattleTimes());

                    contextManager.write(attackLog.getRid(), CmdCode._43003, builder.build());
                    if (!message.isSuperiorBattle() && message.isDefendReallyPlayer())
                        eventBus.post(VideoRecordEvent.of(VideoType.LADDER, 0, battleReport, LadderConstant.NOT_SYSTEM));

                    //保存战报
                    SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(battleReport);
                    commandBus.invoke(saveBattleReportCommand);

                    ladderService.sendRedStatus(attackRole.getRid());

                }
                if (roleService.isRole(defendLog.getRid()) && message.getRid() == defendLog.getRid()) {
                    LadderMyBattle ladderMyBattle = ladderService.createRecord(newDefendRank, oldDefendRank, battleTime, defendLog.getRid(), attackRole,
                            defendRole, battleReport.getWinId(), battleReport.getBattleId());
                    ladderService.addOrReplace(ladderMyBattle);
                    if (CollectionUtil.isNotEmpty(message.getDefendNewDefends())) {
                        ladder.setDefends(message.getDefendNewDefends());
                    }
                    ladder.setDefendsTime(DateTimeUtil.currentSecond());
                    ladderService.updateLadder(ladder);
                    if (attackLog.getServerId() != defendLog.getServerId() && !message.isSuperiorBattle())//战斗
                        eventBus.post(VideoRecordEvent.of(VideoType.LADDER, 0, battleReport, LadderConstant.NOT_SYSTEM));

                    //保存战报
                    SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(battleReport);
                    commandBus.invoke(saveBattleReportCommand);

                    ladderService.sendRedStatus(defendRole.getRid());

                    //通知客户端界面数据
                    LadderGMsg.GResLadderInfo.Builder defendNewBuilder = LadderGMsg.GResLadderInfo.newBuilder();
                    defendNewBuilder.setMyRank(newDefendRank);
                    defendNewBuilder.setBattleTimes(ladder.getBattleTimes());
                    defendNewBuilder.setBuyTimes(ladder.getBuyTimes());
                    defendNewBuilder.setHadBuyTimes(ladder.getHadBuyTimes());
                    if (CollectionUtil.isNotEmpty(ladder.getDefends()))
                        ladder.getDefends().forEach(defend -> {
                            LadderGMsg.PSLadderRankData.Builder listBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                            listBuilder.setRank(defend.getRank());
                            listBuilder.setRoleInfo(ladderService.builderLadderRole(defend));
                            defendNewBuilder.addDefends(listBuilder);
                        });
                    contextManager.write(defendRole.getRid(), CmdCode._43001, defendNewBuilder.build());

                }
            } catch (InvalidProtocolBufferException e) {
                log.error("战报解析错误！", e);
            }

        } else {
            builder.setCode(1);
            Ladder ladder = ladderService.getLadder(message.getRid());
            builder.setSelfRank(ladderRankService.getRank(message.getRid()));
            ladder.getDefends().forEach(defend -> {
                LadderGMsg.PSLadderRankData.Builder defendBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                defendBuilder.setRank(defend.getRank());
                defendBuilder.setRoleInfo(ladderService.builderLadderRole(defend));
                builder.addDefends(defendBuilder);
            });
            builder.setBattleTimes(ladder.getBattleTimes());
            contextManager.write(message.getRid(), CmdCode._43003, builder.build());
        }
    }

    @RemoteMethod
    public void superiorBattle(LadderSuperiorBattleMessage message) {
        BattleGMsg.BattleReport battleReport = null;
        try {
            battleReport = BattleGMsg.BattleReport.parseFrom(message.getBattleReport());
        } catch (InvalidProtocolBufferException e) {
            log.error("战报解析错误", e);
            return;
        }

        BattleGMsg.BattlerFightLog attackLog = battleReport.getLog().getAttackerLog();
        BattleGMsg.BattlerFightLog defendLog = battleReport.getLog().getDefenderLog();

        LadderBattleRole attackRole = ladderService.getLadderBattleRole(message.getAttackRank(), attackLog);
        LadderBattleRole defendRole = ladderService.getLadderBattleRole(message.getDefendRank(), defendLog);

        LadderSuperiorBattle superiorBattle = new LadderSuperiorBattle();
        superiorBattle.setBattleTime((int) (battleReport.getStartTime() / 1000));
        superiorBattle.setWinRid(battleReport.getWinId());
        superiorBattle.setReportId(battleReport.getBattleId());
        superiorBattle.setAttack(attackRole);
        superiorBattle.setDefend(defendRole);
        ladderService.addOrReplaceSuperior(superiorBattle);

        //本服的大神战斗已经入库
        if (serverConfig.matchServerId(attackLog.getServerId()) || serverConfig.matchServerId(defendLog.getServerId()))
            eventBus.post(VideoRecordEvent.of(VideoType.LADDER, 0, battleReport, ""));

        //保存战报
        SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(battleReport);
        commandBus.invoke(saveBattleReportCommand);

    }


    @CMD(id = CmdCode._43004)
    public void oneKeyChallenge(PlayerContext playerContext, LadderGMsg.GReqLadderOneKeyChallenge req) {

        Asserts.isTrue(ladderService.isOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(), String.format("活动未开启{%s}-{%s}",
                ladderService.getLadderData().getStartTime(), ladderService.getLadderData().getEndTime()));

        long rid = playerContext.getId();
        Ladder ladder = ladderService.getLadder(rid);

        Asserts.isTrue(ladder.getBattleTimes() > 0, ErrorCode.LADDER_BATTLE_TIMES_NOT_ENOUGH.getValue(),
                String.format("挑战次数不足{%s}", ladder.getBattleTimes()));

        CLadderPlayReward rewardConfig = DropUtil.randomDrop(ladderPlayRewardSysCache.getAll());
        thingService.add(playerContext.getId(), rewardConfig.getReward(), GameEvent.LADDER_CHALLENGE_REWARD, NoticeType.NORMAL);

        ladder.setBattleTimes(ladder.getBattleTimes() - 1);
        ladderService.updateLadder(ladder);

        LadderGMsg.GResLadderOneKeyChallenge.Builder builder = LadderGMsg.GResLadderOneKeyChallenge.newBuilder();
        builder.setBattleTimes(ladder.getBattleTimes());

        playerContext.write(CmdCode._43004, builder.build());

    }

    @CMD(id = CmdCode._43005)
    public void getMyBattleRecord(PlayerContext playerContext, LadderGMsg.GReqMyLadderBattleRecord req) {
        LadderGMsg.GResMyLadderBattleRecord.Builder builder = LadderGMsg.GResMyLadderBattleRecord.newBuilder();
        Ladder ladder = ladderService.getLadder(playerContext.getId());
        List<LadderMyBattle> allMyBattle = ladderService.getAllMyBattle(playerContext.getId());
        allMyBattle.forEach(ladderMyBattle -> {
            LadderGMsg.PSMyLadderBattle.Builder battleBuilder = LadderGMsg.PSMyLadderBattle.newBuilder();
            battleBuilder.setBattleId(ladderMyBattle.getReportId());
            battleBuilder.setBattleTime(ladderMyBattle.getBattleTime());
            battleBuilder.setOldRank(ladderMyBattle.getOldRank());
            battleBuilder.setNewRank(ladderMyBattle.getNewRank());
            if (ladderMyBattle.getAttack().getRid() == ladderMyBattle.getRid()) {
                battleBuilder.setBattleType(1);
                battleBuilder.setDefendInfo(ladderService.getLadderRole(ladderMyBattle.getDefend()));
            } else {
                battleBuilder.setBattleType(2);
                battleBuilder.setDefendInfo(ladderService.getLadderRole(ladderMyBattle.getAttack()));
            }
            battleBuilder.setIsWin(ladderMyBattle.getWinRid() == ladderMyBattle.getRid() ? 1 : 0);

            battleBuilder.setIsRead(ladder.getReadTime() < ladderMyBattle.getBattleTime() ? 1 : 0);
//            battleBuilder.setOldRank(myLadderBattle.getOldRank());
            builder.addBattleDefendInfo(battleBuilder);
        });
        playerContext.write(CmdCode._43005, builder.build());
    }


    @CMD(id = CmdCode._43006)
    public void getHighLadderBattleRecord(PlayerContext playerContext, LadderGMsg.GReqHighLadderBattleRecord req) {
        List<LadderSuperiorBattle> allSuperiorBattle = ladderService.getAllSuperiorBattle();
        LadderGMsg.GResHighLadderBattleRecord.Builder builder = LadderGMsg.GResHighLadderBattleRecord.newBuilder();
        for (LadderSuperiorBattle ladderSuperiorBattle : allSuperiorBattle) {
            LadderGMsg.PSHighLadderBattle.Builder battleBuilder = LadderGMsg.PSHighLadderBattle.newBuilder();
            battleBuilder.setBattleId(ladderSuperiorBattle.getReportId());
            battleBuilder.setWinTeam(ladderSuperiorBattle.getWinRid());
            battleBuilder.setBattleTime(ladderSuperiorBattle.getBattleTime());
            battleBuilder.setAttackInfo(ladderService.getLadderRole(ladderSuperiorBattle.getAttack()));
            battleBuilder.setDefendInfo(ladderService.getLadderRole(ladderSuperiorBattle.getDefend()));
            builder.addBattleDefendInfo(battleBuilder);
        }

        playerContext.write(CmdCode._43006, builder.build());

    }

    @CMD(id = CmdCode._43007)
    public void rankList(PlayerContext playerContext, LadderGMsg.GReqLadderRank req) {
        LadderGMsg.GResLadderRank.Builder builder = LadderGMsg.GResLadderRank.newBuilder();
        List<CrossLadderRank> list = ladderRankService.getAllList();
        int page = req.getPage();
        int rankCount = list.size();
        int sendStatus = 1;// 已完成
        if (rankCount > (page - 1) * RANK_PAGE_NUM) {
            int end = Math.min(rankCount, page * RANK_PAGE_NUM);
            for (int i = RANK_PAGE_NUM * (page - 1); i < end; i++) {
                builder.addList(ladderRankService.builder(list.get(i)));
            }
            if (rankCount > page * RANK_PAGE_NUM) {
                sendStatus = 0;// 未完成
            }
        }
        builder.setSendStatus(sendStatus);
        builder.setPage(page);
        builder.setSelfData(ladderRankService.self(playerContext.getId()));
        playerContext.write(CmdCode._43007, builder.build());
    }

    @CMD(id = CmdCode._43008)
    public void getLineUpData(PlayerContext playerContext, LadderGMsg.GReqLadderLineUpData req) {

        Asserts.isTrue(ladderService.isOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(), String.format("活动未开启{%s}-{%s}",
                ladderService.getLadderData().getStartTime(), ladderService.getLadderData().getEndTime()));

        LadderGMsg.GResLadderLineUpData.Builder builder = LadderGMsg.GResLadderLineUpData.newBuilder();
        long defendId = req.getRid();
        Ladder ladder = ladderService.getLadder(playerContext.getId());
        LadderDefenderData ladderDefenderData = ladder.getDefends().stream().filter(defend -> defend.getRid() == defendId).findFirst().orElse(null);
        if (ladderDefenderData == null) {
            builder.setCode(1);
            playerContext.write(CmdCode._43008, builder.build());
            return;
        }
        if (ladderDefenderData.isRealPlayer()) {
            if (serverConfig.matchServerId(ladderDefenderData.getServerId())) {
                playerContext.write(CmdCode._43008, ladderService.builderLineup(defendId).build());
            } else {
                messageDispatcher.dispatch(LadderGetLineUpReqMessage.of(playerContext.getId(), serverConfig.getServerId(), defendId, ladderDefenderData.getServerId()), res -> {
                    LadderGetLineUpResMessage resMessage = (LadderGetLineUpResMessage) res;
                    try {
                        contextManager.write(resMessage.getRid(), CmdCode._43008, LadderGMsg.GResLadderLineUpData.parseFrom(resMessage.getLineUpData()));
                    } catch (InvalidProtocolBufferException e) {
                        log.error("解析阵容数据失败", e);
                    }
                });
            }
        } else {
            List<CServerLadderRobot> list = serverLadderRobotSysCache.getTeam((int) defendId);
            list.forEach(config -> {
                LadderGMsg.PSLadderBriefData.Builder heroBriefData = LadderGMsg.PSLadderBriefData.newBuilder();
                heroBriefData.setHeroType(config.getHero_type());
                heroBriefData.setLevel(config.getHero_level());
                heroBriefData.setStar(config.getHero_star());
                heroBriefData.setPos(config.getPos());
                heroBriefData.setHeroId(0);
                builder.addHeroData(heroBriefData);
            });
            builder.setFight(battleTemplate.computeMonsterStrength(list));
            builder.setFormationId(battleTemplate.formationId(list));
            contextManager.write(playerContext.getId(), CmdCode._43008, builder.build());
        }
    }

    @RemoteMethod
    public LadderGetLineUpResMessage getLadderLineUp(LadderGetLineUpReqMessage message) {
        long defendId = message.getDefendRid();
        return LadderGetLineUpResMessage.of(message.getRid(), message.serverId(), ladderService.builderLineup(defendId).build().toByteArray());
    }


    @CMD(id = CmdCode._43009)
    public void buyTimes(PlayerContext playerContext, LadderGMsg.GReqBuyTimes req) {

        Asserts.isTrue(ladderService.isOpen(), ErrorCode.LADDER_NOT_OPEN.getValue(), String.format("活动未开启{%s}-{%s}",
                ladderService.getLadderData().getStartTime(), ladderService.getLadderData().getEndTime()));

        Ladder ladder = ladderService.getLadder(playerContext.getId());

        Asserts.isTrue(ladder.getHadBuyTimes() <= ladderFightTimesSysCache.getMaxTimes(), ErrorCode.LADDER_BUY_TIMES_MAX.getValue(),
                String.format("次数上限{%s}", ladder.getHadBuyTimes()));

        CLadderFightTimes config = ladderFightTimesSysCache.getById(ladder.getHadBuyTimes() + 1);
        thingService.cost(playerContext.getId(), config.getCost(), GameEvent.LADDER_CHALLENGE_COST);
        ladder.setHadBuyTimes(ladder.getHadBuyTimes() + 1);
        ladder.setBuyTimes(ladder.getBuyTimes() - 1);
        ladder.setBattleTimes(ladder.getBattleTimes() + 1);
        ladderService.updateLadder(ladder);

        LadderGMsg.GResBuyTimes.Builder builder = LadderGMsg.GResBuyTimes.newBuilder();
        builder.setHadBuyTimes(ladder.getHadBuyTimes());
        builder.setBattleTimes(ladder.getBattleTimes());
        builder.setBuyTimes(ladder.getBuyTimes());

        playerContext.write(CmdCode._43009, builder.build());

    }

    @CMD(id = CmdCode._43010)
    public void like(PlayerContext playerContext, LadderGMsg.GReqLikeSuperior req) {
        Ladder ladder = ladderService.getLadder(playerContext.getId());

        CrossServerGroup group = crossServerGroupDao.get();

        Asserts.notNull(group, ErrorCode.CROSS_SERVICE_HAS_BEEN_DISCONNECTED.getValue(), "不存在跨服组");

        LadderLike ladderLike = ladderLikeRedisDao.get(LadderLike.getKey(group.getGroupId(), req.getRank()));

        Asserts.notNull(ladderLike, ErrorCode.LADDER_NOT_HAVE_LIST.getValue(), String.format("不存咋点赞列表{%s}", req.getRank()));

        Asserts.isTrue(ladder.getLikeTime().get(req.getRank()) == null || !ladder.getLikeTime().get(req.getRank()).isEqual(LocalDate.now()),
                ErrorCode.LADDER_HAD_LIKE.getValue(), String.format("今日已经点赞{%s}", ladder.getLikeTime()));

        Role role = roleService.getOrThrow(ladder.getRid());

        ladder.getLikeTime().put(req.getRank(), LocalDate.now());
        ladderService.updateLadder(ladder);

        thingService.add(ladder.getRid(), systemSysCache.getCrossServerLadderLikeReward(), GameEvent.LADDER_RANK, NoticeType.TIPS);

        messageDispatcher.dispatch(LadderLikeNumAddReqMessage.of(req.getRank(), serverConfig.getServerId()), response -> {
            LadderGMsg.GResLikeList.Builder builder = LadderGMsg.GResLikeList.newBuilder();
            builder.addAllLikeData(ladderService.getLakeList(role.getId()));

            playerContext.write(CmdCode._43013, builder.build());
        });

        if (ladderLike.isReallyPlayer())
            messageDispatcher.dispatch(CrossLadderLikeReqMessage.of(role.getServerId(), role.getNick(), ladderLike.getRid(), ladderLike.getServerId()));
    }


    @RemoteMethod
    public void beLike(CrossLadderLikeReqMessage message) {
        LadderGMsg.GResBeLikeSuperior.Builder builder = LadderGMsg.GResBeLikeSuperior.newBuilder();
        builder.setLikeName(message.getLikeName());
        builder.setLikeServerId(message.getLikeServerId());
        contextManager.write(message.getBeLikeId(), CmdCode._43011, builder.build());

    }

    @CMD(id = CmdCode._43013)
    public void likeList(PlayerContext playerContext, LadderGMsg.GReqLikeList req) {
        Ladder ladder = ladderService.getLadder(playerContext.getId());
        LadderGMsg.GResLikeList.Builder builder = LadderGMsg.GResLikeList.newBuilder();

        CrossServerGroup group = crossServerGroupDao.get();
        if (group == null) {
            return;
        }
        List<String> rankList = new ArrayList<>();
        rankList.add(LadderLike.getKey(group.getGroupId(), 1));
        rankList.add(LadderLike.getKey(group.getGroupId(), 2));
        rankList.add(LadderLike.getKey(group.getGroupId(), 3));
        List<LadderLike> ladderLikes = ladderLikeRedisDao.get(rankList);
        ladderLikes.forEach(ladderLike -> {
            if (Objects.nonNull(ladderLike)) {

                LadderGMsg.PSLikeData.Builder likeData = LadderGMsg.PSLikeData.newBuilder();
                likeData.setClanName(ladderLike.getClanName());
                likeData.setNick(ladderLike.getNick());
                likeData.setLikeNum(ladderLike.getLikeNum());
                likeData.setRank(ladderLike.getRank());
                likeData.setImage(ladderLike.getImage());
                likeData.setCanLike(ladder.getLikeTime().get(ladderLike.getRank()) == null ||
                        !ladder.getLikeTime().get(ladderLike.getRank()).isEqual(LocalDate.now()) ? true : false);
                builder.addLikeData(likeData);
            }
        });

        playerContext.write(CmdCode._43013, builder.build());
    }

    @CMD(id = CmdCode._43014)
    public void redList(PlayerContext playerContext, LadderGMsg.GReqMyBattleRed req) {
        long rid = playerContext.getId();
        ladderService.sendRedStatus(rid);
    }


    @CMD(id = CmdCode._43015)
    public void readBattle(PlayerContext playerContext, LadderGMsg.GReqLadderReadReport req) {
        Ladder ladder = ladderService.getLadder(playerContext.getId());
        ladder.setReadTime(TimeDateUtil.getCurrentTimeInt());
        ladderService.updateLadder(ladder);
        playerContext.write(CmdCode._43015, LadderGMsg.GResLadderReadReport.getDefaultInstance());
    }


}
