/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.period;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondRoundSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondSeasonSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.constant.PinnaclePeriod;
import com.ayjs.mxzg.config.excel.constant.PinnacleStage;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondRound;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleResult;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleTop;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.*;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.*;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleCoinResult;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleGroup;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleRankResult;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleTopData;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleGuessWinner;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleEnd;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleGuessWin;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleSaveBattle;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.module.pinnacle.IPinnacleCompetitor;
import com.ayjs.mxzg.module.pinnacle.PinnacleTemplate;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;


@Slf4j
@Service
public class PinnaclePeriodService {

	@Autowired
	protected TopMatchSecondRoundSysCache pinnacleRoundSysCache;
	@Autowired
	protected PinnacleCrossService pinnacleService;
	@Autowired
	protected PinnacleCrossBattleService pinnacleBattleService;
	@Autowired
	protected BattleTemplate battleTemplate;
	@Autowired
	protected CommandBus commandBus;
	@Autowired
	protected PinnacleCrossCompetitorService pinnacleCompetitorService;
	@Autowired
	protected TopMatchSecondSeasonSysCache pinnacleSeasonSysCache;
	@Autowired
	protected PinnacleCrossPlayerService pinnaclePlayerService;
	@Autowired
	protected PinnacleTemplate pinnacleTemplate;
	@Autowired
	protected ServerGroupService serverGroupService;
	@Autowired
	protected MessageHelper messageHelper;
	@Autowired
	protected OpponentDao opponentDao;
	@Autowired
	private PinnacleCrossResultService pinnacleCrossResultService;


	private Map<Integer, List<PinnacleCrossCompetitor>> crossKnockoutMap = new ConcurrentHashMap<>();

	//所有的32强战斗，这是一个有序的列表，按32强比赛、16强比赛、8强比赛这样排列
	private Map<Integer, List<PinnacleCrossBattle>> crossAll32Battle = new ConcurrentHashMap<>();

	/**
	 * 阶段标志
	 * 
	 * @return
	 */
	public PinnaclePeriod getPeriod(){
		return PinnaclePeriod.KNOCKOUT;
	}

	/**
	 * 当前阶段是否结束
	 * 
	 * @return
	 */
	public boolean isPeriodEnd(PinnacleCrossSystem pinnacleSystem){
		//2强之后表示结束
		return pinnacleSystem.getBattleRound() < 2;
	}

	/**
	 * 结算当前阶段
	 * 
	 * @param pinnacleSystem
	 */
	public void settlePeriod(PinnacleCrossSystem pinnacleSystem){
		log.info("第{}届冠军赛已经结束", pinnacleSystem.getRound());

		List<PinnacleCrossResult> resultList = null;

		try {
			for(Entry<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> entry : pinnacleCompetitorService.getCompetitorMap().entrySet()) {

				int crossGroupId = entry.getKey();

				PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(crossGroupId);
				if(pinnacleGroup == null){
					continue;
				}

				for(PinnacleCrossCompetitor competitor : entry.getValue().values()) {
					if(competitor.getRank() > 3) {
						//只保存前三名信息
						continue;
					}
					PinnacleTop pinnacleTop = new PinnacleTop();
					pinnacleTop.setRid(competitor.getRid());
					HeroVo firstHero = null;
					for(HeroVo heroVo : competitor.getBattlerVo().getHeros()) {
						if(firstHero == null) {
							firstHero = heroVo;
						} else {
							if(heroVo.getPos() < firstHero.getPos()) {
								firstHero = heroVo;
							}
						}
					}
					pinnacleTop.setHeroStar(firstHero.getHero_star());
					pinnacleTop.setHeroType(firstHero.getHero_type());
					pinnacleTop.setRank(competitor.getRank());
					pinnacleTop.setRobot(competitor.getRobot());

					pinnacleGroup.getTopPlayers().put(pinnacleTop.getRank(), pinnacleTop);
				}
			}
			int currRound = pinnacleSystem.getRound();
			sumPlayerPinnacleEnd();
			//奖励列表
			resultList = countPinnacleResult(currRound);
		} finally {
			pinnacleSystem.setRound(pinnacleSystem.getRound() + 1);
			pinnacleSystem.setPeriod(PinnaclePeriod.IDLE.getValue());
			pinnacleSystem.setOpening(false);
		}
		if(resultList != null) {
			//发放奖励
			tellPinnacleEndAndRewards(resultList);
		}
		log.info("下一届，第{}届冠军赛将于{}开始", pinnacleSystem.getRound(), TimeDateUtil.time2String(pinnacleSystem.getStartTime() * 1000l));
	}

