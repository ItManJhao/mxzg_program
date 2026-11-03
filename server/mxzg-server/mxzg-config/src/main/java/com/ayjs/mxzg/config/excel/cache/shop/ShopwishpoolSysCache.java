package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopwishpool;

import org.springframework.stereotype.Component;

@Component
public class ShopwishpoolSysCache extends BaseExcelCache<CShopwishpool> {


	@Override
	public String getFileName() {
		return "shopwishpool";
	}


}