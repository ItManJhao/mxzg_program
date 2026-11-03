/**
 * 
 */
package com.ayjs.mxzg.module.pinnacle;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.constant.PinnaclePeriod;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleGuess;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleResult;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

/**
 * @author YY
 *
 */
@Slf4j
@Component
public class PinnacleTemplate {
	
	@Autowired
	private CommandBus commandBus;
	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private EventBus eventBus;
	

	/**
	 * 初始化选拔赛分组、位置、下标
	 * 
	 * 选拔赛避免一个玩家在六轮的战斗中会遇到同一个玩家的去重处理
	 * 并不是通过记录一个已战斗过玩家列表去实现，如果用这种方式实现，会在最后几个玩家的匹配时有一定概率出现打同一个玩家的情况，导致需要重新匹配
	 * 而采取的实现思路是，把128个玩家分成8个小组（或16个小组）如下，An小组是前64名的乱序分组，Bn小组是后64名的乱序分组
	 * A1    A2    A3    A4
	 * B1    B2    B3    B4
	 * 在前3轮需要让前64名有较好游戏体验的机制要求下，让A1对战B1，A2对战B2，An对战Bn
	 * 在每个组内玩家的对战匹配方式如下，an，bn为玩家代号
	 * a1   a2   a3   a4   ......   a16
	 * b1   b2   b3   b4   ......   b16
	 * 让a1依轮次对战b1、b2、b3，让a2依轮次对战b2、b3、b4，......让a16依轮次对战b16、b1、b2
	 * 反观b1，他也对战了a1、a15、a16三个玩家，因此他也进行了三次战斗
	 * 
	 * 在后3轮的随机匹配要求下，让A1B1重新组成小组AB1，A2B2重新组成小组AB2，AnBn重新组成小组ABn，
	 * 对每个ABn小组进行乱序，并对四个ABn小组进行随机组队，如AB1（记为C1）对战AB4（记为D1），AB2（记为C2）对战AB3（记为D2）
	 * 在每个组内的对战匹配方式如下
	 * c1   c2   c3   c4   ......   c32
	 * d1   d2   d3   d4   ......   d32
	 * 让c1依轮次对战d1、d2、d3，让c2依轮次对战d2、d3、d4，......让c32依轮次对战d32、d1、d2
	 * 通过这种方式实现在六轮的战斗中不会匹配到同一个玩家的处理
	 * 
	 * PS:因为所有分组里面的玩家都是随机组合的，因此不需要顾虑玩家对战随机性的问题
	 * 
	 * @param competitors
	 */
	public static void initTrials(List<? extends IPinnacleCompetitor> competitors) {

		Collections.sort(competitors, Comparator.comparingInt(IPinnacleCompetitor::getOriPoint));
		Collections.reverse(competitors);

		List<IPinnacleCompetitor> before = new ArrayList<>();
		List<IPinnacleCompetitor> after = new ArrayList<>();

		for(int i = 0; i < competitors.size(); i++) {
			if(i < competitors.size() / 2) {
				before.add(competitors.get(i));
			} else {
				after.add(competitors.get(i));
			}
		}
		//将打乱后的前64、后64各分成4组
		Collections.shuffle(before);
		Collections.shuffle(after);

		//分组数量，写死4，即每组16个人
		int groupCount = 4;

		int groupSize = before.size() / groupCount;

		Map<Integer, List<IPinnacleCompetitor>> groupMap = new HashMap<>();

		for(int i = 0; i < groupCount; i++) {

			List<IPinnacleCompetitor> competitorList = new ArrayList<>();
			groupMap.put(i + 1, competitorList);

			for(int j = 0; j < groupSize; j++) {
				IPinnacleCompetitor competitorA = before.get(j + groupSize * i);
				competitorA.setTrialsGroup(i + 1);
				competitorA.setTrialsPos(1);
				competitorA.setTrialsIndex(j + 1);
				competitorList.add(competitorA);

				IPinnacleCompetitor competitorB = after.get(j + groupSize * i);
				competitorB.setTrialsGroup(i + 1);
				competitorB.setTrialsPos(2);
				competitorB.setTrialsIndex(j + 1);
				competitorList.add(competitorB);
			}

			Collections.shuffle(competitorList);

			for(int ii = 0; ii < competitorList.size(); ii++) {
				IPinnacleCompetitor competitor = competitorList.get(ii);
				competitor.setChaosIndex(ii + 1);
			}
		}

		List<Integer> groupsNum = new ArrayList<>(groupMap.keySet());
		Collections.shuffle(groupsNum);

		for(int i = 0; i < groupsNum.size() / 2; i++) {
			int groupA = groupsNum.get(i * 2);
			int groupB = groupsNum.get(i * 2 + 1);

			List<IPinnacleCompetitor> groupAList = groupMap.get(groupA);
			List<IPinnacleCompetitor> groupBList = groupMap.get(groupB);

			for(IPinnacleCompetitor competitor : groupAList) {
				competitor.setChaosGroup(groupB);
			}
			for(IPinnacleCompetitor competitor : groupBList) {
				competitor.setChaosGroup(groupA);
			}
		}
	}


