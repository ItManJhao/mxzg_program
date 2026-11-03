package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CItemBoxChance;
import org.springframework.stereotype.Component;

@Component
public class ItemBoxChanceSysCache extends BaseExcelCache<CItemBoxChance> {


	@Override
	public String getFileName() {
		return "itemboxchance";
	}


}