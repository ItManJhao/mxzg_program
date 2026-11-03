/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionRobotRoleSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CChampionRobotRole;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.champion.ChampionGuess;
import com.ayjs.mxzg.config.struct.champion.ChampionTop;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionRobot;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionBattleService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionCompetitorService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionPlayerService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionRobotService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.gameserver.module.champion.service.period.ChampionKnockoutService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.module.champion.ChampionGuessEvent;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionBiuList;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionBiubiu;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionGuessList;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionLike;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionRank;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionSaveFormation;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionShowMyResult;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqChampionShowTop;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqGetChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqGuessChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqGuessOneBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqMyChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqScanChampion;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqScanChampionKnockout;
import com.ayjs.mxzg.protocol.ChampionGMsg.GReqScanMyChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionBiuList;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionBiubiu;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionFormationChange;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionGuessBroadcast;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionGuessList;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionLike;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionRank;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionSaveFormation;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionShowMyResult;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionShowTop;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResGetChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResGuessChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResGuessOneBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResMyChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResScanChampion;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResScanChampionKnockout;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResScanMyChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionFormation;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionGuess;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionHero;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionKnockoutBattle;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionMyResult;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionRank;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionRanker;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class ChampionHandler extends ProtocolHandler {

	@Autowired
	private ChampionService championService;
	@Autowired
	private ChampionPlayerService championPlayerService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private ChampionRobotRoleSysCache championRobotRoleSysCache;
	@Autowired
	private ChampionBattleService championBattleService;
	@Autowired
	private ChampionKnockoutService championKnockoutService;
	@Autowired
	private ChampionRobotService championRobotService;
	@Autowired
	private LanguageSysCache languageSysCache;
	@Autowired
	private LanguageHelper languageHelper;
	@Autowired
	private SensitiveWordService sensitiveWordService;
	@Autowired
	private ChampionSeasonSysCache championSeasonSysCache;
	@Autowired
	private ContextManager contextManager;
	@Autowired
	private ThingService thingService;
	@Autowired
	private BattleHelper battleHelper;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private ChampionCompetitorService championCompetitorService;
	@Autowired
	private EventBus eventBus;
	
	@CMD(id = CmdCode._41001)
	public void scanChampion(PlayerContext playerContext, GReqScanChampion msg) {
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		ChampionSystem championSystem = championService.getSystem();
		
		GResScanChampion.Builder builder = GResScanChampion.newBuilder();
		builder.setLike(championPlayer.getLike());
		builder.setPeriod(championSystem.getPeriod());
		builder.setRank(championService.getRoleRank(playerContext.getId()));
		builder.setHisRank(championPlayer.getHisRank());
		builder.setStartTime(championSystem.getRoundStartTime());
		builder.setEndTime(championSystem.getRoundEndTime());
		builder.addAllLikeRank(championPlayer.getKneels());
		for(ChampionTop championTop : championSystem.getTopPlayers().values()) {
			builder.addRanks(serialChampionRank(championTop));
		}
		builder.setBiuCd(championPlayer.getBiuCd());
		builder.setShowRound(championPlayer.getShowRound() < championSystem.getRound() - 1 ? 1 : 0);
		if(championPlayer.getShowResult() == 0 && championPlayer.getResult() != null) {
			PSChampionMyResult.Builder model = PSChampionMyResult.newBuilder();
			model.setRank(championPlayer.getResult().getRank());
			model.setBattleNum(championPlayer.getResult().getBattleNum());
			model.setWinNum(championPlayer.getResult().getWinNum());
			builder.setResult(model.build());
		}
		builder.setBattleStartTime(championSystem.getStartTime());
		playerContext.write(CmdCode._41001, builder.build());
	}
	
	private PSChampionRank serialChampionRank(ChampionTop championTop) {
		PSChampionRank.Builder builder = PSChampionRank.newBuilder();
		builder.setRid(championTop.getRid());
		builder.setRobot(championTop.getRobot());
		if(championTop.getRobot() == 1) {
			ChampionRobot robot = championRobotService.getRobot(championTop.getRid());
			CChampionRobotRole cRobotRole = championRobotRoleSysCache.getOrThrow((int)championTop.getRid());
			CLanguage cLanguage = languageSysCache.getByKey(cRobotRole.getName_lang());
			builder.setName(languageHelper.getLanguageBy(cLanguage));
			builder.setLike(robot.getLike());
			builder.setImageId(0);
		} else {
			Role role = roleService.getOrThrow(championTop.getRid());
			builder.setName(role.getNick());
			ChampionPlayer championPlayer = championPlayerService.getPlayer(role.getId());
			builder.setLike(championPlayer.getLike());
			builder.setImageId(role.getImageId());
		}
		builder.setRank(championTop.getRank());
		return builder.build();
	}
	
	@CMD(id = CmdCode._41002)
	public void scanMyBattle(PlayerContext playerContext, GReqMyChampionBattle msg) {
		ChampionSystem championSystem = championService.getSystem();
		
		GResMyChampionBattle.Builder builder = GResMyChampionBattle.newBuilder();
		
		builder.setPeriod(championSystem.getPeriod());
		builder.setBattleRound(championSystem.getBattleRound());
		builder.setNextTime(championSystem.getNextStageTime());
		
		List<ChampionBattle> myBattleList = new ArrayList<>();
		for(ChampionBattle championBattle : championService.getAllBattleMap().values()) {
			if(championBattle.getAtkRid() == playerContext.getId() || championBattle.getDefRid() == playerContext.getId()) {
				myBattleList.add(championBattle);
			}
		}
		Collections.sort(myBattleList, ChampionTemplate.BATTLE_SORTER);
		if(!myBattleList.isEmpty()) {
			ChampionBattle championBattle = myBattleList.get(0);
			builder.setAttacker(serialFormation(championBattle.getAtkRid(), championBattle.getAtkFight(), championBattle.getAtkVo()));
			builder.setDefender(serialFormation(championBattle.getDefRid(), championBattle.getDefFight(), championBattle.getDefVo()));
			
			builder.setBid(championBattle.getId());
			if(championBattle.getBattleId() != null) {
				builder.setBattleId(championBattle.getBattleId());
			}
			builder.setWhichWin(championBattle.getWhichWin());
			
			//TODO 止步逻辑
//			if(championBattle.getPeriod() == ChampionPeriod.KNOCKOUT) {
//				//止步淘汰赛的逻辑处理
//				if(championBattle.getWhichWin() == 1 && championBattle.getAtkRid() != playerContext.getId()) {
//					builder.setPeriod(championBattle.getPeriod());
//					builder.setBattleRound(championBattle.getBattleRound());
//				} else if(championBattle.getWhichWin() == 2 && championBattle.getDefRid() != playerContext.getId()) {
//					builder.setPeriod(championBattle.getPeriod());
//					builder.setBattleRound(championBattle.getBattleRound());
//				}
//			} else if(championBattle.getPeriod() == ChampionPeriod.TRIALS) {
//				ChampionCompetitor competitor = championService.getCompetitor(playerContext.getId());
//				if(competitor != null && competitor) {
//					
//				}
//			}
		}
		builder.setStage(championSystem.getStage());
		playerContext.write(CmdCode._41002, builder.build());
	}
	
	private PSChampionFormation serialFormation(long rid, int fighting, BattlerVo battlerVo) {
		PSChampionFormation.Builder builder = PSChampionFormation.newBuilder();
		ChampionCompetitor championCompetitor = championService.getCompetitorMap().get(rid);
		
		if(championCompetitor.getRobot() == 1) {
			CChampionRobotRole robotRole = championRobotRoleSysCache.getOrThrow((int)championCompetitor.getRid());
			builder.setLevel(robotRole.getLevel());
			builder.setHeadId(robotRole.getHead());
			builder.setBorderId(0);
		} else {
			Role role = roleService.getOrThrow(championCompetitor.getRid());
			builder.setLevel(role.getLevel());
			builder.setHeadId(role.getHeadId());
			builder.setBorderId(role.getBorderId());
			builder.setAssistanceUnlock(role.isAssistanceUnlock());
		}
		
		builder.setRid(championCompetitor.getRid());
		builder.setName(championCompetitor.getName());
		
		builder.setFighting(fighting);
		for(HeroVo heroVo : battlerVo.getHeros()) {
			PSChampionHero.Builder model = PSChampionHero.newBuilder();
			model.setId(heroVo.getId());
			model.setPos(heroVo.getPos());
			model.setHeroType(heroVo.getHero_type());
			model.setLevel(heroVo.getHero_level());
			model.setStage(heroVo.getStage());
			model.setStar(heroVo.getHero_star());
			model.setFashionId(heroVo.getFashionId());
			builder.addHeros(model.build());
		}
		builder.setRobot(championCompetitor.getRobot());
		builder.setFormationId(battlerVo.getFormationId());
		return builder.build();
	}
	
	
	@CMD(id = CmdCode._41003)
	public void scanGuessBattle(PlayerContext playerContext, GReqGuessChampionBattle msg) {
		
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		ChampionSystem championSystem = championService.getSystem();
		
		GResGuessChampionBattle.Builder builder = GResGuessChampionBattle.newBuilder();
		builder.setPeriod(championSystem.getPeriod());
		builder.setBattleRound(championSystem.getBattleRound());
		builder.setNextTime(championSystem.getNextStageTime());
		
		ChampionBattle championBattle = championService.getOneBattle(championSystem.getGuessId());
		if(championBattle != null) {
			builder.setAttacker(serialFormation(championBattle.getAtkRid(), championBattle.getAtkFight(), championBattle.getAtkVo()));
			builder.setDefender(serialFormation(championBattle.getDefRid(), championBattle.getDefFight(), championBattle.getDefVo()));
			
			builder.setBid(championBattle.getId());
			if(championBattle.getBattleId() != null) {
				builder.setBattleId(championBattle.getBattleId());
			}
			builder.setWhichWin(championBattle.getWhichWin());
			builder.setAtkCoin(championBattle.getAtkCoin());
			builder.setDefCoin(championBattle.getDefCoin());
		}
		
		builder.setGuessCoin(championPlayer.getGuessCoin());
		builder.setIsGuess(championBattle != null && championPlayer.getGuessId() == championBattle.getId() ? 1 : 0);
		builder.setStage(championSystem.getStage());
		builder.setGuessType(championPlayer.getGuessType());

		playerContext.write(CmdCode._41003, builder.build());
	}
	
	@CMD(id = CmdCode._41004)
	public void guessBattle(PlayerContext playerContext, GReqGuessOneBattle msg) {
		
		Asserts.isTrue(msg.getType() == 1 || msg.getType() == 2, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要1、2，实际" + msg.getType());
		
		Asserts.isTrue(msg.getGuessCoin() > 0, ErrorCode.ERROR_PARAM.getValue(), "参数错误，需要大于0，实际" + msg.getGuessCoin());
		
		Asserts.isTrue(msg.getGuessCoin() <= ChampionConst.MAX_GUESS, ErrorCode.CHAMPION_MAX_GUESS.getValue(), "你的竞猜投注太多了" + msg.getGuessCoin());
		
		ChampionSystem championSystem = championService.getSystem();
		
		ChampionBattle championBattle = championService.getOneBattle(championSystem.getGuessId());
		
		Asserts.notNull(championBattle, ErrorCode.CHAMPION_NO_GUESS.getValue(), "当前没有比赛正在进行竞猜" + championSystem.getGuessId());
		
		Asserts.isTrue(championService.isGuessStage(), ErrorCode.CHAMPION_NOT_GUESS.getValue(), "当前不是竞猜阶段");
		
		Asserts.isTrue(championBattle.getWhichWin() == 0, ErrorCode.CHAMPION_GUESS_OVER.getValue(), "该比赛已经结束");
		
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		Asserts.isTrue(championPlayer.getGuessId() != championBattle.getId(), ErrorCode.CHAMPION_HAD_GUESS.getValue(), "你已经参与了该比赛的竞猜");
		
		Asserts.isTrue(championPlayer.getGuessCoin() >= msg.getGuessCoin(), ErrorCode.CHAMPION_GUESS_LACK.getValue(), "你的竞猜币不足");
		
		championPlayer.setGuessCoin(championPlayer.getGuessCoin() - msg.getGuessCoin());
		championPlayer.setGuessId(championBattle.getId());
		championPlayer.setGuessType(msg.getType());
		championPlayer.setBetCoin(msg.getGuessCoin());
		
		//添加投注记录
		ChampionGuess guessRecord = new ChampionGuess();
		guessRecord.setBid(championBattle.getId());
		guessRecord.setGuessType(msg.getType());
		guessRecord.setGuessCoin(msg.getGuessCoin());
		championPlayer.getGuessRecords().add(guessRecord);
		championPlayerService.update(championPlayer);
		
		synchronized (championBattle) {
			if(msg.getType() == 1) {
				championBattle.setAtkCoin(championBattle.getAtkCoin() + msg.getGuessCoin());
			} else {
				championBattle.setDefCoin(championBattle.getDefCoin() + msg.getGuessCoin());
			}
			championBattle.getGuessPlayers().add(playerContext.getId());
			championBattleService.updateBattle(championBattle);
		}
		
		GResGuessOneBattle.Builder builder = GResGuessOneBattle.newBuilder();
		builder.setGuessCoin(championPlayer.getGuessCoin());
		playerContext.write(CmdCode._41004, builder.build());
		
		GResChampionGuessBroadcast.Builder builder0 = GResChampionGuessBroadcast.newBuilder();
		builder0.setType(msg.getType());
		builder0.setGuessCoin(msg.getGuessCoin());
		contextManager.writeAll(CmdCode._41019, builder0.build());
		
		eventBus.post(ChampionGuessEvent.of(playerContext.getId(), -msg.getGuessCoin(), championPlayer.getGuessCoin(),
				msg.getType(), championBattle, GameEvent.CHAMPION_GUESS_BATTLE));
	}
	
	@CMD(id = CmdCode._41005)
	public void getChampionBattle(PlayerContext playerContext, GReqGetChampionBattle msg) {
		ChampionBattle championBattle = championService.getOneBattle(msg.getBid());
		
		Asserts.notNull(championBattle, ErrorCode.CHAMPION_NO_BATTLE.getValue(), "没有找到该比赛" + msg.getBid());
		
		String battleId = championBattle.getBattleId();
		Asserts.isTrue(battleId != null && !"".equals(battleId), ErrorCode.CHAMPION_NO_BATTLE.getValue(), "没有找到该比赛" + msg.getBid());
		
		GResGetChampionBattle.Builder builder = GResGetChampionBattle.newBuilder();
		builder.setBattleId(battleId);
		playerContext.write(CmdCode._41005, builder.build());
	}
	
	@CMD(id = CmdCode._41006)
	public void scanChampion32(PlayerContext playerContext, GReqScanChampionKnockout msg) {
		
		ChampionSystem championSystem = championService.getSystem();
		
		GResScanChampionKnockout.Builder builder = GResScanChampionKnockout.newBuilder();
		
		builder.setGuessId(championSystem.getGuessId());
		builder.setBattleRound(championSystem.getBattleRound());
		builder.setNextTime(championSystem.getNextStageTime());
		builder.setStage(championSystem.getStage());
		//这里用下标进行循环，避免正在遍历中修改列表的情况
		for(int i = 0; i < championKnockoutService.getAll32Battle().size(); i++) {
			ChampionBattle battle = championKnockoutService.getAll32Battle().get(i);
			builder.addBattles(serial32Battle(battle));
		}
		playerContext.write(CmdCode._41006, builder.build());
	}
	
	private PSChampionKnockoutBattle serial32Battle(ChampionBattle battle) {
		PSChampionKnockoutBattle.Builder builder = PSChampionKnockoutBattle.newBuilder();
		ChampionCompetitor attacker = championService.getCompetitor(battle.getAtkRid());
		ChampionCompetitor defender = championService.getCompetitor(battle.getDefRid());
		builder.setAtkName(attacker.getName());
		builder.setDefName(defender.getName());
		builder.setBid(battle.getId());
		builder.setBattleRound(battle.getBattleRound());
		builder.setWhichWin(battle.getWhichWin());
		if(battle.getBattleId() != null) {
			builder.setBattleId(battle.getBattleId());
		}
		if(battle.getWhichWin() == 1) {
			builder.setWinHead(attacker.getHeadId());
			builder.setWinBorder(attacker.getBorderId());
		} else if(battle.getWhichWin() == 2) {
			builder.setWinHead(defender.getHeadId());
			builder.setWinBorder(defender.getBorderId());
		}
		builder.setAtkRid(battle.getAtkRid());
		builder.setDefRid(battle.getDefRid());
		return builder.build();
	}
	
	@CMD(id = CmdCode._41007)
	public void championLike(PlayerContext playerContext, GReqChampionLike msg) {
		ChampionCompetitor topCompetitor = null;
		for(ChampionCompetitor competitor : championService.getTopList()) {
			if(competitor.getRid() == msg.getRid()) {
				topCompetitor = competitor;
				break;
			}
		}
		Asserts.notNull(topCompetitor, ErrorCode.CHAMPION_NO_TOP.getValue(), "冠军赛还没有产生冠军选手" + msg.getRid());
		
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		Asserts.isTrue(!championPlayer.getKneels().contains(topCompetitor.getRid()),
				ErrorCode.CHAMPION_KNEEL_TOP.getValue(),
				"你已经膜拜过该选手" + topCompetitor.getRank() + "已膜拜列表" + championPlayer.getKneels());
		
		Asserts.isTrue(championPlayer.getKneels().size() < ChampionConst.MAX_LIKE, ErrorCode.CHAMPION_MAX_LIKE.getValue(),
				"" + championPlayer.getKneels().size());
		
		championPlayer.getKneels().add(topCompetitor.getRid());
		championPlayerService.update(championPlayer);
		
		String kneelLock = "CHAMPION_KNEEL" + topCompetitor.getRid();
		
		if(topCompetitor.getRobot() == 1) {
			synchronized (kneelLock.intern()) {
				ChampionRobot topRobot = championRobotService.getRobot(topCompetitor.getRid());
				topRobot.setLike(topRobot.getLike() + 1);
				championRobotService.updateRobot(topRobot);
			}
		} else {
			synchronized (kneelLock.intern()) {
				ChampionPlayer topPlayer = championPlayerService.getPlayer(topCompetitor.getRid());
				topPlayer.setLike(topPlayer.getLike() + 1);
				championPlayerService.update(topPlayer);
			}
		}
		
		thingService.add(playerContext.getId(), ChampionConst.LIKE_REWARD, GameEvent.CHAMPION_LIKE, NoticeType.TIPS);
		
		GResChampionLike.Builder builder = GResChampionLike.newBuilder();
		builder.setRid(topCompetitor.getRid());
		playerContext.write(CmdCode._41007, builder.build());
	}
	
	@CMD(id = CmdCode._41008)
	public void championBiubiubiu(PlayerContext playerContext, GReqChampionBiubiu msg) {
		
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		Asserts.isTrue(championPlayer.getBiuCd() < TimeDateUtil.getCurrentTimeInt(),
				ErrorCode.CHAMPION_BIU_CD.getValue(), "你发表弹幕信息太快了");
		
		Role role = roleService.getOrThrow(playerContext.getId());
		// 是否被禁言
        Asserts.isTrue(role.getForbidWordsEndTime() < DateTimeUtil.currentSecond(),
                ErrorCode.CHAT_FORBID.getValue(), () -> String.format("ForbidWordsEndTime:%s, current:%s",
                        role.getForbidWordsEndTime(), DateTimeUtil.currentSecond()));
        
        ChampionSystem championSystem = championService.getSystem();
		CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
        
        // 弹幕长度限制
		Asserts.isTrue(StringUtil.getShowLength(msg.getContent()) <= championSeason.getBiu_len(),
				ErrorCode.CHAMPION_BIU_LONG.getValue(), String.format("弹幕信息太长了：字符长度：{%s}，限制长度{%s}",
						StringUtil.getShowLength(msg.getContent()), championSeason.getBiu_len()));
		
		boolean canSendOther = sensitiveWordService.wordCanUseChat(msg.getContent());
		Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());
		
		canSendOther = sensitiveWordService.wordCanUse(msg.getContent(),role);
		Asserts.isTrue(canSendOther, ErrorCode.CHAMPION_BIU_ILLEGAL.getValue(), "弹幕信息含有违规信息：" + msg.getContent());
		
		thingService.cost(playerContext.getId(), ChampionConst.BIU_COST, GameEvent.CHAMPION_BIUBIUBIU);
		
		championPlayer.setBiuCd(TimeDateUtil.getCurrentTimeInt() + championSeason.getBiu_cd());
		championPlayerService.update(championPlayer);
		
		championService.addBiubiubiu(playerContext.getId(), msg.getContent());
		
		GResChampionBiubiu.Builder builder = GResChampionBiubiu.newBuilder();
		builder.setBiuCd(championPlayer.getBiuCd());
		playerContext.write(CmdCode._41008, builder.build());
	}
	
	@CMD(id = CmdCode._41009)
	public void getBiuList(PlayerContext playerContext, GReqChampionBiuList msg) {
		GResChampionBiuList.Builder builder = GResChampionBiuList.newBuilder();
		builder.addAllContent(championService.getBiuQueue());
		playerContext.write(CmdCode._41009, builder.build());
	}
	
	@CMD(id = CmdCode._41011)
	public void getGuessList(PlayerContext playerContext, GReqChampionGuessList msg) {
		ChampionPlayer championPlayer = championPlayerService.getPlayer(playerContext.getId());
		
		ChampionSystem championSystem = championService.getSystem();
		
		GResChampionGuessList.Builder builder = GResChampionGuessList.newBuilder();
		for(ChampionGuess championGuess : championPlayer.getGuessRecords()) {
			builder.addRecord(serialize(championGuess, championSystem));
		}
		playerContext.write(CmdCode._41011, builder.build());
	}
	
	private PSChampionGuess serialize(ChampionGuess guess, ChampionSystem championSystem) {
		ChampionBattle battle = championService.getOneBattle(guess.getBid());
		
		PSChampionGuess.Builder builder = PSChampionGuess.newBuilder();
		builder.setBid(guess.getBid());
		builder.setBattleId(battle.getBattleId() == null ? "" : battle.getBattleId());
		builder.setGuessType(guess.getGuessType());
		builder.setGuessCoin(guess.getGuessCoin());
		builder.setDelta(guess.getDelta());
		builder.setAttacker(serialFormation(battle.getAtkRid(), battle.getAtkFight(), battle.getAtkVo()));
		builder.setDefender(serialFormation(battle.getDefRid(), battle.getDefFight(), battle.getDefVo()));
		builder.setPeriod(battle.getPeriod());
		builder.setBattleRound(battle.getBattleRound());
		if(championSystem.getBattleRound() == battle.getBattleRound() && championSystem.getGuessId() == battle.getId()) {
			//当前正在战斗阶段，则当前正在战斗的比赛“显示”为下注中
			builder.setWhichWin(0);
		} else {
			builder.setWhichWin(battle.getWhichWin());
		}
		if(battle.getBattleLog() != null) {
			try {
				builder.setBattleLog(BattleLog.parseFrom(battle.getBattleLog().getBytes(VideoConst.ISO)));
			} catch (Exception e) {
				log.error("冠军赛战斗" + battle.getId() + "无法转化战报");
			}
		}
		return builder.build();
	}
	
	
	@CMD(id = CmdCode._41013)
	public void getBattleList(PlayerContext playerContext, GReqScanMyChampionBattle msg) {
		
		List<ChampionBattle> myBattleList = new ArrayList<>();
		for(ChampionBattle championBattle : championService.getAllBattleMap().values()) {
			if(championBattle.getAtkRid() == playerContext.getId() || championBattle.getDefRid() == playerContext.getId()) {
				myBattleList.add(championBattle);
			}
		}
		Collections.sort(myBattleList, ChampionTemplate.BATTLE_SORTER);
		
		GResScanMyChampionBattle.Builder builder = GResScanMyChampionBattle.newBuilder();
		for(ChampionBattle battle : myBattleList) {
			PSChampionBattle.Builder model = PSChampionBattle.newBuilder();
			model.setBid(battle.getId());
			model.setBattleId(battle.getBattleId());
			model.setAddPoint(battle.getAddPoint());
			model.setAttacker(serialFormation(battle.getAtkRid(), battle.getAtkFight(), battle.getAtkVo()));
			model.setDefender(serialFormation(battle.getDefRid(), battle.getDefFight(), battle.getDefVo()));
			model.setWhichWin(battle.getWhichWin());
			model.setPeriod(battle.getPeriod());
			model.setBattleRound(battle.getBattleRound());
			if(battle.getBattleLog() != null) {
				try {
					model.setBattleLog(BattleLog.parseFrom(battle.getBattleLog().getBytes(VideoConst.ISO)));
				} catch (Exception e) {
					log.error("冠军赛战斗" + battle.getId() + "无法转化战报");
				}
			}
			builder.addBattles(model.build());
		}
		playerContext.write(CmdCode._41013, builder.build());
	}
	
	@CMD(id = CmdCode._41015)
	public void scanChampionRank(PlayerContext playerContext, GReqChampionRank msg) {
		List<ChampionCompetitor> topList = championService.getTopList();
		GResChampionRank.Builder builder = GResChampionRank.newBuilder();
		for(ChampionCompetitor competitor : topList) {
			builder.addRanks(serialChampionRank(competitor));
		}
		playerContext.write(CmdCode._41015, builder.build());
	}
	
	private PSChampionRanker serialChampionRank(ChampionCompetitor competitor) {
		PSChampionRanker.Builder builder = PSChampionRanker.newBuilder();
		builder.setRid(competitor.getRid());
		builder.setRobot(competitor.getRobot());
		if(competitor.getRobot() == 1) {
			ChampionRobot robot = championRobotService.getRobot(competitor.getRid());
			builder.setLike(robot.getLike());
		} else {
			ChampionPlayer championPlayer = championPlayerService.getPlayer(competitor.getRid());
			builder.setLike(championPlayer.getLike());
		}
		builder.setName(competitor.getName());
		builder.setRank(competitor.getRank());
		builder.setLevel(competitor.getLevel());
		builder.setHeadId(competitor.getHeadId());
		builder.setBorderId(competitor.getBorderId());
		builder.setPoint(competitor.getPoint());
		builder.setFighting(competitor.getFighting());
		return builder.build();
	}
	
	@CMD(id = CmdCode._41017)
	public void getChampionLastTop(PlayerContext playerContext, GReqChampionShowTop msg) {
		ChampionSystem championSystem = championService.getSystem();
		
		ChampionPlayer player = championPlayerService.getPlayer(playerContext.getId());
		if(player.getShowRound() < championSystem.getRound() - 1) {
			player.setShowRound(championSystem.getRound() - 1);
			championPlayerService.update(player);
		}
		
		GResChampionShowTop.Builder builder = GResChampionShowTop.newBuilder();
		builder.setTime(championSystem.getLastStartTime());
		
		List<ChampionCompetitor> topList = championService.getTopList();
		//只需要发送前3名
		for(int i = 0; i < 3 && i < topList.size(); i++) {
			ChampionCompetitor competitor = topList.get(i);
			builder.addRanks(serialChampionRank(competitor));
		}
		
		playerContext.write(CmdCode._41017, builder.build());
	}
	
	@CMD(id = CmdCode._41018)
	public void markShowMyResult(PlayerContext playerContext, GReqChampionShowMyResult msg) {
		ChampionPlayer player = championPlayerService.getPlayer(playerContext.getId());
		if(player.getShowResult() == 0) {
			player.setShowResult(1);
			championPlayerService.update(player);
		}
		playerContext.write(CmdCode._41018, GResChampionShowMyResult.getDefaultInstance());
	}
	
	
	@CMD(id = CmdCode._41020)
	public void saveChampionFormation(PlayerContext playerContext, GReqChampionSaveFormation msg) {
		ChampionCompetitor competitor = championService.getCompetitor(playerContext.getId());
		if(competitor == null) {
			log.warn("玩家" + playerContext.getId() + "不是这个赛季的参赛者");
			playerContext.write(CmdCode._41020, GResChampionSaveFormation.getDefaultInstance());
			return;
		}
		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CHAMPION);
		if(heroLineUp.getFormationMap().isEmpty()) {
			log.warn("玩家" + playerContext.getId() + "的冠军赛阵容布阵为空");
			playerContext.write(CmdCode._41020, GResChampionSaveFormation.getDefaultInstance());
			return;
		}
		BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.CHAMPION, playerContext.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        
        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);
		
		competitor.setBattlerVo(battlerVo);
		competitor.setFighting(fighting);
		championCompetitorService.update(competitor);
		
		ChampionSystem championSystem = championService.getSystem();
		ChampionBattle championBattle = championService.getMyBattle(playerContext.getId());
		if(championBattle != null && championSystem.getStage() == ChampionStage.PREPARE.getValue()) {
			if(championBattle.getAtkRid() == playerContext.getId()) {
				championBattle.setAtkVo(battlerVo);
				championBattle.setAtkFight(fighting);
			} else if(championBattle.getDefRid() == playerContext.getId()) {
				championBattle.setDefVo(battlerVo);
				championBattle.setDefFight(fighting);
			}
			championBattleService.updateBattle(championBattle);
		}
		playerContext.write(CmdCode._41020, GResChampionSaveFormation.getDefaultInstance());
		
		if(championBattle != null) {
			//给在线所有人推送
			contextManager.writeAll(CmdCode._41021, GResChampionFormationChange.getDefaultInstance());
		}
	}
}
