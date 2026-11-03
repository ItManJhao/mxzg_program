package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionNewGift;
import org.springframework.stereotype.Component;

@Component
public class PromotionNewGiftSysCache extends BaseExcelCache<CPromotionNewGift> {


	@Override
	public String getFileName() {
		return "promotionnewgift";
	}


}