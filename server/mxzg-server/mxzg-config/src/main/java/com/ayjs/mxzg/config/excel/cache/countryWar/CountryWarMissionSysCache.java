package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMission;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarMissionSysCache extends BaseExcelCache<CCountryWarMission> {

    private Map<Integer, Map<Integer, List<CCountryWarMission>>> map;
    private Map<Integer, Integer> roundMap;

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CCountryWarMission>> typeMap = getAll().stream().collect(Collectors.groupingBy(CCountryWarMission::getType));
        Map<Integer, Map<Integer, List<CCountryWarMission>>> mapTemp = new HashMap<>();
        Map<Integer, Integer> roundMapTemp = new HashMap<>();
        typeMap.forEach((type, list) -> {
            mapTemp.put(type, list.stream().collect(Collectors.groupingBy(CCountryWarMission::getRound)));
            roundMapTemp.put(type, list.stream().mapToInt(CCountryWarMission::getRound).max().getAsInt());
        });
        map = mapTemp;
        roundMap = roundMapTemp;
    }

    public List<CCountryWarMission> getByRoundAndType(int type, int round) {
        Map<Integer, List<CCountryWarMission>> typeMap = map.get(type);
        ConfigAsserts.isTrue(typeMap != null, String.format("不存在该类型，轮次的任务：{%s}，{%s}", type, round));
        List<CCountryWarMission> list = typeMap.get(round);
        ConfigAsserts.isTrue(list != null, String.format("不存在该类型，轮次的任务：{%s}，{%s}", type, round));
        return list;
    }

    public int getRoundMax(int type) {
        Integer round = roundMap.get(type);
        ConfigAsserts.isTrue(round != null, String.format("不存在该类型得任务：{%s}", type));
        return round;
    }

    public Set<Integer> getAllType() {
        return roundMap.keySet();
    }

    @Override
    public String getFileName() {
        return "countrywarmission";
    }
}
