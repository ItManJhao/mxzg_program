/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CItemHero;

/**
 * @author YY
 *
 */
@Component
public class ItemHeroSysCache extends BaseExcelCache<CItemHero> {

	@Override
	public String getFileName() {
		return "itemhero";
	}
}
