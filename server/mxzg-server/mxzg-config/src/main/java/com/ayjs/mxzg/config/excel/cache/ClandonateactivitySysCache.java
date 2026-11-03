package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClandonateactivity;
import org.springframework.stereotype.Component;

@Component
public class ClandonateactivitySysCache extends BaseExcelCache<CClandonateactivity> {


	@Override
	public String getFileName() {
		return "clandonateactivity";
	}


}