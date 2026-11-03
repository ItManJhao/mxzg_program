/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service.period;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionRoundSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionBattleService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionCompetitorService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionPlayerService;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionGuessWin;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

/**
 * @author YY
 *
 */
@Slf4j
public abstract class ChampionPeriodService {

	@Autowired
	protected ChampionRoundSysCache championRoundSysCache;
	@Autowired
	protected ChampionService championService;
	@Autowired
	protected ChampionBattleService championBattleService;
	@Autowired
	protected BattleHelper battleHelper;
	@Autowired
	protected CommandBus commandBus;
	@Autowired
	protected ChampionCompetitorService championCompetitorService;
	@Autowired
	protected ChampionPlayerService championPlayerService;
	@Autowired
	protected ContextManager contextManager;
	@Autowired
	protected ChampionSeasonSysCache championSeasonSysCache;
	@Autowired
	protected ChampionTemplate championTemplate;
	@Autowired
	protected EventBus eventBus;
	
	/**
	 * 阶段标志
	 * @return
	 */
	protected abstract ChampionPeriod getPeriod();
	
	/**
	 * 当前阶段是否结束
	 * @return
	 */
	protected abstract boolean isPeriodEnd(ChampionSystem championSystem);
	
	/**
	 * 结算当前阶段
	 * @param championSystem
	 */
	protected abstract void settlePeriod(ChampionSystem championSystem);
	
	/**
	 * 获取阶段配置
	 * @param battleRound
	 * @return
	 */
	protected abstract CChampionRound getRoundConfig(int battleRound);
	
	/**
	 * 处理战斗匹配
	 * @param championSystem
	 */
	protected abstract void handleBattleMatch(ChampionSystem championSystem);
	
	/**
	 * 处理战斗
	 * @param cChampionRound
	 */
	private void handleBattle(CChampionRound cChampionRound) {
		List<ChampionCompetitor> winnerList = runBattle(cChampionRound);
		handleAfterBattle(cChampionRound, winnerList);
		
		//进行一次统一的排名，冠军赛有唯一的排名触发点，只需要在战斗后进行一次排序就可以
		championService.sortCompetitor();
	}
	
	protected void handleAfterBattle(CChampionRound cChampionRound, List<ChampionCompetitor> winnerList) {
		
	}
	
	/**
	 * 初始化比赛分组
	 */
	protected abstract void initMatchGroup();
	
	protected abstract void setNextBattleRound(ChampionSystem championSystem);
	
	public void handleStage(ChampionSystem championSystem) {
		if(isPeriodEnd(championSystem)) {
			settlePeriod(championSystem);
		} else {
			int nowTime = TimeDateUtil.getCurrentTimeInt();
			CChampionRound cConfig = getRoundConfig(championSystem.getBattleRound());
			if(championSystem.getStage() == ChampionStage.MATCH.getValue()) {
				//进入准备阶段
				this.sendLastRoundGuessReward(championSystem);
				//对玩家进行战斗匹配
				this.handleBattleMatch(championSystem);
				
				championSystem.setStage(ChampionStage.PREPARE.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getPrepare_time());
				
				logInPeriod(championSystem);
				
				championService.tellStageChange();
				
			} else if(championSystem.getStage() == ChampionStage.PREPARE.getValue()) {
				//进入竞猜阶段
				//选择一场战力差距最小的战斗
				this.handleGuessBattle(championSystem);
				
				championSystem.setStage(ChampionStage.GUESS.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getGuess_time());
				
				logInPeriod(championSystem);
				
				championService.tellStageChange();
				
			} else if(championSystem.getStage() == ChampionStage.GUESS.getValue()) {
				//进入观战阶段
				
				//进行战斗
				this.handleBattle(cConfig);
				
				championSystem.setStage(ChampionStage.BATTLE.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getBattle_time());
				
				logInPeriod(championSystem);
				
				championService.tellStageChange();
				
			} else if(championSystem.getStage() == ChampionStage.BATTLE.getValue()) {
				
				//进行竞猜结算后再进行下一轮的数据设置
				handleGuessBattleReward(championSystem);
				
				//进入匹配阶段
				championSystem.setStage(ChampionStage.MATCH.getValue());
				
				setNextBattleRound(championSystem);
				
				logInPeriod(championSystem);
				
				//不用推送阶段变化
			}
		}
	}
	
	private void logInPeriod(ChampionSystem championSystem) {
		log.info("冠军{}第{}轮{}阶段，下一阶段执行时间{}", getPeriod().getNote(), championSystem.getBattleRound(),
				ChampionStage.of(championSystem.getStage()).getDesc(), championSystem.nextStageTime());
	}
	
