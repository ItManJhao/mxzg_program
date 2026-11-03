package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CMagicWandAttr;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class MagicWandAttrSysCache extends BaseExcelCache<CMagicWandAttr> {

    private Map<Integer, List<CMagicWandAttr>> rareMap;

    @Override
    public String getFileName() {
        return "magicwandattr";
    }

    @Override
    protected void loadAfterReady() {
        rareMap = this.fillListMap(CMagicWandAttr::getRare);
    }

    public List<CMagicWandAttr> getDataByRare(int rare) {
        List<CMagicWandAttr> attr_list = rareMap.get(rare);
        ConfigAsserts.notNull(attr_list, "配置表中没有存在该品质的魔杖，请检查！");
        return attr_list;
    }
}
