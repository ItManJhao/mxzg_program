/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.handler;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.champion.ChampionGuess;
import com.ayjs.mxzg.config.struct.champion.ChampionTop;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossPlayer;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossResult;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossRobot;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossBattleService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossCompetitorService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossPlayerService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossResultService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossRobotService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossService;
import com.ayjs.mxzg.cross.module.champion.service.period.ChampionKnockoutService;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionGroup;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRobot;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderRobotService;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBattle.CSChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionFormation.CSChampionFormationBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuess;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuess.CSChampionGuessBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionHero;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionHero.CSChampionHeroBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionKnockoutBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionKnockoutBattle.CSChampionKnockoutBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionMyResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionMyResult.CSChampionMyResultBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRank.CSChampionRankBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRanker;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiuList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionBiubiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionCrossGmNextStage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionGuessList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionLike;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionReport;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionSaveFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowMyResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionShowTop;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGetChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqGuessOneBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionKnockout;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanChampionMessage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqScanMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuList.ResChampionBiuListBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiubiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiubiu.ResChampionBiubiuBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionFormationChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessBroadcast;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessBroadcast.ResChampionGuessBroadcastBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessList;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessList.ResChampionGuessListBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionLike;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionLike.ResChampionLikeBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionRank;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionRank.ResChampionRankBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveFormation;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveFormation.ResChampionSaveFormationBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowMyResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowMyResult.ResChampionShowMyResultBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowTop;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionShowTop.ResChampionShowTopBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGetChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGetChampionBattle.ResGetChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessChampionBattle.ResGuessChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessOneBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResGuessOneBattle.ResGuessOneBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResMyChampionBattle.ResMyChampionBattleBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionKnockout;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionKnockout.ResScanChampionKnockoutBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionMessage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanChampionMessage.ResScanChampionMessageBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanMyChampionBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResScanMyChampionBattle.ResScanMyChampionBattleBuilder;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.champion.ChampionGuessEvent;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.util.ProtostuffUtil;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class ChampionCrossHandler implements MessageHandler {

	@Autowired
	private ChampionCrossService championService;
	@Autowired
	private ChampionCrossPlayerService championPlayerService;
	@Autowired
	private ChampionCrossCompetitorService championCompetitorService;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private CrossServerGroupService crossServerGroupService;
	@Autowired
	private ChampionCrossRobotService championRobotService;
	@Autowired
	private CrossLadderRobotService crossLadderRobotService;
	@Autowired
	private ChampionCrossBattleService championBattleService;
	@Autowired
	private ChampionKnockoutService championKnockoutService;
	@Autowired
	private MessageHelper messageHelper;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private ChampionCrossResultService championCrossResultService;
	
	@RemoteMethod
	public void scanChampion(ReqScanChampionMessage message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(message.getRid());
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		ResScanChampionMessageBuilder builder = ResScanChampionMessage.builder();
		builder.rid(message.getRid());
		builder.like(championPlayer.getLike());
		builder.period(championSystem.getPeriod());
		builder.rank(championCompetitorService.getRoleRank(message.getRid()));
		builder.hisRank(championPlayer.getHisRank());
		builder.startTime(championSystem.getRoundStartTime());
		builder.endTime(championSystem.getRoundEndTime());
		builder.likeRank(new ArrayList<>(championPlayer.getKneels()));
		builder.battleRound(championSystem.getBattleRound());
		
		ChampionGroup championGroup = championSystem.getGroupResult().get(crossGroupId);
		if(championGroup != null) {
			List<CSChampionRank> ranks = new ArrayList<>();
			for(ChampionTop championTop : championGroup.getTopPlayers().values()) {
				ranks.add(serialChampionRank(championTop));
			}
			builder.ranks(ranks);
		}
		
		builder.biuCd(championPlayer.getBiuCd());
		builder.showRound(championPlayer.getShowRound() < championSystem.getRound() - 1 ? 1 : 0);
		if(championPlayer.getShowResult() == 0 && championPlayer.getResult() != null) {
			CSChampionMyResultBuilder model = CSChampionMyResult.builder();
			model.rank(championPlayer.getResult().getRank());
			model.battleNum(championPlayer.getResult().getBattleNum());
			model.winNum(championPlayer.getResult().getWinNum());
			builder.result(model.build());
		}
		builder.battleStartTime(championSystem.getStartTime());
		connection.send(builder.build());
	}
	
	private CSChampionRank serialChampionRank(ChampionTop championTop) {
		CSChampionRankBuilder builder = CSChampionRank.builder();
		builder.rid(championTop.getRid());
		builder.robot(championTop.getRobot());
		if(championTop.getRobot() == 1) {
			ChampionCrossRobot robot = championRobotService.getRobot(championTop.getRid());
			CrossLadderRobot ladderRobot = crossLadderRobotService.getRobot(championTop.getRid());
			builder.name(ladderRobot.getNick());
			builder.like(robot.getLike());
			builder.imageId(0);
		} else {
			CrossRole role = crossRoleService.getOrThrow(championTop.getRid());
			builder.name(role.getNick());
			ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(role.getId());
			builder.like(championPlayer.getLike());
			builder.imageId(role.getImageId());
		}
		builder.rank(championTop.getRank());
		return builder.build();
	}
	
	@RemoteMethod
	public void scanMyBattle(ReqMyChampionBattle message, Connection connection) {
		ChampionCrossSystem championSystem = championService.getSystem();
		
		ResMyChampionBattleBuilder builder = ResMyChampionBattle.builder();
		builder.rid(message.getRid());
		builder.nextTime(championSystem.getNextStageTime());
		
		List<ChampionCrossBattle> myBattleList = new ArrayList<>();
		for(ChampionCrossBattle championBattle : championBattleService.getAllBattleMap().values()) {
			if(championBattle.getAtkRid() == message.getRid() || championBattle.getDefRid() == message.getRid()) {
				myBattleList.add(championBattle);
			}
		}
		Collections.sort(myBattleList, ChampionTemplate.BATTLE_SORTER);
		if(!myBattleList.isEmpty()) {
			ChampionCrossBattle championBattle = myBattleList.get(0);
			builder.attacker(serialFormation(championBattle.getAtkRid(), championBattle.getAtkFight(),
					championBattle.getAtkVo(), championBattle.getCrossGroupId()));
			builder.defender(serialFormation(championBattle.getDefRid(), championBattle.getDefFight(),
					championBattle.getDefVo(), championBattle.getCrossGroupId()));

			builder.bid(championBattle.getId());
			if(championBattle.getBattleId() != null) {
				builder.battleId(championBattle.getBattleId());
			} else {
				builder.battleId("");
			}
			builder.whichWin(championBattle.getWhichWin());
		}
		if(!myBattleList.isEmpty()) {
			ChampionCrossBattle lastBattle = myBattleList.get(0);
			builder.period(lastBattle.getPeriod());
			builder.battleRound(lastBattle.getBattleRound());
		} else {
			builder.period(championSystem.getPeriod());
			builder.battleRound(championSystem.getBattleRound());
		}
		builder.stage(championSystem.getStage());
		connection.send(builder.build());
	}
	
	private CSChampionFormation serialFormation(long rid, int fighting, BattlerVo battlerVo, int crossGroup) {
		CSChampionFormationBuilder builder = CSChampionFormation.builder();
		ChampionCrossCompetitor championCompetitor = championCompetitorService.getCompetitor(rid, crossGroup);
		
		if(championCompetitor.getRobot() == 1) {
			CrossLadderRobot ladderRobot = crossLadderRobotService.getRobot(championCompetitor.getRid());
			builder.level(ladderRobot.getLevel());
			builder.headId(ladderRobot.getHeadId());
			builder.borderId(ladderRobot.getBorderId());
		} else {
			CrossRole role = crossRoleService.getOrThrow(championCompetitor.getRid());
			builder.level(role.getLevel());
			builder.headId(role.getHeadId());
			builder.borderId(role.getBorderId());
		}
		
		builder.rid(championCompetitor.getRid());
		builder.name(championCompetitor.getName());
		
		builder.fighting(fighting);
		
		List<CSChampionHero> heros = new ArrayList<>();
		for(HeroVo heroVo : battlerVo.getHeros()) {
			CSChampionHeroBuilder model = CSChampionHero.builder();
			model.id(heroVo.getId());
			model.pos(heroVo.getPos());
			model.heroType(heroVo.getHero_type());
			model.level(heroVo.getHero_level());
			model.stage(heroVo.getStage());
			model.star(heroVo.getHero_star());
			model.fashionId(heroVo.getFashionId());
			heros.add(model.build());
		}
		builder.heros(heros);
		builder.robot(championCompetitor.getRobot());
		builder.formationId(battlerVo.getFormationId());
		return builder.build();
	}
	
	@RemoteMethod
	public void scanGuessBattle(ReqGuessChampionBattle message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(message.getRid());
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		ResGuessChampionBattleBuilder builder = ResGuessChampionBattle.builder();
		builder.rid(message.getRid());
		builder.period(championSystem.getPeriod());
		builder.battleRound(championSystem.getBattleRound());
		builder.nextTime(championSystem.getNextStageTime());
		
		ChampionGroup championGroup = championSystem.getGroupResult().get(crossGroupId);
		if(championGroup != null) {
			ChampionCrossBattle championBattle = championBattleService.getOneBattle(championGroup.getGuessId());
			if(championBattle != null) {
				builder.attacker(serialFormation(championBattle.getAtkRid(), championBattle.getAtkFight(),
						championBattle.getAtkVo(), championBattle.getCrossGroupId()));
				builder.defender(serialFormation(championBattle.getDefRid(), championBattle.getDefFight(),
						championBattle.getDefVo(), championBattle.getCrossGroupId()));

				builder.bid(championBattle.getId());
				if(championBattle.getBattleId() != null) {
					builder.battleId(championBattle.getBattleId());
				}
				builder.whichWin(championBattle.getWhichWin());
				builder.atkCoin(championBattle.getAtkCoin());
				builder.defCoin(championBattle.getDefCoin());
				
				builder.isGuess(championBattle != null && championPlayer.getGuessId() == championBattle.getId() ? 1 : 0);
			}
		}
		
		builder.guessCoin(championPlayer.getGuessCoin());
		builder.stage(championSystem.getStage());
		builder.guessType(championPlayer.getGuessType());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void guessBattle(ReqGuessOneBattle message, Connection connection) {
		
		Asserts.isTrue(message.getType() == 1 || message.getType() == 2, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要1、2，实际" + message.getType());
		
		Asserts.isTrue(message.getGuessCoin() > 0, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要大于0，实际" + message.getGuessCoin());
		
		Asserts.isTrue(message.getGuessCoin() <= ChampionConst.MAX_GUESS, ErrorCode.CHAMPION_MAX_GUESS.getValue(), "你的竞猜投注太多了" + message.getGuessCoin());
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionGroup championGroup = championSystem.getGroupResult().get(crossGroupId);
		Asserts.isTrue(championGroup != null, ErrorCode.CHAMPION_CROSS_GROUP_MISS.getValue(), "跨服冠军赛分组不存在");
		ChampionCrossBattle championBattle = championBattleService.getOneBattle(championGroup.getGuessId());
		
		Asserts.notNull(championBattle, ErrorCode.CHAMPION_NO_GUESS.getValue(), "当前没有比赛正在进行竞猜" + championGroup.getGuessId());
		
		Asserts.isTrue(championService.isGuessStage(), ErrorCode.CHAMPION_NOT_GUESS.getValue(), "当前不是竞猜阶段");
		
		Asserts.isTrue(championBattle.getWhichWin() == 0, ErrorCode.CHAMPION_GUESS_OVER.getValue(), "该比赛已经结束");
		
		ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(message.getRid());
		
		Asserts.isTrue(championPlayer.getGuessId() != championBattle.getId(), ErrorCode.CHAMPION_HAD_GUESS.getValue(), "你已经参与了该比赛的竞猜");
		
		Asserts.isTrue(championPlayer.getGuessCoin() >= message.getGuessCoin(), ErrorCode.CHAMPION_GUESS_LACK.getValue(), "你的竞猜币不足");
		
		championPlayer.setGuessCoin(championPlayer.getGuessCoin() - message.getGuessCoin());
		championPlayer.setGuessId(championBattle.getId());
		championPlayer.setGuessType(message.getType());
		championPlayer.setBetCoin(message.getGuessCoin());
		
		//添加投注记录
		ChampionGuess guessRecord = new ChampionGuess();
		guessRecord.setBid(championBattle.getId());
		guessRecord.setGuessType(message.getType());
		guessRecord.setGuessCoin(message.getGuessCoin());
		championPlayer.getGuessRecords().add(guessRecord);
		championPlayerService.update(championPlayer);
		
		synchronized (championBattle) {
			if(message.getType() == 1) {
				championBattle.setAtkCoin(championBattle.getAtkCoin() + message.getGuessCoin());
			} else {
				championBattle.setDefCoin(championBattle.getDefCoin() + message.getGuessCoin());
			}
			championBattle.getGuessPlayers().add(championPlayer.getRid());
			championBattleService.updateBattle(championBattle);
		}
		
		ResGuessOneBattleBuilder builder = ResGuessOneBattle.builder();
		builder.rid(message.getRid());
		builder.guessCoin(championPlayer.getGuessCoin());
		connection.send(builder.build());
		
		ResChampionGuessBroadcastBuilder builder0 = ResChampionGuessBroadcast.builder();
		builder0.type(message.getType());
		builder0.guessCoin(message.getGuessCoin());
		messageHelper.pushToGroupMessage(crossGroupId, builder0.build());
	
		eventBus.post(ChampionGuessEvent.of(message.getRid(), -message.getGuessCoin(), championPlayer.getGuessCoin(),
				message.getType(), championBattle, GameEvent.CHAMPION_GUESS_BATTLE));
	}
	
	@RemoteMethod
	public void getChampionBattle(ReqGetChampionBattle message, Connection connection) {
		ChampionCrossBattle championBattle = championBattleService.getOneBattle(message.getBid());
		
		Asserts.notNull(championBattle, ErrorCode.CHAMPION_NO_BATTLE.getValue(), "没有找到该比赛" + message.getBid());
		
		String battleId = championBattle.getBattleId();
		Asserts.isTrue(battleId != null && !"".equals(battleId), ErrorCode.CHAMPION_NO_BATTLE.getValue(),
				"没有找到该比赛" + message.getBid());
		
		ResGetChampionBattleBuilder builder = ResGetChampionBattle.builder();
		builder.rid(message.getRid());
		builder.battleId(battleId);
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void scanChampion32(ReqScanChampionKnockout message, Connection connection) {
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionGroup championGroup = championSystem.getGroupResult().get(crossGroupId);
		
		ResScanChampionKnockoutBuilder builder = ResScanChampionKnockout.builder();
		builder.rid(message.getRid());
		if(championGroup != null) {
			builder.guessId(championGroup.getGuessId());
		}
		builder.battleRound(championSystem.getBattleRound());
		builder.nextTime(championSystem.getNextStageTime());
		builder.stage(championSystem.getStage());
		//这里用下标进行循环，避免正在遍历中修改列表的情况
		
		List<ChampionCrossBattle> battle32List = championKnockoutService.get32Battle(crossGroupId);
		if(battle32List != null) {
			List<CSChampionKnockoutBattle> battles = new ArrayList<>();
			for(int i = 0; i < battle32List.size(); i++) {
				ChampionCrossBattle battle = battle32List.get(i);
				battles.add(serial32Battle(battle));
			}
			builder.battles(battles);
		}
		connection.send(builder.build());
	}
	
	private CSChampionKnockoutBattle serial32Battle(ChampionCrossBattle battle) {
		CSChampionKnockoutBattleBuilder builder = CSChampionKnockoutBattle.builder();
		ChampionCrossCompetitor attacker = championCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
		ChampionCrossCompetitor defender = championCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
		builder.atkName(attacker.getName());
		builder.defName(defender.getName());
		builder.bid(battle.getId());
		builder.battleRound(battle.getBattleRound());
		builder.whichWin(battle.getWhichWin());
		if(battle.getBattleId() != null) {
			builder.battleId(battle.getBattleId());
		}
		if(battle.getWhichWin() == 1) {
			builder.winHead(attacker.getHeadId());
			builder.winBorder(attacker.getBorderId());
		} else if(battle.getWhichWin() == 2) {
			builder.winHead(defender.getHeadId());
			builder.winBorder(defender.getBorderId());
		}
		builder.atkRid(battle.getAtkRid());
		builder.defRid(battle.getDefRid());
		return builder.build();
	}
	
	@RemoteMethod
	public void championLike(ReqChampionLike message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionCrossCompetitor topCompetitor = null;
		for(ChampionCrossCompetitor competitor : championCompetitorService.getTopList(crossGroupId)) {
			if(competitor.getRid() == message.getTargetRid()) {
				topCompetitor = competitor;
				break;
			}
		}
		Asserts.notNull(topCompetitor, ErrorCode.CHAMPION_NO_TOP.getValue(), "冠军赛还没有产生冠军选手" + message.getTargetRid());
		
		ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(message.getRid());
		
		Asserts.isTrue(!championPlayer.getKneels().contains(topCompetitor.getRid()),
				ErrorCode.CHAMPION_KNEEL_TOP.getValue(),
				"你已经膜拜过该选手" + topCompetitor.getRank() + "已膜拜列表" + championPlayer.getKneels());
		
		Asserts.isTrue(championPlayer.getKneels().size() < ChampionConst.CROSS_MAX_LIKE, ErrorCode.CHAMPION_MAX_LIKE.getValue(),
				"" + championPlayer.getKneels().size());
		
		championPlayer.getKneels().add(topCompetitor.getRid());
		championPlayerService.update(championPlayer);
		
		String kneelLock = "CHAMPION_KNEEL" + topCompetitor.getRid();
		
		if(topCompetitor.getRobot() == 1) {
			synchronized (kneelLock.intern()) {
				ChampionCrossRobot topRobot = championRobotService.getRobot(topCompetitor.getRid());
				topRobot.setLike(topRobot.getLike() + 1);
				championRobotService.updateRobot(topRobot);
			}
		} else {
			synchronized (kneelLock.intern()) {
				ChampionCrossPlayer topPlayer = championPlayerService.getPlayer(topCompetitor.getRid());
				topPlayer.setLike(topPlayer.getLike() + 1);
				championPlayerService.update(topPlayer);
			}
		}
		
		ResChampionLikeBuilder builder = ResChampionLike.builder();
		builder.rid(message.getRid());
		builder.targetRid(topCompetitor.getRid());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void championBiubiubiu(ReqChampionBiubiu message, Connection connection) {
		championService.addBiubiubiu(message.getRid(), message.getContent());
		
		ResChampionBiubiuBuilder builder = ResChampionBiubiu.builder();
		builder.rid(message.getRid());
		builder.biuCd(message.getBiuCd());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getBiuList(ReqChampionBiuList message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ResChampionBiuListBuilder builder = ResChampionBiuList.builder();
		builder.rid(message.getRid());
		builder.content(new ArrayList<>(championService.getBiuQueue(crossGroupId)));
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getGuessList(ReqChampionGuessList message, Connection connection) {
		ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(message.getRid());
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		ResChampionGuessListBuilder builder = ResChampionGuessList.builder();
		builder.rid(message.getRid());
		List<CSChampionGuess> record = new ArrayList<>();
		for(ChampionGuess championGuess : championPlayer.getGuessRecords()) {
			record.add(serialize(championGuess, championSystem));
		}
		builder.record(record);
		connection.send(builder.build());
	}
	
	private CSChampionGuess serialize(ChampionGuess guess, ChampionCrossSystem championSystem) {
		ChampionCrossBattle battle = championBattleService.getOneBattle(guess.getBid());
		
		CSChampionGuessBuilder builder = CSChampionGuess.builder();
		builder.bid(guess.getBid());
		builder.battleId(battle.getBattleId() == null ? "" : battle.getBattleId());
		builder.guessType(guess.getGuessType());
		builder.guessCoin(guess.getGuessCoin());
		builder.delta(guess.getDelta());
		builder.attacker(serialFormation(battle.getAtkRid(), battle.getAtkFight(), battle.getAtkVo(), battle.getCrossGroupId()));
		builder.defender(serialFormation(battle.getDefRid(), battle.getDefFight(), battle.getDefVo(), battle.getCrossGroupId()));
		builder.period(battle.getPeriod());
		builder.battleRound(battle.getBattleRound());
		
		ChampionGroup championGroup = championSystem.getGroupResult().get(battle.getCrossGroupId());
		if(championGroup != null) {
			if(championSystem.getBattleRound() == battle.getBattleRound() && championGroup.getGuessId() == battle.getId()) {
				//当前正在战斗阶段，则当前正在战斗的比赛“显示”为下注中
				builder.whichWin(0);
			} else {
				builder.whichWin(battle.getWhichWin());
			}
		}
		builder.battleLog(battle.getBattleLog());
		return builder.build();
	}
	
	@RemoteMethod
	public void getBattleList(ReqScanMyChampionBattle message, Connection connection) {
		
		List<ChampionCrossBattle> myBattleList = new ArrayList<>();
		for(ChampionCrossBattle championBattle : championBattleService.getAllBattleMap().values()) {
			if(championBattle.getAtkRid() == message.getRid() || championBattle.getDefRid() == message.getRid()) {
				myBattleList.add(championBattle);
			}
		}
		Collections.sort(myBattleList, ChampionTemplate.BATTLE_SORTER);
		
		ResScanMyChampionBattleBuilder builder = ResScanMyChampionBattle.builder();
		builder.rid(message.getRid());
		List<CSChampionBattle> battles = new ArrayList<>();
		for(ChampionCrossBattle battle : myBattleList) {
			CSChampionBattleBuilder model = CSChampionBattle.builder();
			model.bid(battle.getId());
			model.battleId(battle.getBattleId());
			model.addPoint(battle.getAddPoint());
			model.attacker(serialFormation(battle.getAtkRid(), battle.getAtkFight(), battle.getAtkVo(), battle.getCrossGroupId()));
			model.defender(serialFormation(battle.getDefRid(), battle.getDefFight(), battle.getDefVo(), battle.getCrossGroupId()));
			model.whichWin(battle.getWhichWin());
			model.period(battle.getPeriod());
			model.battleRound(battle.getBattleRound());
			model.battleLog(battle.getBattleLog());
			battles.add(model.build());
		}
		builder.battles(battles);
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void scanChampionRank(ReqChampionRank message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		List<ChampionCrossCompetitor> topList = championCompetitorService.getTopList(crossGroupId);
		
		ResChampionRankBuilder builder = ResChampionRank.builder();
		builder.rid(message.getRid());
		if(topList != null) {
			List<CSChampionRanker> ranks = new ArrayList<>();
			for(int i = 0; i < topList.size(); i++) {
				ChampionCrossCompetitor competitor = topList.get(i);
				if(i < 50 || competitor.getRid() == message.getRid()) {
					ranks.add(championCompetitorService.serialChampionRank(competitor));
				}
			}
			builder.ranks(ranks);
		}
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getChampionLastTop(ReqChampionShowTop message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		ChampionCrossSystem championSystem = championService.getSystem();
		
		ChampionCrossPlayer player = championPlayerService.getPlayer(message.getRid());
		if(player.getShowRound() < championSystem.getRound() - 1) {
			player.setShowRound(championSystem.getRound() - 1);
			championPlayerService.update(player);
		}
		
		ResChampionShowTopBuilder builder = ResChampionShowTop.builder();
		builder.rid(message.getRid());
		builder.time(championSystem.getLastStartTime());
		
		List<ChampionCrossCompetitor> topList = championCompetitorService.getTopList(crossGroupId);
		//只需要发送前3名
		if(topList != null) {
			List<CSChampionRanker> ranks = new ArrayList<>();
			for(int i = 0; i < 3 && i < topList.size(); i++) {
				ChampionCrossCompetitor competitor = topList.get(i);
				ranks.add(championCompetitorService.serialChampionRank(competitor));
			}
			builder.ranks(ranks);
		}
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void markShowMyResult(ReqChampionShowMyResult message, Connection connection) {
		ChampionCrossPlayer player = championPlayerService.getPlayer(message.getRid());
		if(player.getShowResult() == 0) {
			player.setShowResult(1);
			championPlayerService.update(player);
		}
		ResChampionShowMyResultBuilder builder = ResChampionShowMyResult.builder();
		builder.rid(message.getRid());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void saveChampionFormation(ReqChampionSaveFormation message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		
		
		ResChampionSaveFormationBuilder builder = ResChampionSaveFormation.builder();
		builder.rid(message.getRid());
		
		ChampionCrossCompetitor competitor = championCompetitorService.getCompetitor(message.getRid(), crossGroupId);
		if(competitor == null) {
			log.warn("玩家" + message.getRid() + "不是这个赛季的参赛者");
			connection.send(builder.build());
			return;
		}
		
		BattlerVo battlerVo = ProtostuffUtil.deserialize(message.getBattlerVo(), BattlerVo.class);
		competitor.setBattlerVo(battlerVo);
		competitor.setFighting(message.getFighting());
		championCompetitorService.update(competitor);
		
		ChampionCrossSystem championSystem = championService.getSystem();
		ChampionCrossBattle championBattle = championBattleService.getMyBattle(message.getRid());
		if(championBattle != null && championSystem.getStage() == ChampionStage.PREPARE.getValue()) {
			if(championBattle.getAtkRid() == message.getRid()) {
				championBattle.setAtkVo(battlerVo);
				championBattle.setAtkFight(message.getFighting());
			} else if(championBattle.getDefRid() == message.getRid()) {
				championBattle.setDefVo(battlerVo);
				championBattle.setDefFight(message.getFighting());
			}
			championBattleService.updateBattle(championBattle);
		}
		connection.send(builder.build());
		
		if(championBattle != null) {
			//修改阵容后给整个跨服组进行消息推送
			messageHelper.pushToGroupMessage(crossGroupId, ResChampionFormationChange.builder().build());
		}
	}
	
	@RemoteMethod
	public void reportReward(ReqChampionReport message, Connection connection) {
		ChampionCrossResult result = championCrossResultService.getByServerRound(message.getServerId(), message.getRound());
		if(result.getStatus() == 0) {
			result.setStatus(1);
			championCrossResultService.updateResult(result);
		}
	}
	
	@RemoteMethod
	public void gmNextStage(ReqChampionCrossGmNextStage message, Connection connection) {
		championService.gmTransformStage();
	}
}
