/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.shop;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopChampion;

/**
 * @author YY
 *
 */
@Component
public class ShopChampionSysCache extends BaseExcelCache<CShopChampion> {

	@Override
	public String getFileName() {
		return "shopchampion";
	}
}
