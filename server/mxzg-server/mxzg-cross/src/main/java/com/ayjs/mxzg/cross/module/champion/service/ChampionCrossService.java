/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ConcurrentMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache.ChampionNextSeason;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.constant.ChampionStage;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossSystemDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.cross.module.champion.service.period.ChampionKnockoutService;
import com.ayjs.mxzg.cross.module.champion.service.period.ChampionTrialsService;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionGroup;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionBiu.CSChampionBiuBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionBiuChange.ResChampionBiuChangeBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionStageChange;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionStageChange.ResChampionStageChangeBuilder;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ChampionCrossService implements Lifecycle {
	
	@Autowired
	private ChampionCrossSystemDao championSystemDao;
	@Autowired
	private ChampionKnockoutService championKnockoutService;
	@Autowired
	private ChampionCrossCompetitorService championCompetitorService;
	@Autowired
	private ChampionCrossBattleService championBattleService;
	@Autowired
	private ChampionTrialsService championTrialsService;
	@Autowired
	private ChampionSeasonSysCache championSeasonSysCache;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private CrossServerGroupService crossServerGroupService;
	@Autowired
	private MessageHelper messageHelper;
	
	private boolean isRunningGm = false;
	
	/**
	 * 弹幕队列
	 */
	private Map<Integer, ConcurrentLinkedQueue<CSChampionBiu>> crossBiuMap = new ConcurrentHashMap<>();
	
	public ChampionCrossSystem getSystem() {
		ChampionCrossSystem championSystem = null;
		List<ChampionCrossSystem> systemList = championSystemDao.listAll();
		if(systemList.isEmpty()) {
			championSystem = new ChampionCrossSystem();
			championSystem.setRound(1);
			championSystem.setPeriod(ChampionPeriod.IDLE.getValue());
			championSystem.setBattleRound(1);
			//创建数据时以默认的开服时间来创建
			ChampionNextSeason nextSeason = getNextTime();
			this.resetChampionTime(championSystem, nextSeason);
			
			championSystem.setGroupResult(new ConcurrentHashMap<>());
			championSystemDao.add(championSystem);
		} else {
			championSystem = systemList.get(0);
		}
		return championSystem;
	}
	
	public void tellStageChange() {
		//通知游戏服阶段变化
		ResChampionStageChangeBuilder builder = ResChampionStageChange.builder();
		messageHelper.pushToAll(builder.build());
	}
	
	public ChampionNextSeason getNextTime() {
		return championSeasonSysCache.getCrossNextStartTime();
	}
	
	/**
	 * 重设新赛季的时间属性
	 * @param championSystem
	 * @param nextSeason
	 */
	public void resetChampionTime(ChampionCrossSystem championSystem, ChampionNextSeason nextSeason) {
		championSystem.setLastStartTime(championSystem.getStartTime());
		championSystem.setRoundStartTime(nextSeason.getNextStartTime());
		championSystem.setStartTime(championSystem.getRoundStartTime() + nextSeason.getSeasonConfig().getStart_time());
		//赛季结束时间为周六23:59:59
		championSystem.setRoundEndTime(nextSeason.getNextStartTime() + TimeDateUtil.ONEWEEKINT - 1);
		championSystem.setConfigId(nextSeason.getSeasonConfig().getIdx());
	}
	
	public void runForChampion() {
		ChampionCrossSystem championSystem = getSystem();
		
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
	
	private void transformStage(ChampionCrossSystem championSystem) {
		if(championSystem.getPeriod() == ChampionPeriod.IDLE.getValue()) {
			log.info("第{}届冠军赛开始", championSystem.getRound());
			
			championKnockoutService.restart();
			championCompetitorService.restart();
			championBattleService.restart();
			
			//进行玩家选中
			championCompetitorService.initCompetitor(championSystem);
			
			//进入选拔赛阶段
			championSystem.setPeriod(ChampionPeriod.TRIALS.getValue());
			championSystem.setBattleRound(1);
			
			//把无用的跨服分组数据清理掉
			ConcurrentMap<Integer, ChampionGroup> groupMap = new ConcurrentHashMap<>();
			championSystem.getGroupResult().forEach((crossGroupId, group) -> groupMap.put(group.getCrossId(), group));
			championSystem.getGroupResult().clear();
			
			for(Integer crossGroupId : championCompetitorService.getCrossGroups()) {
				ChampionGroup championGroup = groupMap.get(crossGroupId);
				if(championGroup == null) {
					championGroup = new ChampionGroup();
					championGroup.setCrossId(crossGroupId);
					championGroup.setTopPlayers(new ConcurrentHashMap<>());
				}
				championSystem.getGroupResult().put(crossGroupId, championGroup);
			}
			
			//初始化选拔赛分组
			championTrialsService.initMatchGroup();
			
			championSystem.setNextStageTime(championSystem.getStartTime());
			
			log.info("冠军赛进入选拔赛阶段，下一阶段执行时间{}", championSystem.nextStageTime());
			tellStageChange();
			
			//清空弹幕
			crossBiuMap.clear();
		} else if(championSystem.getPeriod() == ChampionPeriod.TRIALS.getValue()) {
			championTrialsService.handleStage(championSystem);
		} else if(championSystem.getPeriod() == ChampionPeriod.KNOCKOUT.getValue()) {
			championKnockoutService.handleStage(championSystem);
		}
		championSystemDao.update(championSystem);
	}
	
	public void gmTransformStage() {
		isRunningGm = true;
		ChampionCrossSystem championSystem = getSystem();
		transformStage(championSystem);
	}
	
	@Override
	public void start() throws Exception {
		ChampionCrossSystem championSystem = getSystem();
		
		//加载本届冠军赛的参赛者
		List<ChampionCrossCompetitor> competitors = championCompetitorService.loadOnServerStart(championSystem.getRound());
		
		if(!competitors.isEmpty() && competitors.size() % ChampionConst.TRIALS_PLAYER != 0 && championSystem.getPeriod() != ChampionPeriod.IDLE.getValue()) {
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
			
			List<ChampionCrossBattle> battleList = championBattleService.loadOnServerStart(championSystem);
			
			//添加回所有本届打过或进行中的32强比赛数据
			championKnockoutService.sort32Battle(championSystem, battleList);
			
			log.info("冠军赛第{}届开服恢复，当前进程{}，比赛进行到的轮数{}，{}阶段，下一次任务时间{}", championSystem.getRound(),
					championSystem.getPeriod(), championSystem.getBattleRound(),
					ChampionStage.of(championSystem.getStage()).getDesc(), championSystem.nextStageTime());
		}
	}
	
	/**
	 * 是否竞猜阶段
	 * @return
	 */
	public boolean isGuessStage() {
		ChampionCrossSystem championSystem = getSystem();
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
		CrossRole role = crossRoleService.getOrThrow(rid);
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		ConcurrentLinkedQueue<CSChampionBiu> biuQueue = crossBiuMap.get(crossGroupId);
		if(biuQueue == null) {
			biuQueue = new ConcurrentLinkedQueue<>();
			crossBiuMap.put(crossGroupId, biuQueue);
		}
		
		CSChampionBiuBuilder builder = CSChampionBiu.builder();
		builder.rid(rid);
		builder.content(content);
		biuQueue.add(builder.build());
		
		ChampionCrossSystem championSystem = getSystem();
		CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
		while(biuQueue.size() > championSeason.getBiu_count()) {
			biuQueue.poll();
		}
		//推送弹幕
		ResChampionBiuChangeBuilder res = ResChampionBiuChange.builder();
		res.content(builder.build());
		messageHelper.pushToGroupMessage(crossGroupId, res.build());
	}
	
	public Queue<CSChampionBiu> getBiuQueue(int crossGroupId) {
		Queue<CSChampionBiu> queue = crossBiuMap.get(crossGroupId);
		if(queue == null) {
			queue = new LinkedList<>();
		}
		return queue;
	}

	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf("ChampionCrossService");
	}
	
	public void cleanBiu() {
		crossBiuMap.clear();
	}
}
