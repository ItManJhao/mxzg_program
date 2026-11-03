package com.ayjs.mxzg.config.excel.cache.promotion077;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077MissionBoxReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion077MissionBoxRewardSysCache extends BaseExcelCache<CPromotion077MissionBoxReward> {

    @Override
    public String getFileName() {
        return "promotion077missionboxreward";
    }
}
