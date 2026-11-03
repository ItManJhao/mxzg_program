package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopMakeEgg;
import org.springframework.stereotype.Component;

@Component
public class ShopMakeEggSysCache extends BaseExcelCache<CShopMakeEgg> {

    @Override
    public String getFileName() {
        return "shopmakeegg";
    }


}