package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTowerSweep;

@Component
public class TowerSweepSysCache extends BaseExcelCache<CTowerSweep> {

	private int maxCount;

	@Override
	public String getFileName() {
		return "towersweep";
	}

	@Override
	protected void loadAfterReady() {
		maxCount = this.getAll().size();
	}

	public int getMaxCount() {
		return maxCount;
	}
}