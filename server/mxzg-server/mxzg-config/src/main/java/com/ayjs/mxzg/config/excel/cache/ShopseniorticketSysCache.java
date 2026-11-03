package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShopseniorticket;

import org.springframework.stereotype.Component;

@Component
public class ShopseniorticketSysCache extends BaseExcelCache<CShopseniorticket> {


	@Override
	public String getFileName() {
		return "shopseniorticket";
	}


}