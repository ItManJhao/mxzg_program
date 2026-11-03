package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion001FirstRechargeReward;
import org.springframework.stereotype.Component;

@Component
public class Promotion001FirstRechargeRewardSysCache extends BaseExcelCache<CPromotion001FirstRechargeReward> {


	@Override
	public String getFileName() {
		return "promotionfirstrechargereward";
	}


}