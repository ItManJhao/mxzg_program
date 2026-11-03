package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion060RechargeDays;
import org.springframework.stereotype.Component;

@Component
public class Promotion060RechargeDaysSysCache extends BaseExcelCache<CPromotion060RechargeDays> {

	@Override
	public String getFileName() {
		return "promotionrechargedays98";
	}
}