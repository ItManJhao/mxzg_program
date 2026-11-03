package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEvent;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
public class SpaceTimeEventShowSysCache extends BaseExcelCache<CSpaceTimeEventShow> {

    /**
     * <航线id,>
     */

    private Map<Integer, Map<Integer, CSpaceTimeEventShow>> eventMap;

    @Override
    protected void loadAfterReady() {
        this.eventMap = this.fillTwoLayerMap(CSpaceTimeEventShow::getRoute_id, CSpaceTimeEventShow::getEvent_id);
    }

    public List<CSpaceTimeEventShow> getMap(int routeId) {
        Map<Integer, CSpaceTimeEventShow> events = eventMap.get(routeId);
        ConfigAsserts.notNull(events, () -> String.format("spacetimeeventshow不存在航线{%s}", routeId));
        return new ArrayList<>(events.values());
    }

    public CSpaceTimeEventShow getEventMap(int routeId, int eventId) {
        Map<Integer, CSpaceTimeEventShow> events = eventMap.get(routeId);
        ConfigAsserts.notNull(events, () -> String.format("spacetimeeventshow不存在航线{%s}", routeId));
        CSpaceTimeEventShow cSpaceTimeEventShow = events.get(eventId);
        ConfigAsserts.notNull(events, () -> String.format("spacetimeeventshow不存在航线{%s},事件{%s}", routeId, eventId));
        return cSpaceTimeEventShow;
    }

    @Override
    public String getFileName() {
        return "spacetimeeventshow";
    }
}
