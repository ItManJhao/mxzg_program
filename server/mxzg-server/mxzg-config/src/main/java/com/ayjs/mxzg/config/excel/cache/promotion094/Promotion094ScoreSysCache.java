package com.ayjs.mxzg.config.excel.cache.promotion094;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion094.CPromotion094Score;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion094ScoreSysCache extends BaseExcelCache<CPromotion094Score> {

    @Override
    public String getFileName() {
        return "promotion094score";
    }

    public CPromotion094Score getConfig() {
        return getAll().get(0);
    }
}
