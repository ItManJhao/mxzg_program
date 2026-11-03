package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessReset;

@Component
public class GoddessResetSysCache extends BaseExcelCache<CGoddessReset> {
    @Override
    public String getFileName() {
        return "goddessreset";
    }
}
