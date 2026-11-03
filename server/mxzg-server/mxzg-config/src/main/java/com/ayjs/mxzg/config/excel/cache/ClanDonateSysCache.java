package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanDonate;
import org.springframework.stereotype.Component;

@Component
public class ClanDonateSysCache extends BaseExcelCache<CClanDonate> {


	@Override
	public String getFileName() {
		return "clandonate";
	}


}