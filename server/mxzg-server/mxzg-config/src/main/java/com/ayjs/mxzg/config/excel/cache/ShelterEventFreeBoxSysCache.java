package com.ayjs.mxzg.config.excel.cache;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEventFreeBox;

@Component
public class ShelterEventFreeBoxSysCache extends BaseExcelCache<CShelterEventFreeBox> {

    private Map<Integer, List<CShelterEventFreeBox>> itemMap = new HashMap<>();

    private Set<Integer> eventIdList = new HashSet<>();

    @Override
    public String getFileName() {
        return "sheltereventfreebox";
    }

    @Override
    protected void loadAfterReady() {

        eventIdList = getAll().stream().map(CShelterEventFreeBox::getEvent_id).collect(Collectors.toSet());

        Map<Integer, List<CShelterEventFreeBox>> itemMapTemp = new HashMap<>();
        getAll().stream().forEach(shelterEventFreeBox -> {
            List<CShelterEventFreeBox> itemList = itemMapTemp.computeIfAbsent(shelterEventFreeBox.getEvent_id(),
                    k -> new ArrayList<>());
            itemList.add(shelterEventFreeBox);
        });
        itemMap = itemMapTemp;
    }

    public List<CShelterEventFreeBox> getItemMap(int eventId) {
        return itemMap.get(eventId);
    }

    public Set<Integer> getEventIdList() {
        return eventIdList;
    }
}