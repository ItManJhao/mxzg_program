package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarKillRankReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarKillRankRewardSysCache extends BaseExcelCache<CCountryWarKillRankReward> {

    @Override
    public String getFileName() {
        return "countrywarkillrankreward";
    }

    public CCountryWarKillRankReward getByRank(int rank) {
        return getAll().stream().filter(config -> config.getRank_up() <= rank && rank <= config.getRank_down()).findFirst().orElse(null);
    }
}
