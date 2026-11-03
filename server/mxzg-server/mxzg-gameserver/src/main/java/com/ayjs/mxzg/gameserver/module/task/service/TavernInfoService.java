/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.gameserver.module.task.dao.TavernInfoDao;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.google.common.collect.Sets;

/**
 * @author YY
 *
 */
@Service
public class TavernInfoService {
	
	@Autowired
	private TavernInfoDao tavernInfoDao;
	
	public TavernInfo getTavernInfo(long rid) {
		TavernInfo info = tavernInfoDao.get(rid);
		if(info == null) {
			info = new TavernInfo();
			info.setRid(rid);
			info.setFirstRefreshStars(Sets.newHashSet());
			info.setStatus(-1);
			info.setFreeRefresh(0);
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTime());
			info.setAdventureCount(TavernConst.TAVERN_INITIAL_ITEM);
			tavernInfoDao.add(info);
		}
		boolean needUpdate = false;
		if(info.getRefreshCount() == null) {
			info.setRefreshCount(new HashMap<>());
			needUpdate = true;
		}
		if(info.getLimitRefresh() == null) {
			info.setLimitRefresh(new HashMap<>());
			needUpdate = true;
		}
		if(TimeDateUtil.getCurrentTime() > info.getDailyTime()) {
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTime());
			info.setFreeRefresh(0);
			info.setLuxuryRefresh(0);
			info.setHighRefresh(0);
			info.setGemRefresh(0);
			info.getLimitRefresh().clear();
			needUpdate = true;
		}
		if(needUpdate) {
			tavernInfoDao.update(info);
		}
		return info;
	}
	
	public void updateTavernInfo(TavernInfo info) {
		tavernInfoDao.update(info);
	}
}
