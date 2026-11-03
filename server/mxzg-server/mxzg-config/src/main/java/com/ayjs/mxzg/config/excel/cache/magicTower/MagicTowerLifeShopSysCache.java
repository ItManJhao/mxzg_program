package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerLifeShop;
import org.springframework.stereotype.Component;

@Component
public class MagicTowerLifeShopSysCache extends BaseExcelCache<CMagicTowerLifeShop> {
    @Override
    public String getFileName() {
        return "magictowerlifeshop";
    }
}
