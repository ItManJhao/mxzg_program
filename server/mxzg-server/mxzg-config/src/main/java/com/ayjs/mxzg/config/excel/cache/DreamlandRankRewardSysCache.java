package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandRankReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Component
public class DreamlandRankRewardSysCache extends BaseExcelCache<CDreamlandRankReward> {
    @Override
    public String getFileName() {
        return "infiniterankreward";
    }

    public CDreamlandRankReward getConfigByRank(int rank) {
        return getAll().stream().filter(config -> config.getRank_min() <= rank &&
                config.getRank_max() >= rank).findFirst().orElse(null);
    }
}
