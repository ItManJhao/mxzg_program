/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.ICClanWarStage;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.NextStageConfig;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCross;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarRecord;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarStageControl;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarTeam;
import com.ayjs.mxzg.cross.module.clanwar.struct.ClanWarBattling;
import com.ayjs.mxzg.cross.module.clanwar.struct.ClanWarRoadInfo;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattleDetail;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarSaveBattleMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarSaveBattleMessage.ResClanWarSaveBattleMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellBattleHappenMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellBattleHappenMessage.ResClanWarTellBattleHappenMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellEndMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellEndMessage.ResClanWarTellEndMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellStageMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarTellStageMessage.ResClanWarTellStageMessageBuilder;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarResult;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarRoad;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarStage;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ClanWarService implements Lifecycle {

	@Autowired
	private ClanWarStageSysCache clanWarStageSysCache;
	@Autowired
	private ClanWarCrossService clanWarCrossService;
	@Autowired
	private ClanWarTeamService clanWarTeamService;
	@Autowired 
	private SchedulerService schedulerService;
	@Autowired
	private ClanWarRecordService clanWarRecordService;
	@Autowired
	private ClanWarStageControlService clanWarStageControlService;
	@Autowired
	private MessageHelper messageHelper;
	
	private static final String SCHEDULE_ID = "ClanWar";
	
	//定时任务
	private ScheduledFuture<?> warFuture;
	
	private Map<Long, ClanWarBattling> battlingClanMap;
	
	
	public void runForClanWar(int nextTime) {
		int time = TimeDateUtil.getCurrentTimeInt() + nextTime;
		log.info("公会战注册执行任务，将于{}执行下一次任务", TimeDateUtil.time2String(time * 1000l));
		warFuture = schedulerService.schedule(SCHEDULE_ID, new Runnable() {
			@Override
			public void run() {
				int nextRunTime = 0;
				try {
					nextRunTime = transformStage(false);
				} catch (Exception e) {
					log.error("", e);
				} finally {
					runForClanWar(nextRunTime);
				}
			}
		}, nextTime, TimeUnit.SECONDS);
	}
	
	
	private int transformStage(boolean useGm) {
		ClanWarStageControl stageControl = clanWarStageControlService.getClanWarStage();
		
		ICClanWarStage cClanWarStage = null;
		
		if(!useGm) {
			cClanWarStage = clanWarStageSysCache.getOrThrow(stageControl.getConfigId());
		} else {
			cClanWarStage = clanWarStageSysCache.getGmStage();
		}
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		
		int nextRunTime = 0;
		
		if(stageControl.getStage() == ClanWarStage.MATCH) {
			//处理公会战匹配
			handleClanWarMatch(stageControl, cClanWarStage);
			//设置进入备战阶段
			stageControl.setStage(ClanWarStage.PREPARE);
			stageControl.setInitBattle(0);
			stageControl.setNextStageTime(stageControl.getWeekStartTime() + cClanWarStage.getPrepare_time());
			log.info("公会战进入备战阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
			
			nextRunTime = stageControl.getNextStageTime() - nowTime;
			
		} else if(stageControl.getStage() == ClanWarStage.PREPARE) {
			//设置进入调整阶段
			stageControl.setStage(ClanWarStage.ADJUST);
			stageControl.setNextStageTime(stageControl.getWeekStartTime() + cClanWarStage.getAdjust_time());
			log.info("公会战进入调整阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
			
			nextRunTime = stageControl.getNextStageTime() - nowTime;
			
		} else if(stageControl.getStage() == ClanWarStage.ADJUST) {
			//处理公会战开战
			handleOnClanWarStart(stageControl);

			//设置进入开战阶段和下一次战斗时间
			stageControl.setStage(ClanWarStage.BATTLE);
			stageControl.setInitBattle(1);
			
			log.info("公会战进入开战阶段，当前轮数{}，下一次计算战斗时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextBattleTime() * 1000l));
			
			nextRunTime = stageControl.getNextStageTime() - nowTime;
			
		} else if(stageControl.getStage() == ClanWarStage.BATTLE) {
			if(battlingClanMap == null) {
				//开战阶段重启服务器的情况下需要重建公会战
				handleOnClanWarStart(stageControl);
			}
			
			if(!handleClanWarBattle()) {
				//所有战斗都结束了
				stageControl.setStage(ClanWarStage.IDLE);
				
				stageControl.setNextStageTime(stageControl.getWeekStartTime() + cClanWarStage.getSpace_time());
				log.info("公会战所有战斗已经结束，当前轮数{}，下一轮公会战开始时间{}", stageControl.getRound(),
						TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
				
				nextRunTime = stageControl.getNextStageTime() - nowTime;
				
			} else {
				//每隔一个battleTime进行一次战斗
				stageControl.setNextBattleTime(stageControl.getNextBattleTime() + cClanWarStage.getBattle_time());
				log.info("公会战正在开战阶段，当前轮数{}，下一次计算战斗时间{}", stageControl.getRound(),
						TimeDateUtil.time2String(stageControl.getNextBattleTime() * 1000l));
				
				nextRunTime = stageControl.getNextBattleTime() - nowTime;
			}
		} else if(stageControl.getStage() == ClanWarStage.IDLE) {
			stageControl.setRound(stageControl.getRound() + 1);
			
			NextStageConfig cNextStage = null;
			
			if(!useGm) {
				cNextStage = clanWarStageSysCache.getNextConfig();
			} else {
				cNextStage = clanWarStageSysCache.getNextGmConfig();
			}
			resetNewWarTime(stageControl, cNextStage);
			
			log.info("公会战进入匹配阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
			
			nextRunTime = stageControl.getNextStageTime() - nowTime;
		}
		clanWarStageControlService.update(stageControl);
		
		tellStageChange(stageControl);
		return nextRunTime;
	}
	
	private void tellStageChange(ClanWarStageControl stageControl) {
		if(battlingClanMap == null) {
			return;
		}
		//通知参战公会阶段变化
		List<ClanWarBattling> clanList = new ArrayList<>(battlingClanMap.values());
		Map<Integer, List<ClanWarBattling>> serverClans = ListMapUtil.fillListMap(clanList, ClanWarBattling::getServerId);
		
		for(Entry<Integer, List<ClanWarBattling>> entry : serverClans.entrySet()) {
			ResClanWarTellStageMessageBuilder builder = ResClanWarTellStageMessage.builder();
			builder.serverId(entry.getKey());
			builder.stage(stageControl.getStage());
			List<Long> clanIds = new ArrayList<>();
			for(ClanWarBattling battling : entry.getValue()) {
				clanIds.add(battling.getClanId());
			}
			builder.clanIds(clanIds);
			builder.roundEndTime(stageControl.getRoundEndTime());
			messageHelper.pushToMessage(builder.build());
		}
	}
	
	/**
	 * 公会战开始时的处理，构建战争数据
	 * @param stageControl
	 */
	private void handleOnClanWarStart(ClanWarStageControl stageControl) {
		battlingClanMap = new ConcurrentHashMap<>();
		
		stageControl.setNextBattleTime(stageControl.getNextStageTime());
		
		List<ClanWarTeam> updateTeams = new ArrayList<>();
		
		for(ClanWarCross warInfo : clanWarCrossService.getThisRoundMap().values()) {
			
			ClanWarBattling warBattling = new ClanWarBattling(warInfo.getClanId(), warInfo.getServerId());
			
			//初始化各种的路况对象
			for(ClanWarRoad warRoad : ClanWarRoad.values()) {
				ClanWarRoadInfo roadInfo = new ClanWarRoadInfo(warRoad.getRoad());
				warBattling.getRoadTeamMap().put(warRoad.getRoad(), roadInfo);
			}
			
			//构建战路信息
			for(Long rid : warInfo.getBattleMembers()) {
				ClanWarTeam clanWarTeam = clanWarTeamService.getClanWarTeam(rid);
				ClanWarRoadInfo roadInfo = warBattling.getRoadTeamMap().get(clanWarTeam.getRoad());
				if(stageControl.getInitBattle() == 0) {
					//重置队伍存活状态
					clanWarTeam.setAlive(1);
					updateTeams.add(clanWarTeam);
				}
				clanWarTeam.setShowAlive(clanWarTeam.getAlive());
				roadInfo.getTeams().add(clanWarTeam);
			}
			
			//对战路进行排序
			for(ClanWarRoadInfo roadInfo : warBattling.getRoadTeamMap().values()) {
				roadInfo.getTeams().sort(Comparator.comparingInt(ClanWarTeam::getSort));
			}
			battlingClanMap.put(warInfo.getClanId(), warBattling);
		}
		if(!updateTeams.isEmpty()) {
			clanWarTeamService.updateTeams(updateTeams);
		}
	}
	
	/**
	 * 处理战斗匹配
	 */
	private void handleClanWarMatch(ClanWarStageControl stageControl, ICClanWarStage cClanWarStage) {
		clanWarCrossService.handleClanWarMatch(stageControl, cClanWarStage);
	}
	
	/**
	 * 处理公会战战斗计算
	 * @return true所有公会的战斗都已经结束 false还有公会的战斗仍在继续
	 */
	private boolean handleClanWarBattle() {
		
		List<ClanWarCross> updateWarInfos = new ArrayList<>();
		
		List<ClanWarTeam> updateTeams = new ArrayList<>();
		
		Set<ClanWarCross> noticeUpdateClan = new HashSet<>();
		
		//公会战战斗记录
		List<ClanWarRecord> warRecordList = new ArrayList<>();
		
		//公会战活动是否还有战斗在进行
		boolean hasAnyBattle = false;
		
		ClanWarStageControl stageControl = clanWarStageControlService.getClanWarStage();
		
		for(ClanWarBattling mainBattling : battlingClanMap.values()) {
			ClanWarCross mainWarInfo = clanWarCrossService.getThisRoundCross(mainBattling.getClanId());
			if(mainWarInfo.getSettleStatus() != 0) {
				//已经结算过的公会不进行处理
				continue;
			}
			if(mainWarInfo.getMainAttack() != 1) {
				//由主攻方来发起战斗
				continue;
			}
			ClanWarBattling targetBattling = battlingClanMap.get(mainWarInfo.getTargetClanId());
			ClanWarCross targetWarInfo = clanWarCrossService.getThisRoundCross(mainWarInfo.getTargetClanId());
			
			//是否还有战斗在进行
			boolean hasBattle = false;
			
			for(ClanWarRoad warRoad : ClanWarRoad.values()) {
				ClanWarRoadInfo mainRoadInfo = mainBattling.getRoadTeamMap().get(warRoad.getRoad());
				ClanWarRoadInfo targetRoadInfo = targetBattling.getRoadTeamMap().get(warRoad.getRoad());
				//跳过已经决出胜负的一路
				if(mainRoadInfo.getResult() != ClanWarResult.NONE || targetRoadInfo.getResult() != ClanWarResult.NONE) {
					continue;
				}
				//需要进行通知更新的公会
				noticeUpdateClan.add(mainWarInfo);
				noticeUpdateClan.add(targetWarInfo);
				
				//处理当前正在进行的战斗
				ClanWarTeam mainCurrTeam = mainRoadInfo.getCurrBattleTeam();
				ClanWarTeam targetCurrTeam = targetRoadInfo.getCurrBattleTeam();
				if(mainCurrTeam != null && targetCurrTeam != null) {
					//设置队伍的显示存活状态
					mainCurrTeam.setShowAlive(mainCurrTeam.getAlive());
					targetCurrTeam.setShowAlive(targetCurrTeam.getAlive());
				}
				//添加历史记录
				if(mainRoadInfo.getCurrBattleDetail() != null) {
					mainRoadInfo.getHisDetailList().add(mainRoadInfo.getCurrBattleDetail());
					targetRoadInfo.getHisDetailList().add(mainRoadInfo.getCurrBattleDetail());
					//重置当前正在进行的战斗信息
					mainRoadInfo.setCurrBattleDetail(null);
				}
				
				//判断双方战路是否被摧毁
				if(mainRoadInfo.isRoadDestory() && !targetRoadInfo.isRoadDestory()) {
					//target公会摧毁了main公会的一路
					log.info("公会{}摧毁了公会{}的{}", targetBattling.getClanId(), mainBattling.getClanId(), warRoad.toString());
					targetWarInfo.getBreakCastle().add(warRoad.getRoad());
					updateWarInfos.add(targetWarInfo);
					
					mainRoadInfo.setResult(ClanWarResult.LOSE);
					targetRoadInfo.setResult(ClanWarResult.WIN);
					continue;
					
				} else if(!mainRoadInfo.isRoadDestory() && targetRoadInfo.isRoadDestory()) {
					//main公会摧毁了target公会的一路
					log.info("公会{}摧毁了公会{}的{}", mainBattling.getClanId(), targetBattling.getClanId(), warRoad.toString());
					
					mainWarInfo.getBreakCastle().add(warRoad.getRoad());
					updateWarInfos.add(mainWarInfo);
					
					mainRoadInfo.setResult(ClanWarResult.WIN);
					targetRoadInfo.setResult(ClanWarResult.LOSE);
					continue;
					
				} else if(mainRoadInfo.isRoadDestory() && targetRoadInfo.isRoadDestory()) {
					log.info("公会{}和公会{}在{}上都没有存活的队伍，双方判负", mainBattling.getClanId(), targetBattling.getClanId(), warRoad.toString());
					
					mainRoadInfo.setResult(ClanWarResult.LOSE);
					targetRoadInfo.setResult(ClanWarResult.LOSE);
					continue;
				}
				
				ClanWarTeam mainTeam = mainRoadInfo.getFirstAliveTeam();
				ClanWarTeam targetTeam = targetRoadInfo.getFirstAliveTeam();
				
				mainRoadInfo.setCurrBattleTeam(mainTeam);
				targetRoadInfo.setCurrBattleTeam(targetTeam);
				
				//进行战斗并记录战斗
				ClanWarRecord clanWarRecord = clanWarRecordService.fightForClanWar(stageControl, mainTeam, targetTeam);
	            warRecordList.add(clanWarRecord);
	            
				updateTeams.add(mainTeam);
				updateTeams.add(targetTeam);
				
				hasBattle = true;
				
				CSHisBattleDetail builder = clanWarRecordService.buildWarRecord(clanWarRecord);
				mainRoadInfo.setCurrBattleDetail(builder);
			}
			
			if(!hasBattle) {
				//三路都没有战争在进行，则对对战双方公会进行结算
				//结算
				handleOnBattleFinish(mainWarInfo, targetWarInfo);
			} else {
				hasAnyBattle = true;
			}
		}
		
		if(!updateTeams.isEmpty()) {
			clanWarTeamService.updateTeams(updateTeams);
		}
		if(!updateWarInfos.isEmpty()) {
			clanWarCrossService.update(updateWarInfos);
		}
		if(!warRecordList.isEmpty()) {
			clanWarRecordService.insert(warRecordList);
			
			Map<Long, List<ClanWarRecord>> atkRecordMap = ListMapUtil.fillListMap(warRecordList, ClanWarRecord::getAtkClanId);
			noticeSaveBattleReport(atkRecordMap);
			
			Map<Long, List<ClanWarRecord>> defRecordMap = ListMapUtil.fillListMap(warRecordList, ClanWarRecord::getDefClanId);
			noticeSaveBattleReport(defRecordMap);
		}
		
		noticeBattleHappen(noticeUpdateClan);
		return hasAnyBattle;
	}
	
	/**
	 * 通知游戏服保存战报
	 * @param recordMap
	 */
	private void noticeSaveBattleReport(Map<Long, List<ClanWarRecord>> recordMap) {
		for(Entry<Long, List<ClanWarRecord>> entry : recordMap.entrySet()) {
			long clanId = entry.getKey();
			ClanWarBattling battling = battlingClanMap.get(clanId);
			if(battling == null) {
				continue;
			}
			//没有按服务器进行战报通知，考虑同一个服务器的战报太多，导致数据包太大，因此按公会进行发放，每个公会最多3场战斗
			ResClanWarSaveBattleMessageBuilder builder = ResClanWarSaveBattleMessage.builder();
			builder.serverId(battling.getServerId());
			builder.clanId(clanId);
			List<byte[]> battleReports = new ArrayList<>();
			for(ClanWarRecord record : entry.getValue()) {
				if(record.getBattleReport() != null) {
					battleReports.add(record.getBattleReport().toByteArray());
				}
			}
			builder.battleReports(battleReports);
			if(battleReports.isEmpty()) {
				continue;
			}
			messageHelper.pushToMessage(builder.build());
		}
	}
	
	/**
	 * 通知游戏服有战斗发生
	 * @param battlingClans
	 */
	private void noticeBattleHappen(Set<ClanWarCross> battlingClans) {
		List<ClanWarCross> clanList = new ArrayList<>(battlingClans);
		Map<Integer, List<ClanWarCross>> serverClans = ListMapUtil.fillListMap(clanList, ClanWarCross::getServerId);
		
		for(Entry<Integer, List<ClanWarCross>> entry : serverClans.entrySet()) {
			ResClanWarTellBattleHappenMessageBuilder builder = ResClanWarTellBattleHappenMessage.builder();
			builder.serverId(entry.getKey());
			List<Long> clanIds = new ArrayList<>();
			for(ClanWarCross clanWarCross : entry.getValue()) {
				clanIds.add(clanWarCross.getClanId());
			}
			builder.clanIds(clanIds);
			messageHelper.pushToMessage(builder.build());
		}
	}
	
	/**
	 * 结算对战双方的结果
	 * @param mainInfo
	 * @param targetInfo
	 */
	private void handleOnBattleFinish(ClanWarCross mainInfo, ClanWarCross targetInfo) {
		
		//TODO 推送数据到游戏服
		log.info("公会{}与公会{}的对战已经结束", mainInfo.getName(), targetInfo.getName());
		
		mainInfo.setSettleStatus(1);
		targetInfo.setSettleStatus(1);
		
		if(mainInfo.getBreakCastle().size() > targetInfo.getBreakCastle().size()) {
			//主攻方胜利
			mainInfo.setIsWin(ClanWarResult.WIN.getValue());
			targetInfo.setIsWin(ClanWarResult.LOSE.getValue());
		} else if(mainInfo.getBreakCastle().size() < targetInfo.getBreakCastle().size()) {
			//主攻方失败
			mainInfo.setIsWin(ClanWarResult.LOSE.getValue());
			targetInfo.setIsWin(ClanWarResult.WIN.getValue());
		} else {
			//双方失败
			mainInfo.setIsWin(ClanWarResult.LOSE.getValue());
			targetInfo.setIsWin(ClanWarResult.LOSE.getValue());
		} 
		clanWarCrossService.update(mainInfo);
		clanWarCrossService.update(targetInfo);
		
		tellClanResult(mainInfo);
		tellClanResult(targetInfo);
	}
	
	private void tellClanResult(ClanWarCross clanWar) {
		ResClanWarTellEndMessageBuilder builder = ResClanWarTellEndMessage.builder();
		builder.clanId(clanWar.getClanId());
		builder.serverId(clanWar.getServerId());
		builder.isWin(clanWar.getIsWin());
		builder.round(clanWar.getRound());
		List<Long> battleMembers = new ArrayList<>(clanWar.getBattleMembers());
		builder.battleMembers(battleMembers);
		messageHelper.pushToMessage(builder.build());
		log.info("公会战已向游戏服推送对第{}轮比赛中的公会{}-{}进行发奖", clanWar.getRound(), clanWar.getClanId(), clanWar.getName());
	}
	
	@Override
	public void start() throws Exception {
		ClanWarStageControl stageControl = clanWarStageControlService.getClanWarStage();
		if (stageControl.getStage() == ClanWarStage.PREPARE || stageControl.getStage() == ClanWarStage.ADJUST
				|| stageControl.getStage() == ClanWarStage.BATTLE || stageControl.getStage() == ClanWarStage.IDLE) {
			
			//开服时恢复本轮公会战的公会数据
			List<ClanWarCross> crossList = clanWarCrossService.getByRound(stageControl.getRound());
			for(ClanWarCross clanWarCross : crossList) {
				clanWarCrossService.getThisRoundMap().put(clanWarCross.getClanId(), clanWarCross);
			}
			
			//恢复战场
			this.handleOnClanWarStart(stageControl);
			
			List<ClanWarRecord> records = clanWarRecordService.getByRound(stageControl.getRound());
			Collections.sort(records, Comparator.comparingInt(ClanWarRecord::getTime));
			
			for(ClanWarRecord warRecord : records) {
				CSHisBattleDetail builder = clanWarRecordService.buildWarRecord(warRecord);
				//进攻方
				ClanWarBattling atkBattling = battlingClanMap.get(warRecord.getAtkClanId());
				if(atkBattling != null) {
					ClanWarRoadInfo roadInfo = atkBattling.getRoadTeamMap().get(warRecord.getRoad());
					roadInfo.getHisDetailList().add(builder);
				}
				//防守方
				ClanWarBattling defBattling = battlingClanMap.get(warRecord.getDefClanId());
				if(defBattling != null) {
					ClanWarRoadInfo roadInfo = defBattling.getRoadTeamMap().get(warRecord.getRoad());
					roadInfo.getHisDetailList().add(builder);
				}
			}
		}
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int nextRunTime = stageControl.getNextStageTime() - nowTime;
		runForClanWar(nextRunTime);
	}
	
	/**
	 * GM换阶段
	 */
	public void gmTransformStage() {
		if(warFuture != null) {
			//取消当前的任务
			warFuture.cancel(false);
			log.info("GM命令停止公会战定时任务");
		}
		transformStage(true);
	}
	
	private void resetNewWarTime(ClanWarStageControl stageControl, NextStageConfig nextConfig) {
		ICClanWarStage nextWarStage = nextConfig.getStageConfig();
		
		stageControl.setStage(ClanWarStage.MATCH);
		stageControl.setWeekStartTime(nextConfig.getWeekZero());
		stageControl.setNextStageTime(stageControl.getWeekStartTime() + nextWarStage.getMatch_time());
		stageControl.setConfigId(nextWarStage.getIdx());
		stageControl.setRoundStartTime(TimeDateUtil.getSomedayZeroInt(stageControl.getNextStageTime()));
		stageControl.setRoundEndTime(stageControl.getRoundStartTime() + TimeDateUtil.ONEDAYINT);
	}
	
	/**
	 * 获取战斗信息
	 * @param clanId
	 * @return
	 */
	public ClanWarBattling getBattlingInfo(long clanId) {
		if(battlingClanMap == null) {
			return null;
		}
		return battlingClanMap.get(clanId);
	}
	
	/**
	 * 是否可以查看公会战信息
	 * @return
	 */
	public boolean isCanScanClanWar() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(control.getRoundEndTime() > nowTime) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 是否备战阶段
	 * @return
	 */
	public boolean isPrepareStage() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		return control.getStage() == ClanWarStage.PREPARE;
	}
	/**
	 * 是否调整阶段
	 * @return
	 */
	public boolean isAdjustStage() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		return control.getStage() == ClanWarStage.ADJUST;
	}
	/**
	 * 是否战斗阶段
	 * @return
	 */
	public boolean isBattleStage() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		return control.getStage() == ClanWarStage.BATTLE;
	}
	/**
	 * 是否可以看历史记录
	 * @return
	 */
	public boolean isCanScanHisBattle() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		return control.getStage() == ClanWarStage.BATTLE || TimeDateUtil.getCurrentTimeInt() <= control.getRoundEndTime();
	}
	
	
	/**
	 * 是否公会战活动期间
	 * @return
	 */
	public boolean isDuringClanWar() {
		ClanWarStageControl control = clanWarStageControlService.getClanWarStage();
		return control.getRoundEndTime() > TimeDateUtil.getCurrentTimeInt();
	}

	/**
	 * 公会是否参加公会战
	 * @param clanId
	 * @return true:参加，false:没参加
	 */
	public boolean isJoinClanWar(long clanId) {
		return battlingClanMap != null && battlingClanMap.get(clanId) != null;
	}
	
	/**
	 * 获取指定服务器正在进行公会战的公会
	 * @param serverId
	 * @return
	 */
	public List<Long> getServerBattlingClans(int serverId) {
		List<Long> battlingClans = new ArrayList<>();
		if(battlingClanMap == null) {
			return Collections.emptyList();
		}
		
		for(ClanWarBattling clan : battlingClanMap.values()) {
			if(clan.getServerId() == serverId) {
				battlingClans.add(clan.getClanId());
			}
		}
		return battlingClans;
	}


	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._10, "ClanWarService");
	}
}
