package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopFashion;
import org.springframework.stereotype.Component;

/**
 * 皮肤（时装）商店
 *
 * @author hyx
 */
@Component
public class ShopFashionSysCache extends BaseExcelCache<CShopFashion> {


    @Override
    public String getFileName() {
        return "shopfashion";
    }
}
