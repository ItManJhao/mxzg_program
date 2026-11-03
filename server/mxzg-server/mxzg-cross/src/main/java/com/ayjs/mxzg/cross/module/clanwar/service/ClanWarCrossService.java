/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.ICClanWarStage;
import com.ayjs.mxzg.config.excel.constant.ClanWarConst;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.service.CrossClanService;
import com.ayjs.mxzg.cross.module.clanwar.dao.ClanWarCrossDao;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCross;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCrossInfo;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarStageControl;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.template.constant.GameConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ClanWarCrossService {
	
	@Autowired
	private ClanWarCrossDao clanWarCrossDao;
	@Autowired
	private CrossClanService crossClanService;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private CrossServerGroupService crossServerGroupService;
	@Autowired
	private ClanWarCrossInfoService clanWarCrossInfoService;
	
	private final Map<Long, ClanWarCross> thisRoundMap = new ConcurrentHashMap<>();
	
	public List<ClanWarCross> getByRound(int round) {
		return clanWarCrossDao.list("round", round);
	}
	
	public ClanWarCross getFromCache(long clanId, int round) {
		ClanWarCross clanWarCross = thisRoundMap.get(clanId);
		if(clanWarCross != null && clanWarCross.getRound() == round) {
			return clanWarCross;
		}
		Map<String, Object> options = new HashMap<>();
		options.put("round", round);
		options.put("clanId", clanId);
		List<ClanWarCross> list = clanWarCrossDao.list(options);
		if(list.size() == 1) {
			return list.get(0);
		} else {
			return null;
		}
	}

	/**
	 * 获取本轮所有的战斗公会数据
	 * @return
	 */
	public Map<Long, ClanWarCross> getThisRoundMap() {
		return thisRoundMap;
	}
	
	public ClanWarCross getThisRoundCross(long clanId) {
		return thisRoundMap.get(clanId);
	}
	
	public void update(List<ClanWarCross> list) {
		clanWarCrossDao.update(list);
	}
	
	public void update(ClanWarCross clanWarCross) {
		clanWarCrossDao.update(clanWarCross);
	}
	
	
	private Map<Integer, List<ClanWarCross>> splitClanIntoGroup(ClanWarStageControl stageControl) {
		List<CrossRole> allRoles = crossRoleService.getAllRoles();
		Map<Long, List<CrossRole>> clanRoleMap = ListMapUtil.fillListMap(allRoles, CrossRole::getClanId);
		
		//统计公会战时的活跃玩家数
		Map<Integer, List<ClanWarCross>> clanWarGroups = new HashMap<>();
		
		long nowTime = TimeDateUtil.getCurrentTime();
		for(Entry<Long, List<CrossRole>> entry : clanRoleMap.entrySet()) {
			long clanId = entry.getKey();
			if(clanId <= 0) {
				continue;
			}
			//TODO 如果改成抛异常的话，这里需要把异常捕捉处理掉
			CrossClan crossClan = null;
			try {
				crossClan = crossClanService.get(clanId);
			} catch(Exception e) {
				log.error(e.getMessage());
				continue;
			}
			if(crossClan == null) {
				continue;
			}
			//公会所在服务器的开服时间，对没有满足开服时间的公会进行过滤
			int clanServerTime = TimeDateUtil.getSomedayZeroInt(crossClan.getServerOpenTime())
					+ TimeDateUtil.ONEDAYINT * ClanWarConst.OPEN_DAY;
			if(clanServerTime > nowTime) {
				continue;
			}
			//按照跨服分组统计公会活跃数据
			int groupId = crossServerGroupService.getGroupId(crossClan.getServerId());
			List<ClanWarCross> clanWarList = clanWarGroups.get(groupId);
			if(clanWarList == null) {
				clanWarList = new ArrayList<>();
				clanWarGroups.put(groupId, clanWarList);
			}
			int activeCount = 0;
			long fighting = 0;
			for(CrossRole role : entry.getValue()) {
				if(role.getLastOfflineTime() > nowTime - TimeDateUtil.ONEDAY * ClanWarConst.ACTIVE_STANDARD) {
					activeCount++;
				}
				fighting += role.getFighting();
			}
			//组装出本轮公会战的数据
			ClanWarCross clanWarCross = new ClanWarCross();
			clanWarCross.setClanId(clanId);
			clanWarCross.setName(crossClan.getClanName());
			clanWarCross.setRound(stageControl.getRound());
			clanWarCross.setActiveMembers(activeCount);
			clanWarCross.setFighting(fighting);
			clanWarCross.setServerId(crossClan.getServerId());
			clanWarCross.setBattleMembers(new HashSet<>());
			clanWarCross.setBreakCastle(new HashSet<>());
			clanWarCross.setJoinMembers(new HashSet<>());
			for(CrossRole role : entry.getValue()) {
				clanWarCross.getJoinMembers().add(role.getId());
			}
			clanWarList.add(clanWarCross);
		}
		return clanWarGroups;
	}
	
	/**
	 * 处理战斗匹配
	 */
	public void handleClanWarMatch(ClanWarStageControl stageControl, ICClanWarStage cClanWarStage) {
		Map<Integer, List<ClanWarCross>> groupMap = splitClanIntoGroup(stageControl);
		
		thisRoundMap.clear();
		
		for(Entry<Integer, List<ClanWarCross>> entry : groupMap.entrySet()) {
			//只给活跃人数达到要求的公会进行匹配
			//活跃的公会
			List<ClanWarCross> activeClans = new ArrayList<>();
			//不活跃的公会
			List<ClanWarCross> unactiveClans = new ArrayList<>();
			
			List<ClanWarCross> clanList = entry.getValue();
			
			for(ClanWarCross clan : clanList) {
				if(clan.getActiveMembers() >= cClanWarStage.getNeed_active()) {
					activeClans.add(clan);
					log.info("活跃公会【S{}】-{}-{}，活跃人数{}", clan.getServerId(), clan.getClanId(), clan.getName(), clan.getActiveMembers());
				} else {
					unactiveClans.add(clan);
					log.info("非活跃公会【S{}】-{}-{}，活跃人数{}", clan.getServerId(), clan.getClanId(), clan.getName(), clan.getActiveMembers());
				}
			}
			log.info("公会战匹配检查，活跃公会{}个，非活跃公会{}个", activeClans.size(), unactiveClans.size());
			//公会战力高的公会优先匹配
			activeClans.sort(Comparator.comparingLong(ClanWarCross::getFighting));
			Collections.reverse(activeClans);
			
			unactiveClans.sort(Comparator.comparingLong(ClanWarCross::getFighting));
			Collections.reverse(unactiveClans);
			
			//成功匹配到的公会信息
			List<ClanWarCross> matchedClanList = new ArrayList<>();
			List<ClanWarCrossInfo> matchedClanInfoList = new ArrayList<>();
			
			while(!activeClans.isEmpty()) {
				ClanWarCross mainClan = activeClans.remove(0);
				ClanWarCrossInfo mainInfo = clanWarCrossInfoService.getClanWarInfo(mainClan.getClanId());
				//扩大次数
				int growCount = 0;
				ClanWarCross targetClan = null;
				//先找到之前没有对战过的公会
				while(!activeClans.isEmpty() && targetClan == null) {
					growCount++;
	                long minFighting = mainClan.getFighting() * (GameConstant.WAN - cClanWarStage.getGrow_rate() * growCount) / GameConstant.WAN;
					for(ClanWarCross ele : activeClans) {
						if(minFighting <= ele.getFighting() && !mainInfo.getRivalClanIds().contains(ele.getClanId())) {
							targetClan = ele;
							break;
						}
					}
					if(minFighting <= 0) {
						break;
					}
				}
				//当一共只有两个公会进行匹配时，即使他们之前对战过，也只能他们两个进行对战
				growCount = 0;
				while(!activeClans.isEmpty() && targetClan == null) {
					growCount++;
	                long minFighting = mainClan.getFighting() * (GameConstant.WAN - cClanWarStage.getGrow_rate() * growCount) / GameConstant.WAN;
					for(ClanWarCross ele : activeClans) {
						if(minFighting <= ele.getFighting()) {
							targetClan = ele;
							break;
						}
					}
				}
				
				if(targetClan == null && activeClans.isEmpty() && !unactiveClans.isEmpty()) {
					//给单数的最后一个将要轮空的公会匹配一个不活跃的公会
					targetClan = unactiveClans.remove(0);
				}
				
				if(targetClan != null) {
					activeClans.remove(targetClan);
					//设置双方的匹配信息
					handleOnMatchSuccess(mainInfo, mainClan, targetClan.getClanId());
					//设置主攻方
					mainClan.setMainAttack(1);
					matchedClanList.add(mainClan);
					matchedClanInfoList.add(mainInfo);
					
					ClanWarCrossInfo targetInfo = clanWarCrossInfoService.getClanWarInfo(targetClan.getClanId());
					handleOnMatchSuccess(targetInfo, targetClan, mainClan.getClanId());
					targetClan.setMainAttack(0);
					matchedClanList.add(targetClan);
					matchedClanInfoList.add(targetInfo);
					
					log.info("成功为公会{}-{}和公会{}-{}进行战斗匹配", mainClan.getClanId(), mainClan.getName(), targetClan.getClanId(), targetClan.getName());
				} else {
					//轮空
				}
			}
			
			if(!matchedClanList.isEmpty()) {
				clanWarCrossDao.add(matchedClanList);
				clanWarCrossInfoService.update(matchedClanInfoList);
				
				for(ClanWarCross clan : matchedClanList) {
					thisRoundMap.put(clan.getClanId(), clan);
				}
			}
		}
	}
	
	/**
	 * 成功匹配后的处理
	 * @param warInfo
	 * @param stageControl
	 * @param rivalClanId
	 */
	private void handleOnMatchSuccess(ClanWarCrossInfo warInfo, ClanWarCross clanWarCross, long rivalClanId) {
		// 设置对手公会ID
		clanWarCross.setTargetClanId(rivalClanId);
		// 添加已对战过的对方公会ID
		warInfo.getRivalClanIds().add(rivalClanId);
	}
}
