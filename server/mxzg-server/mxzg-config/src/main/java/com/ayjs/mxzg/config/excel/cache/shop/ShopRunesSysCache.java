/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.shop;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopRunes;

/**
 * @author YY
 *
 */
@Component
public class ShopRunesSysCache extends BaseExcelCache<CShopRunes> {

	@Override
	public String getFileName() {
		return "shoprunes";
	}
}
