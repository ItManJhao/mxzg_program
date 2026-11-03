package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion011befall;

import org.springframework.stereotype.Component;

@Component
public class Promotion011befallSysCache extends BaseExcelCache<CPromotion011befall> {


	@Override
	public String getFileName() {
		return "promotionbefall";
	}


}