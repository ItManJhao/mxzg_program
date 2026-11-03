package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEventStone;
import org.springframework.stereotype.Component;

@Component
public class ShelterEventStoneSysCache extends BaseExcelCache<CShelterEventStone> {


	@Override
	public String getFileName() {
		return "sheltereventstone";
	}


}