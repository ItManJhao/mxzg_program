package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion010PrivilegeGift;

@Component
public class Promotion010PrivilegeGiftSysCache extends BaseExcelCache<CPromotion010PrivilegeGift> {

	private Map<Integer, CPromotion010PrivilegeGift> productIdMap;
	
	@Override
	public String getFileName() {
		return "promotionprivilegegift";
	}

	@Override
	protected void loadAfterReady() {
		this.productIdMap = this.fillOneLayerMap(CPromotion010PrivilegeGift::getProduction_id);
	}

	public CPromotion010PrivilegeGift getByProductId(int productId) {
		return productIdMap.get(productId);
	}
}