/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service.period;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache.ChampionNextSeason;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionReward;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.champion.ChampionResult;
import com.ayjs.mxzg.config.struct.champion.ChampionTop;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.champion.event.ChampionEndEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionEnd;
import com.ayjs.mxzg.template.constant.GameConstant;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 * 淘汰赛逻辑
 */
@Slf4j
@Service
public class ChampionKnockoutService extends ChampionPeriodService {
	
	@Autowired
	private ChampionRewardSysCache championRewardSysCache;
	@Autowired
	private MailService mailService;
	
	private List<ChampionCompetitor> knockoutList;
	
	//所有的32强战斗，这是一个有序的列表，按32强比赛、16强比赛、8强比赛这样排列
	private List<ChampionBattle> all32Battle = new ArrayList<>();
	
	@Override
	protected ChampionPeriod getPeriod() {
		return ChampionPeriod.KNOCKOUT;
	}

	@Override
	protected boolean isPeriodEnd(ChampionSystem championSystem) {
		//2强之后表示结束
		return championSystem.getBattleRound() < 2;
	}

	@Override
	protected void settlePeriod(ChampionSystem championSystem) {
		log.info("第{}届冠军赛已经结束", championSystem.getRound());
		
		try {
			for(ChampionCompetitor competitor : championService.getCompetitorMap().values()) {
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
				championSystem.getTopPlayers().put(championTop.getRank(), championTop);
			}
			int currRound = championSystem.getRound();
			sumPlayerChampionEnd();
			//发放奖励，必须在championSystem.setRound(championSystem.getRound() + 1);之前执行
			sendRewards(currRound);
		} finally {
			championSystem.setRound(championSystem.getRound() + 1);
			championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
			//设置下一赛季的时间
			ChampionNextSeason nextSeason = championService.getNextTime();
			championService.resetChampionTime(championSystem, nextSeason);
			
			//抛出冠军赛结束事件
			eventBus.post(ChampionEndEvent.of(championService.getCompetitorMap().values()));
			//推送冠军赛结束后
			contextManager.writeAll(CmdCode._41016, GResChampionEnd.getDefaultInstance());
		}
		log.info("下一届，第{}届冠军赛将于{}开始", championSystem.getRound(), TimeDateUtil.time2String(championSystem.getStartTime() * 1000l));
	}
	
	private void sendRewards(int currRound) {
		log.info("发放冠军赛参赛者排名奖励");
		List<Mail> mailList = new ArrayList<>();
		for(ChampionCompetitor competitor : championService.getCompetitorMap().values()) {
			if(competitor.getRobot() == 1) {
				continue;
			}
			CChampionReward cChampionReward = championRewardSysCache.getByRank(competitor.getRank());
			if(cChampionReward == null) {
				continue;
			}
			//邮件类型、参数
			Mail mail = mailService.newMailNoTitle(competitor.getRid(), MailScene.CHAMPION_RANK,
					MailParams.build(competitor.getRank()), cChampionReward.getRank_reward(), GameEvent.CHAMPION_RANK);
			mailList.add(mail);
		}
		mailService.insertMails(mailList);
		log.info("发放冠军赛竞猜参与玩家奖励");
		//将竞猜币换算成公会奖励
		
		//这是从数据库中查出来的数据，相对于缓存来说是脏数据，查出来只是为了获得玩家ID
		List<ChampionPlayer> dirtyPlayerList = championPlayerService.getByRound(currRound);
		
		List<Mail> coinMailList = new ArrayList<>();
		for(ChampionPlayer dirtyPlayer : dirtyPlayerList) {
			ChampionPlayer player = championPlayerService.getPlayer(dirtyPlayer.getRid());
			if(player.getGuessCoin() <= 0) {
				continue;
			}
			long rewardNum = (long)(player.getGuessCoin() * ChampionConst.GUESS_REWARD_RATE * 1.0f / GameConstant.WAN);
			ImmutableThing reward = ImmutableThing.of(ChampionConst.GUESS_REWARD_TYPE, rewardNum);
			
			Mail mail = mailService.newMailNoTitle(player.getRid(), MailScene.CHAMPION_COIN,
					MailParams.build(player.getGuessCoin(), rewardNum), Collections.singletonList(reward), GameEvent.CHAMPION_COIN);
			coinMailList.add(mail);
		}
		mailService.insertMails(coinMailList);
	}

