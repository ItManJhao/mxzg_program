package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelicStarReward;

/**
 * 诸神遗迹星级奖励
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Repository
public class GodRelicStarRewardSysCache extends BaseExcelCache<CGodRelicStarReward> {
    @Override
    public String getFileName() {
        return "godrelicstarreward";
    }
}
