package com.ayjs.mxzg.config.excel.cache.promotion076;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion076.CPromotion076FashionCountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion076FashionCountRewardSysCache extends BaseExcelCache<CPromotion076FashionCountReward> {

    @Override
    public String getFileName() {
        return "promotion076fashioncountreward";
    }
}