	/**
	 * 选择一场战力差距最小的战斗
	 * @param championSystem
	 */
	private void handleGuessBattle(ChampionSystem championSystem) {
		ChampionBattle guessBattle = ChampionTemplate.findGuessBattle(championService.getRunningBattle());
		
		championSystem.setLastGuessId(championSystem.getGuessId());
		championSystem.setGuessId(guessBattle.getId());
	}
	
	/**
	 * 进行战斗
	 * @param cChampionRound
	 * @return
	 */
	private List<ChampionCompetitor> runBattle(CChampionRound cChampionRound) {
		List<ChampionCompetitor> winnerList = new ArrayList<>();
		for(ChampionBattle battle : championService.getRunningBattle()) {
			
			ChampionCompetitor atk = championService.getCompetitor(battle.getAtkRid());
			ChampionCompetitor def = championService.getCompetitor(battle.getDefRid());
			
			BattleResult battleResult = championTemplate.runOneBattle(battle, atk, def);
			if(battleResult != null) {
				//保存战报
	            commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));
			}
        	
        	ChampionCompetitor winner = null;
        	if(battle.getWhichWin() == 1) {
        		winner = atk;
        	} else {
        		winner = def;
        	}
			battle.setAddPoint(cChampionRound.getWin_point());
        	winner.setPoint(winner.getPoint() + cChampionRound.getWin_point());
        	handleCompetitorWin(battle, winner, battleResult);
        	winnerList.add(winner);
		}
		championBattleService.updateBattles(championService.getRunningBattle());
		return winnerList;
	}
	
	protected void handleCompetitorWin(ChampionBattle battle, ChampionCompetitor winner, BattleResult battleResult) {}
	
	/**
	 * 处理竞猜比赛发奖
	 * @param championSystem
	 */
	private void handleGuessBattleReward(ChampionSystem championSystem) {
		try {
			Set<ChampionPlayer> updatePlayers = new HashSet<>();
			Map<Long, Long> guessRewardMap = sendThisRoundGuessReward(championSystem, updatePlayers);
			
			if(!updatePlayers.isEmpty()) {
				championPlayerService.update(new ArrayList<>(updatePlayers));
			}
			//发送竞猜中奖通知
			if(guessRewardMap != null) {
				for(Entry<Long, Long> entry : guessRewardMap.entrySet()) {
					GResChampionGuessWin.Builder builder = GResChampionGuessWin.newBuilder();
					builder.setPeriod(championSystem.getPeriod());
					builder.setBattleRound(championSystem.getBattleRound());
					builder.setGainCoin(entry.getValue());
			        contextManager.write(entry.getKey(), CmdCode._41012, builder.build());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 发放当前竞猜比赛的奖励
	 * @param championSystem
	 */
	private Map<Long, Long> sendThisRoundGuessReward(ChampionSystem championSystem, Set<ChampionPlayer> updatePlayers) {
		//上一场战斗
		ChampionBattle battle = championService.getOneBattle(championSystem.getGuessId());
		
		Map<Long, ChampionPlayer> joinGuessPlayers = new HashMap<>();
		for(long rid : battle.getGuessPlayers()) {
			ChampionPlayer championPlayer = championPlayerService.getPlayer(rid);
			joinGuessPlayers.put(rid, championPlayer);
		}
		return championTemplate.sendGuessBattleReward(battle, updatePlayers, joinGuessPlayers);
	}
	/**
	 * 发放上一场竞猜比赛的额外奖励
	 * @param championSystem
	 * @param updatePlayers
	 */
	private void sendLastRoundGuessReward(ChampionSystem championSystem) {
		//上一场战斗
		log.info("发放上一场战斗的参与竞猜奖励，上一场比赛ID" + championSystem.getLastGuessId() + " 当前比赛ID" + championSystem.getGuessId());
		//因为改成在准备阶段发额外奖励，所以战斗是刚刚结束的战斗，即guessId对应的战斗
		ChampionBattle lastBattle = championService.getOneBattle(championSystem.getGuessId());
		if(lastBattle == null) {
			log.info("发放上一场战斗的参与竞猜奖励找不到战斗数据");
			return;
		}
		CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
		List<ChampionPlayer> updatePlayers = new ArrayList<>();
		for(long rid : lastBattle.getGuessPlayers()) {
			ChampionPlayer championPlayer = championPlayerService.getPlayer(rid);
			//玩家有参与上一场比赛的竞猜，则再送60竞猜币
			championPlayer.setGuessCoin(championPlayer.getGuessCoin() + championSeason.getGuess_add());
			updatePlayers.add(championPlayer);
		}
		if(!updatePlayers.isEmpty()) {
			championPlayerService.update(updatePlayers);
		}
		log.info("发放上一场战斗的参与竞猜奖励");
	}
}
