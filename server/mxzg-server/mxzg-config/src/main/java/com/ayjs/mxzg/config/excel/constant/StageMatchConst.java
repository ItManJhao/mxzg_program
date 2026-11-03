package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

@Component
public class StageMatchConst extends ExcelDictionaryCache {

    /**
     * 每天匹配次数
     */
    @ExcelDictionaryField("super_stage_daily_matches")
    public static int DAILY_MATCHES = 10;
    /**
     * 每天可以购买的次数
     */
    @ExcelDictionaryField("super_stage_buy_times")
    public static int BUY_TIMES = 10;

    /**
     * 跳过布阵等待的时间
     */
    @ExcelDictionaryField("skip_array_waiting_time")
    public static int SKIP_ARRAY_WAITING_TIME = 10;
    /**
     * 匹配等待的时间
     */
    @ExcelDictionaryField("matching_waiting_time")
    public static int MATCHING_WAITING_TIME = 10;
    /**
     * 个人记录条数
     */
    @ExcelDictionaryField("super_stage_personal_record")
    public static int SUPER_STAGE_PERSONAL_RECORD = 30;
    /**
     * 大神
     */
    @ExcelDictionaryField("great_style_record_num")
    public static int GREAT_STYLE_RECORD = 30;

    /**
     * 大神风采的起始段位
     */
    @ExcelDictionaryField("great_style_stage_id")
    public static int GREAT_STYLE_STAGE_ID = 10;
    /**
     * 最小排名段位
     */
    @ExcelDictionaryField("super_stage_rank_min_stage")
    public static int SUPER_STAGE_RANK_MIN_STAGE = 1;
    /**
     * 段位赛排名数量
     */
    @ExcelDictionaryField("super_stage_number_rankings")
    public static int SUPER_STAGE_NUMBER_RANKINGS = 50;
    /**
     * 赛季传奇
     */
    @ExcelDictionaryField("season_legend_number_rankings")
    public static int SEASON_LEGEND_NUMBER_RANKINGS = 6;
    /**
     * 赛季初始段位id
     */
    @ExcelDictionaryField("super_stage_initial_stage_id")
    public static int SUPER_STAGE_INITIAL_STAGE_ID = 1;
    /**
     * 初始精英积分
     */
    @ExcelDictionaryField("super_stage_initial_points")
    public static int SUPER_STAGE_INITIAL_POINTS = 1;
    /**
     * 继承精英积分比例百分比
     */
    @ExcelDictionaryField("inherit_initial_points_rate")
    public static int INHERIT_ELITE_POINTS_RATIO = 80;
    /**
     * 排行榜大小
     */
    @ExcelDictionaryField("ranking_of_number")
    public static int RANKING_OF_NUMBER = 30;
    /**
     * 保護段位，不掉段
     */
    @ExcelDictionaryField("protection_level_stage_id")
    public static int PROTECTION_LEVEL_STAGE_ID = 1;
    /**
     * 连败次数
     */
    @ExcelDictionaryField("consecutive_failures_number")
    public static int CONSECUTIVE_FAILURES_NUMBER = 2;
    /**
     * 机器人属性范围最小值
     */
    @ExcelDictionaryField("robot_attribute_range_minimum")
    public static int ROBOT_ATTRIBUTE_RANGE_MINIMUM = 6000;
    /**
     * 机器人属性范围最大值
     */
    @ExcelDictionaryField("robot_attribute_range_maximum")
    public static int ROBOT_ATTRIBUTE_RANGE_MAXIMUM = 8000;
    /**
     * 可以连败匹配机器人的最大段位
     */
    @ExcelDictionaryField("robot_max_stage_id")
    public static int ROBOT_MAX_STAGE_ID = 12;

}
