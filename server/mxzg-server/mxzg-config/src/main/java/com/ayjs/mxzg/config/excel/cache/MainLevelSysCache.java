package com.ayjs.mxzg.config.excel.cache;


import java.util.Comparator;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CMainLevel;

@Component
public class MainLevelSysCache extends BaseExcelCache<CMainLevel> {

	private int maxLevel;

	@Override
	public String getFileName() {
		return "mainlevel";
	}

	@Override
	protected void loadAfterReady() {
		maxLevel = this.getAll().stream().max(Comparator.comparingInt(CMainLevel::getLevel)).get().getLevel();
	}

	public int getMaxLevel() {
		return maxLevel;
	}
}