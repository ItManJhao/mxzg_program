package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopHero;
import org.springframework.stereotype.Component;

@Component
public class ShopSuperHeroSysCache extends BaseExcelCache<CShopHero> {

    @Override
    public String getFileName() {
        return "shopsuperhero";
    }

}
