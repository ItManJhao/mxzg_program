/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import org.springframework.stereotype.Component;


@Component
public class TopMatchSecondSeasonSysCache extends BaseExcelCache<CTopMatchSecondSeason> {


	
	@Override
	public String getFileName() {
		return "topmatchsecondseason";
	}
	
	public class PinnacleNextSeason {
		private int nextStartTime;
		private CTopMatchSecondSeason seasonConfig;
		public int getNextStartTime() {
			return nextStartTime;
		}
		protected void setNextStartTime(int nextStartTime) {
			this.nextStartTime = nextStartTime;
		}
		public CTopMatchSecondSeason getSeasonConfig() {
			return seasonConfig;
		}
		protected void setSeasonConfig(CTopMatchSecondSeason seasonConfig) {
			this.seasonConfig = seasonConfig;
		}
	}


	
	public PinnacleNextSeason getCrossNextStartTime() {
		//类型2（跨服冠军赛）只有一条数据
		CTopMatchSecondSeason seasonConfig = getAll().get(0);
		
		int sundayZero = TimeDateUtil.getSundayZeroInt();
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int nextStartTime = 0;
		for(int i = 0; i < 1000; i++) {
			nextStartTime = sundayZero + TimeDateUtil.ONEWEEKINT * i;
//		//TODO 正式服测试阶段两日一次
//		for(int i = 0; i < 100; i++) {
//			nextStartTime = sundayZero + TimeDateUtil.ONEDAYINT * 2 * i;
			int nextTime = nextStartTime + seasonConfig.getStart_time();
			if(nextTime > nowTime) {
				break;
			}
		}

		PinnacleNextSeason nextSeason = new PinnacleNextSeason();
		nextSeason.setNextStartTime(nextStartTime);
		nextSeason.setSeasonConfig(seasonConfig);
		return nextSeason;
	}
	
	public CTopMatchSecondSeason getCrossSeason() {
		return getAll().get(0);
	}
	
}
