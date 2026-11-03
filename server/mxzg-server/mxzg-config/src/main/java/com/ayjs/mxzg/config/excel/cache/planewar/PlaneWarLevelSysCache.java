package com.ayjs.mxzg.config.excel.cache.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarLevel;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarLevelSysCache extends BaseExcelCache<CPlaneWarLevel> {

    @Override
    public String getFileName() {
        return "planewarlevel";
    }
}
