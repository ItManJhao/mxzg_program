package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopcontrol;

import org.springframework.stereotype.Component;

@Component
public class ShopcontrolSysCache extends BaseExcelCache<CShopcontrol> {


	@Override
	public String getFileName() {
		return "shopcontrol";
	}


}