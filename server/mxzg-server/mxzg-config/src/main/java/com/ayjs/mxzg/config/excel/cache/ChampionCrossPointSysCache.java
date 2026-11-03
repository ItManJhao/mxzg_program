/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChampionCrossPoint;

/**
 * @author YY
 *
 */
@Component
public class ChampionCrossPointSysCache extends BaseExcelCache<CChampionCrossPoint> {

	@Override
	public String getFileName() {
		return "championcrosspoint";
	}
}
