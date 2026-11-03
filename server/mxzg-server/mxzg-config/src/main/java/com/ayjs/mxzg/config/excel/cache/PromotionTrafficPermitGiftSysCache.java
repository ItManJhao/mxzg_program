package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermitGift;


@Component
public class PromotionTrafficPermitGiftSysCache extends BaseExcelCache<CPromotionTrafficPermitGift> {

    @Override
    public String getFileName() {
        return "promotiontrafficpermitgift";
    }

}
