package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion003NewSevenDayLogin;

import org.springframework.stereotype.Component;

@Component
public class Promotion003NewSevenDayLoginSysCache extends BaseExcelCache<CPromotion003NewSevenDayLogin> {

	@Override
	public String getFileName() {
		return "promotionnew7daylogin";
	}


}