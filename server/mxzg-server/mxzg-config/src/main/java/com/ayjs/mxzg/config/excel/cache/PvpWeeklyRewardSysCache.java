package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpWeekLyReward;

@Component
public class PvpWeeklyRewardSysCache extends BaseExcelCache<CPvpWeekLyReward> {

	private int maxRank;
	
	@Override
	public String getFileName() {
		return "pvpweeklyreward";
	}

	public CPvpWeekLyReward getReward(int rank) {
		if(rank <= 0) return null;
		for(CPvpWeekLyReward reward : this.getAll()) {
			if(rank <= reward.getRank()) {
				return reward;
			}
		}
		return null;
	}

	@Override
	protected void loadAfterReady() {
		int tempMaxRank = 0;
		for(CPvpWeekLyReward reward : this.getAll()) {
			if(reward.getRank() > tempMaxRank) {
				tempMaxRank = reward.getRank();
			}
		}
		maxRank = tempMaxRank;
	}

	public int getMaxRank() {
		return maxRank;
	}
}