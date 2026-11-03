package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTower;
import org.springframework.stereotype.Component;

/**
 * 幻魔塔
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class MagicTowerSysCache extends BaseExcelCache<CMagicTower> {

    @Override
    public String getFileName() {
        return "magictower";
    }
}
