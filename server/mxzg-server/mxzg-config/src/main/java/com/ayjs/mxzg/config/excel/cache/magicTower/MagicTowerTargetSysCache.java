package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerTarget;
import org.springframework.stereotype.Component;

/**
 * 幻魔塔目标
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class MagicTowerTargetSysCache extends BaseExcelCache<CMagicTowerTarget> {
    @Override
    public String getFileName() {
        return "magictowertarget";
    }
}
