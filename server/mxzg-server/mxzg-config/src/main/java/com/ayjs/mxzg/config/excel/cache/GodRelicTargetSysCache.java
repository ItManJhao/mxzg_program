package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelicTarget;

/**
 * 诸神遗迹目标
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicTargetSysCache extends BaseExcelCache<CGodRelicTarget> {
    @Override
    public String getFileName() {
        return "godrelictarget";
    }
}
