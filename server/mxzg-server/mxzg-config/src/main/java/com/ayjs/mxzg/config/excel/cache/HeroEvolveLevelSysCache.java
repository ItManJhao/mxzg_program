package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroEvolveLevel;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Component
public class HeroEvolveLevelSysCache extends BaseExcelCache<CHeroEvolveLevel> {

    private Map<Integer, Map<String, CHeroEvolveLevel>> heroEvolveMap;

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CHeroEvolveLevel>> heroConfigs = getAll().stream().collect(Collectors.groupingBy(CHeroEvolveLevel::getHero_type));
        Map<Integer, Map<String, CHeroEvolveLevel>> heroEvolveMap_ = Maps.newHashMap();
        heroConfigs.forEach((heroType, configs) -> {
            Map<String, CHeroEvolveLevel> collect = configs.stream().collect(Collectors.toMap(config ->
                    buildKey(config.getEvolve_type(), config.getLevel()), Function.identity()));
            heroEvolveMap_.put(heroType, collect);
        });
        heroEvolveMap = heroEvolveMap_;

    }

    private String buildKey(int evolve, int level) {
        return String.format("%s_%s", evolve, level);
    }

    public CHeroEvolveLevel getBy(int heroType, int evolveType, int level) {
        Map<String, CHeroEvolveLevel> evolveLevelMap = heroEvolveMap.get(heroType);
        if (evolveLevelMap == null)
            return null;
        return evolveLevelMap.get(buildKey(evolveType, level));
    }


    @Override
    public String getFileName() {
        return "heroevolvelevel";
    }
}
