package com.ayjs.mxzg.config.excel.cache.promotion070;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070OpenCountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion070OpenCountRewardSysCache extends BaseExcelCache<CPromotion070OpenCountReward> {

    @Override
    public String getFileName() {
        return "promotion070opencountreward";
    }
}
