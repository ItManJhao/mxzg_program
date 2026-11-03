/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondPoint;
import org.springframework.stereotype.Component;


@Component
public class TopMatchSecondPointSysCache extends BaseExcelCache<CTopMatchSecondPoint> {

	@Override
	public String getFileName() {
		return "topmatchsecondpoint";
	}
}
