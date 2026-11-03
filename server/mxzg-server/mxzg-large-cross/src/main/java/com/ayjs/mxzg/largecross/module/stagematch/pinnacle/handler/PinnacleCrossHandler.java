/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.handler;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.constant.PinnacleStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleGuess;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleTop;
import com.ayjs.mxzg.largecross.module.robot.domain.LargeCrossRobot;
import com.ayjs.mxzg.largecross.module.robot.service.LargeCrossRobotService;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.StageMatchWorker;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossBattle;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossCompetitor;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossPlayer;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossResult;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossSystem;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossBattleService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossCompetitorService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossPlayerService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossResultService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.period.PinnaclePeriodService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleGroup;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleFormation;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleGuess;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleHero;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleKnockoutBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleMyResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRank;
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
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiuList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiubiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleFormationChange;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessBroadcast;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessList;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessOneBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleLike;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleRank;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleSaveFormation;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleShowMyResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleShowTop;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanMyPinnacleBattle;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanPinnacleKnockout;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResScanPinnacleMessage;
import com.ayjs.mxzg.module.pinnacle.PinnacleGuessEvent;
import com.ayjs.mxzg.module.pinnacle.PinnacleTemplate;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


@Slf4j
@Controller
public class PinnacleCrossHandler implements MessageHandler {

	@Autowired
	private PinnacleCrossService pinnacleCrossService;
	@Autowired
	private PinnacleCrossPlayerService pinnaclePlayerService;
	@Autowired
	private PinnacleCrossCompetitorService pinnacleCompetitorService;
	@Autowired
	private OpponentDao opponentDao;
	@Autowired
	private ServerGroupService serverGroupService;
	@Autowired
	private PinnacleCrossBattleService pinnacleBattleService;
	@Autowired
	private PinnaclePeriodService pinnacleKnockoutService;
	@Autowired
	private MessageHelper messageHelper;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private PinnacleCrossResultService pinnacleCrossResultService;
	@Autowired
	private SuperStageCycleSysCache stageMatchCycleSysCache;
	@Autowired
	private StageMatchWorker stageMatchWorker;
	@Autowired
	private SessionManager sessionManager;
	@Autowired
	private LargeCrossRobotService largeCrossRobotService;
	
	@RemoteMethod
	public void scanPinnacle(ReqScanPinnacleMessage message, Connection connection) {
		CrossGroup crossGroup = sessionManager.getGroupByClientId(connection.getClientId());

		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(message.getRid());

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();
		
		ResScanPinnacleMessage.ResScanPinnacleMessageBuilder builder = ResScanPinnacleMessage.builder();
		builder.rid(message.getRid());
		builder.like(pinnaclePlayer.getLike());
		builder.period(pinnacleSystem.getPeriod());
		builder.rank(pinnacleCompetitorService.getRoleRank(message.getRid()));
		builder.hisRank(pinnaclePlayer.getHisRank());
		builder.likeRank(new ArrayList<>(pinnaclePlayer.getKneels()));
		builder.battleRound(pinnacleSystem.getBattleRound());
		
		PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(crossGroup.getGroupId());
		if(pinnacleGroup != null) {
			List<CSPinnacleRank> ranks = new ArrayList<>();
			for(PinnacleTop pinnacleTop : pinnacleGroup.getTopPlayers().values()) {
				ranks.add(serialPinnacleRank(pinnacleTop));
			}
			builder.ranks(ranks);
		}
		
		builder.biuCd(pinnaclePlayer.getBiuCd());
		builder.showRound(pinnaclePlayer.getShowRound() < pinnacleSystem.getRound() - 1 ? 1 : 0);
		if(pinnaclePlayer.getShowResult() == 0 && pinnaclePlayer.getResult() != null) {
			CSPinnacleMyResult.CSPinnacleMyResultBuilder model = CSPinnacleMyResult.builder();
			model.rank(pinnaclePlayer.getResult().getRank());
			model.battleNum(pinnaclePlayer.getResult().getBattleNum());
			model.winNum(pinnaclePlayer.getResult().getWinNum());
			builder.result(model.build());
		}
		builder.battleStartTime(pinnacleSystem.getStartTime());
		connection.send(builder.build());
	}
	
