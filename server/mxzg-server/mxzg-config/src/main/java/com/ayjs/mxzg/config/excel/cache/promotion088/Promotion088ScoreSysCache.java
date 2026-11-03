package com.ayjs.mxzg.config.excel.cache.promotion088;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion088.CPromotion088Score;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion088ScoreSysCache extends BaseExcelCache<CPromotion088Score> {

    @Override
    public String getFileName() {
        return "promotion088score";
    }

    public CPromotion088Score getConfig() {
        return getAll().get(0);
    }
}
