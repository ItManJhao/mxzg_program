package com.ayjs.mxzg.config.excel.cache.pet;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.pet.CPetLevel;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class PetLevelSysCache extends BaseExcelCache<CPetLevel> {

    public Map<Integer, Integer> petMaxLevel;
    public Map<Integer, Map<Integer, CPetLevel>> map;

    @Override
    protected void loadAfterReady() {

        this.map = this.fillTwoLayerMap(CPetLevel::getId, CPetLevel::getLevel);

        Map<Integer, Integer> temp = new HashMap<>();
        for (CPetLevel cPetLevel : this.getAll()) {
            if (temp.get(cPetLevel.getId()) == null || temp.get(cPetLevel.getId()) < cPetLevel.getLevel()) {
                temp.put(cPetLevel.getId(), cPetLevel.getLevel());
            }
        }
        petMaxLevel = temp;
    }

    @Override
    public String getFileName() {
        return "petlevel";
    }

    public int getPetMaxLevel(int petType) {
        return petMaxLevel.get(petType);
    }

    public CPetLevel getPetConfig(int petType, int level) {
        Map<Integer, CPetLevel> typeMap = map.get(petType);
        ConfigAsserts.notNull(typeMap, () -> String.format("未找到petlevel宠物类型{%s}的数据", petType));
        CPetLevel cPetLevel = typeMap.get(level);
        ConfigAsserts.notNull(cPetLevel, () -> String.format("未找到petlevel宠物类型{%s}中{%s}级的数据", petType, level));
        return cPetLevel;
    }

}
