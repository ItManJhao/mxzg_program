package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerDailyShop;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 幻魔塔
 *
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Component
public class MagicTowerDailyShopSysCache extends BaseExcelCache<CMagicTowerDailyShop> {

    @Override
    public String getFileName() {
        return "magictowerdailyshop";
    }

}
