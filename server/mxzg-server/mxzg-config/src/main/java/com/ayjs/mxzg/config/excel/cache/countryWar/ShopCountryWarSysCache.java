package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CShopCountryWar;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class ShopCountryWarSysCache extends BaseExcelCache<CShopCountryWar> {

    @Override
    public String getFileName() {
        return "shopcountrywar";
    }
}