	/**
	 * 冠军赛排名比较器
	 */
	public static Comparator<IPinnacleCompetitor> COMPETITOR_SORTER = new Comparator<IPinnacleCompetitor>() {
		@Override
		public int compare(IPinnacleCompetitor o1, IPinnacleCompetitor o2) {
			if(o1.getKnockoutWin() > o2.getKnockoutWin()) {
				return -1;
			} else if(o1.getKnockoutWin() < o2.getKnockoutWin()) {
				return 1;
			} else {
				if(o1.getPoint() > o2.getPoint()) {
					return -1;
				} else if(o1.getPoint() < o2.getPoint()) {
					return 1;
				} else {
					if(o1.getRid() > o2.getRid()) {
						return 1;
					} else {
						return -1;
					}
				}
			}
		}
	};

	public static Comparator<IPinnacleBattle> KNOCKOUT_SORTER = new Comparator<IPinnacleBattle>() {
		@Override
		public int compare(IPinnacleBattle o1, IPinnacleBattle o2) {
			if(o1.getBattleRound() > o2.getBattleRound()) {
				return -1;
			} else if(o1.getBattleRound() < o2.getBattleRound()) {
				return 1;
			} else {
				if(o1.getKnockoutSort() < o2.getKnockoutSort()) {
					return -1;
				} else {
					return 1;
				}
			}
		}};

	public static Comparator<IPinnacleCompetitor> TRIAL_SORTER = new Comparator<IPinnacleCompetitor>() {
		@Override
		public int compare(IPinnacleCompetitor o1, IPinnacleCompetitor o2) {
			if(o1.getPoint() > o2.getPoint()) {
				return -1;
			} else if(o1.getPoint() < o2.getPoint()) {
				return 1;
			} else {
				if(o1.getRobot() < o2.getRobot()) {
					return -1;
				} else if(o1.getRobot() > o2.getRobot()) {
					return 1;
				} else {
					return 0;
				}
			}
		}
	};

	/**
	 *
	 * @param competitors0
	 * @param groupCount 多少个小组
	 * @return
	 */
	public static <T extends IPinnacleCompetitor> List<T> initKnockoutGroup(Collection<T> competitors0, int groupCount) {
		//每个小组的人数
		int groupSize = PinnacleConst.GROUP_SIZE;
		if(competitors0.size() < groupCount * groupSize){
			return Collections.emptyList();
		}
		List<T> competitors = new ArrayList<>(competitors0);

		Collections.sort(competitors, TRIAL_SORTER);

		//前32或64强
		List<T> rank32 = new ArrayList<>();
		List<T> resultRank32 = new ArrayList<>();
		for(int i = 0; i < groupCount * groupSize; i++) {
			T competitor = competitors.get(i);
			if(competitor.getRobot() == 1) {
				log.info("机器人{}以{}积分入围淘汰赛", competitor.getRid(), competitor.getPoint());
			} else {
				log.info("玩家{}以{}积分入围淘汰赛", competitor.getRid(), competitor.getPoint());
			}
			rank32.add(competitor);
			resultRank32.add(competitor);
		}

		Map<Integer, List<T>> groupMap = new HashMap<>();
		//32强（1到4）64强（1到8）名在不同的组内
		List<Integer> groupNum = new ArrayList<>();
		for(int i = 0; i < groupCount; i++) {
			List<T> list = new ArrayList<>();
			groupMap.put(i + 1, list);
			list.add(rank32.remove(0));
			groupNum.add(i + 1);
		}
		Collections.shuffle(groupNum);
		//32强（5到8）64强（9到16）名在不同的组内
		for(int i = 0; i < groupCount; i++) {
			List<T> list = groupMap.get(groupNum.get(i));
			list.add(rank32.remove(0));
		}
		//32强（9到32）64强（17到64）名随机分配到不同的组内
		Collections.shuffle(rank32);
		for(int i = 0; i < groupCount; i++) {
			List<T> list = groupMap.get(groupNum.get(i));
			while(list.size() < groupSize) {
				list.add(rank32.remove(0));
			}
		}
		//记录淘汰赛分组ID和下标
		for(Entry<Integer, List<T>> entry : groupMap.entrySet()) {
			int groupId = entry.getKey();
			List<T> list = entry.getValue();
			Collections.shuffle(list);
			for(int i = 0; i < list.size(); i++) {
				T competitor = list.get(i);
				competitor.setKnockoutGroup(groupId);
				//对参赛者进行编号，32强（1到32号）64强（1到64号）
				competitor.setKnockoutIndex((groupId - 1) * groupSize + i + 1);
			}
		}
		//根据淘汰赛位置排序
		Collections.sort(resultRank32, Comparator.comparingInt(IPinnacleCompetitor::getKnockoutIndex));
		return resultRank32;
	}

