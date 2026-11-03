package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskMainTest;
import com.ayjs.mxzg.config.struct.TargetType;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class DailyTaskMainTestSysCache extends BaseExcelCache<CDailyTaskMainTest> {

    private Map<TargetType, List<CDailyTaskMainTest>> map = new HashMap<>();

    @Override
    protected void loadAfterReady() {
        Map<TargetType, List<CDailyTaskMainTest>> mapTemp = new HashMap<>();
        getAll().forEach(config -> {
            List<CDailyTaskMainTest> list = mapTemp.computeIfAbsent(config.getTask().getType(), k -> new ArrayList<>());
            list.add(config);
        });
        map = mapTemp;
    }

    public List<CDailyTaskMainTest> getConfigsByType(TargetType targetType) {
        return map.getOrDefault(targetType, Collections.emptyList());
    }

    @Override
    public String getFileName() {
        return "dailytaskmain";
    }

}