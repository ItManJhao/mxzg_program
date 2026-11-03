package com.ayjs.mxzg.config.excel.cache.promotion093;

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
public class Promotion093Const extends ExcelDictionaryCache {

    @Getter
    private ImmutableList<ImmutableThing> diceCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        /**丢骰子消耗*/
        diceCost = ImmutableThingUtil.fromJson(map.get("promotion093_dice_cost").getValue());
    }
}
