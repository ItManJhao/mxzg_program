package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionFoundAtion;
import org.springframework.stereotype.Component;

@Component
public class PromotionFoundAtionSysCache extends BaseExcelCache<CPromotionFoundAtion> {


	@Override
	public String getFileName() {
		return "promotionfoundation";
	}


}