	/**
	 * 结算奖励
	 * @param currRound
	 * @return
	 */
	private List<PinnacleCrossResult> countPinnacleResult(int currRound) {

		List<PinnacleCrossResult> crossResultList = new ArrayList<>();

		try {
			//这是从数据库中查出来的数据，相对于缓存来说是脏数据，查出来只是为了获得玩家ID
			List<PinnacleCrossPlayer> dirtyPlayerList = pinnaclePlayerService.getByRound(currRound);
			List<PinnacleCoinResult> coinResult = new ArrayList<>();
			for(PinnacleCrossPlayer dirtyPlayer : dirtyPlayerList) {
				Opponent role = opponentDao.get(dirtyPlayer.getRid());
				if(role == null) {
					continue;
				}
				PinnacleCrossPlayer player = pinnaclePlayerService.getPlayer(dirtyPlayer.getRid());
				if(player.getGuessCoin() <= 0) {
					continue;
				}
				PinnacleCoinResult result = new PinnacleCoinResult();
				result.setRid(player.getRid());
				result.setCoinNum(player.getGuessCoin());
				result.setServerId(role.getServerId());
				coinResult.add(result);
			}
			//按服务器分组的竞猜币奖励集合
			Map<Integer, List<PinnacleCoinResult>> serverCoinMap = ListMapUtil.fillListMap(coinResult, PinnacleCoinResult::getServerId);

			for(Entry<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> entry : pinnacleCompetitorService.getCompetitorMap().entrySet()) {
				int crossGroupId = entry.getKey();
				List<PinnacleCrossCompetitor> topRanks = new ArrayList<>();

				List<PinnacleRankResult> rankResult = new ArrayList<>();

				for(PinnacleCrossCompetitor competitor : entry.getValue().values()) {
					if(competitor.getRank() <= 3) {
						topRanks.add(competitor);
					}
					if(competitor.getRobot() == 1) {
						continue;
					}
					Opponent role = opponentDao.get(competitor.getRid());
					if(role == null) {
						continue;
					}
					PinnacleRankResult result = new PinnacleRankResult();
					result.setRid(competitor.getRid());
					result.setRank(competitor.getRank());
					result.setServerId(role.getServerId());
					rankResult.add(result);
				}
				//按服务器分组的排名奖励集合
				Map<Integer, List<PinnacleRankResult>> serverRankMap = ListMapUtil.fillListMap(rankResult, PinnacleRankResult::getServerId);

				CrossGroup crossGroup = serverGroupService.getCrossServerGroup().getGroupByGroupId(crossGroupId);
				for(Integer serverId : crossGroup.getServerIds()) {
					PinnacleCrossResult pinnacleResult = new PinnacleCrossResult();
					pinnacleResult.setServerId(serverId);
					pinnacleResult.setRound(currRound);
					pinnacleResult.setStatus(0);
					pinnacleResult.setTops(new ArrayList<>());
					for(PinnacleCrossCompetitor competitor : topRanks) {
						PinnacleTopData topData = new PinnacleTopData();
						topData.setRid(competitor.getRid());
						topData.setRank(competitor.getRank());
						topData.setRobot(competitor.getRobot());
						pinnacleResult.getTops().add(topData);
					}
					pinnacleResult.setRankResults(new HashMap<>());
					List<PinnacleRankResult> ranks = serverRankMap.get(serverId);
					if(ranks != null) {
						for(PinnacleRankResult rank : ranks) {
							pinnacleResult.getRankResults().put(rank.getRid(), rank.getRank());
						}
					}
					pinnacleResult.setCoinResults(new HashMap<>());
					List<PinnacleCoinResult> coins = serverCoinMap.get(serverId);
					if(coins != null) {
						for(PinnacleCoinResult coin : coins) {
							pinnacleResult.getCoinResults().put(coin.getRid(), coin.getCoinNum());
						}
					}
					crossResultList.add(pinnacleResult);
				}
			}
		} catch (Exception e) {
			log.error("生成冠军赛结算奖励中发生异常", e);
		}

		if(!crossResultList.isEmpty()) {
			pinnacleCrossResultService.insertResult(crossResultList);
		}
		log.info("已生成冠军赛结算奖励数据");
		return crossResultList;
	}

