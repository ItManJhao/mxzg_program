/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondRoundSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondSeasonSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnaclePeriod;
import com.ayjs.mxzg.config.excel.constant.PinnacleStage;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondRound;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.StageMatchScheduled;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.dao.PinnacleCrossSystemDao;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossBattle;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossSystem;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.period.PinnaclePeriodService;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleGroup;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleBiu;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleBiuChange;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleStageChange;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.*;

@Slf4j
@Service
public class PinnacleCrossService implements Lifecycle {
	
	@Autowired
	private PinnacleCrossSystemDao pinnacleSystemDao;
	@Autowired
	private PinnaclePeriodService pinnaclePeriodService;
	@Autowired
	private PinnacleCrossCompetitorService pinnacleCompetitorService;
	@Autowired
	private PinnacleCrossBattleService pinnacleBattleService;
	@Autowired
	private TopMatchSecondSeasonSysCache topMatchSecondSeasonSysCache;
	@Autowired
	private TopMatchSecondRoundSysCache topMatchSecondRoundSysCache;
	@Autowired
	private ServerGroupService serverGroupService;
	@Autowired
	private MessageHelper messageHelper;
	@Autowired
	private OpponentDao opponentDao;
	
	private boolean isRunningGm = false;

	/** 调度器 */
	private static ScheduledExecutorService executorService = StageMatchScheduled.getExecutorService();
	
	/**
	 * 弹幕队列
	 */
	private Map<Integer, ConcurrentLinkedQueue<CSPinnacleBiu>> crossBiuMap = new ConcurrentHashMap<>();
	
	public PinnacleCrossSystem getSystem() {
		PinnacleCrossSystem pinnacleSystem = null;
		List<PinnacleCrossSystem> systemList = pinnacleSystemDao.listAll();
		if(systemList.isEmpty()) {
			pinnacleSystem = new PinnacleCrossSystem();
			pinnacleSystem.setRound(1);
			pinnacleSystem.setGroupResult(new ConcurrentHashMap<>());
			pinnacleSystemDao.add(pinnacleSystem);
		} else {
			pinnacleSystem = systemList.get(0);
		}
		return pinnacleSystem;
	}
	
	public void tellStageChange() {
		//通知游戏服阶段变化
		ResPinnacleStageChange.ResPinnacleStageChangeBuilder builder = ResPinnacleStageChange.builder();
		messageHelper.pushToAll(builder.build());
	}

	/**
	 * 开启巅峰赛
	 */
	public void resetPinnacleTime() {
		PinnacleCrossSystem pinnacleSystem = getSystem();
		pinnacleSystem.setLastStartTime(pinnacleSystem.getStartTime());
		pinnacleSystem.setStartTime(DateTimeUtil.currentSecond());
		pinnacleSystem.setOpening(true);
		pinnacleSystem.setPeriod(PinnaclePeriod.IDLE.getValue());
		pinnacleSystem.setStage(PinnacleStage.MATCH.getValue());
		pinnacleSystem.setBattleRound(topMatchSecondRoundSysCache.getFirstRound());
		CTopMatchSecondRound pinnacleRound = topMatchSecondRoundSysCache.getCrossKnockoutRound(pinnacleSystem.getBattleRound());
		pinnacleSystem.setNextStageTime(pinnacleSystem.getStartTime() + pinnacleRound.getPrepare_time());
		scheduleTask();
	}

	public void runForPinnacle() {
		PinnacleCrossSystem pinnacleSystem = getSystem();

		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(nowTime < pinnacleSystem.getStartTime() || pinnacleSystem.getStartTime() == 0) {
			return;
		}
		if(nowTime < pinnacleSystem.getNextStageTime()) {
			return;
		}
		if(isRunningGm) {
			return;
		}
		transformStage(pinnacleSystem);
	}
	
	private void transformStage(PinnacleCrossSystem pinnacleSystem) {
		if(pinnacleSystem.getPeriod() == PinnaclePeriod.IDLE.getValue()) {
			log.info("第{}届冠军赛开始", pinnacleSystem.getRound());

			pinnaclePeriodService.restart();
			pinnacleCompetitorService.restart();
			pinnacleBattleService.restart();

			//进行玩家选中
			pinnacleCompetitorService.initCompetitor(pinnacleSystem);

			//开始第一回合淘汰赛
			pinnacleSystem.setBattleRound(topMatchSecondRoundSysCache.getFirstRound());
			pinnacleSystem.setPeriod(PinnaclePeriod.KNOCKOUT.getValue());

			//把无用的跨服分组数据清理掉
			ConcurrentMap<Integer, PinnacleGroup> groupMap = new ConcurrentHashMap<>();
			pinnacleSystem.getGroupResult().forEach((crossGroupId, group) -> groupMap.put(group.getCrossId(), group));
			pinnacleSystem.getGroupResult().clear();

			for (Integer crossGroupId : pinnacleCompetitorService.getCrossGroups()) {
				PinnacleGroup pinnacleGroup = groupMap.get(crossGroupId);
				if (pinnacleGroup == null) {
					pinnacleGroup = new PinnacleGroup();
					pinnacleGroup.setCrossId(crossGroupId);
					pinnacleGroup.setTopPlayers(new ConcurrentHashMap<>());
				}
				pinnacleSystem.getGroupResult().put(crossGroupId, pinnacleGroup);
			}

			pinnacleSystem.setNextStageTime(pinnacleSystem.getStartTime());

			pinnaclePeriodService.initMatchGroup();

			log.info("冠军赛进入选拔赛阶段，下一阶段执行时间{}", pinnacleSystem.nextStageTime());
			tellStageChange();

			//清空弹幕
			crossBiuMap.clear();

		} else if(pinnacleSystem.getPeriod() == PinnaclePeriod.KNOCKOUT.getValue()) {
			pinnaclePeriodService.handleStage(pinnacleSystem);
		}

		pinnacleSystemDao.update(pinnacleSystem);
		scheduleTask();
	}
	
