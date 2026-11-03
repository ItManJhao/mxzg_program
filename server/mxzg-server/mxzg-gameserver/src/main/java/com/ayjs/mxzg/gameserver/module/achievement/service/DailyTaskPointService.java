///**
// *
// */
//package com.ayjs.mxzg.gameserver.module.achievement.service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import com.ayjs.mxzg.common.util.time.TimeDateUtil;
//import com.ayjs.mxzg.gameserver.module.achievement.dao.DailyTaskPointDao;
//import com.ayjs.mxzg.gameserver.module.achievement.domain.DailyTaskPoint;
//
///**
// * @author YY
// *
// */
//@Service
//public class DailyTaskPointService {
//
//	@Autowired
//	private DailyTaskPointDao dailyTaskPointDao;
//
//	public DailyTaskPoint getDailyTaskPoint(long rid) {
//		DailyTaskPoint info = dailyTaskPointDao.get(rid);
//		if(info == null) {
//			info = new DailyTaskPoint();
//			info.setRid(rid);
//			dailyTaskPointDao.add(info);
//		}
//		if(TimeDateUtil.getCurrentTime() > info.getDailyTime()) {
//			info.setDailyTime(TimeDateUtil.getTomorrowZeroTime());
//			info.setPoint(0);
//			dailyTaskPointDao.update(info);
//		}
//		return info;
//	}
//
//	public void updateDailyTaskPoint(DailyTaskPoint info) {
//		dailyTaskPointDao.update(info);
//	}
//}
