package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

@Component
public class PreliminariesConst extends ExcelDictionaryCache {

    /**
     * 排行榜展示大小
     */
    public static int RANKS_SIZE = 128;
    /**
     * 巅峰赛预赛排名大小
     */
    @ExcelDictionaryField("preliminaries_ranks_number")
    public static int PRELIMINARIES_RANKS_NUMBER = 1000;
    /**
     * 巅峰赛排名前4的玩家固定的排名
     */
    @ExcelDictionaryField("topmatch_match_separate_rankA")
    public static int PRELIMINARIES_RANKS_TOP_A = 6;
    /**
     * 巅峰赛排名前4的玩家固定的排名
     */
    @ExcelDictionaryField("topmatch_match_separate_rankB")
    public static int PRELIMINARIES_RANKS_TOP_B = 4;

    /**
     * 巅峰赛预赛-高于排名分界线A的系数3，则在1到当前排名+3中随机3个玩家
     */
    @ExcelDictionaryField("topmatch_match_separate_ratio")
    public static int TOPMATCH_MATCH_SEPARATE_RATIO = 3;

    /**
     * 对手数量
     */
    @ExcelDictionaryField("topmatch_opponent_number")
    public static int OPPONENT_NUMBER = 3;
    /**
     * 预赛每天挑战的次数
     */
    @ExcelDictionaryField("preliminaries_challenges")
    public static int PRELIMINARIES_CHALLENGES = 999;
    /**
     * 预赛购买次数
     */
    @ExcelDictionaryField("preliminaries_purchases")
    public static int PRELIMINARIES_PURCHASES = 10;
    /**
     * 大神录像的排名门槛
     */
    @ExcelDictionaryField("preliminaries_superior_rank")
    public static int PRELIMINARIES_SUPERIOR_RANK = 50;
    /**
     * 预赛赛购买次数
     */
    @ExcelDictionaryField("preliminaries_buy_times")
    public static int PRELIMINARIES_BUY_TIMES = 10;
    /**
     * 预赛个人记录条数
     */
    @ExcelDictionaryField("preliminaries_record_num")
    public static int PRELIMINARIES_RECORD_NUM = 50;
    /**
     * 预赛的资格段位
     */
    @ExcelDictionaryField("preliminary_qualification_stage_id")
    public static int PRELIMINARY_QUALIFICATION_STAGE_ID = 10;


}
