package com.ayjs.mxzg.config.excel.cache.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092CountRankReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion092CountRankRewardSysCache extends BaseExcelCache<CPromotion092CountRankReward> {

    @Override
    public String getFileName() {
        return "promotion092countrankreward";
    }

    public CPromotion092CountRankReward getByRank(int rank) {
        return getAll().stream().filter(config -> config.getRank_up() <= rank && rank <= config.getRank_down()).findFirst().orElse(null);
    }
}
