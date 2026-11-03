package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEventKeyBox;
import org.springframework.stereotype.Component;

@Component
public class ShelterEventKeyBoxSysCache extends BaseExcelCache<CShelterEventKeyBox> {


	@Override
	public String getFileName() {
		return "sheltereventkeybox";
	}


}