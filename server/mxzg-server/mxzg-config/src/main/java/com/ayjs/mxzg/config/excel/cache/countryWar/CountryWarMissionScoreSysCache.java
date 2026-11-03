package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMissionScore;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarMissionScoreSysCache extends BaseExcelCache<CCountryWarMissionScore> {

    private Map<Integer, List<CCountryWarMissionScore>> map;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.groupingBy(CCountryWarMissionScore::getRound));
    }

    public List<CCountryWarMissionScore> getByType(int type) {
        return map.get(type);
    }

    @Override
    public String getFileName() {
        return "countrywarmissionscore";
    }
}
