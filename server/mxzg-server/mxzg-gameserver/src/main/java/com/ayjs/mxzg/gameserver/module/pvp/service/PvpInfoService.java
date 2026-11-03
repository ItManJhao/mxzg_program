/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.service;

import java.util.ArrayList;
import java.util.HashSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.pvp.dao.PvpInfoDao;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpInfo;

/**
 * @author YY
 *
 */
@Service
public class PvpInfoService {

	@Autowired
	private PvpInfoDao pvpInfoDao;
	@Autowired
	private PvpSysInfoService pvpSysInfoService;
	
	public PvpInfo getPvpInfo(long rid) {
		PvpInfo info = pvpInfoDao.get(rid);
		if(info == null) {
			info = new PvpInfo();
			info.setRid(rid);
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			info.setRecords(new ArrayList<>());
			info.setOtherRids(new HashSet<>());
			info.setRobotIds(new HashSet<>());
			pvpInfoDao.add(info);
		}
		boolean needUpdate = false;
		if(info.getSeasonReward() == null) {
			info.setSeasonReward(new HashSet<>());
			needUpdate = true;
		}
		if(info.getLikeRids() == null) {
			info.setLikeRids(new HashSet<>());
			needUpdate = true;
		}
		if(TimeDateUtil.getCurrentTimeInt() > info.getDailyTime()) {
			info.setNum(0);
			info.getLikeRids().clear();
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			needUpdate = true;
		}
		if(pvpSysInfoService.getNextPvpTime() > info.getSeasonTime()) {
			info.setSeasonCount(0);
			info.getSeasonReward().clear();
			info.setSeasonTime(pvpSysInfoService.getNextPvpTime());
			needUpdate = true;
		}
		if(needUpdate) {
			pvpInfoDao.update(info);
		}
		return info;
	}
	
	public void updatePvpInfo(PvpInfo info) {
		pvpInfoDao.update(info);
	}
}