	/**
	 * 获取阶段配置
	 * 
	 * @param battleRound
	 * @return
	 */
	public CTopMatchSecondRound getRoundConfig(int battleRound){
		return pinnacleRoundSysCache.getCrossKnockoutRound(battleRound);
	}

	/**
	 * 处理战斗匹配
	 * 
	 * @param pinnacleSystem
	 */
	public void handleBattleMatch(PinnacleCrossSystem pinnacleSystem){
		List<PinnacleCrossBattle> battleList = new ArrayList<>();

		for(Entry<Integer, List<PinnacleCrossCompetitor>> entry : crossKnockoutMap.entrySet()) {
			List<PinnacleCrossBattle> battle32 = new ArrayList<>();
			int crossGroupId = entry.getKey();
			List<PinnacleCrossCompetitor> knockoutList = entry.getValue();
			int knockoutSort = 0;
			for(int i = 0; i < knockoutList.size() / 2; i++) {
				knockoutSort ++;
				IPinnacleCompetitor atk = knockoutList.get(i * 2 + 0);
				IPinnacleCompetitor def = knockoutList.get(i * 2 + 1);

				PinnacleCrossBattle battle = pinnacleBattleService.createKnockoutBattle(pinnacleSystem, atk, def, knockoutSort);
				battle32.add(battle);
			}

			List<PinnacleCrossBattle> rank32Battle = crossAll32Battle.get(crossGroupId);
			if(rank32Battle == null) {
				rank32Battle = new ArrayList<>();
				crossAll32Battle.put(crossGroupId, rank32Battle);
			}
			rank32Battle.addAll(battle32);
			battleList.addAll(battle32);
		}
		pinnacleBattleService.setRunningBattle(battleList);
	}

	/**
	 * 处理战斗
	 * 
	 * @param cTopMatchSecondRound
	 */
	private void handleBattle(CTopMatchSecondRound cTopMatchSecondRound) {
		log.info("处理战斗开始");
		List<PinnacleCrossCompetitor> winnerList = runBattle(cTopMatchSecondRound);
		handleAfterBattle(cTopMatchSecondRound, winnerList);
		// 进行一次统一的排名，冠军赛有唯一的排名触发点，只需要在战斗后进行一次排序就可以
		pinnacleCompetitorService.sortCompetitor();
		log.info("处理战斗结束");
	}

	protected void handleAfterBattle(CTopMatchSecondRound cTopMatchSecondRound, List<PinnacleCrossCompetitor> winnerList) {
		Map<Integer, List<PinnacleCrossCompetitor>> crossMap = ListMapUtil.fillListMap(winnerList, PinnacleCrossCompetitor::getCrossGroup);
		for(Entry<Integer, List<PinnacleCrossCompetitor>> entry : crossMap.entrySet()) {
			Collections.sort(entry.getValue(), Comparator.comparingInt(IPinnacleCompetitor::getKnockoutIndex));
			crossKnockoutMap.put(entry.getKey(), entry.getValue());
		}
	}

	/**
	 * 初始化比赛分组
	 */
	public void initMatchGroup(){
		for (Entry<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> crossEntry : pinnacleCompetitorService.getCompetitorMap().entrySet()) {
			List<PinnacleCrossCompetitor> resultRank32 = PinnacleTemplate.initKnockoutGroup(crossEntry.getValue().values(), PinnacleConst.CROSS_GROUP_COUNT);
			if(!CollectionUtils.isEmpty(resultRank32)){
				pinnacleCompetitorService.updateList(resultRank32);
				crossKnockoutMap.put(crossEntry.getKey(), resultRank32);
			}
		}
	}

