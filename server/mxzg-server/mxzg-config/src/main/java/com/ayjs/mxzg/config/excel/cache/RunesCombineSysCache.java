package com.ayjs.mxzg.config.excel.cache;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CRunesCombine;

@Component
public class RunesCombineSysCache extends BaseExcelCache<CRunesCombine> {

	private Map<Integer, CRunesCombine> typeMap;
	
	@Override
	public String getFileName() {
		return "runescombine";
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = this.fillOneLayerMap(CRunesCombine::getType);
	}
	
	public CRunesCombine getByType(int type) {
		return typeMap.get(type);
	}
}