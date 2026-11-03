package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopZsjt;
import org.springframework.stereotype.Component;

@Component
public class ShopZsjtSysCashe extends BaseExcelCache<CShopZsjt> {

    @Override
    public String getFileName() {
        return "shopzsjt";
    }
}
