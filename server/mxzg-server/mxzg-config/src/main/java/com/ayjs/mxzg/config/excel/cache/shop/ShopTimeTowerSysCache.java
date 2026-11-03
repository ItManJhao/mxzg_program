package com.ayjs.mxzg.config.excel.cache.shop;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopTimeTower;

@Component
public class ShopTimeTowerSysCache extends BaseExcelCache<CShopTimeTower> {

	@Override
	public String getFileName() {
		return "shoptimetower";
	}

}
