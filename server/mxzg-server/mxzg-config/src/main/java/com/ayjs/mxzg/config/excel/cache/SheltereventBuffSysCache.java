package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSheltereventBuff;
import org.springframework.stereotype.Component;

@Component
public class SheltereventBuffSysCache extends BaseExcelCache<CSheltereventBuff> {


	@Override
	public String getFileName() {
		return "sheltereventbuff";
	}


}