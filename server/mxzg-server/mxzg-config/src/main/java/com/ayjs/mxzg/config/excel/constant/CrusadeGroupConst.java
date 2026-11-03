package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 讨伐团
 */
@Component
public class CrusadeGroupConst extends ExcelDictionaryCache {

    /** 血量默认上限 */
    public static int HP_DEFAULT_UP_LIMIT = 10000;

    /** 小地图每页显示的数据大小 */
    public static int PAGE_SIZE_NUM = 1000;

    /** 默认的关隘和boss占领id */
    public static int DEFAULT_OCCUPIED_ID = 1;

    /** 元素概率分母 */
    public static int ELEMENT_RATE_DENOMINATOR = 9000;

    /** 体力恢复间隔 */
    public static int RECOVERY_PHYSICAL_INTERVAL_S = 3600;

    /** 默认的开垦英雄id */
    public static int DEFAULT_RECLAIM_HERO_ID = 6;

    /**
     * 讨伐团成员上限
     */
    @ExcelDictionaryField("group_upper_limit")
    public static int GROUP_UPPER_LIMIT	= 160;

    /**
     * 讨伐团成员下限
     */
    @ExcelDictionaryField("group_lower_limit")
    public static int GROUP_LOWER_LIMIT	= 140;

    /**
     * 讨伐团英雄等级
     */
    @ExcelDictionaryField("crusade_group_hero_level")
    public static int CRUSADE_GROUP_HERO_LEVEL = 380;

    /**
     * 讨伐团初始爵位等级
     */
    @ExcelDictionaryField("crusade_group_init_knighthood_id")
    public static int CRUSADE_GROUP_INIT_KNIGHTHOOD_ID = 1;

    /**
     * 讨伐团初始英雄体力
     */
    @ExcelDictionaryField("crusade_group_init_energy")
    public static int CRUSADE_GROUP_INIT_ENERGY = 60;

    /**
     * 讨伐团元素比例 格式：{"2000":1,"4000":2,"6000":3,"8000":4,"10000":5}
     */
    @ExcelDictionaryField("crusade_group_element_rate")
    public static Map<Integer, Integer> ELEMENT_RATE;

    /**
     * npc恢复的时间（单位：秒）
     */
    @ExcelDictionaryField("npc_recovery_time_s")
    public static int NPC_RECOVERY_TIME_S = 3600;

    /**
     * 评价战力比例，高于自身最大战力该比例为困难，大于或小于该比例以内为势均力敌，小于该比例则为简单（万分比）
     */
    @ExcelDictionaryField("evaluation_fighting_ratio")
    public static int EVALUATION_FIGHT_RATIO = 3000;

    /**
     * 评价获得第二颗星的时候不能大于的回合数
     */
    @ExcelDictionaryField("evaluation_second_star_round")
    public static int EVALUATION_SECOND_STAR_ROUND = 7;

    /**
     * 星级获得的体力恢复列表，格式：{"1":2,"2":4,"3":6}
     */
    @ExcelDictionaryField("star_recovery_physical")
    public static Map<Integer, Integer> STAR_RECOVERY_PHYSICAL;

    /**
     * 开发过后的产量倍数
     */
    @ExcelDictionaryField("production_increase_ratio")
    public static double PRODUCTION_INCREASE_RATIO = 1.2;

    /**
     * 精华生产间隔（秒）
     */
    @ExcelDictionaryField("essence_production_interval_s")
    public static int ESSENCE_PRODUCTION_INTERVAL_S = 360;

    /** 每小时恢复的体力 */
    @ExcelDictionaryField("recovery_physical")
    public static int RECOVERY_PHYSICAL = 4;

    /** 讨伐团指挥者数量 */
    @ExcelDictionaryField("crusade_group_commander")
    public static int CRUSADE_GROUP_COMMANDER = 3;

    /**讨伐团名字长度  */
    @ExcelDictionaryField("group_name_length")
    public static int GROUP_NAME_LENGTH = 25;

    /** 重命名次数上限  */
    @ExcelDictionaryField("rename_number_up_limit")
    public static int RENAME_NUMBER_UP_LIMIT = 1;

    /** 讨伐团开启后几天内可以重命名   */
    @ExcelDictionaryField("rename_days")
    public static int RENAME_DAYS = 1;

    /** boss刷新时间（单位：秒）  */
    @ExcelDictionaryField("boss_refresh_time_s")
    public static int BOSS_REFRESH_TIME_S = 3600;
    /**
     * 保护时间
     */
    @ExcelDictionaryField("challenge_protection_time_s")
    public static int CHALLENGE_PROTECTION_TIME_S = 1800;

}
