/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.shop;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopTalent;

/**
 * @author YY
 *
 */
@Component
public class ShopTalentSysCache extends BaseExcelCache<CShopTalent> {

	@Override
	public String getFileName() {
		return "shoptalent";
	}
}
