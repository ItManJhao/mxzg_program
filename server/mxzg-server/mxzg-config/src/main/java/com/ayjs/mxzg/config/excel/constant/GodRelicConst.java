package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
@Getter
public class GodRelicConst extends ExcelDictionaryCache {

    /***
     * 每日免费次数
     */
    private int godRelicDailyFreeTimes = 0;//120;

    /***
     * 购买最大次数
     */
    private int godRelicDailyBuyTimes = 0;//120;

    /***
     * 购买消耗
     */
    private ImmutableList<ImmutableThing> godRelicDailyBuyNeed;//120;

    private String levelLanguage = 5756 + "";

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        godRelicDailyBuyNeed = ImmutableThingUtil.fromJson(map.get("relic_daily_buy_need").getValue());
        godRelicDailyBuyTimes = Integer.valueOf(map.get("relic_daily_buy_times").getValue());
        godRelicDailyFreeTimes = Integer.valueOf(map.get("relic_daily_free_times").getValue());

    }

}
