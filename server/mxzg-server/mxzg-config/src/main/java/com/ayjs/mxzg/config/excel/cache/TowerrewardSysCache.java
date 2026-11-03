package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTowerreward;
import org.springframework.stereotype.Component;

@Component
public class TowerrewardSysCache extends BaseExcelCache<CTowerreward> {


	@Override
	public String getFileName() {
		return "towerreward";
	}


}