	public void gmTransformStage() {
		isRunningGm = true;
		PinnacleCrossSystem pinnacleSystem = getSystem();
		transformStage(pinnacleSystem);
	}
	
	@Override
	public void start() throws Exception {
		PinnacleCrossSystem pinnacleSystem = getSystem();
		log.info("起服恢复巅峰赛，巅峰赛当前状态opening={}", pinnacleSystem.isOpening());


		//加载本届冠军赛的参赛者
		pinnacleCompetitorService.loadOnServerStart(pinnacleSystem.getRound());

		List<PinnacleCrossBattle> battleList = pinnacleBattleService.loadOnServerStart(pinnacleSystem);

		//添加回所有本届打过或进行中的32强比赛数据
		pinnaclePeriodService.sort32Battle(pinnacleSystem, battleList);
		if(!pinnacleSystem.isOpening()){
			return;
		}

		log.info("冠军赛第{}届开服恢复，当前进程{}，比赛进行到的轮数{}，{}阶段，下一次任务时间{}", pinnacleSystem.getRound(),
				pinnacleSystem.getPeriod(), pinnacleSystem.getBattleRound(),
				PinnacleStage.of(pinnacleSystem.getStage()).getDesc(), pinnacleSystem.nextStageTime());

		scheduleTask();
	}

	/**
	 * 添加调度任务
	 */
	public void scheduleTask(){
		PinnacleCrossSystem pinnacleSystem = getSystem();
		if(!pinnacleSystem.isOpening()){
			log.info("巅峰赛已经关闭，定时器取消");
			return;
		}
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int delay = pinnacleSystem.getNextStageTime() - nowTime;
		executorService.schedule(()->{
			try{
				runForPinnacle();
			} catch (Exception ex){
				ex.printStackTrace();
			}
		}, delay, TimeUnit.SECONDS);
		LocalDateTime nextTime = LocalDateTimeUtil.ofEpochSecond(pinnacleSystem.getNextStageTime());
		log.info("巅峰赛将在{}执行{}轮的{}阶段", nextTime, pinnacleSystem.getBattleRound(), pinnacleSystem.getStage());
	}
	
	/**
	 * 是否竞猜阶段
	 * @return
	 */
	public boolean isGuessStage() {
		PinnacleCrossSystem pinnacleSystem = getSystem();
		if (pinnacleSystem.getStage() == PinnacleStage.GUESS.getValue()
				&& TimeDateUtil.getCurrentTimeInt() < pinnacleSystem.getNextStageTime()) {
			return true;
		}
		return false;
	}
	
	/**
	 * 添加弹幕信息
	 * @param content
	 */
	public void addBiubiubiu(long rid, String content) {
		Opponent role = opponentDao.get(rid);
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());
		ConcurrentLinkedQueue<CSPinnacleBiu> biuQueue = crossBiuMap.get(crossGroupId);
		if(biuQueue == null) {
			biuQueue = new ConcurrentLinkedQueue<>();
			crossBiuMap.put(crossGroupId, biuQueue);
		}

		CSPinnacleBiu.CSPinnacleBiuBuilder builder = CSPinnacleBiu.builder();
		builder.rid(rid);
		builder.content(content);
		biuQueue.add(builder.build());

		CTopMatchSecondSeason pinnacleSeason = topMatchSecondSeasonSysCache.getCrossSeason();
		while(biuQueue.size() > pinnacleSeason.getBiu_count()) {
			biuQueue.poll();
		}
		//推送弹幕
		ResPinnacleBiuChange.ResPinnacleBiuChangeBuilder res = ResPinnacleBiuChange.builder();
		res.content(builder.build());
		messageHelper.pushToGroupMessage(crossGroupId, res.build());
	}
	
	public Queue<CSPinnacleBiu> getBiuQueue(int crossGroupId) {
		Queue<CSPinnacleBiu> queue = crossBiuMap.get(crossGroupId);
		if(queue == null) {
			queue = new LinkedList<>();
		}
		return queue;
	}

	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf(Priority.LOW, 2, "PINNACLE_CROSS_SERVICE");
	}
	
	public void cleanBiu() {
		crossBiuMap.clear();
	}
}
