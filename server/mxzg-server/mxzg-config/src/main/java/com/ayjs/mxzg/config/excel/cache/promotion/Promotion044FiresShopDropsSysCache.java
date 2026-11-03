package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion044FiresShopDrops;
import org.springframework.stereotype.Component;

@Component
public class Promotion044FiresShopDropsSysCache extends BaseExcelCache<CPromotion044FiresShopDrops> {

    @Override
    public String getFileName() {
        return "promotionfiredrops";
    }

}