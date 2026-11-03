package com.ayjs.mxzg.config.excel.cache.promotion070;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070MissionBoxReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion070MissionBoxRewardSysCache extends BaseExcelCache<CPromotion070MissionBoxReward> {

    @Override
    public String getFileName() {
        return "promotion070missionboxreward";
    }
}
