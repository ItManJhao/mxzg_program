package com.ayjs.mxzg.config.excel.cache.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarInformation;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarInformationSysCache extends BaseExcelCache<CPlaneWarInformation> {

    private Map<Integer, Set<Integer>> dayOpenTimeMap;

    @Override
    protected void loadAfterReady() {
        Map<Integer, Set<Integer>> dayOpenMapTemp = Maps.newHashMap();
        getAll().forEach(config -> config.getOpen_day().forEach(weekIndex ->
                dayOpenMapTemp.computeIfAbsent(weekIndex, key -> new HashSet<Integer>()).add(config.getElement())));
        dayOpenTimeMap = dayOpenMapTemp;
    }

    public Set<Integer> getOpenElement(int weekday) {
        return dayOpenTimeMap.get(weekday);
    }

    @Override
    public String getFileName() {
        return "planewarinformation";
    }
}
