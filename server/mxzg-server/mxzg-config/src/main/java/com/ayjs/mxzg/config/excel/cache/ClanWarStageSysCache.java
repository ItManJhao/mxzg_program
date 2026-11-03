/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.CClanWarStage;

/**
 * @author YY
 *
 */
@Component
public class ClanWarStageSysCache extends BaseExcelCache<CClanWarStage> {

	private GMCClanWarStage gmStage = new GMCClanWarStage();
	
	@Override
	public String getFileName() {
		return "clanwarstage";
	}
	
	public static interface ICClanWarStage {
		public int getIdx();
		public int getMatch_time();
		public int getPrepare_time();
		public int getAdjust_time();
		public int getSpace_time();
		public int getBattle_time();
		public int getNeed_active();
		public int getGrow_rate();
	}
	
	public NextStageConfig getNextConfig() {
		return getNextConfig(TimeDateUtil.getCurrentTimeInt(), 0);
	}
	
	public NextStageConfig getNextConfig(int currTime, int openServerDay) {
		int firstZero = TimeDateUtil.getSomedayZeroInt(currTime) + + TimeDateUtil.ONEDAYINT * openServerDay;
		int weekZeroTime = TimeDateUtil.getWeekZeroTimeInt();
		
		for(int i = 0; i < 100; i++) {
			int weekZero = weekZeroTime + i * TimeDateUtil.ONEDAYINT * 7;
			for(CClanWarStage stage : this.getAll()) {
				if(weekZero + stage.getMatch_time() >= firstZero) {
					NextStageConfig nextStageConfig = new NextStageConfig();
					nextStageConfig.setWeekZero(weekZero);
					nextStageConfig.setStageConfig(stage);
					return nextStageConfig;
				}
			}
		}
		throw new ConfigNotFoundException("未找到可用的公会战时间配置");
	}
	
	
	/**
	 * 用于GM测试时的时间轴配置
	 * @author YY
	 *
	 */
	public static class GMCClanWarStage implements ICClanWarStage {

		@Override
		public int getIdx() {
			return 1;
		}

		@Override
		public int getMatch_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getPrepare_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getAdjust_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getSpace_time() {
			return TimeDateUtil.getTomorrowZeroTimeInt() - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getBattle_time() {
			return TimeDateUtil.ONEMININT;
		}

		@Override
		public int getNeed_active() {
			return 0;
		}

		@Override
		public int getGrow_rate() {
			return 1000;
		}
	}
	
	public GMCClanWarStage getGmStage() {
		return gmStage;
	}
	
	public NextStageConfig getNextGmConfig() {
		NextStageConfig nextStageConfig = new NextStageConfig();
		nextStageConfig.setWeekZero(TimeDateUtil.getWeekZeroTimeInt());
		nextStageConfig.setStageConfig(gmStage);
		return nextStageConfig;
	}
	
	public static class NextStageConfig {
		private int weekZero;
		private ICClanWarStage stageConfig;
		public int getWeekZero() {
			return weekZero;
		}
		public void setWeekZero(int weekZero) {
			this.weekZero = weekZero;
		}
		public ICClanWarStage getStageConfig() {
			return stageConfig;
		}
		public void setStageConfig(ICClanWarStage stageConfig) {
			this.stageConfig = stageConfig;
		}
	}
	
	public static void main(String[] args) {
		
		long day1_0 = TimeDateUtil.stringToTime("2019-10-14 00:00:00") / 1000;
		
		//星期二的时间
		long day2_3 = TimeDateUtil.stringToTime("2019-10-15 03:00:00") / 1000 - day1_0;
		long day2_19 = TimeDateUtil.stringToTime("2019-10-15 19:00:00") / 1000 - day1_0;
		long day2_20 = TimeDateUtil.stringToTime("2019-10-15 20:00:00") / 1000 - day1_0;
		long day4_0 = TimeDateUtil.stringToTime("2019-10-17 00:00:00") / 1000 - day1_0;
		//星期四的时间
		long day4_3 = TimeDateUtil.stringToTime("2019-10-17 03:00:00") / 1000 - day1_0;
		long day4_19 = TimeDateUtil.stringToTime("2019-10-17 19:00:00") / 1000 - day1_0;
		long day4_20 = TimeDateUtil.stringToTime("2019-10-17 20:00:00") / 1000 - day1_0;
		long day6_0 = TimeDateUtil.stringToTime("2019-10-19 00:00:00") / 1000 - day1_0;
		//星期六的时间
		long day6_3 = TimeDateUtil.stringToTime("2019-10-19 03:00:00") / 1000 - day1_0;
		long day6_19 = TimeDateUtil.stringToTime("2019-10-19 19:00:00") / 1000 - day1_0;
		long day6_20 = TimeDateUtil.stringToTime("2019-10-19 20:00:00") / 1000 - day1_0;
		long day1_24 = TimeDateUtil.stringToTime("2019-10-22 00:00:00") / 1000 - day1_0;
		
		System.out.println(day2_3 + " " + day2_19 + " " + day2_20 + " " + day4_0);
		System.out.println();
		
		System.out.println(day4_3 + " " + day4_19 + " " + day4_20 + " " + day6_0);
		System.out.println();
		
		System.out.println(day6_3 + " " + day6_19 + " " + day6_20 + " " + day1_24);
		
		System.out.println(60 * 60 *24);
		
	}
}
