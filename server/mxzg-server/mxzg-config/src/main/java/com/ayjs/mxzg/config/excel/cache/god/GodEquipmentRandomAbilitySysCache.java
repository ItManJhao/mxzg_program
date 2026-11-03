/**
 *
 */
package com.ayjs.mxzg.config.excel.cache.god;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRandomAbility;
import com.ayjs.mxzg.config.struct.GodAttr;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentRandomAbilitySysCache extends BaseExcelCache<CGodEquipmentRandomAbility> {

    //
    private Map<Integer, Map<Integer, List<CGodEquipmentRandomAbility>>> placeStarMap;

    //<place, <star, <ability_type, <level>>>>
    private Map<Integer, Map<Integer, Map<Integer, Map<Integer, CGodEquipmentRandomAbility>>>> fullIndexMap;

    @Override
    public String getFileName() {
        return "godequipmentrandomability";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, List<CGodEquipmentRandomAbility>>> tempMap = new HashMap<>();
        for (CGodEquipmentRandomAbility config : this.getAll()) {
            Map<Integer, List<CGodEquipmentRandomAbility>> placeMap = tempMap.get(config.getPlace());
            if (placeMap == null) {
                placeMap = new HashMap<>();
                tempMap.put(config.getPlace(), placeMap);
            }
            List<CGodEquipmentRandomAbility> starList = placeMap.get(config.getStar());
            if (starList == null) {
                starList = new ArrayList<>();
                placeMap.put(config.getStar(), starList);
            }
            starList.add(config);
        }
        this.placeStarMap = tempMap;

        Map<Integer, Map<Integer, Map<Integer, Map<Integer, CGodEquipmentRandomAbility>>>> tempFullIndexMap = new HashMap<>();
        for (CGodEquipmentRandomAbility config : this.getAll()) {
            Map<Integer, Map<Integer, Map<Integer, CGodEquipmentRandomAbility>>> starMap = tempFullIndexMap.get(config.getPlace());
            if (starMap == null) {
                starMap = new HashMap<>();
                tempFullIndexMap.put(config.getPlace(), starMap);
            }
            Map<Integer, Map<Integer, CGodEquipmentRandomAbility>> attrMap = starMap.get(config.getStar());
            if (attrMap == null) {
                attrMap = new HashMap<>();
                starMap.put(config.getStar(), attrMap);
            }
            Map<Integer, CGodEquipmentRandomAbility> levelMap = attrMap.get(config.getAbility_type());
            if (levelMap == null) {
                levelMap = new HashMap<>();
                attrMap.put(config.getAbility_type(), levelMap);
            }
            levelMap.put(config.getLevel(), config);
        }
        this.fullIndexMap = tempFullIndexMap;
    }


    /**
     * 获取该装备的属性列表
     * @param place
     * @param star
     * @return
     */
    public List<CGodEquipmentRandomAbility> getAbilityList(int place, int star) {
        Map<Integer, List<CGodEquipmentRandomAbility>> placeMap = placeStarMap.get(place);
        ConfigAsserts.notNull(placeMap,
                () -> String.format("CGodEquipmentRandomAbility配置数据不存在部位place:{%s}", place));
        List<CGodEquipmentRandomAbility> starList = placeMap.get(star);
        ConfigAsserts.notNull(starList,
                () -> String.format("CGodEquipmentRandomAbility配置数据不存在部位place:{%s},星级:{%s}", place, star + "的神装"));
        return starList;
    }

    /**
     * 获取指定神装属性的最大值
     * @param abilityList
     * @param ability
     * @return
     */
    private int abilityMaxLevel(List<CGodEquipmentRandomAbility> abilityList, int ability) {
        return abilityList.stream().filter(config -> config.getAbility_type() == ability).mapToInt(CGodEquipmentRandomAbility::getLevel).max().getAsInt();
    }

    /**
     * 获取指定神装属性的最大值
     * @param place
     * @param star
     * @param ability
     * @return
     */
    public int abilityMaxLevel(int place, int star, int ability) {
        List<CGodEquipmentRandomAbility> getAbilityList = getAbilityList(place, star);
        return getAbilityList.stream().filter(config -> config.getAbility_type() == ability).mapToInt(CGodEquipmentRandomAbility::getLevel).max().getAsInt();
    }

    public GodAttr washAbility(int place, int star, int abilityType, GodAttr godAttr, int washLevel) {
        GodAttr newGodAttr = new GodAttr();
        newGodAttr.setLock(godAttr.getLock());
        newGodAttr.setSort(godAttr.getSort());
        newGodAttr.setSysId(abilityType);

        int maxLevel = abilityMaxLevel(getAbilityList(place, star), abilityType);
        newGodAttr.setLevel(Math.min(washLevel + 1, maxLevel));
        return newGodAttr;
    }

    public CGodEquipmentRandomAbility getAbility(int place, int star, int abilityType, int level) {
        Map<Integer, Map<Integer, Map<Integer, CGodEquipmentRandomAbility>>> starMap = fullIndexMap.get(place);
        if (starMap == null) {
            return null;
        }
        Map<Integer, Map<Integer, CGodEquipmentRandomAbility>> attrMap = starMap.get(star);
        if (attrMap == null) {
            return null;
        }
        Map<Integer, CGodEquipmentRandomAbility> levelMap = attrMap.get(abilityType);
        if (levelMap == null) {
            return null;
        }
        return levelMap.get(level);
    }
}
