package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CMagicWandStrengthen;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class MagicWandStrengthenSysCache extends BaseExcelCache<CMagicWandStrengthen> {

    private Map<Integer, Map<Integer, CMagicWandStrengthen>> typeLevelMap;

    @Override
    public String getFileName() {
        return "magicwandstrengthen";
    }

    @Override
    protected void loadAfterReady() {
        this.typeLevelMap = this.fillTwoLayerMap(CMagicWandStrengthen::getItem_type, CMagicWandStrengthen::getLevel);
    }

    public CMagicWandStrengthen getDataByTypeAndLevel(int item_type, int level) {
        Map<Integer, CMagicWandStrengthen> typeDataMap = getDataByType(item_type);
        if (typeDataMap == null) {
            return null;
        }
        return typeDataMap.get(level);
    }

    public Map<Integer, CMagicWandStrengthen> getDataByType(int item_type) {
        return typeLevelMap.get(item_type);
    }
}
