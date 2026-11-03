/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDragonRemains;

/**
 * @author YY
 *
 */
@Component
public class DragonRemainsSysCache extends BaseExcelCache<CDragonRemains> {

	private Map<Integer, Map<Integer, CDragonRemains>> typeLevelMap;
	
	@Override
	public String getFileName() {
		return "dragonremains";
	}

	@Override
	protected void loadAfterReady() {
		this.typeLevelMap = this.fillTwoLayerMap(CDragonRemains::getType, CDragonRemains::getLevel);
	}
	
	public CDragonRemains getIdentityRemains(int level) {
		Map<Integer, CDragonRemains> levelMap = typeLevelMap.get(1);
		return levelMap.get(level);
	}
	
	public CDragonRemains getSpeedRemains(int level) {
		Map<Integer, CDragonRemains> levelMap = typeLevelMap.get(2);
		return levelMap.get(level);
	}
}
