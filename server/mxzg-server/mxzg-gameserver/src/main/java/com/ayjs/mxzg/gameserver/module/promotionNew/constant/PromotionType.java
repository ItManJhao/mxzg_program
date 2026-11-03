/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.constant;

import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.ILoopingPromotionCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion015NewServerLimitGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion016DragonMarkDropsSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion017DragonMarkTotalChargeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion018SevenDayTargetSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion019MainLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion020DailyGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion021DailyFirstRechargeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion022DailyTotalRechargeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion023MonthGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion024WeeklyGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion025BuyGoldSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion026SpeedfightSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion027AdventureSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion028TavernWeeklySysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion031PvpWinsSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion032TavernSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion033CombineSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion034PveSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion035HappyTimeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion054FlashSaleSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion061ThreeDayTaskSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion063ElfWeekCardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion067WeekendKoiSysCache;
import com.ayjs.mxzg.gameserver.web.activity.config.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 所有活动类型
 * @author YY
 *
 */
public enum PromotionType {
    CHAO_ZHI_SHOU_CHONG(		"超值首充",	1,	 0, 0, null),//首充奖励
    YAO_QING_YOU_LI(			"邀请有礼",	2,	 0, 0, null),
    DENG_LU_ZENG_LI(			"登录赠礼",	3,	 0, 0, null),//新号七登奖励
    QIAN_DAO(					"签到",		4,	 0, 0, null),
    CHENG_ZHANG_JI_JIN(			"成长基金",	5,	 0, 0, null),
    YUE_JI_JIN_128(				"月基金128",	6,	 0, 0, null),
    YUE_JI_JIN_328(				"月基金328",	7,	 0, 0, null),
    YUE_KA(						"月卡",		8,	 0, 0, null),
    ZUN_GUI_YUE_KA(				"尊贵月卡",	9,	 0, 0, null),
    TE_QUAN_SHANG_CHENG(		"特权商城",	10,	 0, 0, null),//特权礼包

    YING_XIONG_JIANG_LIN(		"英雄降临",	11,	 0, 0, null),
    XING_JI_YANG_CHENG_LI(		"星级养成礼",	12,	 0, 0, null),
    DENG_JI_YANG_CHENG_LI(		"等级养成礼",	13,	 0, 0, null),
    GUAN_QIA_YANG_CHENG_LI(		"关卡养成礼",	14,	 0, 0, null),

    XIN_FU_LI_BAO(				"新服礼包", 	15,	 1, 0, Promotion015NewServerLimitGiftSysCache.class),
    XIAN_SHI_DUI_HUAN(			"限时兑换",	16,	 1, 0, Promotion016DragonMarkDropsSysCache.class),
    LEI_JI_CHONG_ZHI(			"累计充值",	17,	 1, 0, Promotion017DragonMarkTotalChargeSysCache.class),
    QI_RI_MU_BIAO(				"七日目标",	18,	 1, 0, Promotion018SevenDayTargetSysCache.class),
    SHENG_JI_YOU_LI(			"升级有礼",	19,	 1, 0, Promotion019MainLevelRewardSysCache.class),
    MEI_RI_LI_BAO(				"每日礼包",	20,	 1, 0, Promotion020DailyGiftSysCache.class),
    MEI_RI_SHOU_CHONG(			"每日首充",	21,	 1, 0, Promotion021DailyFirstRechargeSysCache.class),
    MEI_RI_LEI_CHONG(			"每日累充",	22,	 1, 0, Promotion022DailyTotalRechargeSysCache.class),
    MEI_YUE_FU_LI(				"每月福利",	23,	 1, 0, Promotion023MonthGiftSysCache.class),
    MEI_ZHOU_FU_LI(				"每周福利",	24,	 1, 0, Promotion024WeeklyGiftSysCache.class),
    DIAN_SHI_CHENG_JIN(			"点石成金", 	25,	 1, 0, Promotion025BuyGoldSysCache.class),
    SU_ZHAN_ZHI_WANG(			"速战之王",	26,	 1, 0, Promotion026SpeedfightSysCache.class),
    SHI_LIAN_ZHI_LU(			"试炼之路",	27,	 1, 0, Promotion027AdventureSysCache.class),
    JIU_GUAN_CHANG_KE(			"酒馆常客",	28,	 1, 0, Promotion028TavernWeeklySysCache.class),
    MAO_XIAN_RI_JI(				"冒险日记",	29,	 1, 0, Promotion029AdventureNotesSysCache.class),
    SHEN_MI_MO_HE(				"神秘魔盒",	30,	 1, 0, Promotion030MysteryBoxSysCache.class),


    JING_JI_ZHI_DIAN(			"竞技之巅",	31,	 1, 1, Promotion031PvpWinsSysCache.class),
    JIU_GUAN_DA_BIAO(			"酒馆达标",	32,	 1, 2, Promotion032TavernSysCache.class),
    HE_CHENG_JUE_XING(			"合成觉醒",	33,	 1, 3, Promotion033CombineSysCache.class),
    ZHU_SHEN_ZHI_ZHAN(			"诸神之战",	34,	 1, 4, Promotion034PveSysCache.class),
    KUANG_HUAN_SHI_KE(			"狂欢时刻",	35,	 1, 5, Promotion035HappyTimeSysCache.class),


