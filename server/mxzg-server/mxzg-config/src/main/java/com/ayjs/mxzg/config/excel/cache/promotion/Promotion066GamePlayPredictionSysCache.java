package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion066GamePlayPrediction;
import org.springframework.stereotype.Component;

/**
 * 功能预告活动
 * @author hyx
 */
@Component
public class Promotion066GamePlayPredictionSysCache extends BaseExcelCache<CPromotion066GamePlayPrediction> {

    @Override
    public String getFileName() {
        return "promotiongameplayprediction";
    }
}
