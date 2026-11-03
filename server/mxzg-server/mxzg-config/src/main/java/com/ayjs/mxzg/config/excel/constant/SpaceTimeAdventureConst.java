package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

/**
 * @author hyx
 */
@Component
public class SpaceTimeAdventureConst extends ExcelDictionaryCache {

    /**
     * 舰队名字上限
     */
    @ExcelDictionaryField("spacetime_name_max")
    public static int SPACETIME_NAME_MAX = 0;

    /**
     * 土著商店商品刷新数量
     */
    @ExcelDictionaryField("spacetime_shop_item_limit")
    public static int SPACETIME_SHOP_ITEM_LIMIT = 0;

    /**
     * 异界冒险-土著商店开启时长
     */
    @ExcelDictionaryField("spacetime_shop_open_time_limit")
    public static int SPACETIME_SHOP_OPEN_TIME_LIMIT = 7200;

    public static String LANGUAGE = 76569 + "";

    /**
     * 匹配战力上限
     */
    @ExcelDictionaryField("spacetime_fighting_up")
    public static int SPACETIME_FIGHTING_UP = 12000;
    /**
     * 匹配战力下限
     */
    @ExcelDictionaryField("spacetime_fighting_down")
    public static int SPACETIME_FIGHTING_DOWN = 8000;

    public static int PROGRESS_TIMES = 300;

    /**
     * 航线礼包开启进度
     */
    @ExcelDictionaryField("spacetime_open_product_sail_progress")
    public static int SPACETIME_OPEN_PRODUCT_SAIL_PROGRESS = 5000;

    /**
     * 商品出现时长
     */
    @ExcelDictionaryField("spacetime_product_open_time")
    public static int SPACETIME_PRODUCT_OPEN_TIME = 7200;

}