	/**
	 * 下阶段
	 * @param pinnacleSystem
	 */
	public void setNextBattleRound(PinnacleCrossSystem pinnacleSystem){
		//战斗轮数加1
		pinnacleSystem.setBattleRound(pinnacleSystem.getBattleRound() / 2);

		for(Entry<Integer, List<PinnacleCrossCompetitor>> entry : crossKnockoutMap.entrySet()) {
			int crossGroupId = entry.getKey();
			for(PinnacleCrossCompetitor competitor : entry.getValue()) {
				if(competitor.getRobot() == 1) {
					log.info("跨服分组{}机器人{}入围淘汰赛{}强", crossGroupId, competitor.getRid(), pinnacleSystem.getBattleRound());
				} else {
					log.info("跨服分组{}玩家{}入围淘汰赛{}强", crossGroupId, competitor.getRid(), pinnacleSystem.getBattleRound());
				}
			}
		}
	}

	public void handleStage(PinnacleCrossSystem pinnacleSystem) {
		if (isPeriodEnd(pinnacleSystem)) {
			settlePeriod(pinnacleSystem);
		} else {
			int nowTime = TimeDateUtil.getCurrentTimeInt();
			CTopMatchSecondRound cConfig = getRoundConfig(pinnacleSystem.getBattleRound());
			if (pinnacleSystem.getStage() == PinnacleStage.MATCH.getValue()) {
				// 进入准备阶段
				this.sendLastRoundGuessReward(pinnacleSystem);
				// 对玩家进行战斗匹配
				this.handleBattleMatch(pinnacleSystem);

				pinnacleSystem.setStage(PinnacleStage.PREPARE.getValue());
				pinnacleSystem.setNextStageTime(nowTime + cConfig.getPrepare_time());

				logInPeriod(pinnacleSystem);

				pinnacleService.tellStageChange();

			} else if (pinnacleSystem.getStage() == PinnacleStage.PREPARE.getValue()) {
				// 进入竞猜阶段
				// 选择一场战力差距最小的战斗
				this.handleGuessBattle(pinnacleSystem);

				pinnacleSystem.setStage(PinnacleStage.GUESS.getValue());
				pinnacleSystem.setNextStageTime(nowTime + cConfig.getGuess_time());

				logInPeriod(pinnacleSystem);

				pinnacleService.tellStageChange();

			} else if (pinnacleSystem.getStage() == PinnacleStage.GUESS.getValue()) {
				// 进入观战阶段

				// 进行战斗
				this.handleBattle(cConfig);

				pinnacleSystem.setStage(PinnacleStage.BATTLE.getValue());
				pinnacleSystem.setNextStageTime(nowTime + cConfig.getBattle_time());

				logInPeriod(pinnacleSystem);

				pinnacleService.tellStageChange();

			} else if (pinnacleSystem.getStage() == PinnacleStage.BATTLE.getValue()) {

				// 进行竞猜结算后再进行下一轮的数据设置
				handleGuessBattleReward(pinnacleSystem);

				// 进入匹配阶段
				pinnacleSystem.setStage(PinnacleStage.MATCH.getValue());

				setNextBattleRound(pinnacleSystem);

				logInPeriod(pinnacleSystem);


				// 不用推送阶段变化
			}
		}
	}

	/**
	 * 统计整届比赛各个参赛者的比赛场数与胜利场数
	 */
	private void sumPlayerPinnacleEnd() {

		Map<Integer, List<PinnacleCrossBattle>> crossAllBattle = ListMapUtil.fillListMap(
				new ArrayList<>(pinnacleBattleService.getAllBattleMap().values()),
				PinnacleCrossBattle::getCrossGroupId);

		for(Entry<Integer, List<PinnacleCrossBattle>> entry : crossAllBattle.entrySet()) {

			Map<Long, PinnacleResult> playerBattleMap = PinnacleTemplate.sumBattleNum(entry.getValue());

			List<PinnacleCrossPlayer> updatePlayers = new ArrayList<>();
			for(PinnacleCrossCompetitor competitor : pinnacleCompetitorService.getCrossGroupCompetitor(entry.getKey()).values()) {
				if(competitor.getRobot() == 1) {
					continue;
				}
				PinnacleCrossPlayer player = pinnaclePlayerService.getPlayer(competitor.getRid());
				PinnacleResult result = playerBattleMap.get(player.getRid());
				result.setRank(competitor.getRank());
				//记录参赛者最新一期的结果
				player.setResult(result);
				player.setShowResult(0);
				if(player.getHisRank() == 0 || competitor.getRank() < player.getHisRank()) {
					player.setHisRank(competitor.getRank());
				}
				updatePlayers.add(player);
			}
			pinnaclePlayerService.update(updatePlayers);
		}
	}

