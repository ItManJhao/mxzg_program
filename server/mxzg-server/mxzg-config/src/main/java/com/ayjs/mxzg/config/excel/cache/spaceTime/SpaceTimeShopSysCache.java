package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeShop;
import org.springframework.stereotype.Component;

@Component
public class SpaceTimeShopSysCache extends BaseExcelCache<CSpaceTimeShop> {

    @Override
    public String getFileName() {
        return "spacetimeshop";
    }
}
