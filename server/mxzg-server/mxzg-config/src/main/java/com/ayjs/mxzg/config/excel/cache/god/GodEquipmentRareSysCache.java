/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.god;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRare;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentRareSysCache extends BaseExcelCache<CGodEquipmentRare> {

	@Override
	public String getFileName() {
		return "godequipmentrare";
	}

}
