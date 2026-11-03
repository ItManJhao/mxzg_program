/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossStage;

/**
 * @author YY
 *
 */
@Component
public class ClanWorldBossStageSysCache extends BaseExcelCache<CClanWorldBossStage> {

	private GMCClanWorldBossStage gmStage = new GMCClanWorldBossStage();
	
	@Override
	public String getFileName() {
		return "clanworldbossstage";
	}
	
	public static interface ICClanWorldBossStage {
		public int getIdx();
		public int getForecast_time();
		public int getChallenge_time();
		public int getRob_time();
		public int getSpace_time();
		public int getChallenge_cd();
		public int getMax_challenge();
		public int getRob_cd();
		public int getMax_rob();
	}
	
	public NextStageConfig getNextConfig() {
		return getNextConfig(TimeDateUtil.getCurrentTimeInt(), 0);
	}
	
	public NextStageConfig getNextConfig(int currTime, int openServerDay) {
		int zeroTime = TimeDateUtil.getSomedayZeroInt(currTime) + TimeDateUtil.ONEDAYINT * openServerDay;
		int weekZeroTime = TimeDateUtil.getSundayZeroInt();
		
		NextStageConfig nextStageConfig = new NextStageConfig();
		
		for(int i = 0; i < 100; i++) {
			int weekZero = weekZeroTime + i * TimeDateUtil.ONEDAYINT * 7;
			for(CClanWorldBossStage stage : this.getAll()) {
				if(weekZero + stage.getForecast_time() >= zeroTime) {
					nextStageConfig.setWeekZero(weekZero);
					nextStageConfig.setStageConfig(stage);
					return nextStageConfig;
				}
			}
		}
		throw new ConfigNotFoundException("未找到可用的公会世界BOSS时间配置");
	}
	
	
	public static class NextStageConfig {
		private int weekZero;
		private ICClanWorldBossStage stageConfig;
		public int getWeekZero() {
			return weekZero;
		}
		public void setWeekZero(int weekZero) {
			this.weekZero = weekZero;
		}
		public ICClanWorldBossStage getStageConfig() {
			return stageConfig;
		}
		public void setStageConfig(ICClanWorldBossStage stageConfig) {
			this.stageConfig = stageConfig;
		}
	}
	
	
	/**
	 * 使用进行GM指令的时间配置数据
	 * @author YY
	 */
	public static class GMCClanWorldBossStage implements ICClanWorldBossStage {
		@Override
		public int getIdx() {
			return 1;
		}
		@Override
		public int getForecast_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getChallenge_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getRob_time() {
			return TimeDateUtil.getCurrentTimeInt() + TimeDateUtil.ONEHOURINT - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getSpace_time() {
			return TimeDateUtil.getTomorrowZeroTimeInt() - TimeDateUtil.getWeekZeroTimeInt();
		}

		@Override
		public int getChallenge_cd() {
			return 120;
		}

		@Override
		public int getMax_challenge() {
			return 3;
		}

		@Override
		public int getRob_cd() {
			return 120;
		}

		@Override
		public int getMax_rob() {
			return 3;
		}
	}
	
	public ICClanWorldBossStage getGmStage() {
		return gmStage;
	}
	
	public NextStageConfig getNextGmConfig() {
		NextStageConfig nextStageConfig = new NextStageConfig();
		nextStageConfig.setWeekZero(TimeDateUtil.getWeekZeroTimeInt());
		nextStageConfig.setStageConfig(gmStage);
		return nextStageConfig;
	}
	
	public static void main(String[] args) {
		
		long day1_0 = TimeDateUtil.stringToTime("2019-10-14 00:00:00") / 1000;
		
		//星期二的时间
		long day1_9 = TimeDateUtil.stringToTime("2019-10-14 09:00:00") / 1000 - day1_0;
		long day1_12 = TimeDateUtil.stringToTime("2019-10-14 12:00:00") / 1000 - day1_0;
		long day1_15 = TimeDateUtil.stringToTime("2019-10-14 15:00:00") / 1000 - day1_0;
		long day3_0 = TimeDateUtil.stringToTime("2019-10-16 00:00:00") / 1000 - day1_0;
		//星期四的时间
		long day3_9 = TimeDateUtil.stringToTime("2019-10-16 09:00:00") / 1000 - day1_0;
		long day3_12 = TimeDateUtil.stringToTime("2019-10-16 12:00:00") / 1000 - day1_0;
		long day3_15 = TimeDateUtil.stringToTime("2019-10-16 15:00:00") / 1000 - day1_0;
		long day5_0 = TimeDateUtil.stringToTime("2019-10-18 00:00:00") / 1000 - day1_0;
		//星期六的时间
		long day5_9 = TimeDateUtil.stringToTime("2019-10-18 09:00:00") / 1000 - day1_0;
		long day5_12 = TimeDateUtil.stringToTime("2019-10-18 12:00:00") / 1000 - day1_0;
		long day5_15 = TimeDateUtil.stringToTime("2019-10-18 15:00:00") / 1000 - day1_0;
		long day7_24 = TimeDateUtil.stringToTime("2019-10-21 00:00:00") / 1000 - day1_0;
		
		System.out.println(day1_9 + " " + day1_12 + " " + day1_15 + " " + day3_0);
		System.out.println();
		
		System.out.println(day3_9 + " " + day3_12 + " " + day3_15 + " " + day5_0);
		System.out.println();
		
		System.out.println(day5_9 + " " + day5_12 + " " + day5_15 + " " + day7_24);
		
	}
	
	
}
