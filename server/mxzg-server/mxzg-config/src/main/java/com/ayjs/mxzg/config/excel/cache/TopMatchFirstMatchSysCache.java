package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchFirstMatch;
import org.springframework.stereotype.Component;

/**
 * 预赛匹配
 */
@Component
public class TopMatchFirstMatchSysCache extends BaseExcelCache<CTopMatchFirstMatch> {

    @Override
    public String getFileName() {
        return "topmatchfirstmatch";
    }
}
