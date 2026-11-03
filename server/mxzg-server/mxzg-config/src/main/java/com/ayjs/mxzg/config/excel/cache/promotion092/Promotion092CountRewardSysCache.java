package com.ayjs.mxzg.config.excel.cache.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092CountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion092CountRewardSysCache extends BaseExcelCache<CPromotion092CountReward> {

    @Override
    public String getFileName() {
        return "promotion092countreward";
    }

}
