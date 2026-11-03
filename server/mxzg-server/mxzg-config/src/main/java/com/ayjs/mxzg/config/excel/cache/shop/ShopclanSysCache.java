package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopclan;

import org.springframework.stereotype.Component;

@Component
public class ShopclanSysCache extends BaseExcelCache<CShopclan> {


	@Override
	public String getFileName() {
		return "shopclan";
	}


}