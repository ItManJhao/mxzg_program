package com.ayjs.mxzg.config.excel.cache;

import java.util.List;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillLevel;

@Component
public class GoddessSkillLevelSysCache extends BaseExcelCache<CGoddessSkillLevel> {
    @Override
    public String getFileName() {
        return "goddessskilllevel";
    }
    
    /**
     * 根据羁绊id和等级获取羁绊被动数
     * @param type
     * @param level
     * @return
     */
    public CGoddessSkillLevel getByLevelOrThrow(int type, int level){
    	List<CGoddessSkillLevel> allLevel = getAll();
    	for(CGoddessSkillLevel skillLevel : allLevel){
    		if(skillLevel.getType() == type && skillLevel.getLevel() == level){
    			return skillLevel;
    		}
    	}
    	throw new ConfigNotFoundException(String.format("CGoddessSkillLevel羁绊女神技能等级表找不到id:%s,level:%s", type, level));
    }
}
