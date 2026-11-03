/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service.period;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache.ChampionNextSeason;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.config.struct.champion.ChampionResult;
import com.ayjs.mxzg.config.struct.champion.ChampionTop;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossPlayer;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossResult;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossResultService;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionCoinResult;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionGroup;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionRankResult;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionTopData;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionEnd;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.module.champion.IChampionCompetitor;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 * 淘汰赛逻辑
 */
@Slf4j
@Service
public class ChampionKnockoutService extends ChampionPeriodService {
	
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private ChampionCrossResultService championCrossResultService;
	
	
	
	private Map<Integer, List<ChampionCrossCompetitor>> crossKnockoutMap = new ConcurrentHashMap<>();
	
	//所有的32强战斗，这是一个有序的列表，按32强比赛、16强比赛、8强比赛这样排列
	private Map<Integer, List<ChampionCrossBattle>> crossAll32Battle = new ConcurrentHashMap<>();
	
	@Override
	protected ChampionPeriod getPeriod() {
		return ChampionPeriod.KNOCKOUT;
	}

	@Override
	protected boolean isPeriodEnd(ChampionCrossSystem championSystem) {
		//2强之后表示结束
		return championSystem.getBattleRound() < 2;
	}

	@Override
	protected void settlePeriod(ChampionCrossSystem championSystem) {
		log.info("第{}届冠军赛已经结束", championSystem.getRound());
		
		List<ChampionCrossResult> resultList = null;
		
		try {
			for(Entry<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> entry : championCompetitorService.getCompetitorMap().entrySet()) {
				
				int crossGroupId = entry.getKey();
				
				ChampionGroup championGroup = championSystem.getGroupResult().get(crossGroupId);
				
				for(ChampionCrossCompetitor competitor : entry.getValue().values()) {
					if(competitor.getRank() > 3) {
						//只保存前三名信息
						continue;
					}
					ChampionTop championTop = new ChampionTop();
					championTop.setRid(competitor.getRid());
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
					championTop.setHeroStar(firstHero.getHero_star());
					championTop.setHeroType(firstHero.getHero_type());
					championTop.setRank(competitor.getRank());
					championTop.setRobot(competitor.getRobot());
					
					championGroup.getTopPlayers().put(championTop.getRank(), championTop);
				}
			}
			int currRound = championSystem.getRound();
			sumPlayerChampionEnd();
			//奖励列表
			resultList = countChampionResult(currRound);
		} finally {
			championSystem.setRound(championSystem.getRound() + 1);
			championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
			//设置下一赛季的时间
			ChampionNextSeason nextSeason = championService.getNextTime();
			championService.resetChampionTime(championSystem, nextSeason);
		}
		if(resultList != null) {
			//发放奖励
			tellChampionEndAndRewards(resultList);
		}
		log.info("下一届，第{}届冠军赛将于{}开始", championSystem.getRound(), TimeDateUtil.time2String(championSystem.getStartTime() * 1000l));
	}
	
