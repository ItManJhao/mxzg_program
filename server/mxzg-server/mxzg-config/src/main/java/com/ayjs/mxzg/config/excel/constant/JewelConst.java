/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;

/**
 * @author YY
 *
 */
@Component
public class JewelConst extends ExcelDictionaryCache {
	
	public static Map<Integer, Integer> OPEN_STAR = new HashMap<>();
	
	@Override
	protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
		Map<Integer, Integer> tempOpenStar = new HashMap<>();
		String openStar = map.get("jewel_single_open_star").getValue();
		String[] openStarCondition = openStar.split(";");
		for(String temp : openStarCondition) {
			if(temp == null || "".equals(temp)) {
				continue;
			}
			String[] stars = temp.split("_");
			tempOpenStar.put(Integer.parseInt(stars[0]), Integer.parseInt(stars[1]));
		}
		OPEN_STAR = tempOpenStar;
	}
}
