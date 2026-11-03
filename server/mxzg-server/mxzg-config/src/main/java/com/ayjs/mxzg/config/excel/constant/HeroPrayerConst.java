package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

@Component
public class HeroPrayerConst extends ExcelDictionaryCache {

    /**
     * 祈愿特权持续时间
     */
    @ExcelDictionaryField("hero_prayer_duration")
    public static int HERO_PRAYER_DURATION = 30;

}
