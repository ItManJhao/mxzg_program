package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion049RechargeDays;

import org.springframework.stereotype.Component;

@Component
public class Promotion049RechargeDaysSysCache extends BaseExcelCache<CPromotion049RechargeDays> {

	@Override
	public String getFileName() {
		return "promotionrechargedays";
	}
}