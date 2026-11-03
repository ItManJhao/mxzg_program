package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopDifferentWorld;
import org.springframework.stereotype.Component;

@Component
public class ShopDifferentWorldSysCache extends BaseExcelCache<CShopDifferentWorld> {

    @Override
    public String getFileName() {
        return "shopdifferentworld";
    }
}
