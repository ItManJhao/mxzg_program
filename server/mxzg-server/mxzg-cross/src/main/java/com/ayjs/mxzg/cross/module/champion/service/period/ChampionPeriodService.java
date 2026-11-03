/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service.period;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionRoundSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossPlayer;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossBattleService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossCompetitorService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossPlayerService;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossService;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionGroup;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuessWinner;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionGuessWinner.CSChampionGuessWinnerBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessWin;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionGuessWin.ResChampionGuessWinBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveBattle;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionSaveBattle.ResChampionSaveBattleBuilder;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
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
	protected ChampionCrossService championService;
	@Autowired
	protected ChampionCrossBattleService championBattleService;
	@Autowired
	protected BattleTemplate battleTemplate;
	@Autowired
	protected CommandBus commandBus;
	@Autowired
	protected ChampionCrossCompetitorService championCompetitorService;
	@Autowired
	protected ChampionSeasonSysCache championSeasonSysCache;
	@Autowired
	protected ChampionCrossPlayerService championPlayerService;
	@Autowired
	protected ChampionTemplate championTemplate;
	@Autowired
	protected CrossServerGroupService crossServerGroupService;
	@Autowired
	protected MessageHelper messageHelper;
	@Autowired
	protected CrossRoleService crossRoleService;

	/**
	 * 阶段标志
	 * 
	 * @return
	 */
	protected abstract ChampionPeriod getPeriod();

	/**
	 * 当前阶段是否结束
	 * 
	 * @return
	 */
	protected abstract boolean isPeriodEnd(ChampionCrossSystem championSystem);

	/**
	 * 结算当前阶段
	 * 
	 * @param championSystem
	 */
	protected abstract void settlePeriod(ChampionCrossSystem championSystem);

	/**
	 * 获取阶段配置
	 * 
	 * @param battleRound
	 * @return
	 */
	protected abstract CChampionRound getRoundConfig(int battleRound);

	/**
	 * 处理战斗匹配
	 * 
	 * @param championSystem
	 */
	protected abstract void handleBattleMatch(ChampionCrossSystem championSystem);

	/**
	 * 处理战斗
	 * 
	 * @param cChampionRound
	 */
	private void handleBattle(CChampionRound cChampionRound) {
		log.info("处理战斗开始");
		List<ChampionCrossCompetitor> winnerList = runBattle(cChampionRound);
		handleAfterBattle(cChampionRound, winnerList);
		// 进行一次统一的排名，冠军赛有唯一的排名触发点，只需要在战斗后进行一次排序就可以
		championCompetitorService.sortCompetitor();
		log.info("处理战斗结束");
	}

	protected void handleAfterBattle(CChampionRound cChampionRound, List<ChampionCrossCompetitor> winnerList) {

	}

	/**
	 * 初始化比赛分组
	 */
	protected abstract void initMatchGroup();

	protected abstract void setNextBattleRound(ChampionCrossSystem championSystem);

	public void handleStage(ChampionCrossSystem championSystem) {
		if (isPeriodEnd(championSystem)) {
			settlePeriod(championSystem);
		} else {
			int nowTime = TimeDateUtil.getCurrentTimeInt();
			CChampionRound cConfig = getRoundConfig(championSystem.getBattleRound());
			if (championSystem.getStage() == ChampionStage.MATCH.getValue()) {
				// 进入准备阶段
				this.sendLastRoundGuessReward(championSystem);
				// 对玩家进行战斗匹配
				this.handleBattleMatch(championSystem);

				championSystem.setStage(ChampionStage.PREPARE.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getPrepare_time());

				logInPeriod(championSystem);

				championService.tellStageChange();

			} else if (championSystem.getStage() == ChampionStage.PREPARE.getValue()) {
				// 进入竞猜阶段
				// 选择一场战力差距最小的战斗
				this.handleGuessBattle(championSystem);

				championSystem.setStage(ChampionStage.GUESS.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getGuess_time());

				logInPeriod(championSystem);

				championService.tellStageChange();

			} else if (championSystem.getStage() == ChampionStage.GUESS.getValue()) {
				// 进入观战阶段

				// 进行战斗
				this.handleBattle(cConfig);

				championSystem.setStage(ChampionStage.BATTLE.getValue());
				championSystem.setNextStageTime(nowTime + cConfig.getBattle_time());

				logInPeriod(championSystem);

				championService.tellStageChange();

			} else if (championSystem.getStage() == ChampionStage.BATTLE.getValue()) {

				// 进行竞猜结算后再进行下一轮的数据设置
				handleGuessBattleReward(championSystem);

				// 进入匹配阶段
				championSystem.setStage(ChampionStage.MATCH.getValue());

				setNextBattleRound(championSystem);

				logInPeriod(championSystem);

				// 不用推送阶段变化
			}
		}
	}

	private void logInPeriod(ChampionCrossSystem championSystem) {
		log.info("跨服冠军赛{}第{}轮{}阶段，下一阶段执行时间{}", getPeriod().getNote(), championSystem.getBattleRound(),
				ChampionStage.of(championSystem.getStage()).getDesc(), championSystem.nextStageTime());
	}

	/**
	 * 选择一场战力差距最小的战斗
	 * 
	 * @param championSystem
	 */
	private void handleGuessBattle(ChampionCrossSystem championSystem) {

		List<ChampionCrossBattle> runningBattle = championBattleService.getRunningBattle();

		Map<Integer, List<ChampionCrossBattle>> crossBattleMap = ListMapUtil.fillListMap(runningBattle,
				ChampionCrossBattle::getCrossGroupId);

		for (Entry<Integer, List<ChampionCrossBattle>> entry : crossBattleMap.entrySet()) {
			ChampionCrossBattle guessBattle = ChampionTemplate.findGuessBattle(entry.getValue());

			ChampionGroup championGroup = championSystem.getGroupResult().get(entry.getKey());
			championGroup.setLastGuessId(championGroup.getGuessId());
			championGroup.setGuessId(guessBattle.getId());
			log.info("跨服冠军赛分组{}竞猜比赛{}", entry.getKey(), guessBattle.getId());
		}
	}

	/**
	 * 进行战斗
	 * 
	 * @param cChampionRound
	 * @return
	 */
	private List<ChampionCrossCompetitor> runBattle(CChampionRound cChampionRound) {
		List<ChampionCrossCompetitor> winnerList = new ArrayList<>();

		List<ChampionCrossBattle> runningBattle = championBattleService.getRunningBattle();

		Map<Integer, List<byte[]>> crossBattles = new HashMap<>();

		for (ChampionCrossBattle battle : runningBattle) {

			ChampionCrossCompetitor atk = championCompetitorService.getCompetitor(battle.getAtkRid(),
					battle.getCrossGroupId());
			ChampionCrossCompetitor def = championCompetitorService.getCompetitor(battle.getDefRid(),
					battle.getCrossGroupId());

			BattleResult battleResult = championTemplate.runOneBattle(battle, atk, def);

			ChampionCrossCompetitor winner = null;
			if (battle.getWhichWin() == 1) {
				winner = atk;
			} else {
				winner = def;
			}

			// 保存战报放到了游戏服
			commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));

			battle.setAddPoint(cChampionRound.getWin_point());
			winner.setPoint(winner.getPoint() + cChampionRound.getWin_point());
			handleCompetitorWin(winner);
			winnerList.add(winner);

			if(battleResult != null) {
				List<byte[]> crossBattleList = crossBattles.get(battle.getCrossGroupId());
				if (crossBattleList == null) {
					crossBattleList = new ArrayList<>();
					crossBattles.put(battle.getCrossGroupId(), crossBattleList);
				}
				crossBattleList.add(battleResult.getReport().toByteArray());
			}
		}
		championBattleService.updateBattles(runningBattle);

		// 通知游戏服进行战报保存
		tellGameServerToSaveBattles(crossBattles);

		return winnerList;
	}

	/**
	 * 通知游戏服进行战报保存
	 * 
	 * @param crossBattles
	 */
	private void tellGameServerToSaveBattles(Map<Integer, List<byte[]>> crossBattles) {
		for (Entry<Integer, List<byte[]>> entry : crossBattles.entrySet()) {
			CrossGroup crossGroup = crossServerGroupService.getCrossServerGroup().getGroupByGroupId(entry.getKey());
			if (crossGroup == null) {
				continue;
			}
			for (Integer serverId : crossGroup.getServerIds()) {
				ResChampionSaveBattleBuilder builder = ResChampionSaveBattle.builder();
				builder.serverId(serverId);
				builder.battleReports(entry.getValue());
				ResChampionSaveBattle build = builder.build();
				try {
					messageHelper.pushToMessage(build);
//					log.info("战报数据长度" + ProtostuffUtil.serialize(build).length);
				} catch (Exception e) {
					log.error("向分服" + serverId + "发送战报出现异常，数据长度" + ProtostuffUtil.serialize(build).length, e);
				}
			}
		}
	}

	protected void handleCompetitorWin(ChampionCrossCompetitor winner) {
		//留给子类重写
	}

	/**
	 * 处理竞猜比赛发奖
	 * 
	 * @param championSystem
	 */
	private void handleGuessBattleReward(ChampionCrossSystem championSystem) {
		for (ChampionGroup championGroup : championSystem.getGroupResult().values()) {
			Set<ChampionCrossPlayer> updatePlayers = new HashSet<>();
			Map<Long, Long> guessRewardMap = sendThisRoundGuessReward(championGroup.getGuessId(), updatePlayers);

			if (!updatePlayers.isEmpty()) {
				championPlayerService.update(new ArrayList<>(updatePlayers));
			}
			// 发送竞猜中奖通知
			if (guessRewardMap != null) {
				tellServerGuessWin(championSystem, guessRewardMap);
			}
		}
	}
	
	private void tellServerGuessWin(ChampionCrossSystem championSystem, Map<Long, Long> guessRewardMap) {
		//<服务器ID，ResChampionGuessWin>
		Map<Integer, ResChampionGuessWinBuilder> serverWinners = new HashMap<>();
		
		Map<Integer, List<CSChampionGuessWinner>> winnerMap = new HashMap<>();
		
		for(Entry<Long, Long> entry : guessRewardMap.entrySet()) {
			CrossRole role = crossRoleService.getOrThrow(entry.getKey());
			if(role == null) {
				continue;
			}
			ResChampionGuessWinBuilder builder = serverWinners.get(role.getServerId());
			if(builder == null) {
				builder = ResChampionGuessWin.builder();
				builder.serverId(role.getServerId());
				builder.period(championSystem.getPeriod());
				builder.battleRound(championSystem.getBattleRound());
				List<CSChampionGuessWinner> guessWinners = new ArrayList<>();
				builder.guessWinners(guessWinners);
				serverWinners.put(role.getServerId(), builder);
				winnerMap.put(role.getServerId(), guessWinners);
			}
			
			List<CSChampionGuessWinner> guessWinners = winnerMap.get(role.getServerId());
			
			CSChampionGuessWinnerBuilder model = CSChampionGuessWinner.builder();
			model.rid(entry.getKey());
			model.gainCoin(entry.getValue());
			guessWinners.add(model.build());
		}
		for(ResChampionGuessWinBuilder builder : serverWinners.values()) {
			ResChampionGuessWin build = builder.build();
			try {
				messageHelper.pushToMessage(build);
			} catch (Exception e) {
				log.error("向分服" + build.getServerId() + "发送竞猜中奖出现异常", e);
			}
		}
	}

	/**
	 * 发放当前竞猜比赛的奖励
	 * 
	 * @param championSystem
	 */
	private Map<Long, Long> sendThisRoundGuessReward(long guessId, Set<ChampionCrossPlayer> updatePlayers) {
		// 上一场战斗
		ChampionCrossBattle battle = championBattleService.getOneBattle(guessId);
		Map<Long, ChampionCrossPlayer> joinGuessPlayers = new HashMap<>();
        if (Objects.nonNull(battle) && Objects.nonNull(battle.getGuessPlayers())) {
            for (long rid : battle.getGuessPlayers()) {
                ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(rid);
                joinGuessPlayers.put(rid, championPlayer);
            }
		}
		return championTemplate.sendGuessBattleReward(battle, updatePlayers, joinGuessPlayers);
	}

	/**
	 * 发放上一场竞猜比赛的额外奖励
	 * 
	 * @param championSystem
	 * @param updatePlayers
	 */
	private void sendLastRoundGuessReward(ChampionCrossSystem championSystem) {
		for (ChampionGroup groupData : championSystem.getGroupResult().values()) {
			// 上一场战斗
			log.info("跨服分组{}发放上一场战斗的参与竞猜奖励，上一场比赛ID{}当前比赛ID{}", groupData.getCrossId(), groupData.getLastGuessId(),
					groupData.getGuessId());
			if(groupData.getGuessId() == 0) {
				return;
			}
			// 因为改成在准备阶段发额外奖励，所以战斗是刚刚结束的战斗，即guessId对应的战斗
			ChampionCrossBattle lastBattle = championBattleService.getOneBattle(groupData.getGuessId());
			if (lastBattle == null) {
				log.info("发放上一场战斗的参与竞猜奖励找不到战斗数据");
				return;
			}
			CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
			List<ChampionCrossPlayer> updatePlayers = new ArrayList<>();
			for (long rid : lastBattle.getGuessPlayers()) {
				ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(rid);
				// 玩家有参与上一场比赛的竞猜，则再送60竞猜币
				championPlayer.setGuessCoin(championPlayer.getGuessCoin() + championSeason.getGuess_add());
				updatePlayers.add(championPlayer);
			}
			if (!updatePlayers.isEmpty()) {
				championPlayerService.update(updatePlayers);
			}
			log.info("发放上一场战斗的参与竞猜奖励");
		}
	}
}
