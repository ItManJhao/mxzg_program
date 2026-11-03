package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 龙舟活动
 *
 * @author hyx
 */
@Component
public class DragonBoatConst extends ExcelDictionaryCache {

    /**
     * 龙舟翻牌组数量
     */
    @ExcelDictionaryField("promotiondragonboat_card_count")
    public static int PROMOTION_DRAGON_BOAT_CARD_COUNT = 0;

    /**
     * 翻牌消耗
     */
    public static ImmutableList<ImmutableThing> PROMOTION_DRAGON_BOAT_COST;

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        PROMOTION_DRAGON_BOAT_COST = ImmutableThingUtil.fromJson(map.get("promotiondragonboat_cost").getValue());
    }

}
