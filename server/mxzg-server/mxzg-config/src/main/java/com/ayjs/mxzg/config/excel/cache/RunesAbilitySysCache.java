package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CRunesAbility;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
public class RunesAbilitySysCache extends BaseExcelCache<CRunesAbility> {

	private Map<Integer, Map<Integer, CRunesAbility>> typeRareMap;
	
	@Override
	public String getFileName() {
		return "runesability";
	}

	@Override
	protected void loadAfterReady() {
		this.typeRareMap = this.fillTwoLayerMap(CRunesAbility::getType, CRunesAbility::getRare);
	}
	
	public int randomType() {
		List<Integer> list = new ArrayList<>(typeRareMap.keySet());
		return list.get(RandomUtil.rand(0, list.size()));
	}
	
	public CRunesAbility getByTypeRare(int abilityId, int rare) {
		Map<Integer, CRunesAbility> rareMap = typeRareMap.get(abilityId);
		if(rareMap == null) {
            throw new ConfigNotFoundException(String.format("CRunesAbility数据不存在abilityId:%s", abilityId));
		}
		CRunesAbility ability = rareMap.get(rare);
		if(ability == null){
            throw new ConfigNotFoundException(String.format("CRunesAbility数据不存在abilityId:%s rare:%s", abilityId, rare));
		}
		return ability;
	}
}