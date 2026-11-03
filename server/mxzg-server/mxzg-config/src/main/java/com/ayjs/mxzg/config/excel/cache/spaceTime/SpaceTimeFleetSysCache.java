package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleet;
import org.springframework.stereotype.Component;

@Component
public class SpaceTimeFleetSysCache extends BaseExcelCache<CSpaceTimeFleet> {

    private int maxLevel;

    @Override
    protected void loadAfterReady() {
        maxLevel = getAll().stream().mapToInt(CSpaceTimeFleet::getLevel).max().orElse(1);
    }

    public int getMaxLevel() {
        return maxLevel;
    }

    @Override
    public String getFileName() {
        return "spacetimefleet";
    }
}
