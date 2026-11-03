package com.ayjs.mxzg.config.excel.cache.promotion074;

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
 * @Date: 2020/9/23
 **/
@Getter
@Component
public class Promotion074Const extends ExcelDictionaryCache {
    @ExcelDictionaryField("promotion074_lottery_cost")
    private ImmutableList<ImmutableThing> lotteryCost;
    @ExcelDictionaryField("promotion074_lottery_change_cost")
    private ImmutableList<ImmutableThing> lotteryChangeCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        lotteryCost = ImmutableThingUtil.fromJson(map.get("promotion074_lottery_cost").getValue());
        lotteryChangeCost = ImmutableThingUtil.fromJson(map.get("promotion074_lottery_change_cost").getValue());
    }
}
