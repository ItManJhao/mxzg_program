/**
 *
 */
package com.ayjs.mxzg.gameserver.module.recharge.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum BuyGemType {
    NORMAL(1, "普通充值"),
    //	NORMAL(1, "普通充值"),
    FOUNDATION(2, "成长基金"),

    MONTH_CARD(3, "月卡基金"),

    HERO_STAR_GIFT(4, "星级养成礼"),

    WEEK_GIFT(5, "每周福利限购"),
    DAILY_GIFT(6, "每日礼包限购"),
    OVERVALUE_GIFT(7, "超值礼包"),
    PRIVILEGE_GIFT(8, "特权礼包"),
    MONTH_GIFT(9, "每月福利限购"),
    NEW_SERVER(11, "新服限购"),
    ROLE_LEVEL_GIFT(12, "等级养成礼"),
    CHAPTER_GIFT(13, "关卡养成礼"),
    HAPPY_TIME(15, "狂欢时刻特权"),

    FESTIVAL_OVERVALUE_GIFT(16, "节日豪礼"),

    TRAFFIC_PERMIT_PRIVILEGE_GIFT(17, "通行证活动特权礼包"),
    FLASH_SALE(18, "限时抢购"),

//    FIRST_RECHARGE(19, "新首充"),  // 又改回累冲了

    HERO_SUMMON(20, "英雄召唤祈愿特权"),
    FASHION_BUY(21, "皮肤购买"),

    GOD_RELIC(22, "诸神遗迹"),

    HIGH_WEEK_CARD(23, "高级周卡"),

    SUMMON_WEEK_CARD(24, "召唤周卡"),
    CUSTOM(25, "私人定制"),

    ELF_WEEK_CARD(26, "精灵周卡"),
    LONG_ZHOU(27, "龙舟活动"),
    STAGE_MATCH(28, "超凡段位赛"),
    WEEKEND_KOI(29, "周末锦鲤"),
    PROMOTION_070(30, "梦境秘宝"),

    QI_SHEN_QI(31, "七神器"),

    SPACE_TIME_PRODUCT(32, "异界冒险"),

    PLANE_WAR_LIMIT(33, "位面之战限购礼包"),

    MID_FOOD(34, "赏月佳肴"),

    REGISTER_GIFT(35, "玩家注册奖励"),

    HALLOWEEN_GIFT(36, "万圣礼包"),
    BLACK_FIVE_GIFT(37, "黑五礼包"),
    BLACK_FIVE_MISSION_GIFT(38, "黑五任务礼包"),
    CHRISTMAS_GIFT(39, "圣诞活动礼包"),
    PROMOTION_090(40, "通行证2活动特权礼包"),
    PROMOTION_095(41, "春游记"),
    COUNTRY_WAR_SCORE(42, "国战积分"),
    FOREVER_HERO_SKIN(43, "永久皮肤"),
    MAGIC_TOWER_KING(44, "斩魔王者"),
    ;

    private static Map<Integer, BuyGemType> typeMap = new HashMap<>();

    static {
        for (BuyGemType type : BuyGemType.values()) {
            typeMap.put(type.getType(), type);
        }
    }

    private final int type;
    private final String remark;

    private BuyGemType(int type, String remark) {
        this.type = type;
        this.remark = remark;
    }

    public int getType() {
        return type;
    }

    public String getRemark() {
        return remark;
    }

    public static BuyGemType valueOf(int type) {
        return typeMap.get(type);
    }
}
