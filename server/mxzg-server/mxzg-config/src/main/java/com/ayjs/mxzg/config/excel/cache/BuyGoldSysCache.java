package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGold;
import org.springframework.stereotype.Component;

@Component
public class BuyGoldSysCache extends BaseExcelCache<CBuyGold> {


	@Override
	public String getFileName() {
		return "buygold";
	}


}