package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.CRuneSkillType;

@Component
public class RuneSkillTypeSysCache extends BaseExcelCache<CRuneSkillType> {


	private Map<Integer, List<CRuneSkillType>> levelListMap;
	
	private Map<Integer, Map<Integer, CRuneSkillType>> skillLevelMap;
	
	@Override
	public String getFileName() {
		return "runeskilltype";
	}

	@Override
	protected void loadAfterReady() {
		this.levelListMap = this.fillListMap(CRuneSkillType::getLevel);
		this.skillLevelMap = this.fillTwoLayerMap(CRuneSkillType::getSkill_id, CRuneSkillType::getLevel);
	}

	public CRuneSkillType randomOne(int level) {
		List<CRuneSkillType> list = levelListMap.get(level);
		if(list == null) {
			return null;
		}
		return DropUtil.randomDrop(list);
	}
	
	public CRuneSkillType getByIdLv(int skillId, int level) {
		Map<Integer, CRuneSkillType> levelMap = skillLevelMap.get(skillId);
		if(levelMap == null) {
			return null;
		}
		return levelMap.get(level);
	}
	
}