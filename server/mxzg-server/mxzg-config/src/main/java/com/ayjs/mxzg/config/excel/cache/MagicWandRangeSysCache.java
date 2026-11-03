package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CMagicWandRange;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class MagicWandRangeSysCache extends BaseExcelCache<CMagicWandRange> {

    private Map<Integer, Map<Integer, CMagicWandRange>> attrTypeRareMap;

    @Override
    public String getFileName() {
        return "magicwandrange";
    }

    @Override
    protected void loadAfterReady() {
        attrTypeRareMap = this.fillTwoLayerMap(CMagicWandRange::getAttr_type, CMagicWandRange::getRare);
    }

    public CMagicWandRange getDataByAttrTypeAndRare(int attr_type, int rare) {
        Map<Integer, CMagicWandRange> rareMap = attrTypeRareMap.get(attr_type);
        ConfigAsserts.notNull(rareMap, "配置表不存在此属性类");
        CMagicWandRange magicWandConfig = rareMap.get(rare);
        ConfigAsserts.notNull(magicWandConfig, "配置表中不存在该品质的魔杖");
        return magicWandConfig;
    }
}
