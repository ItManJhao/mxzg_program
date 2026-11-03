package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarRandomShop;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarRandomShopSysCache extends BaseExcelCache<CCountryWarRandomShop> {


    @Override
    public String getFileName() {
        return "countrywarrandomshop";
    }


}
