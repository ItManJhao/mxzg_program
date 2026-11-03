package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopGodequipment;
import org.springframework.stereotype.Component;

@Component
public class ShopGodequipmentSysCache extends BaseExcelCache<CShopGodequipment> {
    @Override
    public String getFileName() {
        return "shopgodequipment";
    }
}
