package com.ayjs.mxzg.config.excel.cache.shop;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopSuperRank;
import org.springframework.stereotype.Component;

@Component
public class ShopSuperRankSysCache extends BaseExcelCache<CShopSuperRank> {

    @Override
    public String getFileName() {
        return "shopsuperrank";
    }


}