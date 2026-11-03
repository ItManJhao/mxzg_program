package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagMission;
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
public class CountryWarFlagMissionSysCache extends BaseExcelCache<CCountryWarFlagMission> {

    private Map<Integer, List<CCountryWarFlagMission>> map;
    @Getter
    private int maxRound;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.groupingBy(CCountryWarFlagMission::getRound));
        maxRound = getAll().stream().mapToInt(CCountryWarFlagMission::getRound).max().getAsInt();
    }

    public List<CCountryWarFlagMission> getByRound(int round) {
        List<CCountryWarFlagMission> list = map.get(round);
        ConfigAsserts.isTrue(list != null, String.format("不存在该类型，轮次的任务：{%s}", round));
        return list;
    }

    @Override
    public String getFileName() {
        return "countrywarflagmission";
    }
}