    MI_JING_SHANG_CHENG(		"秘境商城",	36,	 0, 0, null),
    XU_YUAN_DA_BIAO(			"许愿达标",	37,	 2, 0, Promotion037WishTimesConfig.class),
    ZHAN_XING_ZHEN_REN_WU(		"占星阵任务",	38,	 2, 0, Promotion038AstrologyConfig.class),
    CHAO_ZHI_LI_BAO(			"超值礼包",	39,	 2, 0, Promotion039OvervalueGiftConfig.class),
    ZHAO_HUAN_DA_BIAO(			"召唤达标",	40,	 2, 0, Promotion040SummonTimesConfig.class),
    XIAN_ZHI_KUI_ZENG(			"先知馈赠",	41,	 2, 0, Promotion041ProphecyTimesConfig.class),
    JI_TAN_DUI_HUAN(			"祭坛兑换",	42,	 2, 0, Promotion042SacrificesShopConfig.class),
    ZHAO_HUAN_SHUI_JING(		"召唤水晶",	43,	 2, 0, Promotion043SummonCrystalConfig.class),
    QI_CAI_HUA_ZHANG(			"七彩华章",	44,	 2, 0, Promotion044FiresShopConfig.class),
    DENG_LU_YOU_LI(				"登录有礼",	45,	 2, 0, Promotion045LoginGiftConfig.class),

    SUI_PIAN_JIN_HUA(			"碎片进化",	46,	 2, 0, Promotion046ExchangeShopConfig.class),
    /**
     * 跟每周累充，冲突，去掉
     */
    //	QI_TIAN_LEI_CHONG(			"七天累充",	47,	 2, 0, null),
    MEI_ZHOU_LEI_CHONG(			"每周累充",	48,	 2, 0, Promotion048WeeklyRechargeConfig.class),

    JI_TIAN_HAO_LI(				"积天豪礼",	49,	 0, 0, null),//积天累充

    JIE_RI_LI_BAO(              "节日礼包",	50,	 2, 0, Promotion050FestivalOvervalueGiftConfig.class),
    JIE_RI_DENG_LU(             "节日登陆",	51,	 2, 0, Promotion051FestivalLoginGiftConfig.class),

    CHAO_ZHI_YANG_CHENG_LI(     "超值养成礼",	52,	 0, 0, null),

    TONG_XING_XHENG(            "通行证",		53,  1, 0, PromotionTrafficPermitSysCache.class),
    XIAN_SHI_QIANG_GOU(         "限时抢购",	54,  1, 0, Promotion054FlashSaleSysCache.class),
    WEEKEND_GIFT(               "周末礼包",	55,  0, 0, null),

    FASHION_BUY(                "皮肤活动",	56,  2, 0, Promotion056FashionBuyConfig.class),

    MEI_RI_DENG_LU(				"每日登陆",	57,	 2, 0, Promotion057EveryDayLoginConfig.class),

    GAO_JI_ZHOU_KA(             "高级周卡",	58,  2, 0, Promotion058HighWeeksCardConfig.class),

    ZHAO_HUAN_ZHOU_KA(          "召唤周卡",	59,  2, 0, Promotion059SummonWeeksCardConfig.class),
    JI_TIAN_HAO_LI_2(           "积天豪礼2",	60,  0, 0, null),

    SAN_RI_REN_WU(              "三日任务"	,	61,  1, 0, Promotion061ThreeDayTaskSysCache.class),
    CUSTOM(                     "私人定制",	62,  2, 0, Promotion062CustomRewardConfig.class),

    JING_LING_ZHOU_KA(          "精灵周卡",	63,  1, 0, Promotion063ElfWeekCardSysCache.class),

    LONG_ZHOU_HOU_DONG(         "龙舟活动",	64,  2, 0, Promotion064DragonBoatConfig.class),
    HERO_ROLLING(           	"新英雄抽卡",	65,  2, 0, Promotion065HeroRollingConfig.class),
    GONG_NENG_YU_GAO(           "功能预告",	66,  0, 0, null),

    ZHOU_MO_JIN_LI(             "周末锦鲤",    67, 1, 0, Promotion067WeekendKoiSysCache.class),

