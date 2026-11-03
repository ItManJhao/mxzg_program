package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeAdventure;
import org.springframework.stereotype.Component;

@Component
public class SpaceTimeAdventureSysCache extends BaseExcelCache<CSpaceTimeAdventure> {

    @Override
    public String getFileName() {
        return "spacetimeadventure";
    }
}