	/**
	 * 通知冠军赛已经结束并发放奖励
	 * @param resultList
	 */
	private void tellPinnacleEndAndRewards(List<PinnacleCrossResult> resultList) {
		log.info("发放巅峰赛参赛者排名奖励");
		for(PinnacleCrossResult result : resultList) {
			try {
				ResPinnacleEnd build = pinnacleCrossResultService.serialResult(result);
				messageHelper.pushToMessage(build);
			} catch (Exception e) {
			}
		}
	}

	private void logInPeriod(PinnacleCrossSystem pinnacleSystem) {
		log.info("巅峰赛{}第{}轮{}阶段，下一阶段执行时间{}", getPeriod().getNote(), pinnacleSystem.getBattleRound(),
				PinnacleStage.of(pinnacleSystem.getStage()).getDesc(), pinnacleSystem.nextStageTime());
	}

	/**
	 * 选择一场战力差距最小的战斗
	 * 
	 * @param pinnacleSystem
	 */
	private void handleGuessBattle(PinnacleCrossSystem pinnacleSystem) {

		List<PinnacleCrossBattle> runningBattle = pinnacleBattleService.getRunningBattle();

		Map<Integer, List<PinnacleCrossBattle>> crossBattleMap = ListMapUtil.fillListMap(runningBattle,
				PinnacleCrossBattle::getCrossGroupId);

		for (Entry<Integer, List<PinnacleCrossBattle>> entry : crossBattleMap.entrySet()) {
			PinnacleCrossBattle guessBattle = PinnacleTemplate.findGuessBattle(entry.getValue());

			PinnacleGroup pinnacleGroup = pinnacleSystem.getGroupResult().get(entry.getKey());
			if(pinnacleGroup == null){
				continue;
			}
			pinnacleGroup.setLastGuessId(pinnacleGroup.getGuessId());
			pinnacleGroup.setGuessId(guessBattle.getId());
			log.info("巅峰赛分组{}竞猜比赛{}", entry.getKey(), guessBattle.getId());
		}
	}

	/**
	 * 进行战斗
	 * 
	 * @param cTopMatchSecondRound
	 * @return
	 */
	private List<PinnacleCrossCompetitor> runBattle(CTopMatchSecondRound cTopMatchSecondRound) {
		List<PinnacleCrossCompetitor> winnerList = new ArrayList<>();

		List<PinnacleCrossBattle> runningBattle = pinnacleBattleService.getRunningBattle();

		Map<Integer, List<byte[]>> crossBattles = new HashMap<>();

		for (PinnacleCrossBattle battle : runningBattle) {

			PinnacleCrossCompetitor atk = pinnacleCompetitorService.getCompetitor(battle.getAtkRid(),
					battle.getCrossGroupId());
			PinnacleCrossCompetitor def = pinnacleCompetitorService.getCompetitor(battle.getDefRid(),
					battle.getCrossGroupId());

			BattleResult battleResult = pinnacleTemplate.runOneBattle(battle, atk, def);

			PinnacleCrossCompetitor winner = null;
			if (battle.getWhichWin() == 1) {
				winner = atk;
			} else {
				winner = def;
			}

			// 保存战报放到了游戏服
			commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));

