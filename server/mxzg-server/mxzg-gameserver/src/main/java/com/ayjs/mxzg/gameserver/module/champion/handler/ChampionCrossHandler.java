/**
 *
 */
package com.ayjs.mxzg.gameserver.module.champion.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CChampionReward;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCrossReport;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionCrossReportService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionPlayerService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionCoinResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuess;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuessWinner;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionHero;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionKnockoutBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRankResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRanker;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiuList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiuList.ReqChampionBiuListBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiubiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiubiu.ReqChampionBiubiuBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionGuessList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionGuessList.ReqChampionGuessListBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionLike;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionLike.ReqChampionLikeBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionRank.ReqChampionRankBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionReport;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionReport.ReqChampionReportBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionSaveFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionSaveFormation.ReqChampionSaveFormationBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowMyResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowMyResult.ReqChampionShowMyResultBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowTop;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowTop.ReqChampionShowTopBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGetChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGetChampionBattle.ReqGetChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessChampionBattle.ReqGuessChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessOneBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessOneBattle.ReqGuessOneBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqMyChampionBattle.ReqMyChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionKnockout;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionKnockout.ReqScanChampionKnockoutBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionMessage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionMessage.ReqScanChampionMessageBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanMyChampionBattle.ReqScanMyChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiubiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionCrossCleanBiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionEnd;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionFormationChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessBroadcast;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessWin;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionLike;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowMyResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowTop;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionStageChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGetChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessOneBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionKnockout;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionMessage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanMyChampionBattle;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossBiuList;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossBiubiu;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossGuessList;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossLike;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossRank;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossSaveFormation;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossShowMyResult;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqChampionCrossShowTop;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqGetChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqGuessChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqGuessCrossOneBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqMyChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqScanChampionCross;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqScanChampionCrossKnockout;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GReqScanMyChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossBiuChange;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossBiuList;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossBiubiu;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossCleanBiu;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossEnd;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossFormationChange;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossGuessList;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossGuessWin;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossLike;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossRank;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossSaveFormation;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossShowMyResult;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossShowTop;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResChampionCrossStageChange;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResGetChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResGuessChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResGuessCrossOneBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResMyChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResScanChampionCross;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResScanChampionCrossKnockout;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResScanMyChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossBiu;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossFormation;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossGuess;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossHero;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossKnockoutBattle;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossMyResult;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossRank;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.PSChampionCrossRanker;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionGuessBroadcast;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author YY
 * 跨服冠军赛
 */
