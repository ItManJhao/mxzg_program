package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShoppvpnormal;

import org.springframework.stereotype.Component;

@Component
public class ShoppvpnormalSysCache extends BaseExcelCache<CShoppvpnormal> {


	@Override
	public String getFileName() {
		return "shoppvpnormal";
	}


}