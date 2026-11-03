/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.god;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentLotteryType;

/**
 * 
 * @author YY
 *
 */
@Component
public class GodEquipmentLotteryTypeSysCache extends BaseExcelCache<CGodEquipmentLotteryType> {

	@Override
	public String getFileName() {
		return "godequipmentlotterytype";
	}

	
}
