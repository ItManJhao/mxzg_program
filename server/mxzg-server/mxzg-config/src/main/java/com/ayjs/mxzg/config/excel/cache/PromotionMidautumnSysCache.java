package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionMidautumn;
import org.springframework.stereotype.Component;

@Component
public class PromotionMidautumnSysCache extends BaseExcelCache<CPromotionMidautumn> {


	@Override
	public String getFileName() {
		return "promotionmidautumn";
	}


}