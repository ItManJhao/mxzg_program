package com.ayjs.mxzg.config.excel.cache.promotion074;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion074.CPromotion074LotteryCountReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion074LotteryCountRewardSysCache extends BaseExcelCache<CPromotion074LotteryCountReward> {

    @Override
    public String getFileName() {
        return "promotion074lotterycountreward";
    }
}