	/**
	 * 结算奖励
	 * @param currRound
	 * @return
	 */
	private List<ChampionCrossResult> countChampionResult(int currRound) {
		
		List<ChampionCrossResult> crossResultList = new ArrayList<>();
		
		try {
			//这是从数据库中查出来的数据，相对于缓存来说是脏数据，查出来只是为了获得玩家ID
			List<ChampionCrossPlayer> dirtyPlayerList = championPlayerService.getByRound(currRound);
			List<ChampionCoinResult> coinResult = new ArrayList<>();
			for(ChampionCrossPlayer dirtyPlayer : dirtyPlayerList) {
				CrossRole role = crossRoleService.getOrThrow(dirtyPlayer.getRid());
				if(role == null) {
					continue;
				}
				ChampionCrossPlayer player = championPlayerService.getPlayer(dirtyPlayer.getRid());
				if(player.getGuessCoin() <= 0) {
					continue;
				}
				ChampionCoinResult result = new ChampionCoinResult();
				result.setRid(player.getRid());
				result.setCoinNum(player.getGuessCoin());
				result.setServerId(role.getServerId());
				coinResult.add(result);
			}
			//按服务器分组的竞猜币奖励集合
			Map<Integer, List<ChampionCoinResult>> serverCoinMap = ListMapUtil.fillListMap(coinResult, ChampionCoinResult::getServerId);
			
			for(Entry<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> entry : championCompetitorService.getCompetitorMap().entrySet()) {
				int crossGroupId = entry.getKey();
				List<ChampionCrossCompetitor> topRanks = new ArrayList<>();
				
				List<ChampionRankResult> rankResult = new ArrayList<>();
				
				for(ChampionCrossCompetitor competitor : entry.getValue().values()) {
					if(competitor.getRank() <= 3) {
						topRanks.add(competitor);
					}
					if(competitor.getRobot() == 1) {
						continue;
					}
					CrossRole role = crossRoleService.getOrThrow(competitor.getRid());
					if(role == null) {
						continue;
					}
					ChampionRankResult result = new ChampionRankResult();
					result.setRid(competitor.getRid());
					result.setRank(competitor.getRank());
					result.setServerId(role.getServerId());
					rankResult.add(result);
				}
				//按服务器分组的排名奖励集合
				Map<Integer, List<ChampionRankResult>> serverRankMap = ListMapUtil.fillListMap(rankResult, ChampionRankResult::getServerId);

				CrossGroup crossGroup = crossServerGroupService.getCrossServerGroup().getGroupByGroupId(crossGroupId);
				for(Integer serverId : crossGroup.getServerIds()) {
					ChampionCrossResult championResult = new ChampionCrossResult();
					championResult.setServerId(serverId);
					championResult.setRound(currRound);
					championResult.setStatus(0);
					championResult.setTops(new ArrayList<>());
					for(ChampionCrossCompetitor competitor : topRanks) {
						ChampionTopData topData = new ChampionTopData();
						topData.setRid(competitor.getRid());
						topData.setRank(competitor.getRank());
						topData.setRobot(competitor.getRobot());
						championResult.getTops().add(topData);
					}
					championResult.setRankResults(new HashMap<>());
					List<ChampionRankResult> ranks = serverRankMap.get(serverId);
					if(ranks != null) {
						for(ChampionRankResult rank : ranks) {
							championResult.getRankResults().put(rank.getRid(), rank.getRank());
						}
					}
					championResult.setCoinResults(new HashMap<>());
					List<ChampionCoinResult> coins = serverCoinMap.get(serverId);
					if(coins != null) {
						for(ChampionCoinResult coin : coins) {
							championResult.getCoinResults().put(coin.getRid(), coin.getCoinNum());
						}
					}
					crossResultList.add(championResult);
				}
			}
		} catch (Exception e) {
			log.error("生成冠军赛结算奖励中发生异常", e);
		}
		
		if(!crossResultList.isEmpty()) {
			championCrossResultService.insertResult(crossResultList);
		}
		log.info("已生成冠军赛结算奖励数据");
		return crossResultList;
	}
	
	/**
	 * 通知冠军赛已经结束并发放奖励
	 * @param resultList
	 */
	private void tellChampionEndAndRewards(List<ChampionCrossResult> resultList) {
		log.info("发放冠军赛参赛者排名奖励");
		for(ChampionCrossResult result : resultList) {
			try {
				ResChampionEnd build = championCrossResultService.serialResult(result);
				messageHelper.pushToMessage(build);
			} catch (Exception e) {
			}
		}
	}

