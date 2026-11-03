/**
 *
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondSeasonSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondReward;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
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
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao.PinnacleReportDao;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnaclePlayer;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleReport;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.service.PinnaclePlayerService;
import com.ayjs.mxzg.gameserver.module.title.event.IssueTitleEvent;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleBiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleCoinResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleFormation;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleGuess;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleGuessWinner;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleHero;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleKnockoutBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRank;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRankResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRanker;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqGetPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqGuessPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqMyPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleBiuList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleBiubiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleCrossGmNextStage;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleGuessList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleGuessOneBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleLike;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleRank;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleReport;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleSaveFormation;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleShowMyResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqPinnacleShowTop;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqResetStage;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqScanMyPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqScanPinnacleKnockout;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ReqScanPinnacleMessage;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResGetPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResGuessPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResMyPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiuChange;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiuList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiubiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleCrossCleanBiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleEnd;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleFormationChange;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessBroadcast;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessOneBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessWin;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleLike;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleRank;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleSaveBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleSaveFormation;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleShowMyResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleShowTop;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleStageChange;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanMyPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanPinnacleKnockout;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanPinnacleMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.ChampionCrossGMsg.GResGuessCrossOneBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqGetPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqGuess;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqGuessPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqMyPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleBiuList;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleBiubiu;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleGuessList;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleLike;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleRank;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleSaveFormation;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleShowMyResult;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqPinnacleShowTop;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqScanMyPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqScanPinnacle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GReqScanPinnacleKnockout;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResGetPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResGuessPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResMyPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleBiuChange;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleBiuList;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleBiubiu;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleCleanBiu;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleEnd;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleFormationChange;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleGuessBroadcast;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleGuessList;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleGuessWin;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleLike;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleRank;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleSaveFormation;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleShowMyResult;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleShowTop;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleStageChange;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResScanMyPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResScanPinnacle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResScanPinnacleKnockout;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleBiu;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleFormation;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleGuess;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleHero;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleKnockoutBattle;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleMyResult;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleRank;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleRanker;
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


@Slf4j
@Controller
public class PinnacleHandler extends ProtocolHandler implements MessageHandler {

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
	private PinnaclePlayerService pinnaclePlayerService;
	@Autowired
	private TopMatchSecondSeasonSysCache pinnacleSeasonSysCache;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private BattleHelper battleHelper;
	@Autowired
	private CommandBus commandBus;
	@Autowired
	private PinnacleReportDao pinnacleReportDao;
	@Autowired
	private TopMatchSecondRewardSysCache pinnacleRewardSysCache;
	@Autowired
	private MailService mailService;
	@Autowired
	private OpenConditionSysCache openConditionSysCache;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private ServerConfig serverConfig;


	@CMD(id = CmdCode._72301)
	public void scanPinnacle(PlayerContext playerContext, GReqScanPinnacle msg) {
		Role role = roleService.getOrThrow(playerContext.getId());

		COpenCondition cOpenCondition = openConditionSysCache.getCondition(EntryType.MAIN_CHAMPION);
		if(role.getLevel() < cOpenCondition.getCondition_value()) {
			playerContext.write(CmdCode._72301, GResScanPinnacle.getDefaultInstance());
			return;
		}

		ReqScanPinnacleMessage.ReqScanPinnacleMessageBuilder builder = ReqScanPinnacleMessage.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void scanPinnacle(ResScanPinnacleMessage message) {
		GResScanPinnacle.Builder builder = GResScanPinnacle.newBuilder();
		builder.setLike(message.getLike());
		builder.setPeriod(message.getPeriod());
		builder.setRank(message.getRank());
		builder.setHisRank(message.getHisRank());
		builder.setStartTime(message.getStartTime());
		builder.setEndTime(message.getEndTime());
		if(message.getLikeRank() != null) {
			builder.addAllLikeRank(message.getLikeRank());
		}

		builder.setBiuCd(message.getBiuCd());
		builder.setShowRound(message.getShowRound());
		if(message.getResult() != null) {
			PSPinnacleMyResult.Builder model = PSPinnacleMyResult.newBuilder();
			model.setRank(message.getResult().getRank());
			model.setBattleNum(message.getResult().getBattleNum());
			model.setWinNum(message.getResult().getWinNum());
			builder.setResult(model.build());
		}
		builder.setBattleStartTime(message.getBattleStartTime());
		builder.setBattleRound(message.getBattleRound());
		contextManager.write(message.getRid(), CmdCode._72301, builder.build());
	}


	private PSPinnacleRank serialPinnacleRank(CSPinnacleRank pinnacleRank) {
		PSPinnacleRank.Builder builder = PSPinnacleRank.newBuilder();
		builder.setRid(pinnacleRank.getRid());
		builder.setRobot(pinnacleRank.getRobot());
		if(pinnacleRank.getName() != null) {
			builder.setName(pinnacleRank.getName());
		} else {
			builder.setName("");
		}
		builder.setLike(pinnacleRank.getLike());
		builder.setImageId(pinnacleRank.getImageId());
		builder.setRank(pinnacleRank.getRank());
		return builder.build();
	}

	@CMD(id = CmdCode._72302)
	public void scanMyBattle(PlayerContext playerContext, GReqMyPinnacleBattle msg) {
		ReqMyPinnacleBattle.ReqMyPinnacleBattleBuilder builder = ReqMyPinnacleBattle.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void scanMyBattle(ResMyPinnacleBattle message) {
		GResMyPinnacleBattle.Builder builder = GResMyPinnacleBattle.newBuilder();

		builder.setPeriod(message.getPeriod());
		builder.setBattleRound(message.getBattleRound());
		builder.setNextTime(message.getNextTime());

		if(message.getAttacker() != null) {
			builder.setAttacker(serialFormation(message.getAttacker()));
		}
		if(message.getDefender() != null) {
			builder.setDefender(serialFormation(message.getDefender()));
		}
		builder.setBid(message.getBid());
		if(message.getBattleId() != null) {
			builder.setBattleId(message.getBattleId());
		}
		builder.setWhichWin(message.getWhichWin());
		builder.setStage(message.getStage());
		contextManager.write(message.getRid(), CmdCode._72302, builder.build());
	}

	private PSPinnacleFormation serialFormation(CSPinnacleFormation formation) {
		PSPinnacleFormation.Builder builder = PSPinnacleFormation.newBuilder();
		builder.setLevel(formation.getLevel());
		builder.setHeadId(formation.getHeadId());
		builder.setBorderId(formation.getBorderId());
		builder.setRid(formation.getRid());
		if(formation.getName() != null) {
			builder.setName(formation.getName());
		} else {
			builder.setName("");
		}
		builder.setFighting(formation.getFighting());
		builder.setFormationId(formation.getFormationId());
		if(formation.getHeros() != null) {
			for(CSPinnacleHero hero : formation.getHeros()) {
				PSPinnacleHero.Builder model = PSPinnacleHero.newBuilder();
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

	@CMD(id = CmdCode._72303)
	public void scanGuessBattle(PlayerContext playerContext, GReqGuessPinnacleBattle msg) {
		ReqGuessPinnacleBattle.ReqGuessPinnacleBattleBuilder builder = ReqGuessPinnacleBattle.builder();
		builder.rid(playerContext.getId()).serverId(serverConfig.getServerId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void scanGuessBattle(ResGuessPinnacleBattle message) {
		GResGuessPinnacleBattle.Builder builder = GResGuessPinnacleBattle.newBuilder();
		builder.setPeriod(message.getPeriod());
		builder.setBattleRound(message.getBattleRound());
		builder.setNextTime(message.getNextTime());

		if(message.getAttacker() != null) {
			builder.setAttacker(serialFormation(message.getAttacker()));
		}
		if(message.getDefender() != null) {
			builder.setDefender(serialFormation(message.getDefender()));
		}
		builder.setBid(message.getBid());
		if(message.getBattleId() != null) {
			builder.setBattleId(message.getBattleId());
		}
		builder.setWhichWin(message.getWhichWin());
		builder.setAtkCoin(message.getAtkCoin());
		builder.setDefCoin(message.getDefCoin());
		builder.setGuessCoin(message.getGuessCoin());
		builder.setIsGuess(message.getIsGuess());
		builder.setStage(message.getStage());
		builder.setGuessType(message.getGuessType());
		contextManager.write(message.getRid(), CmdCode._72303, builder.build());
	}

	@CMD(id = CmdCode._72304)
	public void guessBattle(PlayerContext playerContext, GReqGuess msg) {
		ReqPinnacleGuessOneBattle.ReqPinnacleGuessOneBattleBuilder builder = ReqPinnacleGuessOneBattle.builder();
		builder.rid(playerContext.getId());
		builder.type(msg.getType());
		builder.guessCoin(msg.getGuessCoin());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void guessBattle(ResPinnacleGuessOneBattle message) {
		GResGuessCrossOneBattle.Builder builder = GResGuessCrossOneBattle.newBuilder();
		builder.setGuessCoin(message.getGuessCoin());
		contextManager.write(message.getRid(), CmdCode._72304, builder.build());

	}


	@CMD(id = CmdCode._72305)
	public void getPinnacleBattle(PlayerContext playerContext, GReqGetPinnacleBattle msg) {
		ReqGetPinnacleBattle.ReqGetPinnacleBattleBuilder builder = ReqGetPinnacleBattle.builder();
		builder.rid(playerContext.getId());
		builder.bid(msg.getBid());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void getPinnacleBattle(ResGetPinnacleBattle message) {
		GResGetPinnacleBattle.Builder builder = GResGetPinnacleBattle.newBuilder();
		builder.setBattleId(message.getBattleId());
		contextManager.write(message.getRid(), CmdCode._72305, builder.build());
	}

	@CMD(id = CmdCode._72306)
	public void scanPinnacle32(PlayerContext playerContext, GReqScanPinnacleKnockout msg) {
		ReqScanPinnacleKnockout.ReqScanPinnacleKnockoutBuilder builder = ReqScanPinnacleKnockout.builder();
		builder.rid(playerContext.getId()).serverId(serverConfig.getServerId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void scanPinnacle32(ResScanPinnacleKnockout message) {
		GResScanPinnacleKnockout.Builder builder = GResScanPinnacleKnockout.newBuilder();
		builder.setGuessId(message.getGuessId());
		builder.setBattleRound(message.getBattleRound());
		builder.setNextTime(message.getNextTime());
		builder.setStage(message.getStage());
		//这里用下标进行循环，避免正在遍历中修改列表的情况
		if(message.getBattles() != null) {
			for(CSPinnacleKnockoutBattle battle : message.getBattles()) {
				builder.addBattles(serial32Battle(battle));
			}
		}
		contextManager.write(message.getRid(), CmdCode._72306, builder.build());
	}


	private PSPinnacleKnockoutBattle serial32Battle(CSPinnacleKnockoutBattle battle) {
		PSPinnacleKnockoutBattle.Builder builder = PSPinnacleKnockoutBattle.newBuilder();
		builder.setAtkName(battle.getAtkName());
		builder.setDefName(battle.getDefName());
		builder.setBid(battle.getBid());
		builder.setBattleRound(battle.getBattleRound());
		builder.setWhichWin(battle.getWhichWin());
		if(battle.getBattleId() != null) {
			builder.setBattleId(battle.getBattleId());
		}
		builder.setWinHead(battle.getWinHead());
		builder.setWinBorder(battle.getWinBorder());
		builder.setAtkRid(battle.getAtkRid());
		builder.setDefRid(battle.getDefRid());
		return builder.build();
	}

	@CMD(id = CmdCode._72307)
	public void pinnacleLike(PlayerContext playerContext, GReqPinnacleLike msg) {
		ReqPinnacleLike.ReqPinnacleLikeBuilder builder = ReqPinnacleLike.builder();
		builder.rid(playerContext.getId());
		builder.targetRid(msg.getRid());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void pinnacleLike(ResPinnacleLike message) {
		thingService.add(message.getRid(), PinnacleConst.PINNACLE_LIKE_REWARD, GameEvent.PINNACLE_LIKE_REWARD, NoticeType.TIPS);

		GResPinnacleLike.Builder builder = GResPinnacleLike.newBuilder();
		builder.setRid(message.getTargetRid());
		contextManager.write(message.getRid(), CmdCode._72307, builder.build());
	}

	@CMD(id = CmdCode._72308)
	public void pinnacleBiubiubiu(PlayerContext playerContext, GReqPinnacleBiubiu msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		// 是否被禁言
		Asserts.isTrue(role.getForbidWordsEndTime() < DateTimeUtil.currentSecond(),
				ErrorCode.CHAT_FORBID.getValue(), () -> String.format("ForbidWordsEndTime:%s, current:%s",
						role.getForbidWordsEndTime(), DateTimeUtil.currentSecond()));

		boolean canSendOther = sensitiveWordService.wordCanUseChat(msg.getContent());
		Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());

		canSendOther = sensitiveWordService.wordCanUse(msg.getContent(),role);
		Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());

		boolean enough = thingService.enough(playerContext.getId(), PinnacleConst.BIU_COST);
		Asserts.isTrue(enough, ErrorCode.BAG_ITEM_LACK.getValue(), "道具不足");

		PinnaclePlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(playerContext.getId());
		Asserts.isTrue(pinnaclePlayer.getCrossBiuCd() < TimeDateUtil.getCurrentTimeInt(),
				ErrorCode.CHAMPION_BIU_CD.getValue(), "你发表弹幕信息太快了");

		CTopMatchSecondSeason pinnacleSeason = pinnacleSeasonSysCache.getCrossSeason();

		// 弹幕长度限制
		Asserts.isTrue(StringUtil.getShowLength(msg.getContent()) <= pinnacleSeason.getBiu_len(),
				ErrorCode.CHAMPION_BIU_LONG.getValue(), String.format("弹幕信息太长了：字符长度：{%s}，限制长度{%s}",
						StringUtil.getShowLength(msg.getContent()), pinnacleSeason.getBiu_len()));

		thingService.cost(playerContext.getId(), PinnacleConst.BIU_COST, GameEvent.CHAMPION_BIUBIUBIU);

		pinnaclePlayer.setCrossBiuCd(TimeDateUtil.getCurrentTimeInt() + pinnacleSeason.getBiu_cd());
		pinnaclePlayerService.update(pinnaclePlayer);

		ReqPinnacleBiubiu.ReqPinnacleBiubiuBuilder builder = ReqPinnacleBiubiu.builder();
		builder.rid(playerContext.getId());
		builder.content(msg.getContent());
		builder.biuCd(pinnaclePlayer.getCrossBiuCd());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void pinnacleBiubiubiu(ResPinnacleBiubiu message) {
		GResPinnacleBiubiu.Builder builder = GResPinnacleBiubiu.newBuilder();
		builder.setBiuCd(message.getBiuCd());
		contextManager.write(message.getRid(), CmdCode._72308, builder.build());
	}


	@CMD(id = CmdCode._72309)
	public void getBiuList(PlayerContext playerContext, GReqPinnacleBiuList msg) {
		ReqPinnacleBiuList.ReqPinnacleBiuListBuilder builder = ReqPinnacleBiuList.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void getBiuList(ResPinnacleBiuList message) {
		GResPinnacleBiuList.Builder builder = GResPinnacleBiuList.newBuilder();
		if(message.getContent() != null) {
			for(CSPinnacleBiu biu : message.getContent()) {
				PSPinnacleBiu.Builder model = PSPinnacleBiu.newBuilder();
				model.setRid(biu.getRid());
				model.setContent(biu.getContent());
				builder.addContent(model.build());
			}
		}
		contextManager.write(message.getRid(), CmdCode._72309, builder.build());
	}



	@CMD(id = CmdCode._72311)
	public void getGuessList(PlayerContext playerContext, GReqPinnacleGuessList msg) {
		ReqPinnacleGuessList.ReqPinnacleGuessListBuilder builder = ReqPinnacleGuessList.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void getGuessList(ResPinnacleGuessList message) {
		GResPinnacleGuessList.Builder builder = GResPinnacleGuessList.newBuilder();
		if(message.getRecord() != null) {
			for(CSPinnacleGuess guess : message.getRecord()) {
				builder.addRecord(serialize(guess));
			}
		}
		contextManager.write(message.getRid(), CmdCode._72311, builder.build());
	}

	private PSPinnacleGuess serialize(CSPinnacleGuess guess) {
		PSPinnacleGuess.Builder builder = PSPinnacleGuess.newBuilder();
		builder.setBid(guess.getBid());
		builder.setBattleId(guess.getBattleId() == null ? "" : guess.getBattleId());
		builder.setGuessType(guess.getGuessType());
		builder.setGuessCoin(guess.getGuessCoin());
		builder.setDelta(guess.getDelta());
		if(guess.getAttacker() != null) {
			builder.setAttacker(serialFormation(guess.getAttacker()));
		}
		if(guess.getDefender() != null) {
			builder.setDefender(serialFormation(guess.getDefender()));
		}
		builder.setPeriod(guess.getPeriod());
		builder.setBattleRound(guess.getBattleRound());
		builder.setWhichWin(guess.getWhichWin());
		if(guess.getBattleLog() != null) {
			try {
				builder.setBattleLog(BattleLog.parseFrom(guess.getBattleLog().getBytes(VideoConst.ISO)));
			} catch (Exception e) {
				log.error("巅峰赛战斗" + guess.getBid() + "无法转化战报");
			}
		}
		return builder.build();
	}


	@CMD(id = CmdCode._72313)
	public void scanMyPinnacleBattle(PlayerContext playerContext, GReqScanMyPinnacleBattle msg) {
		ReqScanMyPinnacleBattle.ReqScanMyPinnacleBattleBuilder builder = ReqScanMyPinnacleBattle.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void scanMyPinnacleBattle(ResScanMyPinnacleBattle message) {
		GResScanMyPinnacleBattle.Builder builder = GResScanMyPinnacleBattle.newBuilder();
		if(message.getBattles() != null) {
			for(CSPinnacleBattle battle : message.getBattles()) {
				PSPinnacleBattle.Builder model = PSPinnacleBattle.newBuilder();
				model.setBid(battle.getBid());
				model.setBattleId(battle.getBattleId() == null ? "" : battle.getBattleId());
				model.setAddPoint(battle.getAddPoint());
				if(battle.getAttacker() != null) {
					model.setAttacker(serialFormation(battle.getAttacker()));
				}
				if(battle.getDefender() != null) {
					model.setDefender(serialFormation(battle.getDefender()));
				}
				model.setWhichWin(battle.getWhichWin());
				model.setPeriod(battle.getPeriod());
				model.setBattleRound(battle.getBattleRound());
				if(battle.getBattleLog() != null) {
					try {
						model.setBattleLog(BattleLog.parseFrom(battle.getBattleLog().getBytes(VideoConst.ISO)));
					} catch (Exception e) {
						log.error("巅峰赛战斗" + battle.getBid() + "无法转化战报");
					}
				}
				builder.addBattles(model.build());
			}
		}
		contextManager.write(message.getRid(), CmdCode._72313, builder.build());
	}

	@CMD(id = CmdCode._72315)
	public void getBattleList(PlayerContext playerContext, GReqPinnacleRank msg) {
		ReqPinnacleRank.ReqPinnacleRankBuilder builder = ReqPinnacleRank.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void getBattleList(ResPinnacleRank message) {
		GResPinnacleRank.Builder builder = GResPinnacleRank.newBuilder();
		if(message.getRanks() != null) {
			for(CSPinnacleRanker ranker : message.getRanks()) {
				builder.addRanks(serialPinnacleRank(ranker));
			}
		}
		contextManager.write(message.getRid(), CmdCode._72315, builder.build());
	}

	private PSPinnacleRanker serialPinnacleRank(CSPinnacleRanker ranker) {
		PSPinnacleRanker.Builder builder = PSPinnacleRanker.newBuilder();
		builder.setRid(ranker.getRid());
		builder.setLike(ranker.getLike());
		builder.setName(ranker.getName());
		builder.setServerId(ranker.getServerId());
		builder.setRank(ranker.getRank());
		builder.setLevel(ranker.getLevel());
		builder.setHeadId(ranker.getHeadId());
		builder.setBorderId(ranker.getBorderId());
		builder.setPoint(ranker.getPoint());
		builder.setFighting(ranker.getFighting());
		builder.setImageId(ranker.getImageId());
		builder.setStageId(ranker.getStageId());
		return builder.build();
	}

	@CMD(id = CmdCode._72317)
	public void getPinnacleLastTop(PlayerContext playerContext, GReqPinnacleShowTop msg) {
		ReqPinnacleShowTop.ReqPinnacleShowTopBuilder builder = ReqPinnacleShowTop.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void getPinnacleLastTop(ResPinnacleShowTop message) {
		GResPinnacleShowTop.Builder builder = GResPinnacleShowTop.newBuilder();
		builder.setTime(message.getTime());
		if(message.getRanks() != null) {
			//只需要发送前3名
			for(CSPinnacleRanker ranker : message.getRanks()) {
				builder.addRanks(serialPinnacleRank(ranker));
			}
		}
		contextManager.write(message.getRid(), CmdCode._72317, builder.build());
	}


	@CMD(id = CmdCode._72318)
	public void markShowMyResult(PlayerContext playerContext, GReqPinnacleShowMyResult msg) {
		ReqPinnacleShowMyResult.ReqPinnacleShowMyResultBuilder builder = ReqPinnacleShowMyResult.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void markShowMyResult(ResPinnacleShowMyResult message) {
		contextManager.write(message.getRid(), CmdCode._72318, GResPinnacleShowMyResult.getDefaultInstance());
	}

	@CMD(id = CmdCode._72320)
	public void savePinnacleFormation(PlayerContext playerContext, GReqPinnacleSaveFormation msg) {
		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.PINNACLE);
		if(heroLineUp.getFormationMap().isEmpty()) {
			log.warn("玩家" + playerContext.getId() + "的巅峰赛阵容布阵为空");
			playerContext.write(CmdCode._72320, GResPinnacleSaveFormation.getDefaultInstance());
			return;
		}
		BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.PINNACLE, playerContext.getId(), Faction.ATTACKER);
		BattlerVo battlerVo = battlerDo.toBattlerVo();

		int fighting = heroLineUpService.getLineUpFighting(heroLineUp);

		ReqPinnacleSaveFormation.ReqPinnacleSaveFormationBuilder builder = ReqPinnacleSaveFormation.builder();
		builder.rid(playerContext.getId());
		builder.fighting(fighting);
		builder.battlerVo(ProtostuffUtil.serialize(battlerVo));
		messageDispatcher.dispatch(builder.build());
	}

	@RemoteMethod
	public void savePinnacleFormation(ResPinnacleSaveFormation message) {
		contextManager.write(message.getRid(), CmdCode._72320, GResPinnacleSaveFormation.getDefaultInstance());
	}

	@RemoteMethod
	public void saveBattles(ResPinnacleSaveBattle message) {
		if(message.getBattleReports() == null) {
			return;
		}
		log.info("收到跨服发送来的跨服巅峰赛战报数据{}份", message.getBattleReports().size());
		for(byte[] battleMsg : message.getBattleReports()) {
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
	public void stageChange(ResPinnacleStageChange message) {
		contextManager.writeAll(CmdCode._72314, GResPinnacleStageChange.getDefaultInstance());
	}

	@RemoteMethod
	public void guessBroadcast(ResPinnacleGuessBroadcast message) {
		GResPinnacleGuessBroadcast.Builder builder = GResPinnacleGuessBroadcast.newBuilder();
		builder.setType(message.getType());
		builder.setGuessCoin(message.getGuessCoin());
		contextManager.writeAll(CmdCode._72319, builder.build());
	}

	@RemoteMethod
	public void biuChange(ResPinnacleBiuChange message) {
		GResPinnacleBiuChange.Builder builder = GResPinnacleBiuChange.newBuilder();
		PSPinnacleBiu.Builder model = PSPinnacleBiu.newBuilder();
		model.setRid(message.getContent().getRid());
		model.setContent(message.getContent().getContent());
		builder.setContent(model.build());
		contextManager.writeAll(CmdCode._72310, builder.build());
	}

	@RemoteMethod
	public void pinnacleEndAndReward(ResPinnacleEnd message) {
		log.info("收到跨服通知的第{}届跨服巅峰赛结束发奖消息", message.getRound());
		PinnacleReport report = pinnacleReportDao.getReport();
		if(report.getState() == 1) {
			//已经发奖直接回报发奖状态
			ReqPinnacleReport.ReqPinnacleReportBuilder builder = ReqPinnacleReport.builder();
			builder.serverId(message.getServerId());
			builder.round(message.getRound());
			messageDispatcher.dispatch(builder.build());
			return;
		}
		report.setState(1);
		pinnacleReportDao.update(report);

		log.info("发放巅峰赛参赛者排名奖励");
		if(message.getRankResult() != null) {
			List<Mail> mailList = new ArrayList<>();
			for(CSPinnacleRankResult rank : message.getRankResult()) {
				CTopMatchSecondReward cTopMatchSecondReward = pinnacleRewardSysCache.getCrossByRank(rank.getRank());
				if(cTopMatchSecondReward == null) {
					continue;
				}
				//邮件类型、参数
				Mail mail = mailService.newMailNoTitle(rank.getRid(), MailScene.PINNACLE_RANK,
						MailParams.build(rank.getRank()), cTopMatchSecondReward.getRank_reward(), GameEvent.PINNACLE_RANK);
				mailList.add(mail);

				if(cTopMatchSecondReward.getTitle_id() != 0){
					IssueTitleEvent event = IssueTitleEvent.createOf(rank.getRid(), TitleType.PINNACLE, cTopMatchSecondReward.getTitle_id());
					eventBus.post(event);
					log.info("{}发放称号{}成功!", rank.getRid(), cTopMatchSecondReward.getTitle_id());
				}
			}
			mailService.insertMails(mailList);
		}

		log.info("发放巅峰赛竞猜参与玩家奖励");
		//将竞猜币换算成公会奖励
		if(message.getCoinResult() != null) {
			List<Mail> coinMailList = new ArrayList<>();
			for(CSPinnacleCoinResult coin : message.getCoinResult()) {
				long rewardNum = (long)(coin.getCoinNum() * PinnacleConst.PINNACLE_GUESS_REWARD_RATE * 1.0f / GameConstant.WAN);
				ImmutableThing reward = ImmutableThing.of(PinnacleConst.PINNACLE_GUESS_REWARD_TYPE, rewardNum);

				Mail mail = mailService.newMailNoTitle(coin.getRid(), MailScene.PINNACLE_COIN,
						MailParams.build(coin.getCoinNum(), rewardNum), Collections.singletonList(reward),
						GameEvent.PINNACLE_COIN_RANK);
				coinMailList.add(mail);
			}
			mailService.insertMails(coinMailList);
		}
		//回报发奖状态
		ReqPinnacleReport.ReqPinnacleReportBuilder builder = ReqPinnacleReport.builder();
		builder.serverId(message.getServerId());
		builder.round(message.getRound());
		messageDispatcher.dispatch(builder.build());

		//推送巅峰赛结束后
		contextManager.writeAll(CmdCode._72316, GResPinnacleEnd.getDefaultInstance());
	}

	@RemoteMethod
	public void tellServerGuessWin(ResPinnacleGuessWin message) {
		if(message.getGuessWinners() == null) {
			return;
		}
		for(CSPinnacleGuessWinner winner : message.getGuessWinners()) {
			GResPinnacleGuessWin.Builder builder = GResPinnacleGuessWin.newBuilder();
			builder.setPeriod(message.getPeriod());
			builder.setBattleRound(message.getBattleRound());
			builder.setGainCoin(winner.getGainCoin());
			contextManager.write(winner.getRid(), CmdCode._72312, builder.build());
		}
	}

	@RemoteMethod
	public void tellFormationChange(ResPinnacleFormationChange message) {
		contextManager.writeAll(CmdCode._72321, GResPinnacleFormationChange.getDefaultInstance());
	}

	@RemoteMethod
	public void tellCleanBiu(ResPinnacleCrossCleanBiu message) {
		contextManager.writeAll(CmdCode._72322, GResPinnacleCleanBiu.getDefaultInstance());
	}

	@GMCommand(command = GMCmdCode.PINNACLE_NEXT_STAGE)
	public void testChampionCross(Role role, List<String> param) {
		ReqPinnacleCrossGmNextStage.ReqPinnacleCrossGmNextStageBuilder builder = ReqPinnacleCrossGmNextStage.builder();
		messageDispatcher.dispatch(builder.build());
	}


	@GMCommand(command = GMCmdCode.SUPER_MATCH_RESET_STAGE)
	public void resetStage(Role role, List<String> param) {
		ReqResetStage.ReqResetStageBuilder builder = ReqResetStage.builder();
		messageDispatcher.dispatch(builder.build());
	}

}
