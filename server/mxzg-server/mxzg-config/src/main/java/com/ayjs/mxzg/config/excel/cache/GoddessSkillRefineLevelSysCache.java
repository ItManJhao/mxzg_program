package com.ayjs.mxzg.config.excel.cache;

import java.util.List;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillRefineLevel;

@Component
public class GoddessSkillRefineLevelSysCache extends BaseExcelCache<CGoddessSkillRefineLevel> {
    @Override
    public String getFileName() {
        return "goddessskillrefinelevel";
    }
    
    /**
     * 根据羁绊id和精炼等级获取羁绊精炼加成
     * @param type
     * @param level
     * @return
     */
    public CGoddessSkillRefineLevel getByLevelOrThrow(int type, int level){
    	List<CGoddessSkillRefineLevel> all = getAll();
    	for(CGoddessSkillRefineLevel skillLevel : all){
    		if(skillLevel.getType() == type && skillLevel.getSkill_level() == level){
    			return skillLevel;
    		}
    	}
    	throw new ConfigNotFoundException(String.format("CGoddessSkillRefineLevel羁绊女神技能精炼等级表找不到type:%s,level:%s", type, level));
    }
}
