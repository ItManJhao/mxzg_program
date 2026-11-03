package com.ayjs.mxzg.config.excel.cache.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093Scenic;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/3/22
 **/
@Component
public class Promotion093ScenicSysCache extends BaseExcelCache<CPromotion093Scenic> {
    @Override
    public String getFileName() {
        return "promotion093scenic";
    }
}
