/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache.ICClanWorldBossStage;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache.NextStageConfig;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossSysCache;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.service.CrossClanService;
import com.ayjs.mxzg.cross.module.clanworldboss.constant.ClanWorldBossStage;
import com.ayjs.mxzg.cross.module.clanworldboss.dao.ClanWorldBossStageControlDao;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossResult;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossStageControl;
import com.ayjs.mxzg.cross.module.clanworldboss.struct.ClanWorldBossClan;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellEndMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellEndMessage.ResTellEndMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellFirstMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellFirstMessage.ResTellFirstMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellStageChangeMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellStageChangeMessage.ResTellStageChangeMessageBuilder;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

/**
 * @author YY
 *
 */
@Observer
@Slf4j
@Service
public class ClanWorldBossService implements Lifecycle {

	@Autowired
	private ClanWorldBossStageControlDao clanWorldBossStageControlDao;
	@Autowired
	private ClanWorldBossStageSysCache clanWorldBossStageSysCache;
	@Autowired
	private ClanWorldBossClanRankService clanWorldBossClanRankService;
	@Autowired
	private ClanWorldBossRoleRankService clanWorldBossRoleRankService;
	@Autowired
	private ClanWorldBossSysCache clanWorldBossSysCache;
	@Autowired
	private ClanWorldBossMemberService clanWorldBossMemberService;
	@Autowired
	private SchedulerService schedulerService;
	@Autowired
	private CrossClanService crossClanService;
	@Autowired
	private MessageHelper messageHelper;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private CrossServerGroupService crossServerGroupService;
	@Autowired
	private ClanWorldBossResultService clanWorldBossResultService;
	
	
	private static final String SCHEDULE_ID = "ClanWorldBoss";
	
	private Map<Long, ClanWorldBossClan> clanMap = new ConcurrentHashMap<>();
	
	//定时任务
	private ScheduledFuture<?> bossFuture;
	
	public ClanWorldBossStageControl getClanWorldBossStage() {
		List<ClanWorldBossStageControl> list = clanWorldBossStageControlDao.listAll();
		ClanWorldBossStageControl stageControl = null;
		if(list.isEmpty()) {
			NextStageConfig stageConfig = clanWorldBossStageSysCache
					.getNextConfig(TimeDateUtil.getCurrentTimeInt(), 0);
			
			stageControl = new ClanWorldBossStageControl();
			stageControl.setRound(1);
			stageControl.setBossId(getBossId());
			resetNewBossTime(stageControl, stageConfig);
			clanWorldBossStageControlDao.add(stageControl);
		} else {
			stageControl = list.get(0);
		}
		return stageControl;
	}
	
	private int getBossId() {
		//boss配置的统一处理方式，用当前时间除以一天的秒数，对boss配置数量取模后则可保证统一
		int day = TimeDateUtil.getCurrentTimeInt() / TimeDateUtil.ONEDAYINT;
		int index = day % clanWorldBossSysCache.getAll().size();
		return clanWorldBossSysCache.getAll().get(index).getRound();
	}
	
	
	/**
	 * 是否可以进行BOSS挑战
	 * @return
	 */
	public boolean isCanChallenge() {
		ClanWorldBossStageControl stageControl = getClanWorldBossStage();
		if(stageControl == null) {
			return false;
		}
		return stageControl.getStage() == ClanWorldBossStage.CHALLENGE;
	}
	
	/**
	 * 是否可以进行掠夺
	 * @return
	 */
	public boolean isCanRob() {
		ClanWorldBossStageControl stageControl = getClanWorldBossStage();
		if(stageControl == null) {
			return false;
		}
		return stageControl.getStage() == ClanWorldBossStage.ROB;
	}
	
	/**
	 * 添加玩家到参数列表中
	 * @param member
	 */
	public void joinToWorldBoss(ClanWorldBossMember member) {
		ClanWorldBossClan clanWorldBossClan = this.getClanWorldBossClan(member.getClanId());
		clanWorldBossClan.getJoinMembers().put(member.getRid(), member.getRid());
	}
	
	private void runForBoss(int nextTime) {
		int time = TimeDateUtil.getCurrentTimeInt() + nextTime;
		log.info("公会世界BOSS注册执行任务，将于{}执行下一次任务", TimeDateUtil.time2String(time * 1000l));
		bossFuture = schedulerService.schedule(SCHEDULE_ID, new Runnable() {
			@Override
			public void run() {
				int nextRunTime = 0;
				try {
					//下一次的任务时间
					nextRunTime = transformStage(false);
				} catch(Exception e) {
					log.error("", e);
				} finally {
					runForBoss(nextRunTime);
				}
			}
		}, nextTime, TimeUnit.SECONDS);
	}
	
