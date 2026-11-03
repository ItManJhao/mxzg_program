package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;

/**
 * 装备配置
 */
@Component
public class EquipmenttypeSysCache extends BaseExcelCache<CEquipmenttype> {

    // equipmentType --> 同类型的列表
    private Map<Integer, List<CEquipmenttype>> equipmentTypeMap;

    @Override
    public String getFileName() {
        return "equipmenttype";
    }

    @Override
    protected void loadAfterReady() {
        this.equipmentTypeMap = this.fillListMap(CEquipmenttype::getPlace);
    }

    /**
     * 获取同类型所有装备配置
     */
    public List<CEquipmenttype> getEquipmentTypes(int equipmentType) {
        return equipmentTypeMap.get(equipmentType);
    }
}