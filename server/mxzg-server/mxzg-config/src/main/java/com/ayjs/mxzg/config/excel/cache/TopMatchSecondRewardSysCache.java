/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondReward;
import org.springframework.stereotype.Component;


@Component
public class TopMatchSecondRewardSysCache extends BaseExcelCache<CTopMatchSecondReward> {

	@Override
	public String getFileName() {
		return "topmatchsecondreward";
	}

	
	public CTopMatchSecondReward getCrossByRank(int rank) {
		for (CTopMatchSecondReward config : getAll()) {
			if (config.getRank_low() <= rank && rank <= config.getRank_up()) {
				return config;
			}
		}
		return null;
	}
}
