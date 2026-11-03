package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterShopPrize;
import org.springframework.stereotype.Component;

@Component
public class ShelterShopPrizeSysCache extends BaseExcelCache<CShelterShopPrize> {


	@Override
	public String getFileName() {
		return "sheltershopprize";
	}


}