	/**
	 * 统计整届比赛各个参赛者的比赛场数与胜利场数
	 */
	private void sumPlayerChampionEnd() {
		
		Map<Integer, List<ChampionCrossBattle>> crossAllBattle = ListMapUtil.fillListMap(
				new ArrayList<>(championBattleService.getAllBattleMap().values()),
				ChampionCrossBattle::getCrossGroupId);
		
		for(Entry<Integer, List<ChampionCrossBattle>> entry : crossAllBattle.entrySet()) {
			
			Map<Long, ChampionResult> playerBattleMap = ChampionTemplate.sumBattleNum(entry.getValue());
			
			List<ChampionCrossPlayer> updatePlayers = new ArrayList<>();
			for(ChampionCrossCompetitor competitor : championCompetitorService.getCrossGroupCompetitor(entry.getKey()).values()) {
				if(competitor.getRobot() == 1) {
					continue;
				}
				ChampionCrossPlayer player = championPlayerService.getPlayer(competitor.getRid());
				ChampionResult result = playerBattleMap.get(player.getRid());
				result.setRank(competitor.getRank());
				//记录参赛者最新一期的结果
				player.setResult(result);
				player.setShowResult(0);
				if(player.getHisRank() == 0 || competitor.getRank() < player.getHisRank()) {
					player.setHisRank(competitor.getRank());
				}
				updatePlayers.add(player);
			}
			championPlayerService.update(updatePlayers);
		}
	}
	
	@Override
	protected CChampionRound getRoundConfig(int battleRound) {
		return championRoundSysCache.getCrossKnockoutRound(battleRound);
	}

	@Override
	protected void handleBattleMatch(ChampionCrossSystem championSystem) {
		List<ChampionCrossBattle> battleList = new ArrayList<>();
		
		for(Entry<Integer, List<ChampionCrossCompetitor>> entry : crossKnockoutMap.entrySet()) {
			List<ChampionCrossBattle> battle32 = new ArrayList<>();
			int crossGroupId = entry.getKey();
			List<ChampionCrossCompetitor> knockoutList = entry.getValue();
			int knockoutSort = 0;
			for(int i = 0; i < knockoutList.size() / 2; i++) {
				knockoutSort ++;
				IChampionCompetitor atk = knockoutList.get(i * 2 + 0);
				IChampionCompetitor def = knockoutList.get(i * 2 + 1);
				
				ChampionCrossBattle battle = championBattleService.createKnockoutBattle(championSystem, atk, def, knockoutSort);
				battle32.add(battle);
			}
			
			List<ChampionCrossBattle> rank32Battle = crossAll32Battle.get(crossGroupId);
			if(rank32Battle == null) {
				rank32Battle = new ArrayList<>();
				crossAll32Battle.put(crossGroupId, rank32Battle);
			}
			rank32Battle.addAll(battle32);
			battleList.addAll(battle32);
		}
		championBattleService.setRunningBattle(battleList);
	}

	@Override
	protected void handleAfterBattle(CChampionRound cChampionRound, List<ChampionCrossCompetitor> winnerList) {
		Map<Integer, List<ChampionCrossCompetitor>> crossMap = ListMapUtil.fillListMap(winnerList, ChampionCrossCompetitor::getCrossGroup);
		for(Entry<Integer, List<ChampionCrossCompetitor>> entry : crossMap.entrySet()) {
			Collections.sort(entry.getValue(), Comparator.comparingInt(IChampionCompetitor::getKnockoutIndex));
			crossKnockoutMap.put(entry.getKey(), entry.getValue());
		}
	}

	@Override
	protected void initMatchGroup() {
		for (Entry<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> crossEntry : championCompetitorService
				.getCompetitorMap().entrySet()) {
			
			List<ChampionCrossCompetitor> resultRank32 = ChampionTemplate
					.initKnockoutGroup(crossEntry.getValue().values(), ChampionConst.CROSS_GROUP_COUNT);
			championCompetitorService.updateList(resultRank32);
			
			crossKnockoutMap.put(crossEntry.getKey(), resultRank32);
		}
	}