@Slf4j
@Controller
public class ChampionCrossHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private ChampionPlayerService championPlayerService;
    @Autowired
    private ChampionSeasonSysCache championSeasonSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private ChampionCrossReportService championCrossReportService;
    @Autowired
    private ChampionRewardSysCache championRewardSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;

    @CMD(id = CmdCode._41101)
    public void scanChampion(PlayerContext playerContext, GReqScanChampionCross msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        COpenCondition cOpenCondition = openConditionSysCache.getCondition(EntryType.MAIN_CHAMPION);
        if (role.getLevel() < cOpenCondition.getCondition_value()) {
            playerContext.write(CmdCode._41101, GResScanChampionCross.getDefaultInstance());
            return;
        }

        ReqScanChampionMessageBuilder builder = ReqScanChampionMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanChampion(ResScanChampionMessage message) {
        GResScanChampionCross.Builder builder = GResScanChampionCross.newBuilder();
        builder.setLike(message.getLike());
        builder.setPeriod(message.getPeriod());
        builder.setRank(message.getRank());
        builder.setHisRank(message.getHisRank());
        builder.setStartTime(message.getStartTime());
        builder.setEndTime(message.getEndTime());
        if (message.getLikeRank() != null) {
            builder.addAllLikeRank(message.getLikeRank());
        }
        if (message.getRanks() != null) {
            for (CSChampionRank championTop : message.getRanks()) {
                builder.addRanks(serialChampionRank(championTop));
            }
        }
        builder.setBiuCd(message.getBiuCd());
        builder.setShowRound(message.getShowRound());
        if (message.getResult() != null) {
            PSChampionCrossMyResult.Builder model = PSChampionCrossMyResult.newBuilder();
            model.setRank(message.getResult().getRank());
            model.setBattleNum(message.getResult().getBattleNum());
            model.setWinNum(message.getResult().getWinNum());
            builder.setResult(model.build());
        }
        builder.setBattleStartTime(message.getBattleStartTime());
        builder.setBattleRound(message.getBattleRound());
        contextManager.write(message.getRid(), CmdCode._41101, builder.build());
    }


    private PSChampionCrossRank serialChampionRank(CSChampionRank championRank) {
        PSChampionCrossRank.Builder builder = PSChampionCrossRank.newBuilder();
        builder.setRid(championRank.getRid());
        builder.setRobot(championRank.getRobot());
        if (championRank.getName() != null) {
            builder.setName(championRank.getName());
        } else {
            builder.setName("");
        }
        builder.setLike(championRank.getLike());
        builder.setImageId(championRank.getImageId());
        builder.setRank(championRank.getRank());
        return builder.build();
    }

    @CMD(id = CmdCode._41102)
    public void scanMyBattle(PlayerContext playerContext, GReqMyChampionCrossBattle msg) {
        ReqMyChampionBattleBuilder builder = ReqMyChampionBattle.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanMyBattle(ResMyChampionBattle message) {
        GResMyChampionCrossBattle.Builder builder = GResMyChampionCrossBattle.newBuilder();

        builder.setPeriod(message.getPeriod());
        builder.setBattleRound(message.getBattleRound());
        builder.setNextTime(message.getNextTime());

        if (message.getAttacker() != null) {
            builder.setAttacker(serialFormation(message.getAttacker()));
        }
        if (message.getDefender() != null) {
            builder.setDefender(serialFormation(message.getDefender()));
        }
        builder.setBid(message.getBid());
        if (message.getBattleId() != null) {
            builder.setBattleId(message.getBattleId());
        }
        builder.setWhichWin(message.getWhichWin());
        builder.setStage(message.getStage());
        contextManager.write(message.getRid(), CmdCode._41102, builder.build());
    }

    private PSChampionCrossFormation serialFormation(CSChampionFormation formation) {
        PSChampionCrossFormation.Builder builder = PSChampionCrossFormation.newBuilder();
        builder.setLevel(formation.getLevel());
        builder.setHeadId(formation.getHeadId());
        builder.setBorderId(formation.getBorderId());
        builder.setRid(formation.getRid());
        if (formation.getName() != null) {
            builder.setName(formation.getName());
        } else {
            builder.setName("");
        }
        builder.setFighting(formation.getFighting());
        builder.setRobot(formation.getRobot());
        builder.setFormationId(formation.getFormationId());
        builder.setAssistanceUnlock(true);
        if (formation.getHeros() != null) {
            for (CSChampionHero hero : formation.getHeros()) {
                PSChampionCrossHero.Builder model = PSChampionCrossHero.newBuilder();
                model.setId(hero.getId());
                model.setPos(hero.getPos());
                model.setHeroType(hero.getHeroType());
                model.setLevel(hero.getLevel());
                model.setStage(hero.getStage());
                model.setStar(hero.getStar());
                model.setFashionId(hero.getFashionId());
                builder.addHeros(model.build());
            }
        }
        return builder.build();
    }

    @CMD(id = CmdCode._41103)
    public void scanGuessBattle(PlayerContext playerContext, GReqGuessChampionCrossBattle msg) {
        ReqGuessChampionBattleBuilder builder = ReqGuessChampionBattle.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanGuessBattle(ResGuessChampionBattle message) {
        GResGuessChampionCrossBattle.Builder builder = GResGuessChampionCrossBattle.newBuilder();
        builder.setPeriod(message.getPeriod());
        builder.setBattleRound(message.getBattleRound());
        builder.setNextTime(message.getNextTime());

        if (message.getAttacker() != null) {
            builder.setAttacker(serialFormation(message.getAttacker()));
        }
        if (message.getDefender() != null) {
            builder.setDefender(serialFormation(message.getDefender()));
        }
        builder.setBid(message.getBid());
        if (message.getBattleId() != null) {
            builder.setBattleId(message.getBattleId());
        }
        builder.setWhichWin(message.getWhichWin());
        builder.setAtkCoin(message.getAtkCoin());
        builder.setDefCoin(message.getDefCoin());
        builder.setGuessCoin(message.getGuessCoin());
        builder.setIsGuess(message.getIsGuess());
        builder.setStage(message.getStage());
        builder.setGuessType(message.getGuessType());
        contextManager.write(message.getRid(), CmdCode._41103, builder.build());
    }

    @CMD(id = CmdCode._41104)
    public void guessBattle(PlayerContext playerContext, GReqGuessCrossOneBattle msg) {
        ReqGuessOneBattleBuilder builder = ReqGuessOneBattle.builder();
        builder.rid(playerContext.getId());
        builder.type(msg.getType());
        builder.guessCoin(msg.getGuessCoin());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void guessBattle(ResGuessOneBattle message) {
        GResGuessCrossOneBattle.Builder builder = GResGuessCrossOneBattle.newBuilder();
        builder.setGuessCoin(message.getGuessCoin());
        contextManager.write(message.getRid(), CmdCode._41104, builder.build());

//		GResChampionGuessBroadcast.Builder builder0 = GResChampionGuessBroadcast.newBuilder();
//		builder0.setType(msg.getType());
//		builder0.setGuessCoin(msg.getGuessCoin());
//		contextManager.writeAll(CmdCode._41119, builder0.build());

    }


    @CMD(id = CmdCode._41105)
    public void getChampionBattle(PlayerContext playerContext, GReqGetChampionCrossBattle msg) {
        ReqGetChampionBattleBuilder builder = ReqGetChampionBattle.builder();
        builder.rid(playerContext.getId());
        builder.bid(msg.getBid());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void getChampionBattle(ResGetChampionBattle message) {
        GResGetChampionCrossBattle.Builder builder = GResGetChampionCrossBattle.newBuilder();
        builder.setBattleId(message.getBattleId());
        contextManager.write(message.getRid(), CmdCode._41105, builder.build());
    }

    @CMD(id = CmdCode._41106)
    public void scanChampion32(PlayerContext playerContext, GReqScanChampionCrossKnockout msg) {
        ReqScanChampionKnockoutBuilder builder = ReqScanChampionKnockout.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanChampion32(ResScanChampionKnockout message) {
        GResScanChampionCrossKnockout.Builder builder = GResScanChampionCrossKnockout.newBuilder();
        builder.setGuessId(message.getGuessId());
        builder.setBattleRound(message.getBattleRound());
        builder.setNextTime(message.getNextTime());
        builder.setStage(message.getStage());
        //这里用下标进行循环，避免正在遍历中修改列表的情况
        if (message.getBattles() != null) {
            for (CSChampionKnockoutBattle battle : message.getBattles()) {
                builder.addBattles(serial32Battle(battle));
            }
        }
        contextManager.write(message.getRid(), CmdCode._41106, builder.build());
    }


    private PSChampionCrossKnockoutBattle serial32Battle(CSChampionKnockoutBattle battle) {
        PSChampionCrossKnockoutBattle.Builder builder = PSChampionCrossKnockoutBattle.newBuilder();
        builder.setAtkName(battle.getAtkName());
        builder.setDefName(battle.getDefName());
        builder.setBid(battle.getBid());
        builder.setBattleRound(battle.getBattleRound());
        builder.setWhichWin(battle.getWhichWin());
        if (battle.getBattleId() != null) {
            builder.setBattleId(battle.getBattleId());
        }
        builder.setWinHead(battle.getWinHead());
        builder.setWinBorder(battle.getWinBorder());
        builder.setAtkRid(battle.getAtkRid());
        builder.setDefRid(battle.getDefRid());
        return builder.build();
    }

    @CMD(id = CmdCode._41107)
    public void championLike(PlayerContext playerContext, GReqChampionCrossLike msg) {
        ReqChampionLikeBuilder builder = ReqChampionLike.builder();
        builder.rid(playerContext.getId());
        builder.targetRid(msg.getRid());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void championLike(ResChampionLike message) {
        thingService.add(message.getRid(), ChampionConst.CROSS_LIKE_REWARD, GameEvent.CHAMPION_CROSS_LIKE, NoticeType.TIPS);

        GResChampionCrossLike.Builder builder = GResChampionCrossLike.newBuilder();
        builder.setRid(message.getTargetRid());
        contextManager.write(message.getRid(), CmdCode._41107, builder.build());
    }

    @CMD(id = CmdCode._41108)
    public void championBiubiubiu(PlayerContext playerContext, GReqChampionCrossBiubiu msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        // 是否被禁言
        Asserts.isTrue(role.getForbidWordsEndTime() < DateTimeUtil.currentSecond(),
                ErrorCode.CHAT_FORBID.getValue(), () -> String.format("ForbidWordsEndTime:%s, current:%s",
                        role.getForbidWordsEndTime(), DateTimeUtil.currentSecond()));

        boolean canSendOther = sensitiveWordService.wordCanUseChat(msg.getContent());
        Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());

        canSendOther = sensitiveWordService.wordCanUse(msg.getContent(), role);
        Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());

        boolean enough = thingService.enough(playerContext.getId(), ChampionConst.BIU_COST);
        Asserts.isTrue(enough, ErrorCode.BAG_ITEM_LACK.getValue(), "道具不足");

        ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
        Asserts.isTrue(championPlayer.getCrossBiuCd() < TimeDateUtil.getCurrentTimeInt(),
                ErrorCode.CHAMPION_BIU_CD.getValue(), "你发表弹幕信息太快了");

        CChampionSeason championSeason = championSeasonSysCache.getCrossSeason();

        // 弹幕长度限制
        Asserts.isTrue(StringUtil.getShowLength(msg.getContent()) <= championSeason.getBiu_len(),
                ErrorCode.CHAMPION_BIU_LONG.getValue(), String.format("弹幕信息太长了：字符长度：{%s}，限制长度{%s}",
                        StringUtil.getShowLength(msg.getContent()), championSeason.getBiu_len()));

        thingService.cost(playerContext.getId(), ChampionConst.BIU_COST, GameEvent.CHAMPION_BIUBIUBIU);

        championPlayer.setCrossBiuCd(TimeDateUtil.getCurrentTimeInt() + championSeason.getBiu_cd());
        championPlayerService.update(championPlayer);

        ReqChampionBiubiuBuilder builder = ReqChampionBiubiu.builder();
        builder.rid(playerContext.getId());
        builder.content(msg.getContent());
        builder.biuCd(championPlayer.getCrossBiuCd());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void championBiubiubiu(ResChampionBiubiu message) {
        GResChampionCrossBiubiu.Builder builder = GResChampionCrossBiubiu.newBuilder();
        builder.setBiuCd(message.getBiuCd());
        contextManager.write(message.getRid(), CmdCode._41108, builder.build());
    }


    @CMD(id = CmdCode._41109)
    public void getBiuList(PlayerContext playerContext, GReqChampionCrossBiuList msg) {
        ReqChampionBiuListBuilder builder = ReqChampionBiuList.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void getBiuList(ResChampionBiuList message) {
        GResChampionCrossBiuList.Builder builder = GResChampionCrossBiuList.newBuilder();
        if (message.getContent() != null) {
            for (CSChampionBiu biu : message.getContent()) {
                PSChampionCrossBiu.Builder model = PSChampionCrossBiu.newBuilder();
                model.setRid(biu.getRid());
                model.setContent(biu.getContent());
                builder.addContent(model.build());
            }
        }
        contextManager.write(message.getRid(), CmdCode._41109, builder.build());
    }


    @CMD(id = CmdCode._41111)
    public void getGuessList(PlayerContext playerContext, GReqChampionCrossGuessList msg) {
        ReqChampionGuessListBuilder builder = ReqChampionGuessList.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void getGuessList(ResChampionGuessList message) {
        GResChampionCrossGuessList.Builder builder = GResChampionCrossGuessList.newBuilder();
        if (message.getRecord() != null) {
            for (CSChampionGuess guess : message.getRecord()) {
                builder.addRecord(serialize(guess));
            }
        }
        contextManager.write(message.getRid(), CmdCode._41111, builder.build());
    }

    private PSChampionCrossGuess serialize(CSChampionGuess guess) {
        PSChampionCrossGuess.Builder builder = PSChampionCrossGuess.newBuilder();
        builder.setBid(guess.getBid());
        builder.setBattleId(guess.getBattleId() == null ? "" : guess.getBattleId());
        builder.setGuessType(guess.getGuessType());
        builder.setGuessCoin(guess.getGuessCoin());
        builder.setDelta(guess.getDelta());
        if (guess.getAttacker() != null) {
            builder.setAttacker(serialFormation(guess.getAttacker()));
        }
        if (guess.getDefender() != null) {
            builder.setDefender(serialFormation(guess.getDefender()));
        }
        builder.setPeriod(guess.getPeriod());
        builder.setBattleRound(guess.getBattleRound());
        builder.setWhichWin(guess.getWhichWin());
        if (guess.getBattleLog() != null) {
            try {
                builder.setBattleLog(BattleLog.parseFrom(guess.getBattleLog().getBytes(VideoConst.ISO)));
            } catch (Exception e) {
                log.error("冠军赛战斗" + guess.getBid() + "无法转化战报");
            }
        }
        return builder.build();
    }


    @CMD(id = CmdCode._41113)
    public void scanMyChampionBattle(PlayerContext playerContext, GReqScanMyChampionCrossBattle msg) {
        ReqScanMyChampionBattleBuilder builder = ReqScanMyChampionBattle.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanMyChampionBattle(ResScanMyChampionBattle message) {
        GResScanMyChampionCrossBattle.Builder builder = GResScanMyChampionCrossBattle.newBuilder();
        if (message.getBattles() != null) {
            for (CSChampionBattle battle : message.getBattles()) {
                PSChampionCrossBattle.Builder model = PSChampionCrossBattle.newBuilder();
                model.setBid(battle.getBid());
                model.setBattleId(battle.getBattleId() == null ? "" : battle.getBattleId());
                model.setAddPoint(battle.getAddPoint());
                if (battle.getAttacker() != null) {
                    model.setAttacker(serialFormation(battle.getAttacker()));
                }
                if (battle.getDefender() != null) {
                    model.setDefender(serialFormation(battle.getDefender()));
                }
                model.setWhichWin(battle.getWhichWin());
                model.setPeriod(battle.getPeriod());
                model.setBattleRound(battle.getBattleRound());
                if (battle.getBattleLog() != null) {
                    try {
                        model.setBattleLog(BattleLog.parseFrom(battle.getBattleLog().getBytes(VideoConst.ISO)));
                    } catch (Exception e) {
                        log.error("冠军赛战斗" + battle.getBid() + "无法转化战报");
                    }
                }
                builder.addBattles(model.build());
            }
        }
        contextManager.write(message.getRid(), CmdCode._41113, builder.build());
    }

    @CMD(id = CmdCode._41115)
    public void scanChampionRank(PlayerContext playerContext, GReqChampionCrossRank msg) {
        ReqChampionRankBuilder builder = ReqChampionRank.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanChampionRank(ResChampionRank message) {
        GResChampionCrossRank.Builder builder = GResChampionCrossRank.newBuilder();
        if (message.getRanks() != null) {
            for (CSChampionRanker ranker : message.getRanks()) {
                builder.addRanks(serialChampionRank(ranker));
            }
        }
        contextManager.write(message.getRid(), CmdCode._41115, builder.build());
    }

    private PSChampionCrossRanker serialChampionRank(CSChampionRanker ranker) {
        PSChampionCrossRanker.Builder builder = PSChampionCrossRanker.newBuilder();
        builder.setRid(ranker.getRid());
        builder.setRobot(ranker.getRobot());
        builder.setLike(ranker.getLike());
        builder.setName(ranker.getName());
        builder.setRank(ranker.getRank());
        builder.setLevel(ranker.getLevel());
        builder.setHeadId(ranker.getHeadId());
        builder.setBorderId(ranker.getBorderId());
        builder.setPoint(ranker.getPoint());
        builder.setFighting(ranker.getFighting());
        builder.setServerId(ranker.getServerId());
        return builder.build();
    }

    @CMD(id = CmdCode._41117)
    public void getChampionLastTop(PlayerContext playerContext, GReqChampionCrossShowTop msg) {
        ReqChampionShowTopBuilder builder = ReqChampionShowTop.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void getChampionLastTop(ResChampionShowTop message) {
        GResChampionCrossShowTop.Builder builder = GResChampionCrossShowTop.newBuilder();
        builder.setTime(message.getTime());
        if (message.getRanks() != null) {
            //只需要发送前3名
            for (CSChampionRanker ranker : message.getRanks()) {
                builder.addRanks(serialChampionRank(ranker));
            }
        }
        contextManager.write(message.getRid(), CmdCode._41117, builder.build());
    }


    @CMD(id = CmdCode._41118)
    public void markShowMyResult(PlayerContext playerContext, GReqChampionCrossShowMyResult msg) {
        ReqChampionShowMyResultBuilder builder = ReqChampionShowMyResult.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void markShowMyResult(ResChampionShowMyResult message) {
        contextManager.write(message.getRid(), CmdCode._41118, GResChampionCrossShowMyResult.getDefaultInstance());
    }

    @CMD(id = CmdCode._41120)
    public void saveChampionFormation(PlayerContext playerContext, GReqChampionCrossSaveFormation msg) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CHAMPION_CROSS);
        if (heroLineUp.getFormationMap().isEmpty()) {
            log.warn("玩家" + playerContext.getId() + "的冠军赛阵容布阵为空");
            playerContext.write(CmdCode._41020, GResChampionCrossSaveFormation.getDefaultInstance());
            return;
        }
        BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.CHAMPION_CROSS, playerContext.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();

        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);

        ReqChampionSaveFormationBuilder builder = ReqChampionSaveFormation.builder();
        builder.rid(playerContext.getId());
        builder.fighting(fighting);
        builder.battlerVo(ProtostuffUtil.serialize(battlerVo));
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void saveChampionFormation(ResChampionSaveFormation message) {
        contextManager.write(message.getRid(), CmdCode._41120, GResChampionCrossSaveFormation.getDefaultInstance());
    }

    @RemoteMethod
    public void saveBattles(ResChampionSaveBattle message) {
        if (message.getBattleReports() == null) {
            return;
        }
        log.info("收到跨服发送来的跨服冠军赛战报数据{}份", message.getBattleReports().size());
        for (byte[] battleMsg : message.getBattleReports()) {
            try {
                BattleReport report = BattleReport.parseFrom(battleMsg);
                //保存战报
                commandBus.invoke(SaveBattleReportCommand.of(report));
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
        }
    }

    @RemoteMethod
    public void stageChange(ResChampionStageChange message) {
        contextManager.writeAll(CmdCode._41114, GResChampionCrossStageChange.getDefaultInstance());
    }

    @RemoteMethod
    public void guessBroadcast(ResChampionGuessBroadcast message) {
        GResChampionGuessBroadcast.Builder builder = GResChampionGuessBroadcast.newBuilder();
        builder.setType(message.getType());
        builder.setGuessCoin(message.getGuessCoin());
        contextManager.writeAll(CmdCode._41119, builder.build());
    }

    @RemoteMethod
    public void biuChange(ResChampionBiuChange message) {
        GResChampionCrossBiuChange.Builder builder = GResChampionCrossBiuChange.newBuilder();
        PSChampionCrossBiu.Builder model = PSChampionCrossBiu.newBuilder();
        model.setRid(message.getContent().getRid());
        model.setContent(message.getContent().getContent());
        builder.setContent(model.build());
        contextManager.writeAll(CmdCode._41110, builder.build());
    }

    @RemoteMethod
    public void championEndAndReward(ResChampionEnd message) {
        log.info("收到跨服通知的第{}届跨服冠军赛结束发奖消息", message.getRound());
        ChampionCrossReport report = championCrossReportService.getReport(message.getRound(), message.getServerId());
        if (report.getState() == 1) {
            //已经发奖直接回报发奖状态
            ReqChampionReportBuilder builder = ReqChampionReport.builder();
            builder.serverId(message.getServerId());
            builder.round(message.getRound());
            messageDispatcher.dispatch(builder.build());
            return;
        }
        report.setState(1);
        report.setUpdateTime(TimeDateUtil.getCurrentTimeInt());
        championCrossReportService.updateReport(report);

        log.info("发放冠军赛参赛者排名奖励");
        if (message.getRankResult() != null) {
            List<Mail> mailList = new ArrayList<>();
            for (CSChampionRankResult rank : message.getRankResult()) {
                CChampionReward cChampionReward = championRewardSysCache.getCrossByRank(rank.getRank());
                if (cChampionReward == null) {
                    continue;
                }
                //邮件类型、参数
                Mail mail = mailService.newMailNoTitle(rank.getRid(), MailScene.CHAMPION_CROSS_RANK,
                        MailParams.build(rank.getRank()), cChampionReward.getRank_reward(), GameEvent.CHAMPION_CROSS_RANK);
                mailList.add(mail);
            }
            mailService.insertMails(mailList);
        }

        log.info("发放冠军赛竞猜参与玩家奖励");
        //将竞猜币换算成公会奖励
        if (message.getCoinResult() != null) {
            List<Mail> coinMailList = new ArrayList<>();
            for (CSChampionCoinResult coin : message.getCoinResult()) {
                long rewardNum = (long) (coin.getCoinNum() * ChampionConst.CROSS_GUESS_REWARD_RATE * 1.0f / GameConstant.WAN);
                ImmutableThing reward = ImmutableThing.of(ChampionConst.CROSS_GUESS_REWARD_TYPE, rewardNum);

                Mail mail = mailService.newMailNoTitle(coin.getRid(), MailScene.CHAMPION_CROSS_COIN,
                        MailParams.build(coin.getCoinNum(), rewardNum), Collections.singletonList(reward),
                        GameEvent.CHAMPION_COIN_RANK);
                coinMailList.add(mail);
            }
            mailService.insertMails(coinMailList);
        }
        //回报发奖状态
        ReqChampionReportBuilder builder = ReqChampionReport.builder();
        builder.serverId(message.getServerId());
        builder.round(message.getRound());
        messageDispatcher.dispatch(builder.build());

        //推送冠军赛结束后
        contextManager.writeAll(CmdCode._41116, GResChampionCrossEnd.getDefaultInstance());
    }

    @RemoteMethod
    public void tellServerGuessWin(ResChampionGuessWin message) {
        if (message.getGuessWinners() == null) {
            return;
        }
        for (CSChampionGuessWinner winner : message.getGuessWinners()) {
            GResChampionCrossGuessWin.Builder builder = GResChampionCrossGuessWin.newBuilder();
            builder.setPeriod(message.getPeriod());
            builder.setBattleRound(message.getBattleRound());
            builder.setGainCoin(winner.getGainCoin());
            contextManager.write(winner.getRid(), CmdCode._41112, builder.build());
        }
    }

    @RemoteMethod
    public void tellFormationChange(ResChampionFormationChange message) {
        contextManager.writeAll(CmdCode._41121, GResChampionCrossFormationChange.getDefaultInstance());
    }

    @RemoteMethod
    public void tellCleanBiu(ResChampionCrossCleanBiu message) {
        contextManager.writeAll(CmdCode._41122, GResChampionCrossCleanBiu.getDefaultInstance());
    }
}