	/**
	 * 转换阶段
	 * @return
	 */
	private int transformStage(boolean useGm) {
		ClanWorldBossStageControl stageControl = getClanWorldBossStage();
		
		ICClanWorldBossStage cStage = null;
		if(!useGm) {
			cStage = clanWorldBossStageSysCache.getOrThrow(stageControl.getStageConfigId());
		} else {
			cStage = clanWorldBossStageSysCache.getGmStage();
		}
		
		if(stageControl.getStage() == ClanWorldBossStage.FORECAST) {
			//进入挑战阶段
			stageControl.setStage(ClanWorldBossStage.CHALLENGE);
			stageControl.setNextStageTime(stageControl.getWeekStartTime() + cStage.getChallenge_time());
			log.info("公会世界BOSS进入挑战阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
		} else if(stageControl.getStage() == ClanWorldBossStage.CHALLENGE) {
			//进入掠夺阶段
			stageControl.setStage(ClanWorldBossStage.ROB);
			stageControl.setNextStageTime(stageControl.getWeekStartTime() + cStage.getRob_time());
			log.info("公会世界BOSS进入掠夺阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
		} else if(stageControl.getStage() == ClanWorldBossStage.ROB) {
			//进入休战阶段
			stageControl.setStage(ClanWorldBossStage.IDLE);
			stageControl.setNextStageTime(stageControl.getWeekStartTime() + cStage.getSpace_time());
			stageControl.setRoundEndTime(TimeDateUtil.getTomorrowZeroTimeInt());
			
			log.info("公会世界BOSS进入休战阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
			
			//结算排名奖励
			countWorldBossResult(stageControl);
			log.info("公会世界BOSS已经进行奖励结算，当前轮数{}", stageControl.getRound());
			
		} else if(stageControl.getStage() == ClanWorldBossStage.IDLE) {
			//进入预告阶段
			stageControl.setRound(stageControl.getRound() + 1);
			stageControl.setBossId(getBossId());
			//下一轮活动的时间配置
			NextStageConfig cNextStage = null;
			
			if(!useGm) {
				cNextStage = clanWorldBossStageSysCache.getNextConfig();
			} else {
				cNextStage = clanWorldBossStageSysCache.getNextGmConfig();
			}
			resetNewBossTime(stageControl, cNextStage);
			
			log.info("公会世界BOSS进入预告阶段，当前轮数{}，下一阶段开始时间{}", stageControl.getRound(),
					TimeDateUtil.time2String(stageControl.getNextStageTime() * 1000l));
			
			clanMap.clear();
			clanWorldBossClanRankService.clear();
			clanWorldBossRoleRankService.clear();
		}
		clanWorldBossStageControlDao.update(stageControl);
		
		//通知各游戏服阶段变化
		ResTellStageChangeMessageBuilder builder = ResTellStageChangeMessage.builder();
		builder.stage(stageControl.getStage());
		builder.nextStageTime(stageControl.getNextStageTime());
		messageHelper.pushToAll(builder.build());
		
		//下一次的任务时间
		int nextRunTime = stageControl.getNextStageTime() - TimeDateUtil.getCurrentTimeInt();
		return nextRunTime;
	}
	
	/**
	 * 结算世界BOSS奖励
	 * @param stageControl
	 */
	private void countWorldBossResult(ClanWorldBossStageControl stageControl) {
		List<ClanWorldBossResult> resultList = new ArrayList<>();
		//结算奖励
		for(ClanWorldBossClan clan : clanMap.values()) {
			try {
				CrossClan crossClan = crossClanService.get(clan.getClanId());
				if(crossClan == null) {
					log.error("公会世界BOSS进行发奖中无法获取公会ID为{}的公会数据", clan.getClanId());
					continue;
				}
				
				int clanRank = clanWorldBossClanRankService.getEntityRank(crossClan.getServerId(), clan.getClanId());
				
				ClanWorldBossResult result = new ClanWorldBossResult();
				result.setRound(stageControl.getRound());
				result.setGroupId(crossServerGroupService.getGroupId(crossClan.getServerId()));
				result.setClanId(crossClan.getId());
				result.setClanName(crossClan.getClanName());
				result.setPoint(clan.getPoint());
				result.setRank(clanRank);
				result.setJoinMembers(new HashMap<>());
				result.setBossId(stageControl.getBossId());
				result.setStatus(0);
				result.setServerId(crossClan.getServerId());
				for(long memberId : clan.getJoinMembers().values()) {
					int roleRank = clanWorldBossRoleRankService.getEntityRank(crossClan.getServerId(), memberId);
					result.getJoinMembers().put(memberId, roleRank);
				}
				resultList.add(result);
			} catch (Exception e) {
				log.error("公会" + clan.getClanId() + "发放世界BOSS奖励中发生异常", e);
			}
		}
		clanWorldBossResultService.insertResult(resultList);
		
		//进行发奖通知
		Map<Integer, List<ClanWorldBossResult>> serverResultMap = ListMapUtil.fillListMap(resultList, ClanWorldBossResult::getServerId);
		//按服务器ID进行分组
		Map<Integer, List<CSClanRank>> serverClanMap = new HashMap<>();
		for(Entry<Integer, List<ClanWorldBossResult>> serverEntry : serverResultMap.entrySet()) {
			List<CSClanRank> clanList = new ArrayList<>();
			
			for(ClanWorldBossResult result : serverEntry.getValue()) {
				clanList.add(clanWorldBossResultService.serialize(result));
			}
			serverClanMap.put(serverEntry.getKey(), clanList);
		}
		//推送服务器进行发奖
		for(Entry<Integer, List<CSClanRank>> entry : serverClanMap.entrySet()) {
			ResTellEndMessageBuilder builder = ResTellEndMessage.builder();
			builder.round(stageControl.getRound());
			builder.serverId(entry.getKey());
			builder.clans(entry.getValue());
			messageHelper.pushToMessage(builder.build());
		}
		//通知游戏服务器播报第一名
		tellFirstWhenEnd();
	}
	
	
	private void tellFirstWhenEnd() {
		try {
			//第一名的事件
			Map<Integer, Long> firstClanMap = clanWorldBossClanRankService.getGroupFirst();
			Map<Integer, Long> firstRoleMap = clanWorldBossRoleRankService.getGroupFirst();
			//对每个跨服组推送第一名的结果
			for(Entry<Integer, Long> clanEntry : firstClanMap.entrySet()) {
				int groupId = clanEntry.getKey();
				Long firstRole = firstRoleMap.get(groupId);
				if(firstRole == null) {
					continue;
				}
				
				CrossClan crossClan = crossClanService.get(clanEntry.getValue());
				CrossRole crossRole = crossRoleService.getOrThrow(firstRole);
				
				ResTellFirstMessageBuilder builder = ResTellFirstMessage.builder();
				builder.fristRole(crossRole.getNick());
				builder.firstRoleServer(crossRole.getServerId());
				if (Objects.nonNull(crossClan)){
					builder.firstClan(crossClan.getClanName());
					builder.firstClanServer(crossClan.getServerId());
				} else {
					// TODO 拿不到工会信息填填默认值
					builder.firstClan("");
					builder.firstClanServer(0);
				}
				messageHelper.pushToGroupMessage(groupId, builder.build());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public ClanWorldBossClan getClanWorldBossClan(long clanId) {
		ClanWorldBossClan clan = clanMap.get(clanId);
		if(clan == null) {
			synchronized (clanMap) {
				clan = clanMap.get(clanId);
				if(clan == null) {
					clan = new ClanWorldBossClan(clanId);
					clanMap.put(clanId, clan);
				}
			}
		}
		return clan;
	}
	
	public int getClanPoint(long clanId) {
		ClanWorldBossClan clan = getClanWorldBossClan(clanId);
		int point = 0;
		for(Long rid : clan.getJoinMembers().keySet()) {
			ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(rid);
			point += member.getPoint();
		}
		clan.setPoint(point);
		return point;
	}

	@Override
	public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._41, "ClanWorldBossService");
	}

	@Override
	public void start() throws Exception {
		ClanWorldBossStageControl stageControl = getClanWorldBossStage();
		if(stageControl == null) {
			return;
		}
		List<ClanWorldBossMember> memberList = clanWorldBossMemberService.getByRound(stageControl.getRound());
		Map<Long, List<ClanWorldBossMember>> clanMembers = ListMapUtil.fillListMap(memberList, ClanWorldBossMember::getClanId);
		
		//服务器重启的时候加载数据还原本轮活动状态
		for(Entry<Long, List<ClanWorldBossMember>> entry : clanMembers.entrySet()) {
			long clanId = entry.getKey();
			if(clanId == 0) {
				continue;
			}
			ClanWorldBossClan clan = new ClanWorldBossClan(clanId);
			int point = 0;
			for(ClanWorldBossMember member : entry.getValue()) {
				point += member.getPoint();
				clan.getJoinMembers().put(member.getRid(), member.getRid());
			}
			clan.setPoint(point);
			clanMap.put(clan.getClanId(), clan);
		}
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int nextRunTime = stageControl.getNextStageTime() - nowTime;
		runForBoss(nextRunTime);
	}
	
	/**
	 * GM换阶段
	 */
	public void gmTransformStage() {
		if(bossFuture != null) {
			//取消当前的任务
			bossFuture.cancel(false);
			log.info("GM命令停止公会世界BOSS定时任务");
		}
		transformStage(true);
	}
	
	private void resetNewBossTime(ClanWorldBossStageControl stageControl, NextStageConfig cNextStage) {
		ICClanWorldBossStage nextBossStage = cNextStage.getStageConfig();
		stageControl.setStage(ClanWorldBossStage.FORECAST);
		stageControl.setWeekStartTime(cNextStage.getWeekZero());
		stageControl.setNextStageTime(stageControl.getWeekStartTime() + nextBossStage.getForecast_time());
		stageControl.setRoundStartTime(TimeDateUtil.getSomedayZeroInt(stageControl.getNextStageTime()));
		stageControl.setRoundEndTime(stageControl.getRoundStartTime() + TimeDateUtil.ONEDAYINT);
		stageControl.setStageConfigId(nextBossStage.getIdx());
	}
}
