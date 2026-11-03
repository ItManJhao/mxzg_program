package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBuyTime;
import org.springframework.stereotype.Component;

@Component
public class BuyTimeSysCache extends BaseExcelCache<CBuyTime> {


	@Override
	public String getFileName() {
		return "buytime";
	}


}