			battle.setAddPoint(cTopMatchSecondRound.getWin_point());
			winner.setPoint(winner.getPoint() + cTopMatchSecondRound.getWin_point());
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
		pinnacleBattleService.updateBattles(runningBattle);

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
			CrossGroup crossGroup = serverGroupService.getCrossGroup(entry.getKey());
			if (crossGroup == null) {
				continue;
			}
			for (Integer serverId : crossGroup.getServerIds()) {
				ResPinnacleSaveBattle.ResPinnacleSaveBattleBuilder builder = ResPinnacleSaveBattle.builder();
				builder.serverId(serverId);
				builder.battleReports(entry.getValue());
				ResPinnacleSaveBattle build = builder.build();
				try {
					messageHelper.pushToMessage(build);
				} catch (Exception e) {
					log.error("向分服" + serverId + "发送战报出现异常，数据长度" + ProtostuffUtil.serialize(build).length, e);
				}
			}
		}
	}

	protected void handleCompetitorWin(PinnacleCrossCompetitor winner) {
		winner.setKnockoutWin(winner.getKnockoutWin() + 1);
	}

	/**
	 * 处理竞猜比赛发奖
	 * 
	 * @param pinnacleSystem
	 */
	private void handleGuessBattleReward(PinnacleCrossSystem pinnacleSystem) {
		for (PinnacleGroup pinnacleGroup : pinnacleSystem.getGroupResult().values()) {
			if(pinnacleGroup.getGuessId() == 0){
				continue;
			}
			Set<PinnacleCrossPlayer> updatePlayers = new HashSet<>();
			Map<Long, Long> guessRewardMap = sendThisRoundGuessReward(pinnacleGroup.getGuessId(), updatePlayers);

			if (!updatePlayers.isEmpty()) {
				pinnaclePlayerService.update(new ArrayList<>(updatePlayers));
			}
			// 发送竞猜中奖通知
			if (guessRewardMap != null) {
				tellServerGuessWin(pinnacleSystem, guessRewardMap);
			}
		}
	}
	
	private void tellServerGuessWin(PinnacleCrossSystem pinnacleSystem, Map<Long, Long> guessRewardMap) {
		//<服务器ID，ResPinnacleGuessWin>
		Map<Integer, ResPinnacleGuessWin.ResPinnacleGuessWinBuilder> serverWinners = new HashMap<>();
		
		Map<Integer, List<CSPinnacleGuessWinner>> winnerMap = new HashMap<>();
		
		for(Entry<Long, Long> entry : guessRewardMap.entrySet()) {
			Opponent role = opponentDao.get(entry.getKey());
			if(role == null) {
				continue;
			}
			ResPinnacleGuessWin.ResPinnacleGuessWinBuilder builder = serverWinners.get(role.getServerId());
			if(builder == null) {
				builder = ResPinnacleGuessWin.builder();
				builder.serverId(role.getServerId());
				builder.period(pinnacleSystem.getPeriod());
				builder.battleRound(pinnacleSystem.getBattleRound());
				List<CSPinnacleGuessWinner> guessWinners = new ArrayList<>();
				builder.guessWinners(guessWinners);
				serverWinners.put(role.getServerId(), builder);
				winnerMap.put(role.getServerId(), guessWinners);
			}
			
			List<CSPinnacleGuessWinner> guessWinners = winnerMap.get(role.getServerId());

			CSPinnacleGuessWinner.CSPinnacleGuessWinnerBuilder model = CSPinnacleGuessWinner.builder();
			model.rid(entry.getKey());
			model.gainCoin(entry.getValue());
			guessWinners.add(model.build());
		}
		for(ResPinnacleGuessWin.ResPinnacleGuessWinBuilder builder : serverWinners.values()) {
			ResPinnacleGuessWin build = builder.build();
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
	 * @param guessId
	 * @param updatePlayers
	 */
	private Map<Long, Long> sendThisRoundGuessReward(long guessId, Set<PinnacleCrossPlayer> updatePlayers) {
		// 上一场战斗
		PinnacleCrossBattle battle = pinnacleBattleService.getOneBattle(guessId);
		Map<Long, PinnacleCrossPlayer> joinGuessPlayers = new HashMap<>();
		for (long rid : battle.getGuessPlayers()) {
			PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(rid);
			joinGuessPlayers.put(rid, pinnaclePlayer);
		}
		return pinnacleTemplate.sendGuessBattleReward(battle, updatePlayers, joinGuessPlayers);
	}

	/**
	 * 发放上一场竞猜比赛的额外奖励
	 * 
	 * @param pinnacleSystem
	 */
	private void sendLastRoundGuessReward(PinnacleCrossSystem pinnacleSystem) {
		for (PinnacleGroup groupData : pinnacleSystem.getGroupResult().values()) {
			// 上一场战斗
			log.info("跨服分组{}发放上一场战斗的参与竞猜奖励，上一场比赛ID{}当前比赛ID{}", groupData.getCrossId(), groupData.getLastGuessId(),
					groupData.getGuessId());
			if(groupData.getGuessId() == 0) {
				return;
			}
			// 因为改成在准备阶段发额外奖励，所以战斗是刚刚结束的战斗，即guessId对应的战斗
			PinnacleCrossBattle lastBattle = pinnacleBattleService.getOneBattle(groupData.getGuessId());
			if (lastBattle == null) {
				log.info("发放上一场战斗的参与竞猜奖励找不到战斗数据");
				return;
			}
			CTopMatchSecondSeason pinnacleSeason = pinnacleSeasonSysCache.getCrossSeason();
			List<PinnacleCrossPlayer> updatePlayers = new ArrayList<>();
			for (long rid : lastBattle.getGuessPlayers()) {
				PinnacleCrossPlayer pinnaclePlayer = pinnaclePlayerService.getPlayer(rid);
				// 玩家有参与上一场比赛的竞猜，则再送60竞猜币
				pinnaclePlayer.setGuessCoin(pinnaclePlayer.getGuessCoin() + pinnacleSeason.getGuess_add());
				updatePlayers.add(pinnaclePlayer);
			}
			if (!updatePlayers.isEmpty()) {
				pinnaclePlayerService.update(updatePlayers);
			}
			log.info("发放上一场战斗的参与竞猜奖励");
		}
	}

	public void sort32Battle(PinnacleCrossSystem pinnacleSystem, List<PinnacleCrossBattle> list) {
		Map<Integer, List<PinnacleCrossBattle>> crossBattleMap = ListMapUtil.fillListMap(list, PinnacleCrossBattle::getCrossGroupId);
		for(Entry<Integer, List<PinnacleCrossBattle>> entry : crossBattleMap.entrySet()) {
			int crossGroupId = entry.getKey();
			List<PinnacleCrossBattle> battle32 = new ArrayList<>();
			for(PinnacleCrossBattle battle : entry.getValue()) {
				if(battle.getPeriod() == PinnaclePeriod.KNOCKOUT.getValue()) {
					battle32.add(battle);
				}
			}
			//对32强战斗进行排序
			Collections.sort(battle32, PinnacleTemplate.KNOCKOUT_SORTER);
			crossAll32Battle.put(crossGroupId, battle32);

			if(pinnacleSystem.getPeriod() == PinnaclePeriod.KNOCKOUT.getValue()) {
				//处理淘汰赛列表
				if(pinnacleSystem.getStage() == PinnacleStage.BATTLE.getValue()) {
					List<PinnacleCrossCompetitor> currCompetitors = new ArrayList<>();
					for(PinnacleCrossBattle battle : battle32) {
						//当前轮
						if(battle.getBattleRound() != pinnacleSystem.getBattleRound()) {
							continue;
						}
						if(battle.getWhichWin() == 1) {
							PinnacleCrossCompetitor atk = pinnacleCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
							currCompetitors.add(atk);

						} else if(battle.getWhichWin() == 2) {
							PinnacleCrossCompetitor def = pinnacleCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
							currCompetitors.add(def);
						} else {
							//其它情况表示还没有战斗结束
						}
					}
					Collections.sort(currCompetitors, Comparator.comparingInt(IPinnacleCompetitor::getKnockoutIndex));
					crossKnockoutMap.put(crossGroupId, currCompetitors);

				} else if(pinnacleSystem.getStage() == PinnacleStage.MATCH.getValue()) {
					List<PinnacleCrossCompetitor> currCompetitors = new ArrayList<>();
					for(PinnacleCrossBattle battle : battle32) {
						//上一轮
						if(battle.getBattleRound() != pinnacleSystem.getBattleRound() * 2) {
							continue;
						}
						if(battle.getWhichWin() == 1) {
							PinnacleCrossCompetitor atk = pinnacleCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
							currCompetitors.add(atk);

						} else if(battle.getWhichWin() == 2) {
							PinnacleCrossCompetitor def = pinnacleCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
							currCompetitors.add(def);
						} else {
							//其它情况表示还没有战斗结束
						}
					}
					Collections.sort(currCompetitors, Comparator.comparingInt(IPinnacleCompetitor::getKnockoutIndex));
					crossKnockoutMap.put(crossGroupId, currCompetitors);
				}
			}
		}
	}

	public void restart() {
		this.crossAll32Battle.clear();
	}

	public List<PinnacleCrossBattle> get32Battle(int crossGroup) {
		return crossAll32Battle.get(crossGroup);
	}
}
