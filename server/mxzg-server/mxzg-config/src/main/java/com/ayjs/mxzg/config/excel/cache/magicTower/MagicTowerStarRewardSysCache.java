package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerStarReward;
import org.springframework.stereotype.Repository;

/**
 * 幻魔塔星级奖励
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Repository
public class MagicTowerStarRewardSysCache extends BaseExcelCache<CMagicTowerStarReward> {
    @Override
    public String getFileName() {
        return "magictowerstarreward";
    }
}
