package com.ayjs.mxzg.config.excel.cache.promotion089;

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
 * @Date: 2020/12/14
 **/
@Component
public class Promotion089Const extends ExcelDictionaryCache {

    @Getter
    @ExcelDictionaryField("promotion089_reward")
    private ImmutableList<ImmutableThing> reward;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        reward = ImmutableThingUtil.fromJson(map.get("promotion089_reward").getValue());
    }
}
