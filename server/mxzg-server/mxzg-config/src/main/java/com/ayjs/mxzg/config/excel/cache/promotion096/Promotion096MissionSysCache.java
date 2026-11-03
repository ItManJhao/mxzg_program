package com.ayjs.mxzg.config.excel.cache.promotion096;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion096.CPromotion096Mission;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion096MissionSysCache extends BaseExcelCache<CPromotion096Mission> {

    private Map<Integer, List<CPromotion096Mission>> missionMap;

    @Override
    protected void loadAfterReady() {
        missionMap = getAll().stream().collect(Collectors.groupingBy(CPromotion096Mission::getDay));
    }

    @Override
    public String getFileName() {
        return "promotion096mission";
    }

    public List<CPromotion096Mission> getMissionByDay(int day) {
        ConfigAsserts.isTrue(missionMap.containsKey(day), String.format("开启天数{%s}不存在任务列表", day));
        return missionMap.get(day);
    }
}
