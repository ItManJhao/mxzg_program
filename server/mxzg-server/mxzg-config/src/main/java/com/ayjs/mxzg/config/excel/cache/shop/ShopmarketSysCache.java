package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopmarket;

import org.springframework.stereotype.Component;

@Component
public class ShopmarketSysCache extends BaseExcelCache<CShopmarket> {


	@Override
	public String getFileName() {
		return "shopmarket";
	}


}