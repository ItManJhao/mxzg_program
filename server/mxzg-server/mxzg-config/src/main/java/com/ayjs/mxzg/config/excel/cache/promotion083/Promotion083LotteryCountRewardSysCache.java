package com.ayjs.mxzg.config.excel.cache.promotion083;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion083.CPromotion083LotteryCountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion083LotteryCountRewardSysCache extends BaseExcelCache<CPromotion083LotteryCountReward> {

    @Override
    public String getFileName() {
        return "promotion083lotterycountreward";
    }
}
