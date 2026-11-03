package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerDailyBuy;
import org.springframework.stereotype.Component;

/**
 * 幻魔塔
 *
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Component
public class MagicTowerDailyBuySysCache extends BaseExcelCache<CMagicTowerDailyBuy> {

    @Override
    public String getFileName() {
        return "magictowerdailybuy";
    }

}
