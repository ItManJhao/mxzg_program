package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTimeLimitItem;
import org.springframework.stereotype.Component;

@Component
public class TimeLimitItemSysCache extends BaseExcelCache<CTimeLimitItem> {

    @Override
    public String getFileName() {
        return "timelimititem";
    }
}
