package com.ayjs.mxzg.config.excel.cache;

import cn.hutool.core.lang.WeightRandom;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CProphecyExchange;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * 先知置换
 */
@Component
public class ProphecyExchangeSysCache extends BaseExcelCache<CProphecyExchange> {

    private Map<Integer, Map<Integer, WeightRandom<CProphecyExchange>>> exchangeMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "prophecyexchange";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, WeightRandom<CProphecyExchange>>> exchangeMapTemp = new HashMap<>();
        getAll().forEach(cProphecyExchange -> {
            Map<Integer, WeightRandom<CProphecyExchange>> elementMap = exchangeMapTemp.computeIfAbsent(
                    cProphecyExchange.getElement(), k -> new HashMap<>());
            WeightRandom<CProphecyExchange> startMap = elementMap.computeIfAbsent(cProphecyExchange.getStar(),
                    k -> WeightRandom.create());
            startMap.add(cProphecyExchange, cProphecyExchange.getWeight());
        });
        exchangeMap = exchangeMapTemp;
    }

    public CProphecyExchange getProphecyExchange(int element, int star) {
        Map<Integer, WeightRandom<CProphecyExchange>> elementMap = exchangeMap.get(element);
        ConfigAsserts.notNull(elementMap,
                () -> String.format("CProphecyExchange is null element:%s star:%s", element, star));
        WeightRandom<CProphecyExchange> starMap = elementMap.get(star);
        ConfigAsserts.notNull(starMap,
                () -> String.format("CProphecyExchange is null element:%s star:%s", element, star));
        return starMap.next();
    }


}
