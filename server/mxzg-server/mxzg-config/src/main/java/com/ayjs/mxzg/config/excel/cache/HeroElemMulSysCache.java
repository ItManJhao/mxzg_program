package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroElemMul;

@Component
public class HeroElemMulSysCache extends BaseExcelCache<CHeroElemMul> {


	@Override
	public String getFileName() {
		return "heroelemmul";
	}
	
	
}