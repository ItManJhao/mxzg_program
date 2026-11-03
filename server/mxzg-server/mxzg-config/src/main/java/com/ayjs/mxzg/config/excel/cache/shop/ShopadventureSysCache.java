package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopadventure;

import org.springframework.stereotype.Component;

@Component
public class ShopadventureSysCache extends BaseExcelCache<CShopadventure> {


	@Override
	public String getFileName() {
		return "shopadventure";
	}


}