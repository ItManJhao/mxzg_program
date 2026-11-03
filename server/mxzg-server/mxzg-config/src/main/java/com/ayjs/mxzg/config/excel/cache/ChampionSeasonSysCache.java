/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;

/**
 * @author YY
 *
 */
@Component
public class ChampionSeasonSysCache extends BaseExcelCache<CChampionSeason> {

	private Map<Integer, List<CChampionSeason>> typeMap;
	
	@Override
	public String getFileName() {
		return "championseason";
	}
	
	
	
	public class ChampionNextSeason {
		private int nextStartTime;
		private CChampionSeason seasonConfig;
		public int getNextStartTime() {
			return nextStartTime;
		}
		protected void setNextStartTime(int nextStartTime) {
			this.nextStartTime = nextStartTime;
		}
		public CChampionSeason getSeasonConfig() {
			return seasonConfig;
		}
		protected void setSeasonConfig(CChampionSeason seasonConfig) {
			this.seasonConfig = seasonConfig;
		}
	}
	
	public ChampionNextSeason getNextStartTime(int seasonStartTime) {
		int seasonZero = TimeDateUtil.getSomedayZeroInt(seasonStartTime);
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		int nextStartTime = 0;
		List<CChampionSeason> seasonConfigs = this.typeMap.get(1);
		for(int i = 0; i < 100; i++) {
			for(CChampionSeason cChampionSeason : seasonConfigs) {
				nextStartTime = seasonZero + TimeDateUtil.ONEDAYINT * 7 * i
						+ TimeDateUtil.ONEDAYINT * cChampionSeason.getStart_day();
				int startTime = nextStartTime + cChampionSeason.getStart_time();
				if (startTime > nowTime) {
					ChampionNextSeason nextSeason = new ChampionNextSeason();
					nextSeason.setNextStartTime(nextStartTime);
					nextSeason.setSeasonConfig(cChampionSeason);
					//3、6的晚上21点开始
					return nextSeason;
				}
			}
		}
		return null;
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = this.fillListMap(CChampionSeason::getType);
	}
	
	public ChampionNextSeason getCrossNextStartTime() {
		//类型2（跨服冠军赛）只有一条数据
		CChampionSeason seasonConfig = this.typeMap.get(2).get(0);
		
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
		
		ChampionNextSeason nextSeason = new ChampionNextSeason();
		nextSeason.setNextStartTime(nextStartTime);
		nextSeason.setSeasonConfig(seasonConfig);
		return nextSeason;
	}
	
	public CChampionSeason getCrossSeason() {
		return this.typeMap.get(2).get(0);
	}
	
}
