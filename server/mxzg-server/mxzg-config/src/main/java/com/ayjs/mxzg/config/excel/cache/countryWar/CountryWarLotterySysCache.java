package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarLottery;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarLotterySysCache extends BaseExcelCache<CCountryWarLottery> {

    private Map<String, CCountryWarLottery> map;
    private Map<Integer, List<CCountryWarLottery>> roundMap;
    @Getter
    private int maxRound;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().filter(config -> config.getMax_count() > 0)
                .collect(Collectors.toMap(config -> key(config.getRound(), config.getMax_count()), Function.identity()));
        roundMap = getAll().stream().collect(Collectors.groupingBy(CCountryWarLottery::getRound));
        maxRound = getAll().stream().mapToInt(CCountryWarLottery::getRound).max().getAsInt();
    }

    public List<CCountryWarLottery> getByRound(int round) {
        if (round > maxRound) {
            round = maxRound;
        }
        return roundMap.get(round);
    }

    private String key(int round, int count) {
        return round + "_" + count;
    }

    public CCountryWarLottery getByRoundAndMaxCount(int round, int count) {
        if (round > maxRound) {
            round = maxRound;
        }
        return map.get(key(round, count));
    }

    @Override
    public String getFileName() {
        return "countrywarlottery";
    }
}
