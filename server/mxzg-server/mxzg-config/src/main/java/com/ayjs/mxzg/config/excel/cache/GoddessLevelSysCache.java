package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessLevel;
import org.springframework.stereotype.Component;

@Component
public class GoddessLevelSysCache extends BaseExcelCache<CGoddessLevel> {


    @Override
    public String getFileName() {
        return "goddesslevel";
    }

}