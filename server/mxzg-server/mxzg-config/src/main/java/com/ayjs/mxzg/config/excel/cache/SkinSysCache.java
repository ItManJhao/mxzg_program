package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSkin;

@Component
public class SkinSysCache extends BaseExcelCache<CSkin> {
	
	@Override
	public String getFileName() {
		return "skin";
	}
}