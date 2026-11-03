package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagRoundReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarFlagRoundRewardSysCache extends BaseExcelCache<CCountryWarFlagRoundReward> {

    @Override
    public String getFileName() {
        return "countrywarflagroundreward";
    }
}
