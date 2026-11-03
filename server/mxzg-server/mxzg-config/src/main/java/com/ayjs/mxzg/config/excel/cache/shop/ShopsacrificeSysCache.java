package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopsacrifice;

import org.springframework.stereotype.Component;

@Component
public class ShopsacrificeSysCache extends BaseExcelCache<CShopsacrifice> {


	@Override
	public String getFileName() {
		return "shopsacrifice";
	}


}