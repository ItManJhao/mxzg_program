package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import org.springframework.stereotype.Component;

@Component
public class HeroStarSysCache extends BaseExcelCache<CHeroStar> {


	@Override
	public String getFileName() {
		return "herostar";
	}


}