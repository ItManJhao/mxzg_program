package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEventItem;

@Component
public class ShelterEventItemSysCache extends BaseExcelCache<CShelterEventItem> {

    private Map<Integer, List<CShelterEventItem>> itemMap;

    @Override
    public String getFileName() {
        return "sheltereventitem";
    }

    @Override
    protected void loadAfterReady() {
        itemMap = this.fillListMap(CShelterEventItem::getEvent_id);
    }

    public List<CShelterEventItem> getItemMap(int eventId) {
        return itemMap.get(eventId);
    }

}
