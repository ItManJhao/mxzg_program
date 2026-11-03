package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeProduct;
import org.springframework.stereotype.Component;

@Component
public class SpaceTimeProductSysCache extends BaseExcelCache<CSpaceTimeProduct> {

    @Override
    public String getFileName() {
        return "spacetimeproduct";
    }

    @Override
    protected void loadAfterReady() {
        super.loadAfterReady();
    }
}
