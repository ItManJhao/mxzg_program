/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDragonRelic;

/**
 * @author YY
 *
 */
@Component
public class DragonRelicSysCache extends BaseExcelCache<CDragonRelic> {

	@Override
	public String getFileName() {
		return "dragonrelic";
	}

}
