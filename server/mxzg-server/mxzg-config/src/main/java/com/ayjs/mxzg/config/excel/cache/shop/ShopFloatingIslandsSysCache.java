package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopFloatingIslands;
import org.springframework.stereotype.Component;

@Component
public class ShopFloatingIslandsSysCache extends BaseExcelCache<CShopFloatingIslands> {
	@Override
	public String getFileName() {
		return "shopfloatingisland";
	}
}