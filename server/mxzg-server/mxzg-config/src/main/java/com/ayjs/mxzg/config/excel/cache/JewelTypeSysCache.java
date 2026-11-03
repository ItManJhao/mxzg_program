/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CJewelType;

/**
 * @author YY
 *
 */
@Component
public class JewelTypeSysCache extends BaseExcelCache<CJewelType> {

	private Map<Integer, List<CJewelType>> placeJewelMap;
	
	@Override
	public String getFileName() {
		return "jeweltype";
	}

	@Override
	protected void loadAfterReady() {
		this.placeJewelMap = this.fillListMap(CJewelType::getPlace);
	}

	public List<CJewelType> getPlaceJewels(int place) {
		return placeJewelMap.get(place);
	}
}
