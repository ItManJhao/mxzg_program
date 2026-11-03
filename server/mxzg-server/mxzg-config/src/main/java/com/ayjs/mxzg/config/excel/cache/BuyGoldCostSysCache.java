package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGoldCost;
import org.springframework.stereotype.Component;

@Component
public class BuyGoldCostSysCache extends BaseExcelCache<CBuyGoldCost> {


	@Override
	public String getFileName() {
		return "buygoldcost";
	}


}