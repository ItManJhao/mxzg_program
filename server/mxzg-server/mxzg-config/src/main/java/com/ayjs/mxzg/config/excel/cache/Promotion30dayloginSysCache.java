package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotion30daylogin;
import org.springframework.stereotype.Component;

@Component
public class Promotion30dayloginSysCache extends BaseExcelCache<CPromotion30daylogin> {


	@Override
	public String getFileName() {
		return "promotion30daylogin";
	}


}