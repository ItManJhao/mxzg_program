package com.ayjs.mxzg.config.excel.cache.promotion078;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion078.CPromotion078LotteryCountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion078LotteryCountRewardSysCache extends BaseExcelCache<CPromotion078LotteryCountReward> {

    @Override
    public String getFileName() {
        return "promotion078lotterycountreward";
    }
}