	/**
	 * 统计整届比赛各个参赛者的比赛场数与胜利场数
	 */
	private void sumPlayerChampionEnd() {
		Map<Long, ChampionBattle> allBattles = championService.getAllBattleMap();
		Map<Long, ChampionResult> playerBattleMap = ChampionTemplate.sumBattleNum(allBattles.values());
		
		List<ChampionPlayer> updatePlayers = new ArrayList<>();
		for(ChampionCompetitor competitor : championService.getCompetitorMap().values()) {
			if(competitor.getRobot() == 1) {
				continue;
			}
			ChampionPlayer player = championPlayerService.getPlayer(competitor.getRid());
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
	
	@Override
	protected CChampionRound getRoundConfig(int battleRound) {
		return championRoundSysCache.getKnockoutRound(battleRound);
	}

	@Override
	protected void handleBattleMatch(ChampionSystem championSystem) {
		List<ChampionBattle> battleList = new ArrayList<>();
		
		int knockoutSort = 0;
		for(int i = 0; i < knockoutList.size() / 2; i++) {
			knockoutSort ++;
			ChampionCompetitor atk = knockoutList.get(i * 2 + 0);
			ChampionCompetitor def = knockoutList.get(i * 2 + 1);
			
			ChampionBattle battle = championBattleService.createKnockoutBattle(championSystem, atk, def, knockoutSort);
			battleList.add(battle);
		}
		championBattleService.insertBattles(battleList);
		championService.setRunningBattle(battleList);
		all32Battle.addAll(battleList);
		championService.addAllBattling(battleList);
	}

	@Override
	protected void handleAfterBattle(CChampionRound cChampionRound, List<ChampionCompetitor> winnerList) {
		Collections.sort(winnerList, Comparator.comparingInt(ChampionCompetitor::getKnockoutIndex));
		knockoutList = winnerList;
	}

	@Override
	protected void initMatchGroup() {
		List<ChampionCompetitor> resultRank32 = ChampionTemplate
				.initKnockoutGroup(championService.getCompetitorMap().values(), ChampionConst.GROUP_COUNT);
		championCompetitorService.updateList(resultRank32);
		knockoutList = resultRank32;
	}

	@Override
	protected void setNextBattleRound(ChampionSystem championSystem) {
		//战斗轮数加1
		championSystem.setBattleRound(championSystem.getBattleRound() / 2);
		
		for(ChampionCompetitor competitor : knockoutList) {
			if(competitor.getRobot() == 1) {
				log.info("机器人{}入围淘汰赛{}强", competitor.getRid(), championSystem.getBattleRound());
			} else {
				log.info("玩家{}入围淘汰赛{}强", competitor.getRid(), championSystem.getBattleRound());
			}
		}
	}

	@Override
	protected void handleCompetitorWin(ChampionBattle battle, ChampionCompetitor winner, BattleResult battleResult) {
		winner.setKnockoutWin(winner.getKnockoutWin() + 1);
		
		if(battleResult != null) {
			eventBus.post(VideoRecordEvent.of(VideoType.CHAMPION, battle.getBattleRound(), battleResult.getReport(), ""));
		}
	}

	public List<ChampionBattle> getAll32Battle() {
		return all32Battle;
	}
	
	public void sort32Battle(ChampionSystem championSystem, List<ChampionBattle> list) {
		List<ChampionBattle> battle32 = new ArrayList<>();
		for(ChampionBattle battle : list) {
			if(battle.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
				battle32.add(battle);
			}
		}
		//对32强战斗进行排序
		Collections.sort(battle32, ChampionTemplate.KNOCKOUT_SORTER);
		all32Battle.addAll(battle32);
		
		if(championSystem.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
			//处理淘汰赛列表
			if(championSystem.getStage() == ChampionStage.BATTLE.getValue()) {
				List<ChampionCompetitor> currCompetitors = new ArrayList<>();
				for(ChampionBattle battle : battle32) {
					//当前轮
					if(battle.getBattleRound() != championSystem.getBattleRound()) {
						continue;
					}
					if(battle.getWhichWin() == 1) {
						ChampionCompetitor atk = championService.getCompetitor(battle.getAtkRid());
						currCompetitors.add(atk);
						
					} else if(battle.getWhichWin() == 2) {
						ChampionCompetitor def = championService.getCompetitor(battle.getDefRid());
						currCompetitors.add(def);
					} else {
						//其它情况表示还没有战斗结束
					}
				}
				Collections.sort(currCompetitors, Comparator.comparingInt(ChampionCompetitor::getKnockoutIndex));
				this.knockoutList = currCompetitors;
			} else if(championSystem.getStage() == ChampionStage.MATCH.getValue()) {
				List<ChampionCompetitor> currCompetitors = new ArrayList<>();
				for(ChampionBattle battle : battle32) {
					//上一轮
					if(battle.getBattleRound() != championSystem.getBattleRound() * 2) {
						continue;
					}
					if(battle.getWhichWin() == 1) {
						ChampionCompetitor atk = championService.getCompetitor(battle.getAtkRid());
						currCompetitors.add(atk);
						
					} else if(battle.getWhichWin() == 2) {
						ChampionCompetitor def = championService.getCompetitor(battle.getDefRid());
						currCompetitors.add(def);
					} else {
						//其它情况表示还没有战斗结束
					}
				}
				Collections.sort(currCompetitors, Comparator.comparingInt(ChampionCompetitor::getKnockoutIndex));
				this.knockoutList = currCompetitors;
			}
		}
	}
}
