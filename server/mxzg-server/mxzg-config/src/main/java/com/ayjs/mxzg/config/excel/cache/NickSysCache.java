/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CNick;

/**
 * @author YY
 *
 */
@Component
public class NickSysCache extends BaseExcelCache<CNick> {

	@Override
	public String getFileName() {
		return "nick";
	}

}
