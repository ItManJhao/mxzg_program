package com.ayjs.mxzg.config.excel.cache;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanSkillAbility;

@Component
public class ClanSkillAbilitySysCache extends BaseExcelCache<CClanSkillAbility> {

	private Map<Integer, Map<Integer, CClanSkillAbility>> jobAttrMap;

	@Override
	public String getFileName() {
		return "clanskillability";
	}

	@Override
	protected void loadAfterReady() {
		this.jobAttrMap = this.fillTwoLayerMap(CClanSkillAbility::getOccupation, CClanSkillAbility::getType);
	}
	
	public CClanSkillAbility getByJobAttr(int job, int type) {
		Map<Integer, CClanSkillAbility> attrMap = jobAttrMap.get(job);
		if(attrMap == null) {
			return null;
		}
		return attrMap.get(type);
	}
}