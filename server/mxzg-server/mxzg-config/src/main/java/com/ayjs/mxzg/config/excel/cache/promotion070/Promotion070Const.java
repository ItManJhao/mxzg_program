package com.ayjs.mxzg.config.excel.cache.promotion070;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/8/7
 **/
@Component
@Getter
public class Promotion070Const extends ExcelDictionaryCache {

    @ExcelDictionaryField("promotion070_open_cost")
    private ImmutableList<ImmutableThing> openCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        openCost = ImmutableThingUtil.fromJson(map.get("promotion070_open_cost").getValue());
    }
}
