/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpTimesReward;

/**
 * @author YY
 *
 */
@Component
public class PvpTimesRewardSysCache extends BaseExcelCache<CPvpTimesReward> {

	@Override
	public String getFileName() {
		return "pvptimesreward";
	}
}
