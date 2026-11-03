/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.shop;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopDay;

/**
 * @author YY
 *
 */
@Component
public class ShopDaySysCache extends BaseExcelCache<CShopDay> {

	@Override
	public String getFileName() {
		return "shopday";
	}
}
