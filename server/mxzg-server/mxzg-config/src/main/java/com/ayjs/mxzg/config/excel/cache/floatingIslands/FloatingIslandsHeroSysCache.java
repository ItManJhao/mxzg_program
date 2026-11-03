package com.ayjs.mxzg.config.excel.cache.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsHero;
import lombok.Getter;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsHeroSysCache extends BaseExcelCache<CFloatingIslandsHero> {

    @Getter
    private int maxTurns;

    private Map<Integer, List<CFloatingIslandsHero>> map = null;

    @Override
    protected void loadAfterReady() {
//        maxTurns = getAll().stream().mapToInt(CFloatingIslandsHero::getTurns).max().getAsInt();
//        map = getAll().stream().collect(Collectors.groupingBy(CFloatingIslandsHero::getTurns));
    }

//    public List<CFloatingIslandsHero> getByTurns(int turns) {
//        return map.get(turns);
//    }

    @Override
    public String getFileName() {
        return "floatingislandshero";
    }
}