	@Override
	protected void setNextBattleRound(ChampionCrossSystem championSystem) {
		//战斗轮数加1
		championSystem.setBattleRound(championSystem.getBattleRound() / 2);
		
		for(Entry<Integer, List<ChampionCrossCompetitor>> entry : crossKnockoutMap.entrySet()) {
			int crossGroupId = entry.getKey();
			for(ChampionCrossCompetitor competitor : entry.getValue()) {
				if(competitor.getRobot() == 1) {
					log.info("跨服分组{}机器人{}入围淘汰赛{}强", crossGroupId, competitor.getRid(), championSystem.getBattleRound());
				} else {
					log.info("跨服分组{}玩家{}入围淘汰赛{}强", crossGroupId, competitor.getRid(), championSystem.getBattleRound());
				}
			}
		}
	}

	@Override
	protected void handleCompetitorWin(ChampionCrossCompetitor winner) {
		winner.setKnockoutWin(winner.getKnockoutWin() + 1);
	}

	public void sort32Battle(ChampionCrossSystem championSystem, List<ChampionCrossBattle> list) {
		Map<Integer, List<ChampionCrossBattle>> crossBattleMap = ListMapUtil.fillListMap(list, ChampionCrossBattle::getCrossGroupId);
		for(Entry<Integer, List<ChampionCrossBattle>> entry : crossBattleMap.entrySet()) {
			int crossGroupId = entry.getKey();
			List<ChampionCrossBattle> battle32 = new ArrayList<>();
			for(ChampionCrossBattle battle : entry.getValue()) {
				if(battle.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
					battle32.add(battle);
				}
			}
			//对32强战斗进行排序
			Collections.sort(battle32, ChampionTemplate.KNOCKOUT_SORTER);
			crossAll32Battle.put(crossGroupId, battle32);
			
			if(championSystem.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
				//处理淘汰赛列表
				if(championSystem.getStage() == ChampionStage.BATTLE.getValue()) {
					List<ChampionCrossCompetitor> currCompetitors = new ArrayList<>();
					for(ChampionCrossBattle battle : battle32) {
						//当前轮
						if(battle.getBattleRound() != championSystem.getBattleRound()) {
							continue;
						}
						if(battle.getWhichWin() == 1) {
							ChampionCrossCompetitor atk = championCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
							currCompetitors.add(atk);
							
						} else if(battle.getWhichWin() == 2) {
							ChampionCrossCompetitor def = championCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
							currCompetitors.add(def);
						} else {
							//其它情况表示还没有战斗结束
						}
					}
					Collections.sort(currCompetitors, Comparator.comparingInt(IChampionCompetitor::getKnockoutIndex));
					crossKnockoutMap.put(crossGroupId, currCompetitors);
					
				} else if(championSystem.getStage() == ChampionStage.MATCH.getValue()) {
					List<ChampionCrossCompetitor> currCompetitors = new ArrayList<>();
					for(ChampionCrossBattle battle : battle32) {
						//上一轮
						if(battle.getBattleRound() != championSystem.getBattleRound() * 2) {
							continue;
						}
						if(battle.getWhichWin() == 1) {
							ChampionCrossCompetitor atk = championCompetitorService.getCompetitor(battle.getAtkRid(), battle.getCrossGroupId());
							currCompetitors.add(atk);
							
						} else if(battle.getWhichWin() == 2) {
							ChampionCrossCompetitor def = championCompetitorService.getCompetitor(battle.getDefRid(), battle.getCrossGroupId());
							currCompetitors.add(def);
						} else {
							//其它情况表示还没有战斗结束
						}
					}
					Collections.sort(currCompetitors, Comparator.comparingInt(IChampionCompetitor::getKnockoutIndex));
					crossKnockoutMap.put(crossGroupId, currCompetitors);
				}
			}
		}
	}
	
	public void restart() {
		this.crossAll32Battle.clear();
	}
	
	public List<ChampionCrossBattle> get32Battle(int crossGroup) {
		return crossAll32Battle.get(crossGroup);
	}
}
