package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpDaiLyReward;
import org.springframework.stereotype.Component;

@Component
public class PvpDailyRewardSysCache extends BaseExcelCache<CPvpDaiLyReward> {

	private int maxRank;

	@Override
	public String getFileName() {
		return "pvpdailyreward";
	}

	public CPvpDaiLyReward getReward(int rank) {
		if(rank <= 0) return null;
		for(CPvpDaiLyReward reward : this.getAll()) {
			if(rank <= reward.getRank()) {
				return reward;
			}
		}
		return null;
	}

	@Override
	protected void loadAfterReady() {
		int tempMaxRank = 0;
		for(CPvpDaiLyReward reward : this.getAll()) {
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