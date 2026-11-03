/**
 *
 */
package com.ayjs.mxzg.config.excel.cache.god;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRandomAbilityType;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRare;
import com.ayjs.mxzg.config.struct.GodAttr;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentRandomAbilityTypeSysCache extends BaseExcelCache<CGodEquipmentRandomAbilityType> {

    private Map<Integer, List<CGodEquipmentRandomAbilityType>> typeMap;

    @Override
    public String getFileName() {
        return "godequipmentrandomabilitytype";
    }


    @Override
    protected void loadAfterReady() {
        this.typeMap = this.fillListMap(CGodEquipmentRandomAbilityType::getPlace);
    }

    public List<GodAttr> randomAttr(CGodEquipmentRare cRare, int place) {
        List<GodAttr> list = new ArrayList<>();
        if (cRare.getRandom_ability_num() > 0) {
            List<CGodEquipmentRandomAbilityType> attrType = DropUtil.randomDifDrop(getPlaceAbility(place), cRare.getRandom_ability_num());
            for (int i = 0; i < attrType.size(); i++) {
                CGodEquipmentRandomAbilityType attr = attrType.get(i);
                GodAttr godAttr = new GodAttr();
                godAttr.setSort(i + 1);
                godAttr.setLock(0);
                godAttr.setLevel(cRare.getRandom_ability_start_level());
                godAttr.setSysId(attr.getAbility_type());
                list.add(godAttr);
            }
        }
        return list;
    }


    /**
     * 获取部位的随机属性
     * @param place
     */
    public List<CGodEquipmentRandomAbilityType> getPlaceAbility(int place) {
        return typeMap.get(place);
    }

}
