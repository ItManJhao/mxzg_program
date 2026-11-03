/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.god;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentSettype;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentSettypeSysCache extends BaseExcelCache<CGodEquipmentSettype> {

	//<套装ID，<星级，<需求件数，数据>>>
	private Map<Integer, Map<Integer, Map<Integer, CGodEquipmentSettype>>> attrIndexMap;
	
	@Override
	public String getFileName() {
		return "godequipmentsettype";
	}

	@Override
	protected void loadAfterReady() {
		Map<Integer, Map<Integer, Map<Integer, CGodEquipmentSettype>>> tempAttrIndexMap = new HashMap<>();
		for(CGodEquipmentSettype config : this.getAll()) {
			Map<Integer, Map<Integer, CGodEquipmentSettype>> starMap = tempAttrIndexMap.get(config.getSettype());
			if(starMap == null) {
				starMap = new HashMap<>();
				tempAttrIndexMap.put(config.getSettype(), starMap);
			}
			Map<Integer, CGodEquipmentSettype> numMap = starMap.get(config.getStar());
			if(numMap == null) {
				numMap = new HashMap<>();
				starMap.put(config.getStar(), numMap);
			}
			numMap.put(config.getNum(), config);
		}
		attrIndexMap = tempAttrIndexMap;
	}

	public List<CGodEquipmentSettype> getAbility(int setType, int star, int num) {
		Map<Integer, Map<Integer, CGodEquipmentSettype>> starMap = attrIndexMap.get(setType);
		if(starMap == null) {
			return Collections.emptyList();
		}
		Map<Integer, CGodEquipmentSettype> numMap = starMap.get(star);
		if(numMap == null) {
			return Collections.emptyList();
		}
		return IntStream.rangeClosed(1, num).mapToObj(numMap::get).filter(Objects::nonNull).collect(Collectors.toList());
	}
}
