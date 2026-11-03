package com.ayjs.mxzg.config.excel.cache.promotion081;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081MissionBoxReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion081MissionBoxRewardSysCache extends BaseExcelCache<CPromotion081MissionBoxReward> {

    @Override
    public String getFileName() {
        return "promotion081missionboxreward";
    }
}