	/**
	 * 统计玩家的战斗场数
	 * @param battles
	 * @return
	 */
	public static Map<Long, PinnacleResult> sumBattleNum(Collection<? extends IPinnacleBattle> battles) {
		Map<Long, PinnacleResult> playerBattleMap = new HashMap<>();

		for(IPinnacleBattle battle : battles) {

			PinnacleResult atkResult = playerBattleMap.get(battle.getAtkRid());
			if(atkResult == null) {
				atkResult = new PinnacleResult();
				playerBattleMap.put(battle.getAtkRid(), atkResult);
			}
			PinnacleResult defResult = playerBattleMap.get(battle.getDefRid());
			if(defResult == null) {
				defResult = new PinnacleResult();
				playerBattleMap.put(battle.getDefRid(), defResult);
			}

			atkResult.setBattleNum(atkResult.getBattleNum() + 1);
			defResult.setBattleNum(defResult.getBattleNum() + 1);

			if(battle.getWhichWin() == 1) {
				atkResult.setWinNum(atkResult.getWinNum() + 1);
			} else if(battle.getWhichWin() == 2) {
				defResult.setWinNum(defResult.getWinNum() + 1);
			}
		}
		return playerBattleMap;
	}

	public <T extends IPinnaclePlayer> Map<Long, Long> sendGuessBattleReward(IPinnacleBattle battle, Set<T> updatePlayers,
																			 Map<Long, T> joinGuessPlayers) {
		long a = battle.getAtkCoin();
		long b = battle.getDefCoin();
		if(a + b <= 0 || battle.getGuessPlayers().isEmpty()) {
			//没有人下注过
			return null;
		}

		float A = PinnacleConst.GUESS_COUNT_FACTER[0];//1.5
		float B = PinnacleConst.GUESS_COUNT_FACTER[1];//0.5
		float C = PinnacleConst.GUESS_COUNT_FACTER[2];//1.0
		float D = PinnacleConst.GUESS_COUNT_FACTER[3];//100.0
		float E = PinnacleConst.GUESS_COUNT_FACTER[4];//100.0
		float F = PinnacleConst.GUESS_COUNT_FACTER[5];//1.51
		float G = PinnacleConst.GUESS_COUNT_FACTER[6];//1.99
		float H = PinnacleConst.GUESS_COUNT_FACTER[7];//3.5

		float rateAtk = Math.round((A + B * (1- (a * C / (a + b)))) * D) / E;
		if(a > 0 && b > 0) {
			rateAtk = Math.max(rateAtk, F);
			rateAtk = Math.min(rateAtk, G);
		}
		float rateDef = H - rateAtk;

		Map<Long, Long> guessRewardMap = new HashMap<>();

		for(long rid : battle.getGuessPlayers()) {
			T guessPlayer = joinGuessPlayers.get(rid);
			long gainCoin = 0;
			if(guessPlayer.getGuessType() == 1 && battle.getWhichWin() == 1) {
				//猜进攻方胜利
				gainCoin = (long)(guessPlayer.getBetCoin() * rateAtk);

			} else if(guessPlayer.getGuessType() == 2 && battle.getWhichWin() == 2) {
				//猜防守方胜利
				gainCoin = (long)(guessPlayer.getBetCoin() * rateDef);
			}
			PinnacleGuess currGuess = null;
			for(PinnacleGuess pinnacleGuess : guessPlayer.getGuessRecords()) {
				if(pinnacleGuess.getBid() == battle.getId()) {
					currGuess = pinnacleGuess;
					break;
				}
			}
			if(gainCoin > 0) {
				guessPlayer.setGuessCoin(guessPlayer.getGuessCoin() + gainCoin);
				guessRewardMap.put(rid, gainCoin);
				if(currGuess != null) {
					//记录变化量
					currGuess.setDelta(gainCoin);
				}
			} else {
				if(currGuess != null) {
					//记录变化量
					currGuess.setDelta(-currGuess.getGuessCoin());
				}
			}
			updatePlayers.add(guessPlayer);

			//竞猜事件
			eventBus.post(PinnacleGuessEvent.of(rid, gainCoin, guessPlayer.getGuessCoin(),
					guessPlayer.getGuessType(), battle, GameEvent.PINNACLE_GUESS_RESULT));
		}
		return guessRewardMap;
	}


