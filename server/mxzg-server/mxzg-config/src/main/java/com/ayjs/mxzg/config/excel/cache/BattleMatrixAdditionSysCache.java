/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrixAddition;

/**
 * @author YY
 *
 */
@Component
public class BattleMatrixAdditionSysCache extends BaseExcelCache<CBattleMatrixAddition> {

	private Map<Integer, Map<Integer, CBattleMatrixAddition>> typePosMap;
	
	@Override
	public String getFileName() {
		return "battlematrixaddition";
	}

	@Override
	protected void loadAfterReady() {
		this.typePosMap = this.fillTwoLayerMap(CBattleMatrixAddition::getType, CBattleMatrixAddition::getPosition);
	}
	
	public Map<Integer, CBattleMatrixAddition> getMatrix(int type) {
		return typePosMap.get(type);
	}

	public Map<Integer, Map<Integer, CBattleMatrixAddition>> getAllMatrix() {
		return typePosMap;
	}
}
