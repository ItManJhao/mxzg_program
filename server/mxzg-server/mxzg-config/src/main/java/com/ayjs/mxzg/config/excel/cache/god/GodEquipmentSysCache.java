/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.god;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipment;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentSysCache extends BaseExcelCache<CGodEquipment> {

	@Override
	public String getFileName() {
		return "godequipment";
	}
	
	
}