	public CSPinnacleRank serialPinnacleRank(PinnacleTop pinnacleTop) {
		CSPinnacleRank.CSPinnacleRankBuilder builder = CSPinnacleRank.builder();
		builder.rid(pinnacleTop.getRid());
		builder.robot(pinnacleTop.getRobot());

		Opponent role = opponentDao.get(pinnacleTop.getRid());
		if(role != null){
			builder.name(role.getName());
			builder.imageId(role.getImage_id());
		} else {
			LargeCrossRobot largeCrossRobot = largeCrossRobotService.getRobot(pinnacleTop.getRid());
			builder.name(largeCrossRobot.getNick());
			builder.imageId(largeCrossRobot.getImageId());
		}
		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(pinnacleTop.getRid());
		builder.like(pinnaclePlayer.getLike());
		builder.rank(pinnacleTop.getRank());
		return builder.build();
	}
	
	@RemoteMethod
	public void scanMyBattle(ReqMyPinnacleBattle message, Connection connection) {
		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();

		ResMyPinnacleBattle.ResMyPinnacleBattleBuilder builder = ResMyPinnacleBattle.builder();
		builder.rid(message.getRid());
		builder.nextTime(pinnacleSystem.getNextStageTime());
		
		List<PinnacleCrossBattle> myBattleList = new ArrayList<>();
		for(PinnacleCrossBattle pinnacleBattle : pinnacleBattleService.getAllBattleMap().values()) {
			if(pinnacleBattle.getAtkRid() == message.getRid() || pinnacleBattle.getDefRid() == message.getRid()) {
				myBattleList.add(pinnacleBattle);
			}
		}
		Collections.sort(myBattleList, PinnacleTemplate.BATTLE_SORTER);
		if(!myBattleList.isEmpty()) {
			PinnacleCrossBattle pinnacleBattle = myBattleList.get(0);
			builder.attacker(serialFormation(pinnacleBattle.getAtkRid(), pinnacleBattle.getAtkFight(),
					pinnacleBattle.getAtkVo(), pinnacleBattle.getCrossGroupId()));
			builder.defender(serialFormation(pinnacleBattle.getDefRid(), pinnacleBattle.getDefFight(),
					pinnacleBattle.getDefVo(), pinnacleBattle.getCrossGroupId()));

			builder.bid(pinnacleBattle.getId());
			if(pinnacleBattle.getBattleId() != null) {
				builder.battleId(pinnacleBattle.getBattleId());
			} else {
				builder.battleId("");
			}
			builder.whichWin(pinnacleBattle.getWhichWin());
		}
		if(!myBattleList.isEmpty()) {
			PinnacleCrossBattle lastBattle = myBattleList.get(0);
			builder.period(lastBattle.getPeriod());
			builder.battleRound(lastBattle.getBattleRound());
		} else {
			builder.period(pinnacleSystem.getPeriod());
			builder.battleRound(pinnacleSystem.getBattleRound());
		}
		builder.stage(pinnacleSystem.getStage());
		connection.send(builder.build());
	}
	
