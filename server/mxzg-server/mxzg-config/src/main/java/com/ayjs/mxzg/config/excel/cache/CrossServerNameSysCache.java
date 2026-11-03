/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CCrossServerName;

/**
 * @author YY
 *
 */
@Component
public class CrossServerNameSysCache extends BaseExcelCache<CCrossServerName> {

	private Map<Integer, Map<Integer, CCrossServerName>> platformMap;
	
	@Override
	public String getFileName() {
		return "crossservername";
	}


	@Override
	protected void loadAfterReady() {
		this.platformMap = this.fillTwoLayerMap(CCrossServerName::getPlatform_id, CCrossServerName::getPlatform_son_id);
	}

	public int getByPlatform(int platformId, int platformSonId) {
		Map<Integer, CCrossServerName> map = platformMap.get(platformId);
		if(map == null) {
			return 1000;
		}
		CCrossServerName config = map.get(platformSonId);
		if(config == null) {
			return 1000;
		}
		return config.getServer_id_difference();
	}
	
}
