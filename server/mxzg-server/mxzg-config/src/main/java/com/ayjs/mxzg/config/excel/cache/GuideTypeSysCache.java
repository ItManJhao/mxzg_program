/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGuideType;

/**
 * @author YY
 *
 */
@Component
public class GuideTypeSysCache extends BaseExcelCache<CGuideType> {

	private Map<Integer, CGuideType> intTypeMap;
	private Map<String, CGuideType> strTypeMap;
	
	@Override
	public String getFileName() {
		return "guidetype";
	}

	@Override
	protected void loadAfterReady() {
		Map<Integer, List<CGuideType>> typeMap = this.fillListMap(CGuideType::getType);
		
		Map<Integer, CGuideType> tempIntTypeMap = new HashMap<>();
		for(CGuideType cGuideType : typeMap.get(1)) {
			tempIntTypeMap.put(Integer.parseInt(cGuideType.getSubtype()), cGuideType);
		}
		intTypeMap = tempIntTypeMap;
		
		Map<String, CGuideType> tempStrTypeMap = new HashMap<>();
		for(CGuideType cGuideType : typeMap.get(2)) {
			tempStrTypeMap.put(cGuideType.getSubtype(), cGuideType);
		}
		strTypeMap = tempStrTypeMap;
	}
	
	public boolean isGuide(int subType) {
		return intTypeMap.containsKey(subType);
	}
	
	public boolean isGuide(String subType) {
		return strTypeMap.containsKey(subType);
	}
}
