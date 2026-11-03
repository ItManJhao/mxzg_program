package com.ayjs.mxzg.config.excel.cache.planewar;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarHero;
import com.google.common.collect.Maps;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarHeroSysCache extends BaseExcelCache<CPlaneWarHero> {

    private Map<Integer, Map<Integer, List<CPlaneWarHero>>> map;

    @Getter
    private int maxTurn;

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, List<CPlaneWarHero>>> mapTemp = Maps.newHashMap();
        Map<Integer, List<CPlaneWarHero>> turnMap = getAll().stream().collect(Collectors.groupingBy(CPlaneWarHero::getTurn));
        turnMap.forEach((turn, list) -> {
            mapTemp.put(turn, list.stream().collect(Collectors.groupingBy(CPlaneWarHero::getLevel_idx)));
        });
        map = mapTemp;
        maxTurn = getAll().stream().mapToInt(CPlaneWarHero::getTurn).distinct().max().getAsInt();
    }

    @Override
    public String getFileName() {
        return "planewarhero";
    }

    public List<CPlaneWarHero> getByLevelIdxAndTurn(int levelIdx, int turn) {
        Map<Integer, List<CPlaneWarHero>> turnMap = map.get(turn);
        List<CPlaneWarHero> result = turnMap == null ? null : turnMap.get(levelIdx);
        ConfigAsserts.isTrue(CollectionUtil.isNotEmpty(result), String.format("轮次：{%s},关卡idx：{%s}", turn, levelIdx));
        return result;
    }
}
