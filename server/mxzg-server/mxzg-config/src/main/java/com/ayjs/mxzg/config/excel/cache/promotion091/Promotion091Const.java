package com.ayjs.mxzg.config.excel.cache.promotion091;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/1/16
 **/
@Component
public class Promotion091Const extends ExcelDictionaryCache {

    @Getter
    private ImmutableList<ImmutableThing> boxCost;
    @Getter
    private ImmutableList<ImmutableThing> gashaponCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        /**盲盒消耗*/
        boxCost = ImmutableThingUtil.fromJson(map.get("promotion091_box_cost").getValue());
        /**扭蛋消耗*/
        gashaponCost = ImmutableThingUtil.fromJson(map.get("promotion091_gashapon_cost").getValue());
    }
}
