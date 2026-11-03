package com.ayjs.mxzg.config.excel.cache.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsRankReward;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsRankRewardSysCache extends BaseExcelCache<CFloatingIslandsRankReward> {
    @Override
    public String getFileName() {
        return "floatingislandsrankreward";
    }
}
