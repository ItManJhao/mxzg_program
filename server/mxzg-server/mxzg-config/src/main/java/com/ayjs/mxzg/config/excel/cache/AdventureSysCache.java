package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAdventure;

@Component
public class AdventureSysCache extends BaseExcelCache<CAdventure> {

	private Map<Integer, List<CAdventure>> missionMap;

	@Override
	public String getFileName() {
		return "adventure";
	}

	@Override
	protected void loadAfterReady() {
		this.missionMap = this.fillListMap(CAdventure::getMission_id);
	}

	public Map<Integer, List<CAdventure>> getMissionMap() {
		return missionMap;
	}
}