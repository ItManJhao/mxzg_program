/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CXing;

/**
 * @author YY
 *
 */
@Component
public class XingSysCache extends BaseExcelCache<CXing> {

	@Override
	public String getFileName() {
		return "xing";
	}

}
