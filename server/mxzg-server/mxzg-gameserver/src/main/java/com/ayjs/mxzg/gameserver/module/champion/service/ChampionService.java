/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache.ChampionNextSeason;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionSystemDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.champion.service.period.ChampionKnockoutService;
import com.ayjs.mxzg.gameserver.module.champion.service.period.ChampionTrialsService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.event.ServerOpenTimeResetEvent;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionBiuChange;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionStageChange;
import com.ayjs.mxzg.protocol.ChampionGMsg.PSChampionBiu;

import cn.hutool.core.collection.CollectionUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class ChampionService implements Lifecycle {

	@Autowired
	private ChampionSystemDao championSystemDao;
	@Autowired
	private ChampionCompetitorService championCompetitorService;
	@Autowired
	private ChampionTrialsService championTrialsService;
	@Autowired
	private ChampionKnockoutService championKnockoutService;
	@Autowired
	private ChampionBattleService championBattleService;
	@Autowired
	private ChampionSeasonSysCache championSeasonSysCache;
	@Autowired
	private ServerParamService serverParamService;
	@Autowired
	private ContextManager contextManager;
	
	/**
	 * 是否正在进行GM调试
	 */
	private volatile boolean isRunningGm = false;
	/**
	 * 本届冠军赛的参赛玩家
	 */
	private Map<Long, ChampionCompetitor> competitorMap = new ConcurrentHashMap<>();
	/**
	 * 正在进行的比赛列表
	 */
	private List<ChampionBattle> runningBattle;
	/**
	 * 本届所有比赛的缓存
	 */
	private Map<Long, ChampionBattle> allBattleMap = new ConcurrentHashMap<>();
	/**
	 * 弹幕队列
	 */
	private Queue<PSChampionBiu> biuQueue = new ConcurrentLinkedQueue<>();
	/**
	 * 排行榜
	 */
	private List<ChampionCompetitor> topList;
	
	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._5, "ChampionService");
	}
	
	public ChampionSystem getSystem() {
		ChampionSystem championSystem = null;
		List<ChampionSystem> systemList = championSystemDao.listAll();
		if(systemList.isEmpty()) {
			championSystem = new ChampionSystem();
			championSystem.setRound(1);
			championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
			championSystem.setBattleRound(1);
			//创建数据时以默认的开服时间来创建
			ChampionNextSeason nextSeason = getNextTime();
			this.resetChampionTime(championSystem, nextSeason);
			
			championSystem.setTopPlayers(new ConcurrentHashMap<>());
			championSystemDao.add(championSystem);
		} else {
			championSystem = systemList.get(0);
		}
		return championSystem;
	}
	
	public void runForChampion() {
		ChampionSystem championSystem = getSystem();
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(nowTime < championSystem.getStartTime() || championSystem.getStartTime() == 0) {
			return;
		}
		if(nowTime < championSystem.getNextStageTime()) {
			return;
		}
		if(isRunningGm) {
			return;
		}
		transformStage(championSystem);
	}
	
	private void transformStage(ChampionSystem championSystem) {
		if(championSystem.getPeriod() == ChampionPeriod.IDLE.getValue()) {
			log.info("第{}届冠军赛开始", championSystem.getRound());
			
			championKnockoutService.getAll32Battle().clear();
			competitorMap.clear();
			allBattleMap.clear();
			//进行玩家选中
			List<ChampionCompetitor> competitors = championCompetitorService.initCompetitor(championSystem);
			log.info("冠军赛入选人数" + competitors.size());
			for(ChampionCompetitor competitor : competitors) {
				competitorMap.put(competitor.getRid(), competitor);
			}
			
			//进入选拔赛阶段
			championSystem.setPeriod(ChampionPeriod.TRIALS.getValue());
			championSystem.setBattleRound(1);
			
			//初始化选拔赛分组
			championTrialsService.initMatchGroup();
			
			championSystem.setNextStageTime(championSystem.getStartTime());
			
			log.info("冠军赛进入选拔赛阶段，下一阶段执行时间{}", championSystem.nextStageTime());
			tellStageChange();
			
			//清空弹幕
			biuQueue.clear();
		} else if(championSystem.getPeriod() == ChampionPeriod.TRIALS.getValue()) {
			championTrialsService.handleStage(championSystem);
		} else if(championSystem.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
			championKnockoutService.handleStage(championSystem);
		}
		championSystemDao.update(championSystem);
	}
	
	public void tellStageChange() {
		contextManager.writeAll(CmdCode._41014, GResChampionStageChange.getDefaultInstance());
	}

	public List<ChampionBattle> getRunningBattle() {
		return runningBattle;
	}

	public void setRunningBattle(List<ChampionBattle> runningBattle) {
		this.runningBattle = runningBattle;
	}
	
	public void addAllBattling(List<ChampionBattle> runningBattle) {
		for(ChampionBattle battle : runningBattle) {
			allBattleMap.put(battle.getId(), battle);
		}
	}

	public Map<Long, ChampionCompetitor> getCompetitorMap() {
		return competitorMap;
	}
	
	public ChampionCompetitor getCompetitor(long rid) {
		return competitorMap.get(rid);
	}
	
	public synchronized void gmTransformStage() {
		isRunningGm = true;
		ChampionSystem championSystem = getSystem();
		transformStage(championSystem);
	}

	@Override
	public void start() throws Exception {
		ChampionSystem championSystem = getSystem();
		
		//加载本届冠军赛的参赛者
		List<ChampionCompetitor> competitors = championCompetitorService.getByRound(championSystem.getRound());
		try {
			if (CollectionUtil.isEmpty(competitors)) {
				competitors = championCompetitorService.getByRound(championSystem.getRound() - 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		for(ChampionCompetitor competitor : competitors) {
			competitorMap.put(competitor.getRid(), competitor);
		}
		this.sortCompetitor();
		
		if(competitors.size() != ChampionConst.TRIALS_PLAYER && championSystem.getPeriod() != ChampionPeriod.IDLE.getValue()) {
			//检查
			championSystem.setRound(championSystem.getRound() + 1);
			championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
			
			ChampionNextSeason nextSeason = getNextTime();
			this.resetChampionTime(championSystem, nextSeason);
			championSystemDao.update(championSystem);
			
			log.info("冠军赛起服检测发现参数人数不符，将进行新一轮的冠军赛，届数{}", championSystem.getRound());
			
		} else if(championSystem.getPeriod() == ChampionPeriod.TRIALS.getValue() || championSystem.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
			//初始化选拔赛分组
			championTrialsService.initMatchGroup();
			
			List<ChampionBattle> battleList = championBattleService.getByRound(championSystem.getRound());
			
			List<ChampionBattle> runningList = new ArrayList<>();
			for(ChampionBattle championBattle : battleList) {
				if (championBattle.getPeriod() == championSystem.getPeriod()
						&& championBattle.getBattleRound() == championSystem.getBattleRound()) {
					runningList.add(championBattle);
				}
			}
			this.setRunningBattle(runningList);
			this.addAllBattling(battleList);
			//添加回所有本届打过或进行中的32强比赛数据
			championKnockoutService.sort32Battle(championSystem, battleList);
			
			log.info("冠军赛第{}届开服恢复，当前进程{}，比赛进行到的轮数{}，{}阶段，下一次任务时间{}", championSystem.getRound(),
					championSystem.getPeriod(), championSystem.getBattleRound(),
					ChampionStage.of(championSystem.getStage()).getDesc(), championSystem.nextStageTime());
		}
	}
	
	/**
	 * 获取玩家当前的排名
	 * @param rid
	 * @return
	 */
	public int getRoleRank(long rid) {
		ChampionCompetitor competitor = competitorMap.get(rid);
		if(competitor == null) {
			return 0;
		}
		return competitor.getRank();
	}
	
	/**
	 * 获取玩家当前正在进行的战斗
	 */
	public ChampionBattle getMyBattle(long rid) {
		if(runningBattle == null) {
			return null;
		}
		for(ChampionBattle battle : runningBattle) {
			if(battle.getAtkRid() == rid || battle.getDefRid() == rid) {
				return battle;
			}
		}
		return null;
	}
	
	public ChampionBattle getOneBattle(long bid) {
		return allBattleMap.get(bid);
	}
	
	/**
	 * 是否竞猜阶段
	 * @return
	 */
	public boolean isGuessStage() {
		ChampionSystem championSystem = getSystem();
		if (championSystem.getStage() == ChampionStage.GUESS.getValue()
				&& TimeDateUtil.getCurrentTimeInt() < championSystem.getNextStageTime()) {
			return true;
		}
		return false;
	}
	
	/**
	 * 添加弹幕信息
	 * @param content
	 */
	public void addBiubiubiu(long rid, String content) {
		PSChampionBiu.Builder builder = PSChampionBiu.newBuilder();
		builder.setRid(rid);
		builder.setContent(content);
		biuQueue.add(builder.build());
		
		ChampionSystem championSystem = getSystem();
		CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
		while(biuQueue.size() > championSeason.getBiu_count()) {
			biuQueue.poll();
		}
		//推送弹幕
		GResChampionBiuChange.Builder res = GResChampionBiuChange.newBuilder();
		res.setContent(builder.build());
		contextManager.writeAll(CmdCode._41010, res.build());
	}

	@Subscribe
	private void listen(ServerOpenTimeResetEvent event) {
		this.isRunningGm = true;
		
		ChampionSystem championSystem = getSystem();
		//检查
		championSystem.setRound(championSystem.getRound() + 1);
		championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		
		int weeks = (nowTime - event.getServerTime()) / TimeDateUtil.ONEWEEKINT;
		int seasonStartTime = event.getServerTime() + weeks * TimeDateUtil.ONEWEEKINT;
		
		ChampionNextSeason nextSeason = championSeasonSysCache.getNextStartTime(seasonStartTime);
		//设置下一赛季的时间
		resetChampionTime(championSystem, nextSeason);
		championSystemDao.update(championSystem);
		
		log.info("冠军赛监听开服时间变化，将进行新一轮的冠军赛，届数{}，比赛开始时间{}", championSystem.getRound(),
				TimeDateUtil.time2String(championSystem.getStartTime() * 1000l));
	
		this.isRunningGm = false;
	}
	
	public static void main(String[] args) {
		System.out.println( -1 / 10);
	}
	
	public ChampionNextSeason getNextTime() {
		int serverTime = serverParamService.getServerStartTime();
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int weeks = (nowTime - serverTime) / TimeDateUtil.ONEWEEKINT;
		//开服N天后开启的处理
		int seasonStartTime = serverTime + weeks * TimeDateUtil.ONEWEEKINT + ChampionConst.OPEN_DAY * TimeDateUtil.ONEDAYINT;
		return championSeasonSysCache.getNextStartTime(seasonStartTime);
	}
	
	/**
	 * 重设新赛季的时间属性
	 * @param championSystem
	 * @param nextSeason
	 */
	public void resetChampionTime(ChampionSystem championSystem, ChampionNextSeason nextSeason) {
		championSystem.setLastStartTime(championSystem.getStartTime());
		championSystem.setRoundStartTime(nextSeason.getNextStartTime());
		championSystem.setStartTime(championSystem.getRoundStartTime() + nextSeason.getSeasonConfig().getStart_time());
		championSystem.setRoundEndTime(championSystem.getRoundStartTime()
				+ nextSeason.getSeasonConfig().getLast_day() * TimeDateUtil.ONEDAYINT - 1);
		championSystem.setConfigId(nextSeason.getSeasonConfig().getIdx());
	}

	public Queue<PSChampionBiu> getBiuQueue() {
		return biuQueue;
	}

	public Map<Long, ChampionBattle> getAllBattleMap() {
		return allBattleMap;
	}
	
	/**
	 * 排序比赛者
	 */
	public void sortCompetitor() {
		List<ChampionCompetitor> allCompetitor = new ArrayList<>(this.getCompetitorMap().values());
		Collections.sort(allCompetitor, ChampionTemplate.COMPETITOR_SORTER);
		for(int i = 0; i < allCompetitor.size(); i++) {
			ChampionCompetitor competitor = allCompetitor.get(i);
			competitor.setRank(i + 1);
		}
		championCompetitorService.updateList(allCompetitor);
		this.topList = allCompetitor;
	}

	public List<ChampionCompetitor> getTopList() {
		return topList;
	}
	
	public void cleanBiu() {
		biuQueue.clear();
	}
}
