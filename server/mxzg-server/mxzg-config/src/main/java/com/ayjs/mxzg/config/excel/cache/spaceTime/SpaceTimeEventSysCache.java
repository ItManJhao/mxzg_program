package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEvent;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class SpaceTimeEventSysCache extends BaseExcelCache<CSpaceTimeEvent> {


    @Override
    public String getFileName() {
        return "spacetimeevent";
    }
}
