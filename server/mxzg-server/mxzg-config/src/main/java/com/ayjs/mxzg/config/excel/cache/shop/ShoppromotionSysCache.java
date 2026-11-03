package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShoppromotion;

import org.springframework.stereotype.Component;

@Component
public class ShoppromotionSysCache extends BaseExcelCache<CShoppromotion> {


	@Override
	public String getFileName() {
		return "shoppromotion";
	}


}