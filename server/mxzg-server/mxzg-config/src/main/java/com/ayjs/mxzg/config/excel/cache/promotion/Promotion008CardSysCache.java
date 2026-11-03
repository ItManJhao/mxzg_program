package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion008Card;

import org.springframework.stereotype.Component;

@Component
public class Promotion008CardSysCache extends BaseExcelCache<CPromotion008Card> {


	@Override
	public String getFileName() {
		return "promotioncard";
	}


}