	private CSPinnacleFormation serialFormation(long rid, int fighting, BattlerVo battlerVo, int crossGroup) {
		CSPinnacleFormation.CSPinnacleFormationBuilder builder = CSPinnacleFormation.builder();
		PinnacleCrossCompetitor pinnacleCompetitor = pinnacleCompetitorService.getCompetitor(rid, crossGroup);

		if(pinnacleCompetitor.getRobot() == 1){
			LargeCrossRobot robot = largeCrossRobotService.getRobot(rid);
			builder.level(robot.getLevel());
			builder.headId(robot.getHeadId());
			builder.borderId(robot.getBorderId());
		} else {
			Opponent role = opponentDao.get(pinnacleCompetitor.getRid());
			builder.level(role.getLevel());
			builder.headId(role.getHeadId());
			builder.borderId(role.getBorderId());
		}
		
		builder.rid(pinnacleCompetitor.getRid());
		builder.name(pinnacleCompetitor.getName());
		
		builder.fighting(fighting);
		
		List<CSPinnacleHero> heros = new ArrayList<>();
		for(HeroVo heroVo : battlerVo.getHeros()) {
			CSPinnacleHero.CSPinnacleHeroBuilder model = CSPinnacleHero.builder();
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
		builder.robot(pinnacleCompetitor.getRobot());
		builder.formationId(battlerVo.getFormationId());
		return builder.build();
	}
	
	@RemoteMethod
	public void scanGuessBattle(ReqGuessPinnacleBattle message, Connection connection) {
		int crossGroupId = serverGroupService.getGroupId(message.getServerId());

		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(message.getRid());

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();

		ResGuessPinnacleBattle.ResGuessPinnacleBattleBuilder builder = ResGuessPinnacleBattle.builder();
		builder.rid(message.getRid());
		builder.period(pinnacleSystem.getPeriod());
		builder.battleRound(pinnacleSystem.getBattleRound());
		builder.nextTime(pinnacleSystem.getNextStageTime());

		PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(crossGroupId);
		if(pinnacleGroup != null) {
			PinnacleCrossBattle pinnacleBattle = pinnacleBattleService.getOneBattle(pinnacleGroup.getGuessId());
			if(pinnacleBattle != null) {
				builder.attacker(serialFormation(pinnacleBattle.getAtkRid(), pinnacleBattle.getAtkFight(),
						pinnacleBattle.getAtkVo(), pinnacleBattle.getCrossGroupId()));
				builder.defender(serialFormation(pinnacleBattle.getDefRid(), pinnacleBattle.getDefFight(),
						pinnacleBattle.getDefVo(), pinnacleBattle.getCrossGroupId()));

				builder.bid(pinnacleBattle.getId());
				if(pinnacleBattle.getBattleId() != null) {
					builder.battleId(pinnacleBattle.getBattleId());
				}
				builder.whichWin(pinnacleBattle.getWhichWin());
				builder.atkCoin(pinnacleBattle.getAtkCoin());
				builder.defCoin(pinnacleBattle.getDefCoin());
				
				builder.isGuess(pinnacleBattle != null && pinnaclePlayer.getGuessId() == pinnacleBattle.getId() ? 1 : 0);
			}
		}
		
		builder.guessCoin(pinnaclePlayer.getGuessCoin());
		builder.stage(pinnacleSystem.getStage());
		builder.guessType(pinnaclePlayer.getGuessType());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void guessBattle(ReqPinnacleGuessOneBattle message, Connection connection) {
		
		Asserts.isTrue(message.getType() == 1 || message.getType() == 2, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要1、2，实际" + message.getType());
		
		Asserts.isTrue(message.getGuessCoin() > 0, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要大于0，实际" + message.getGuessCoin());
		
		Asserts.isTrue(message.getGuessCoin() <= PinnacleConst.MAX_GUESS, ErrorCode.CHAMPION_MAX_GUESS.getValue(), "你的竞猜投注太多了" + message.getGuessCoin());

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();
		
		Opponent role = opponentDao.get(message.getRid());
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());

		PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(crossGroupId);
		Asserts.isTrue(pinnacleGroup != null, ErrorCode.CHAMPION_CROSS_GROUP_MISS.getValue(), "跨服冠军赛分组不存在");
		PinnacleCrossBattle pinnacleBattle = pinnacleBattleService.getOneBattle(pinnacleGroup.getGuessId());
		
		Asserts.notNull(pinnacleBattle, ErrorCode.CHAMPION_NO_GUESS.getValue(), "当前没有比赛正在进行竞猜" + pinnacleGroup.getGuessId());
		
		Asserts.isTrue(pinnacleCrossService.isGuessStage(), ErrorCode.CHAMPION_NOT_GUESS.getValue(), "当前不是竞猜阶段");
		
		Asserts.isTrue(pinnacleBattle.getWhichWin() == 0, ErrorCode.CHAMPION_GUESS_OVER.getValue(), "该比赛已经结束");

		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(message.getRid());
		
		Asserts.isTrue(pinnaclePlayer.getGuessId() != pinnacleBattle.getId(), ErrorCode.CHAMPION_HAD_GUESS.getValue(), "你已经参与了该比赛的竞猜");
		
		Asserts.isTrue(pinnaclePlayer.getGuessCoin() >= message.getGuessCoin(), ErrorCode.CHAMPION_GUESS_LACK.getValue(), "你的竞猜币不足");
		
		pinnaclePlayer.setGuessCoin(pinnaclePlayer.getGuessCoin() - message.getGuessCoin());
		pinnaclePlayer.setGuessId(pinnacleBattle.getId());
		pinnaclePlayer.setGuessType(message.getType());
		pinnaclePlayer.setBetCoin(message.getGuessCoin());
		
		//添加投注记录
		PinnacleGuess guessRecord = new PinnacleGuess();
		guessRecord.setBid(pinnacleBattle.getId());
		guessRecord.setGuessType(message.getType());
		guessRecord.setGuessCoin(message.getGuessCoin());
		pinnaclePlayer.getGuessRecords().add(guessRecord);
		pinnaclePlayerService.update(pinnaclePlayer);
		
		synchronized (pinnacleBattle) {
			if(message.getType() == 1) {
				pinnacleBattle.setAtkCoin(pinnacleBattle.getAtkCoin() + message.getGuessCoin());
			} else {
				pinnacleBattle.setDefCoin(pinnacleBattle.getDefCoin() + message.getGuessCoin());
			}
			pinnacleBattle.getGuessPlayers().add(pinnaclePlayer.getRid());
			pinnacleBattleService.updateBattle(pinnacleBattle);
		}

		ResPinnacleGuessOneBattle.ResPinnacleGuessOneBattleBuilder builder = ResPinnacleGuessOneBattle.builder();
		builder.rid(message.getRid());
		builder.guessCoin(pinnaclePlayer.getGuessCoin());
		connection.send(builder.build());

		ResPinnacleGuessBroadcast.ResPinnacleGuessBroadcastBuilder builder0 = ResPinnacleGuessBroadcast.builder();
		builder0.type(message.getType());
		builder0.guessCoin(message.getGuessCoin());
		messageHelper.pushToGroupMessage(crossGroupId, builder0.build());
	
		eventBus.post(PinnacleGuessEvent.of(message.getRid(), -message.getGuessCoin(), pinnaclePlayer.getGuessCoin(),
				message.getType(), pinnacleBattle, GameEvent.PINNACLE_GUESS_BATTLE));
	}
	
	@RemoteMethod
	public void getPinnacleBattle(ReqGetPinnacleBattle message, Connection connection) {
		PinnacleCrossBattle pinnacleBattle = pinnacleBattleService.getOneBattle(message.getBid());
		
		Asserts.notNull(pinnacleBattle, ErrorCode.CHAMPION_NO_BATTLE.getValue(), "没有找到该比赛" + message.getBid());
		
		String battleId = pinnacleBattle.getBattleId();
		Asserts.isTrue(battleId != null && !"".equals(battleId), ErrorCode.CHAMPION_NO_BATTLE.getValue(),
				"没有找到该比赛" + message.getBid());

		ResGetPinnacleBattle.ResGetPinnacleBattleBuilder builder = ResGetPinnacleBattle.builder();
		builder.rid(message.getRid());
		builder.battleId(battleId);
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void scanPinnacle32(ReqScanPinnacleKnockout message, Connection connection) {

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();
		
		Opponent role = opponentDao.get(message.getRid());
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());

		PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(crossGroupId);

		ResScanPinnacleKnockout.ResScanPinnacleKnockoutBuilder builder = ResScanPinnacleKnockout.builder();
		builder.rid(message.getRid());
		if(pinnacleGroup != null) {
			builder.guessId(pinnacleGroup.getGuessId());
		}
		builder.battleRound(pinnacleSystem.getBattleRound());
		builder.nextTime(pinnacleSystem.getNextStageTime());
		builder.stage(pinnacleSystem.getStage());
		//这里用下标进行循环，避免正在遍历中修改列表的情况
		
		List<PinnacleCrossBattle> battle32List = pinnacleKnockoutService.get32Battle(crossGroupId);
		if(battle32List != null) {
			List<CSPinnacleKnockoutBattle> battles = new ArrayList<>();
			for(int i = 0; i < battle32List.size(); i++) {
				PinnacleCrossBattle battle = battle32List.get(i);
				battles.add(serial32Battle(battle));
			}
			builder.battles(battles);
		}
		connection.send(builder.build());
	}
	
	private CSPinnacleKnockoutBattle serial32Battle(PinnacleCrossBattle battle) {
		CSPinnacleKnockoutBattle.CSPinnacleKnockoutBattleBuilder builder = CSPinnacleKnockoutBattle.builder();
		PinnacleCrossCompetitor attacker = pinnacleCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
		PinnacleCrossCompetitor defender = pinnacleCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
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
	public void pinnacleLike(ReqPinnacleLike message, Connection connection) {
		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(message.getRid());
		synchronized (this) {
			Asserts.isTrue(!pinnaclePlayer.getKneels().contains(message.getTargetRid()),
					ErrorCode.CHAMPION_KNEEL_TOP.getValue(), String.format("你已经点赞过该选手%s已经膜拜列表%s", message.getTargetRid(), pinnaclePlayer.getKneels()));

			Asserts.isTrue(pinnaclePlayer.getKneels().size() < PinnacleConst.PINNACLE_MAX_LIKE, ErrorCode.PINNACLE_MAX_LIKE.getValue(),
					String.format("巅峰赛点赞次数超过每日点赞上限%s",pinnaclePlayer.getKneels().size()));

			pinnaclePlayer.getKneels().add(message.getTargetRid());
			pinnaclePlayerService.update(pinnaclePlayer);
			PinnacleCrossPlayer topPlayer = pinnaclePlayerService.getPlayer(message.getTargetRid());
			topPlayer.setLike(topPlayer.getLike() + 1);
			pinnaclePlayerService.update(topPlayer);
		}

		ResPinnacleLike.ResPinnacleLikeBuilder builder = ResPinnacleLike.builder();
		builder.rid(message.getRid());
		builder.targetRid(message.getTargetRid());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void pinnacleBiubiubiu(ReqPinnacleBiubiu message, Connection connection) {
		pinnacleCrossService.addBiubiubiu(message.getRid(), message.getContent());

		ResPinnacleBiubiu.ResPinnacleBiubiuBuilder builder = ResPinnacleBiubiu.builder();
		builder.rid(message.getRid());
		builder.biuCd(message.getBiuCd());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getBiuList(ReqPinnacleBiuList message, Connection connection) {
		Opponent role = opponentDao.get(message.getRid());
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());

		ResPinnacleBiuList.ResPinnacleBiuListBuilder builder = ResPinnacleBiuList.builder();
		builder.rid(message.getRid());
		builder.content(new ArrayList<>(pinnacleCrossService.getBiuQueue(crossGroupId)));
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getGuessList(ReqPinnacleGuessList message, Connection connection) {
		PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(message.getRid());

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();

		ResPinnacleGuessList.ResPinnacleGuessListBuilder builder = ResPinnacleGuessList.builder();
		builder.rid(message.getRid());
		List<CSPinnacleGuess> record = new ArrayList<>();
		for(PinnacleGuess pinnacleGuess : pinnaclePlayer.getGuessRecords()) {
			if(pinnacleGuess.getBid() != 0){
				CSPinnacleGuess guess = serialize(pinnacleGuess, pinnacleSystem);
				if(guess != null){
					record.add(guess);
				}
			}
		}
		builder.record(record);
		connection.send(builder.build());
	}
	
	private CSPinnacleGuess serialize(PinnacleGuess guess, PinnacleCrossSystem pinnacleSystem) {
		PinnacleCrossBattle battle = pinnacleBattleService.getOneBattle(guess.getBid());
		if(battle == null){
			return null;
		}

		CSPinnacleGuess.CSPinnacleGuessBuilder builder = CSPinnacleGuess.builder();
		builder.bid(guess.getBid());
		builder.battleId(battle.getBattleId() == null ? "" : battle.getBattleId());
		builder.guessType(guess.getGuessType());
		builder.guessCoin(guess.getGuessCoin());
		builder.delta(guess.getDelta());
		builder.attacker(serialFormation(battle.getAtkRid(), battle.getAtkFight(), battle.getAtkVo(), battle.getCrossGroupId()));
		builder.defender(serialFormation(battle.getDefRid(), battle.getDefFight(), battle.getDefVo(), battle.getCrossGroupId()));
		builder.period(battle.getPeriod());
		builder.battleRound(battle.getBattleRound());

		PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(battle.getCrossGroupId());
		if(pinnacleGroup != null) {
			if(pinnacleSystem.getBattleRound() == battle.getBattleRound() && pinnacleGroup.getGuessId() == battle.getId()) {
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
	public void getBattleList(ReqScanMyPinnacleBattle message, Connection connection) {
		
		List<PinnacleCrossBattle> myBattleList = new ArrayList<>();
		for(PinnacleCrossBattle pinnacleBattle : pinnacleBattleService.getAllBattleMap().values()) {
			if(pinnacleBattle.getAtkRid() == message.getRid() || pinnacleBattle.getDefRid() == message.getRid()) {
				myBattleList.add(pinnacleBattle);
			}
		}
		Collections.sort(myBattleList, PinnacleTemplate.BATTLE_SORTER);

		ResScanMyPinnacleBattle.ResScanMyPinnacleBattleBuilder builder = ResScanMyPinnacleBattle.builder();
		builder.rid(message.getRid());
		List<CSPinnacleBattle> battles = new ArrayList<>();
		for(PinnacleCrossBattle battle : myBattleList) {
			CSPinnacleBattle.CSPinnacleBattleBuilder model = CSPinnacleBattle.builder();
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
	public void scanPinnacleRank(ReqPinnacleRank message, Connection connection) {
		CrossGroup crossGroup = sessionManager.getGroupByClientId(connection.getClientId());
		int crossGroupId = crossGroup.getGroupId();
		
		List<PinnacleCrossCompetitor> topList = pinnacleCompetitorService.getTopList(crossGroupId);

		ResPinnacleRank.ResPinnacleRankBuilder builder = ResPinnacleRank.builder();
		builder.rid(message.getRid());
		if(topList != null) {
			List<CSPinnacleRanker> ranks = new ArrayList<>();
			for(int i = 0; i < topList.size(); i++) {
				PinnacleCrossCompetitor competitor = topList.get(i);
				if(i < 50 || competitor.getRid() == message.getRid()) {
					ranks.add(pinnacleCompetitorService.serialPinnacleRank(competitor));
				}
			}
			builder.ranks(ranks);
		}
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void getPinnacleLastTop(ReqPinnacleShowTop message, Connection connection) {

		Opponent role = opponentDao.get(message.getRid());
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();

		PinnacleCrossPlayer player = pinnaclePlayerService.getPlayer(message.getRid());
		if(player.getShowRound() < pinnacleSystem.getRound() - 1) {
			player.setShowRound(pinnacleSystem.getRound() - 1);
			pinnaclePlayerService.update(player);
		}

		ResPinnacleShowTop.ResPinnacleShowTopBuilder builder = ResPinnacleShowTop.builder();
		builder.rid(message.getRid());
		builder.time(pinnacleSystem.getLastStartTime());
		
		List<PinnacleCrossCompetitor> topList = pinnacleCompetitorService.getTopList(crossGroupId);
		//只需要发送前3名
		if(topList != null) {
			List<CSPinnacleRanker> ranks = new ArrayList<>();
			for(int i = 0; i < 3 && i < topList.size(); i++) {
				PinnacleCrossCompetitor competitor = topList.get(i);
				ranks.add(pinnacleCompetitorService.serialPinnacleRank(competitor));
			}
			builder.ranks(ranks);
		}
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void markShowMyResult(ReqPinnacleShowMyResult message, Connection connection) {
		PinnacleCrossPlayer player = pinnaclePlayerService.getPlayer(message.getRid());
		if(player.getShowResult() == 0) {
			player.setShowResult(1);
			pinnaclePlayerService.update(player);
		}
		ResPinnacleShowMyResult.ResPinnacleShowMyResultBuilder builder = ResPinnacleShowMyResult.builder();
		builder.rid(message.getRid());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void savePinnacleFormation(ReqPinnacleSaveFormation message, Connection connection) {
		Opponent role = opponentDao.get(message.getRid());
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());


		ResPinnacleSaveFormation.ResPinnacleSaveFormationBuilder builder = ResPinnacleSaveFormation.builder();
		builder.rid(message.getRid());

		PinnacleCrossCompetitor competitor = pinnacleCompetitorService.getCompetitor(message.getRid(), crossGroupId);
		if(competitor == null) {
			log.warn("玩家" + message.getRid() + "不是这个赛季的参赛者");
			connection.send(builder.build());
			return;
		}
		
		BattlerVo battlerVo = ProtostuffUtil.deserialize(message.getBattlerVo(), BattlerVo.class);
		competitor.setBattlerVo(battlerVo);
		competitor.setFighting(message.getFighting());
		pinnacleCompetitorService.update(competitor);

		PinnacleCrossSystem pinnacleSystem = pinnacleCrossService.getSystem();
		PinnacleCrossBattle pinnacleBattle = pinnacleBattleService.getMyBattle(message.getRid());
		if(pinnacleBattle != null && pinnacleSystem.getStage() == PinnacleStage.PREPARE.getValue()) {
			if(pinnacleBattle.getAtkRid() == message.getRid()) {
				pinnacleBattle.setAtkVo(battlerVo);
				pinnacleBattle.setAtkFight(message.getFighting());
			} else if(pinnacleBattle.getDefRid() == message.getRid()) {
				pinnacleBattle.setDefVo(battlerVo);
				pinnacleBattle.setDefFight(message.getFighting());
			}
			pinnacleBattleService.updateBattle(pinnacleBattle);
		}
		connection.send(builder.build());
		
		if(pinnacleBattle != null) {
			//修改阵容后给整个跨服组进行消息推送
			messageHelper.pushToGroupMessage(crossGroupId, ResPinnacleFormationChange.builder().build());
		}
	}
	
	@RemoteMethod
	public void reportReward(ReqPinnacleReport message, Connection connection) {
		PinnacleCrossResult result = pinnacleCrossResultService.getByServerRound(message.getServerId(), message.getRound());
		if(result.getStatus() == 0) {
			result.setStatus(1);
			pinnacleCrossResultService.updateResult(result);
		}
	}
	
	@RemoteMethod
	public void gmNextStage(ReqPinnacleCrossGmNextStage message, Connection connection) {
		pinnacleCrossService.gmTransformStage();
	}



	@RemoteMethod
	public void gmResetStage(ReqResetStage message, Connection connection) {
		CSuperStageCycle nowCycle = stageMatchCycleSysCache.getNowCycle();
		stageMatchWorker.executeCycle(nowCycle);
	}
}
