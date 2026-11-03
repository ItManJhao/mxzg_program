package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarDamageRankReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarDamageRankRewardSysCache extends BaseExcelCache<CCountryWarDamageRankReward> {

    @Override
    public String getFileName() {
        return "countrywardamagerankreward";
    }

    public CCountryWarDamageRankReward getByRank(int rank) {
        return getAll().stream().filter(config -> config.getRank_up() <= rank && rank <= config.getRank_down()).findFirst().orElse(null);
    }
}
