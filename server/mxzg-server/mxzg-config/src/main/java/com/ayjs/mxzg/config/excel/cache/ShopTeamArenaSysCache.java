package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopTeamArena;
import org.springframework.stereotype.Component;

/**
 * 组队竞技场商店
 */
@Component
public class ShopTeamArenaSysCache extends BaseExcelCache<CShopTeamArena> {
    @Override
    public String getFileName() {
        return "shopteamarena";
    }
}
