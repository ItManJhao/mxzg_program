/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CJewelSetType;

/**
 * @author YY
 *
 */
@Component
public class JewelSetTypeSysCache extends BaseExcelCache<CJewelSetType> {

	private Map<Integer, CJewelSetType> starMap;
	
	@Override
	public String getFileName() {
		return "jewelsettype";
	}
	
	@Override
	protected void loadAfterReady() {
		this.starMap = this.fillOneLayerMap(CJewelSetType::getStar);
	}
	
	public CJewelSetType getJewelSetType(int star) {
		return starMap.get(star);
	}

	
}
