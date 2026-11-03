package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelicUnlock;

/**
 * 诸神遗迹
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicUnlockSysCache extends BaseExcelCache<CGodRelicUnlock> {

    @Override
    public String getFileName() {
        return "godrelicunlock";
    }
}
