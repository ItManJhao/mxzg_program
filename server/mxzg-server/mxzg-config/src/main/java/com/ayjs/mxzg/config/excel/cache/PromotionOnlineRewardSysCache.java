package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionOnlineReward;
import org.springframework.stereotype.Component;

@Component
public class PromotionOnlineRewardSysCache extends BaseExcelCache<CPromotionOnlineReward> {


	@Override
	public String getFileName() {
		return "promotiononlinereward";
	}


}