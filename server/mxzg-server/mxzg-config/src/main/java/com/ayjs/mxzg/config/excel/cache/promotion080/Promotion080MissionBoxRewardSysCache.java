package com.ayjs.mxzg.config.excel.cache.promotion080;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080MissionBoxReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion080MissionBoxRewardSysCache extends BaseExcelCache<CPromotion080MissionBoxReward> {

    @Override
    public String getFileName() {
        return "promotion080missionboxreward";
    }
}
