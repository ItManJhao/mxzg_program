package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarTimeSysCache extends BaseExcelCache<CCountryWarTime> {

    @Getter
    private int maxId;
    @Getter
    private Map<Integer, List<CCountryWarTime>> roundMap;

    @Override
    protected void loadAfterReady() {
        maxId = getAll().stream().mapToInt(CCountryWarTime::getIdx).max().getAsInt();
        roundMap = getAll().stream().collect(Collectors.groupingBy(CCountryWarTime::getRound));
    }

    @Override
    public String getFileName() {
        return "countrywartime";
    }

    public CCountryWarTime getByTime(LocalDateTime now) {
        CCountryWarTime result = null;
        for (CCountryWarTime config : getAll()) {
            if (config.getStart_time().isAfter(now)) {
                break;
            } else {
                result = config;
            }
        }
        return result;
    }
}
