package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarCitySysCache extends BaseExcelCache<CCountryWarCity> {

    private Map<Integer, List<CCountryWarCity>> map;

    @Getter
    private int baseCampNum;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.groupingBy(CCountryWarCity::getType));
        baseCampNum = map.get(1).size();
        if (baseCampNum == 0) {
            throw new RuntimeException("大本营配置不存在");
        }
    }

    public List<CCountryWarCity> getByType(int type) {
        return map.get(type);
    }

    @Override
    public String getFileName() {
        return "countrywarcity";
    }
}
