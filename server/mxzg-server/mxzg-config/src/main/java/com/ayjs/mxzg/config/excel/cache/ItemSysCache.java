/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CItem;

/**
 * @author YY
 *
 */
@Component
public class ItemSysCache extends BaseExcelCache<CItem> {

	@Override
	public String getFileName() {
		return "item";
	}
}