	public static <T extends IPinnacleBattle> T findGuessBattle(List<T> runningBattle) {
		T guessBattle = null;
		for(T battle : runningBattle) {
			if(guessBattle == null) {
				guessBattle = battle;
			} else {
				int guessGap = Math.abs(guessBattle.getAtkFight() - guessBattle.getDefFight());
				int currGap = Math.abs(battle.getAtkFight() - battle.getDefFight());
				if(currGap < guessGap) {
					guessBattle = battle;
				}
			}
		}
		return guessBattle;
	}

	public BattleResult runOneBattle(IPinnacleBattle battle, IPinnacleCompetitor atk, IPinnacleCompetitor def) {
		
		BattlerDo attacker = battleTemplate.queryBattler(battle.getAtkVo(), atk.getName(), Faction.ATTACKER, UnitType.HERO);
		attacker.setRoleInfo(atk.getServerId(), atk.getHeadId(), atk.getBorderId(), atk.getLevel(), atk.getFighting());
		
		BattlerDo defender = battleTemplate.queryBattler(battle.getDefVo(), def.getName(), Faction.DEFENDER, UnitType.HERO);
		defender.setRoleInfo(def.getServerId(), def.getHeadId(), def.getBorderId(), def.getLevel(), def.getFighting());
        //进行对战
		try {
			BattleCommand battleCommand = BattleCommand.createOf(BattleType.PINNACLE, attacker, defender);
			commandBus.invoke(battleCommand);
	    	BattleResult battleResult = battleCommand.getResult();
	    	
	    	battle.setBattleId(battleResult.getReport().getBattleId());
			battle.setTime(TimeDateUtil.getCurrentTimeInt());
			
			if(battleResult.isWin()) {
	    		battle.setWhichWin(1);
	    	} else {
	    		battle.setWhichWin(2);
	    	}
			try {
				String battleLog = new String(battleResult.getReport().getLog().toByteArray(), VideoConst.ISO);
				battle.setBattleLog(battleLog);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			return battleResult;
		} catch(Exception e) {
			battle.setBattleId("");
			battle.setTime(0);
			if(atk.getFighting() > def.getFighting()) {
				battle.setWhichWin(1);
			} else {
				battle.setWhichWin(2);
			}
			battle.setBattleLog(null);
			
			StringBuilder atkFormation = new StringBuilder();
			for(HeroVo heroVo : atk.getBattlerVo().getHeros()) {
				atkFormation.append("[").append(heroVo.getHeroId()).append("-").append(heroVo.getName()).append("]");
			}
			StringBuilder defFormation = new StringBuilder();
			for(HeroVo heroVo : def.getBattlerVo().getHeros()) {
				defFormation.append("[").append(heroVo.getHeroId()).append("-").append(heroVo.getName()).append("]");
			}
			log.error("冠军赛第{}届{}赛阶段第{}轮战斗{}发生异常，攻方阵容{}，守方阵容{}", battle.getRound(), battle.getPeriod(), battle.getBattleRound(),
					battle.getId(), atkFormation.toString(), defFormation.toString());
			return null;
		}
	}
	
	public static Comparator<IPinnacleBattle> BATTLE_SORTER = new Comparator<IPinnacleBattle>() {
		@Override
		public int compare(IPinnacleBattle o1, IPinnacleBattle o2) {
			if(o1.getPeriod() > o2.getPeriod()) {
				return -1;
			} else if(o1.getPeriod() < o2.getPeriod()) {
				return 1;
			} else {
				if(o1.getPeriod() == PinnaclePeriod.KNOCKOUT.getValue()) {
					//淘汰赛比赛轮次会越来越小
					if(o1.getBattleRound() > o2.getBattleRound()) {
						return 1;
					} else {
						return -1;
					}
				} else {
					//选拔赛比赛轮次会越来越大
					if(o1.getBattleRound() > o2.getBattleRound()) {
						return -1;
					} else {
						return 1;
					}
				}
			}
		}
	};
}
