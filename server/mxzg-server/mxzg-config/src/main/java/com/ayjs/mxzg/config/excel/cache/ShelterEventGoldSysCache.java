package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEventGold;
import org.springframework.stereotype.Component;

@Component
public class ShelterEventGoldSysCache extends BaseExcelCache<CShelterEventGold> {


	@Override
	public String getFileName() {
		return "sheltereventgold";
	}


}