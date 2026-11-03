/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.timetower;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerReward;

/**
 * @author YY
 *
 */
@Component
public class TimeTowerRewardSysCache extends BaseExcelCache<CTimeTowerReward> {

	@Override
	public String getFileName() {
		return "timetowerreward";
	}

	public CTimeTowerReward getReward(int rank) {
		for(CTimeTowerReward config : this.getAll()) {
			if(config.getRank_max() <= rank && rank <= config.getRank_min()) {
				return config;
			}
		}
		return null;
	}
}
