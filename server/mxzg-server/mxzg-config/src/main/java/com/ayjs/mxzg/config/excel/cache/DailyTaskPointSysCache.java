package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskPoint;
import org.springframework.stereotype.Component;

@Component
public class DailyTaskPointSysCache extends BaseExcelCache<CDailyTaskPoint> {


	@Override
	public String getFileName() {
		return "dailytaskpoint";
	}


}