package com.ayjs.mxzg.config.excel.cache.hades;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesBuyCount;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Repository
public class HadesBuyCountSysCache extends BaseExcelCache<CHadesBuyCount> {
    @Override
    public String getFileName() {
        return "hadesbuycount";
    }
}
