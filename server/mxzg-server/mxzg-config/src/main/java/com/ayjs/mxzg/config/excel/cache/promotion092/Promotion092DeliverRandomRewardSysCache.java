package com.ayjs.mxzg.config.excel.cache.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092DeliverRandomReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion092DeliverRandomRewardSysCache extends BaseExcelCache<CPromotion092DeliverRandomReward> {

    @Override
    public String getFileName() {
        return "promotion092deliverrandomreward";
    }

}
