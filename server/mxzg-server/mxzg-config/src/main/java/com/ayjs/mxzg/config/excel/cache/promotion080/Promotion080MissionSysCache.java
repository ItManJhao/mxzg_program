package com.ayjs.mxzg.config.excel.cache.promotion080;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080Mission;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion080MissionSysCache extends BaseExcelCache<CPromotion080Mission> {

    private Map<Integer, List<CPromotion080Mission>> missionMap;

    @Override
    protected void loadAfterReady() {
        missionMap = getAll().stream().collect(Collectors.groupingBy(CPromotion080Mission::getDay));
    }

    @Override
    public String getFileName() {
        return "promotion080mission";
    }

    public List<CPromotion080Mission> getMissionByDay(int day) {
        ConfigAsserts.isTrue(missionMap.containsKey(day), String.format("开启天数{%s}不存在任务列表", day));
        return missionMap.get(day);
    }
}
