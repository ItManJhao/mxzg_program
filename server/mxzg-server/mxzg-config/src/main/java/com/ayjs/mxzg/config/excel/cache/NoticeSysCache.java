/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CNotice;

/**
 * @author YY
 *
 */
@Component
public class NoticeSysCache extends BaseExcelCache<CNotice> {

	@Override
	public String getFileName() {
		return "notice";
	}
}
