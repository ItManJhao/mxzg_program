package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import org.springframework.stereotype.Component;

/**
 * 段位赛周期表
 */
@Component
public class SuperStageSysCache extends BaseExcelCache<CSuperStage> {

    @Override
    public String getFileName() {
        return "superstage";
    }

}
