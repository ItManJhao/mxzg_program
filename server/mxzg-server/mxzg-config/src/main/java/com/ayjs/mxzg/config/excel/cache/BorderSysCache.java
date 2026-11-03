package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBorder;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Component
public class BorderSysCache extends BaseExcelCache<CBorder> {
    @Override
    public String getFileName() {
        return "border";
    }
}
