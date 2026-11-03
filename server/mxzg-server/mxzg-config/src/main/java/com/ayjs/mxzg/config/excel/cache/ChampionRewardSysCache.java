/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChampionReward;

/**
 * @author YY
 *
 */
@Component
public class ChampionRewardSysCache extends BaseExcelCache<CChampionReward> {

	private Map<Integer, List<CChampionReward>> typeMap;
	
	@Override
	public String getFileName() {
		return "championreward";
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = this.fillListMap(CChampionReward::getReward_rank_type);
	}
	
	public CChampionReward getByRank(int rank) {
		for (CChampionReward config : typeMap.get(0)) {
			if (config.getRank_low() <= rank && rank <= config.getRank_up()) {
				return config;
			}
		}
		return null;
	}
	
	public CChampionReward getCrossByRank(int rank) {
		for (CChampionReward config : typeMap.get(1)) {
			if (config.getRank_low() <= rank && rank <= config.getRank_up()) {
				return config;
			}
		}
		return null;
	}
}
