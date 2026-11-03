package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLadderRankReward;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Component
public class LadderRankRewardSysCache extends BaseExcelCache<CLadderRankReward> {

    @Override
    public String getFileName() {
        return "serverladderrankreward";
    }

    public CLadderRankReward getConfigByRank(int rank) {
        return getAll().stream().filter(config -> config.getRank_low() <= rank &&
                config.getRank_up() >= rank).findFirst().orElse(null);
    }
}
