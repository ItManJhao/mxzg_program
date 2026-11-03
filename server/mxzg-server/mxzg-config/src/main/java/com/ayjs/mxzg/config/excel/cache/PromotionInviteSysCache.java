package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionInvite;
import org.springframework.stereotype.Component;

@Component
public class PromotionInviteSysCache extends BaseExcelCache<CPromotionInvite> {


	@Override
	public String getFileName() {
		return "promotioninvite";
	}


}