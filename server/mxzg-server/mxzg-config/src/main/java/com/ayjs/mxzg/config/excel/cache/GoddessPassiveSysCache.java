package com.ayjs.mxzg.config.excel.cache;

import java.util.List;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CGoddessPassive;

@Component
public class GoddessPassiveSysCache extends BaseExcelCache<CGoddessPassive> {
    @Override
    public String getFileName() {
        return "goddesspassive";
    }
    
    /**
     * 根据羁绊id和等级获取羁绊被动数
     * @param type
     * @param level
     * @return
     */
    public CGoddessPassive getByLevelOrThrow(int type, int level){
    	List<CGoddessPassive> passives = getAll();
    	for(CGoddessPassive passive : passives){
    		if(passive.getType() == type && passive.getSkill_level() == level){
    			return passive;
    		}
    	}
    	throw new ConfigNotFoundException(String.format("CGoddessPassive羁绊女神被动表找不到type:%s,level:%s", type, level));
    }
}
