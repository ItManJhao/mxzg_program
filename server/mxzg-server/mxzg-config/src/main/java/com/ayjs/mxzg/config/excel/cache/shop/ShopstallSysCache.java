package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopstall;

import org.springframework.stereotype.Component;

@Component
public class ShopstallSysCache extends BaseExcelCache<CShopstall> {


	@Override
	public String getFileName() {
		return "shopstall";
	}


}