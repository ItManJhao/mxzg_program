/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;

/**
 * @author YY
 *
 */
@Component
public class OpenConditionSysCache extends BaseExcelCache<COpenCondition> {

	
	private Map<String, COpenCondition> conditionMap;
	
	@Override
	public String getFileName() {
		return "opencondition";
	}

	@Override
	protected void loadAfterReady() {
		this.conditionMap = this.fillOneLayerMap(COpenCondition::getAtom);
	}
	
	public COpenCondition getCondition(String entryType) {
		return conditionMap.get(entryType);
	}
}
