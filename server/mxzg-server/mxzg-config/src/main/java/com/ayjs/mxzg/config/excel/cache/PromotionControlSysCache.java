/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionControl;

/**
 * @author YY
 *
 */
@Component
public class PromotionControlSysCache extends BaseExcelCache<CPromotionControl> {

	@Override
	public String getFileName() {
		return "promotioncontrol";
	}
}
