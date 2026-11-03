/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CTalent;

/**
 * @author YY
 *
 */
@Component
public class TalentSysCache extends BaseExcelCache<CTalent> {

	private Map<Integer, Map<Integer, CTalent>> talentLevelMap;
	
	@Override
	public String getFileName() {
		return "talent";
	}

	@Override
	protected void loadAfterReady() {
		this.talentLevelMap = this.fillTwoLayerMap(CTalent::getSkill_type, CTalent::getLevel);
	}
	
	public CTalent getTalent(int skillType, int level) {
		Map<Integer, CTalent> levelMap = talentLevelMap.get(skillType);
		ConfigAsserts.notNull(levelMap, () -> String.format("无法加载talent表{%s}的技能数据", skillType));
		CTalent cTalent = levelMap.get(level);
		ConfigAsserts.notNull(cTalent, () -> String.format("无法加载talent表{%s}等级{%s}的技能数据", skillType, level));
		return cTalent;
	}
	
}