    SHI_KONG_YI_DAO(            "时空异宝",    68, 2, 0, Promotion068SpacetimeTreasureConfig.class),
    CHAO_ZHI_ZENG_LI(           "超值赠礼",    69, 0, 0, null),
    MENG_JING_MI_BAO(           "梦境秘宝",    70, 2, 0, Promotion070RewardConfig.class),
    QI_SHEN_QI(                 "七神器",      71, 2, 0, Promotion071QSQConfig.class),
    ZHU_SHEN_JI_TAN(            "诸神祭坛",    72, 2, 0, Promotion072RewardConfig.class),
    RESET_NORMAL_DOUBLE(        "重置购买双倍", 73, 2, 0, EmptyActivityConfig.class),
    QIU_SHANG_MING_YUE(         "秋赏明月",    74, 2, 0, Promotion074LotteryRewardConfig.class),
    MID_FOOD(                   "赏月佳肴",    75, 2, 0, Promotion075MidFoodConfig.class),
    YONG_JIU_PI_FU(             "永久皮肤",    76, 2, 0, Promotion076ExchangeRewardConfig.class),
    GUANG_YUE_REN_WU(           "观月任务",    77, 2, 0, EmptyActivityConfig.class),
    WAN_SHENG_LOTTERY(          "万圣抽奖",    78, 2, 0, Promotion078LotteryRewardConfig.class),
    WANG_SHENG_GIFT(            "万圣礼包",    79, 2, 0, Promotion079GiftConfig.class),
    WAN_SHENG_MISSION(          "万圣任务",    80, 2, 0, EmptyActivityConfig.class),


    HEI_WU_MISSION(             "黑五活动任务", 81, 2, 0, Promotion081GiftConfig.class),
    HEI_WU_GIFT(                "黑五活动礼包", 82, 2, 0, Promotion082GiftConfig.class),
    HEI_WU_LOTTERY(             "黑五活动抽奖", 83, 2, 0, Promotion083LotteryRewardConfig.class),

    SAN_RI_LEI_CHONG(			"三日累充",	84,	 2, 0, Promotion084ThreeDayConfig.class),

    CHRISTMAS_MISSION(			"圣诞连线",	85,	 2, 0, Promotion085BoxRewardConfig.class),
    CHRISTMAS_GIFT(			    "约惠圣诞",	86,	 2, 0, Promotion086GiftConfig.class),
    CHRISTMAS_LOTTERY(			"嗨翻圣诞",	87,	 2, 0, Promotion087LotteryRewardConfig.class),
    CHRISTMAS_SCORE(			"圣诞礼盒",	88,	 2, 0, Promotion088RandomRewardConfig.class),
    CHRISTMAS_NOTE(			    "圣诞感谢信",	89,	 2, 0, EmptyActivityConfig.class),

    TONG_XING_XHENG_2(          "通行证2",	90,  2, 0, Promotion090TrafficPermitGiftConfig.class),
    CHUN_JIE(                   "春节活动",	91,  2, 0, Promotion091GashaponLotteryRewardConfig.class),
    NV_SHEN_XIAN_HUA(           "女神献花",	92,  2, 0, Promotion092Config.class),
    CHUN_RI_TA_QING(            "春日踏青",	93,  2, 0, Promotion093RandomRewardConfig.class),
    ZHI_ZUO_NIU_DAN(            "制作彩蛋",	94,  2, 0, Promotion094RandomRewardConfig.class),
    CHUN_YOU_JI(                "春游记",	    95,  2, 0, Promotion095GiftConfig.class),
    CHU_YOU_XUN_CHUN(           "出游寻春",    96,  2, 0, Promotion096BoxRewardConfig.class),
    LABOR_DAY_LUCK_DRAW(        "五一抽奖", 97, 2, 0, Promotion097LaborDayConfig.class),
    ACTIVE_JUMP(                "活动条状", 98, 2, 0, Promotion098ActiveJumpConfig.class),
    ;


    private final String name;
    private final int id;
    /**
     * 开启方式，0系统功能，1策划陪标循环开启，2运营后台控制开启
     */
    private final int openType;
    /**
     * 只有openType=2的需要配置，运营活动配置解析结构体
     *
     */
    private Class<? extends IActivityConfig> clz;
    /**
     * 活动重置顺序
     */
    private int sort;
    /**
     * 只有1类型的需要配置
     */
    private Class<? extends ILoopingPromotionCache> loopCacheClz;

    private static Map<Integer, PromotionType> typeMap = new HashMap<>();

    static {
        for (PromotionType type : PromotionType.values()) {
            typeMap.put(type.getId(), type);
        }
    }

    @SuppressWarnings("unchecked")
    private PromotionType(String name, int id, int openType, int sort, Class<?> clz) {
        this.name = name;
        this.id = id;
        this.openType = openType;
        this.sort = sort;
        if (openType == 1) {
            this.loopCacheClz = (Class<? extends ILoopingPromotionCache>) clz;
        } else if (openType == 2) {
            this.clz = (Class<? extends IActivityConfig>) clz;
        }
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public int getOpenType() {
        return openType;
    }

    public Class<? extends IActivityConfig> getClz() {
        return clz;
    }

    public static PromotionType valueOf(int id) {
        return typeMap.get(id);
    }

    public int getSort() {
        return sort;
    }

    public Class<? extends ILoopingPromotionCache> getLoopCacheClz() {
        return loopCacheClz;
    }

    public static Map<Integer, PromotionType> getTypeMap() {
        return typeMap;
    }

}
