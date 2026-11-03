package com.ayjs.mxzg.config.excel.cache.heroEquipSoul;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoul;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/3/8
 **/
@Component
public class HeroEquipSoulSysCache extends BaseExcelCache<CHeroEquipSoul> {

    public Map<Integer, Map<Integer, CHeroEquipSoul>> map;

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CHeroEquipSoul>> placeConfigs = getAll().stream().collect(Collectors.groupingBy(CHeroEquipSoul::getPlace));

        Map<Integer, Map<Integer, CHeroEquipSoul>> mapTemp = new HashMap<>();
        placeConfigs.forEach((key, value) -> {
            mapTemp.put(key, value.stream().collect(Collectors.toMap(CHeroEquipSoul::getLevel, Function.identity())));
        });
        map = mapTemp;
    }

    public Map<Integer, CHeroEquipSoul> getByPlace(int place) {
        return map.get(place);
    }

    public CHeroEquipSoul getByPlaceAndLv(int place, int level) {
        Map<Integer, CHeroEquipSoul> placeMap = getByPlace(place);
        return placeMap == null ? null : placeMap.get(level);
    }

    @Override
    public String getFileName() {
        return "heroequipsoul";
    }
}
