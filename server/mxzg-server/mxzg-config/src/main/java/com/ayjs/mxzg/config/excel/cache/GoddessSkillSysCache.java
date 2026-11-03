package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkill;

@Component
public class GoddessSkillSysCache extends BaseExcelCache<CGoddessSkill> {
    @Override
    public String getFileName() {
        return "goddessskill";
    }
    
}
