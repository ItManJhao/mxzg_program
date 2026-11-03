package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopprophecy;

import org.springframework.stereotype.Component;

@Component
public class ShopprophecySysCache extends BaseExcelCache<CShopprophecy> {


	@Override
	public String getFileName() {
		return "shopprophecy";
	}


}