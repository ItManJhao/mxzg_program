package com.ayjs.mxzg.config.excel.cache.promotion097;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.entity.promotion097.Promotion097Cost;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class Promotion097CostCache extends BaseExcelCache<Promotion097Cost> {

    private Map<Integer, Map<Integer, Promotion097Cost>> costConfigMap;

    @Override
    public String getFileName() {
        return "promotion097cost";
    }

    @Override
    protected void loadAfterReady() {
        costConfigMap = ListMapUtil.fillTwoLayerMap(this.getAll(), Promotion097Cost::getTurns, Promotion097Cost::getTimes);
    }

    public Map<Integer, Promotion097Cost> getCurTurnsInfo(int turns) {
        Map<Integer, Promotion097Cost> map = costConfigMap.get(turns);
        ConfigAsserts.notNull(map, () -> String.format("{%s}配置表没有配置这一轮的数据{%s}", getFileName(), turns));
        return map;
    }
}
