package com.ayjs.mxzg.config.excel.cache.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093DicePoint;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/3/22
 **/
@Component
public class Promotion093DicePointSysCache extends BaseExcelCache<CPromotion093DicePoint> {

    private Map<Integer, Map<Integer, CPromotion093DicePoint>> map;

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, CPromotion093DicePoint>> mapTemp = new HashMap<>();
        Map<Integer, List<CPromotion093DicePoint>> groupMap = getAll().stream().collect(Collectors.groupingBy(CPromotion093DicePoint::getGroup));
        groupMap.forEach((group, list) -> {
            mapTemp.put(group, list.stream().collect(Collectors.toMap(CPromotion093DicePoint::getDice_count, Function.identity())));
        });
        map = mapTemp;
    }

    public CPromotion093DicePoint getBy(int group, int diceCount) {
        return map.get(group).get(diceCount);
    }

    @Override
    public String getFileName() {
        return "promotion093dicepoint";
    }
}
