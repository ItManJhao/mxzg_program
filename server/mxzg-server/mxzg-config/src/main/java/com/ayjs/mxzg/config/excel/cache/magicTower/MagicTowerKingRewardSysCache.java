package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerKingReward;
import org.springframework.stereotype.Repository;

@Repository
public class MagicTowerKingRewardSysCache extends BaseExcelCache<CMagicTowerKingReward> {
    @Override
    public String getFileName() {
        return "magictowerkingreward";
    }
}
