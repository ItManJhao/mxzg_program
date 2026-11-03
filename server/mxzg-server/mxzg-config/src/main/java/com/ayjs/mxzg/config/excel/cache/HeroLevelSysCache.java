package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroLevel;
import org.springframework.stereotype.Component;

@Component
public class HeroLevelSysCache extends BaseExcelCache<CHeroLevel> {


	@Override
	public String getFileName() {
		return "herolevel";
	}


}