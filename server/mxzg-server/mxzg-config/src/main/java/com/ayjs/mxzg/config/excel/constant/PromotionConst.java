package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class PromotionConst extends ExcelDictionaryCache {

    /**
     * 周末锦鲤赐福次数上限
     */
    @ExcelDictionaryField("weekend_koi_blessing_num")
    public static int WEEKEND_KOI_BLESSING_NUM = 0;

    /**
     * 周末锦鲤开始多少秒内可购买礼包
     */
    @ExcelDictionaryField("weekend_koi_buy_end_time")
    public static int WEEKEND_KOI_BUY_END_TIME = 0;

    /**
     * 周末锦鲤开启多少秒后抽取锦鲤大奖
     */
    @ExcelDictionaryField("weekend_koi_lottery_koi_time")
    public static int WEEKEND_KOI_LOTTERY_KOI_TIME = 0;

    /**
     * 超值赠礼最早开启时间
     */
    @ExcelDictionaryField("recharge_gift_start_time")
    public static int RECHARGE_GIFT_START_TIME = 30;

    public static ImmutableList<ImmutableThing> WEEKEND_KOI_BLESSING_COST;

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        WEEKEND_KOI_BLESSING_COST = ImmutableThingUtil.fromJson(map.get("weekend_koi_blessing_cost").getValue());
    }
}
