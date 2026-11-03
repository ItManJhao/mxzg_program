package com.ayjs.mxzg.config.excel.cache.astrolabe;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Component
@Getter
public class AstrolabeConst extends ExcelDictionaryCache {

    private ImmutableList<ImmutableThing> activeElementCost;
    private ImmutableList<ImmutableThing> astrolabeResetCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        activeElementCost = ImmutableThingUtil.fromJson(map.get("astrolabe_active_elem_cost").getValue());
        astrolabeResetCost = ImmutableThingUtil.fromJson(map.get("astrolabe_reset").getValue());
    }
}
