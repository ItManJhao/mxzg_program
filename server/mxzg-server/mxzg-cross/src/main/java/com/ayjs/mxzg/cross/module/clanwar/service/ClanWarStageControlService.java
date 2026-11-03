/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.ICClanWarStage;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.NextStageConfig;
import com.ayjs.mxzg.cross.module.clanwar.dao.ClanWarStageControlDao;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarStageControl;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarStage;

/**
 * @author YY
 *
 */
@Service
public class ClanWarStageControlService {

	@Autowired
	private ClanWarStageControlDao clanWarStageControlDao;
	@Autowired
	private ClanWarStageSysCache clanWarStageSysCache;
	
	public ClanWarStageControl getClanWarStage() {
		List<ClanWarStageControl> list = clanWarStageControlDao.listAll();
		ClanWarStageControl stageControl = null;
		if(list.isEmpty()) {
			stageControl = new ClanWarStageControl();
			stageControl.setRound(1);
			stageControl.setFirstRoundTime(TimeDateUtil.getSomedayZeroInt(TimeDateUtil.getCurrentTimeInt()));
			//跨服没有开服时间的定义，活动是否开放由游戏服进行决定
			NextStageConfig nextConfig = clanWarStageSysCache.getNextConfig(TimeDateUtil.getCurrentTimeInt(), 0);
			resetNewWarTime(stageControl, nextConfig);
			
			clanWarStageControlDao.add(stageControl);
		} else {
			stageControl = list.get(0);
		}
		return stageControl;
	}
	
	public void resetNewWarTime(ClanWarStageControl stageControl, NextStageConfig nextConfig) {
		ICClanWarStage nextWarStage = nextConfig.getStageConfig();
		
		stageControl.setStage(ClanWarStage.MATCH);
		stageControl.setWeekStartTime(nextConfig.getWeekZero());
		stageControl.setNextStageTime(stageControl.getWeekStartTime() + nextWarStage.getMatch_time());
		stageControl.setConfigId(nextWarStage.getIdx());
		stageControl.setRoundStartTime(TimeDateUtil.getSomedayZeroInt(stageControl.getNextStageTime()));
		stageControl.setRoundEndTime(stageControl.getRoundStartTime() + TimeDateUtil.ONEDAYINT);
	}
	
	public void update(ClanWarStageControl stageControl) {
		clanWarStageControlDao.update(stageControl);
	}
}
