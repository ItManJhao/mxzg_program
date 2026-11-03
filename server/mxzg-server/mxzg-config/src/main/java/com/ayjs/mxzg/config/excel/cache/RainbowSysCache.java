/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CRainbow;

/**
 * @author YY
 *
 */
@Component
public class RainbowSysCache extends BaseExcelCache<CRainbow> {

	@Override
	public String getFileName() {
		return "rainbow";
	}
}
