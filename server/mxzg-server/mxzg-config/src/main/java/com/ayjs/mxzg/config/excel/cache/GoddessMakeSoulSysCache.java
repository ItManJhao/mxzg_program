package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessMakeSoul;
import org.springframework.stereotype.Component;

/**
 * 羁绊铸魂
 * @author hyx
 */
@Component
public class GoddessMakeSoulSysCache extends BaseExcelCache<CGoddessMakeSoul> {

    @Override
    public String getFileName() {
        return "goddessmakesoul";
    }
}
