package com.ayjs.mxzg.config.excel.cache.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarRank;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarRankSysCache extends BaseExcelCache<CPlaneWarRank> {

    private Map<Integer, CPlaneWarRank> map = null;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.toMap(CPlaneWarRank::getRank_up, Function.identity()));
    }

    @Override
    public String getFileName() {
        return "planewarrank";
    }

    public CPlaneWarRank getByRank(int rank) {
        CPlaneWarRank cPlaneWarRank = getAll().stream().filter(config -> config.getRank_up() <= rank &&
                config.getRank_down() >= rank).findFirst().orElse(null);
        return cPlaneWarRank;
    }
}
