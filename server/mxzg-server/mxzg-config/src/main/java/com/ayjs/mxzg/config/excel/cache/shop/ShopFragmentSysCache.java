package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopFragment;
import org.springframework.stereotype.Component;

@Component
public class ShopFragmentSysCache extends BaseExcelCache<CShopFragment> {

    @Override
    public String getFileName() {
        return "shopfragment";
    }

}
