package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessBreak;
import org.springframework.stereotype.Component;

@Component
public class GoddessBreakSysCache extends BaseExcelCache<CGoddessBreak> {


	@Override
	public String getFileName() {
		return "goddessbreak";
	}


}