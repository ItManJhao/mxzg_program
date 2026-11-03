/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanWarAllReward;

/**
 * @author YY
 *
 */
@Component
public class ClanWarAllRewardSysCache extends BaseExcelCache<CClanWarAllReward> {

	@Override
	public String getFileName() {
		return "clanwarallreward";
	}

}
