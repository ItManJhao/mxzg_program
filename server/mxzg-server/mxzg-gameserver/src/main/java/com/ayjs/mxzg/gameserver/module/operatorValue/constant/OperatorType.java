package com.ayjs.mxzg.gameserver.module.operatorValue.constant;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 10:07
 */
public enum OperatorType {

    /**
     * 玩家登陆
     */
    ROLE_LOGIN(1001),

    /**
     * 参与 竞技场
     */
    JOIN_ARENA(1002),

    /**
     * 玩家在线时长
     */
    ROLE_ONLINE(1003),

    /**
     * 友情赠送
     */
    GIVE_FRIEND(1004),

    /**
     * 任意英雄召唤
     */
    HERO_SUMMON(1005),

    /**
     * 每日挑战幻镜之塔
     */
    CHALLENGE_TOWER(1006),

    /**
     * 挑战公会BOSS
     */
    CHALLENGE_CLAN_BOSS(1007),

    /**
     * 酒馆任务派遣
     */
    TAWERN_TASK(1008),

    /**
     * 每日副本
     */
    DAILY_DUNGEON(1009),

    /**
     * 试炼战斗胜利
     */
    ADVEN_BATTLE_WIN(1010),

    /**
     * 公会捐赠
     */
    CLAN_DONATE(1011),

    /**
     * 升级公会技能
     */
    UP_CLAN_SKILL(1012),

    /**
     * 每日合成装备
     */
    COMPOSE_EQUIP(1013),
    /**
     * 购买任意点金
     */
    BUY_GOLD(1014),
    /**
     * 任意许愿池
     */
    WISH(1015),
    /**
     * 高级招募
     */
    SENIOR_SUMMON(1016),
    /**
     * 快速作战
     */
    QUICK_BATTLE_TASK(1017),
    /**
     * 扫荡幻镜之塔
     */
    BATTLE_TOWER(1018),

    /**
     * 四星英雄
     */
    FOUR_STAR_HERO(1100),
    /**
     * 五星英雄
     */
    FIVE_STAR_HERO(1101),
    /**
     * 六星英雄
     */
    SIX_STAR_HERO(1102),
    /**
     * 七星英雄
     */
    SEVEN_STAR_HERO(1103),
    /**
     * 八星英雄
     */
    EIGHT_STAR_HERO(1104),
    /**
     * 九星英雄
     */
    NINE_STAR_HERO(1105),
    /**
     * 十星英雄
     */
    TEN_STAR_HERO(1106),
    /**
     * 十一星英雄
     */
    ELEVEN_STAR_HERO(1107),
    /**
     * 十二星英雄
     */
    TWELVE_STAR_HERO(1108),
    /**
     * 十三星英雄
     */
    THIRTEEN_STAR_HERO(1109),

    /**
     * 先知召唤
     */
    PROPHET_SUMMON(1111),

    /**
     * 英雄置换
     */
    HERO_SWOP(1112),

    /**
     * 竞技场胜利
     */
    ARENA_WIN(1113),

    /**
     * 钻石消耗
     */
    GEM_CONSUME(1114),

    /**
     * 幻镜之塔层数
     */
    TOWER_STAGE(1115),

    /**
     * 关卡难度解锁
     * (废弃)
     */
    CHAPTER_LEVEL(1116),

    /**
     * 战力值成就
     */
    ROLE_FIGHTING(1117),

    /**
     * 玩家等级
     */
    ROLE_LEVEL(1118),

    /**
     * 英雄献祭
     */
    ALTAR_HERO(1119),

    /**
     * 常规许愿
     */
    GENERAL_WISH(1120),

    /**
     * 高级许原
     */
    SENIOR_WISH(1121),
    /***
     * 激活至尊月卡
     */
    ACTIVE_BEST_MONTH_CARD(1302),

    /**
     * 快速作战
     */
    QUICK_BATTLE_END(1311),

    /**
     * 市场购买
     */
    MARKET_BUY(1312),

    /**
     * 高抽
     */
    senior(1313),

    /**
     * 获取橙色一星装备
     */
    ORAGE_ONESTAR_EQUIP(1406),

    /**
     * 四星酒馆任务
     */
    FOUR_STAR_TAVERN_TASK(1504),

    /**
     * 五星酒馆任务
     */
    FIVE_STAR_TAVERN_TASK(1505),

    /**
     * 六星酒馆任务
     */
    SIX_STAR_TAVERN_TASK(1506),

    /**
     * 竞技场最高分数
     */
    ARENA_MAX_CUP(1511),

    /**
     * 许愿池抽到5星英雄
     */
    WISH_FIVE_HERO(1512),

    /**
     * 记录试炼最大关卡
     */
    ADVEN_MAX_MISSION(1513),

    /**
     * 加入公会
     */
    JOIN_CLAN(1514),
    /**
     * 挑战OR扫荡公会BOSS/次
     */
    BATTLE_CLAN_BOSS(1515),
    /**
     * 公会技能升级/次
     */
    CLAN_UP_SKILL(1516),

    /**
     * 获取紫色装备
     */
    PURPLE_EQUIP(1603),

    /**
     * 获取橙色装备
     */
    ORAGE_EQUIP(1604),

    /**
     * 获取红色装备
     */
    RED_EQUIP(1605),

    //七天目标--------------------------------------------------------------

    /**
     * 七天目标钻石礼包
     */
    SEVEN_GEM_CONSUME(900002),

    /**
     * 开服累计充值
     */
    SEVEN_RECHARGE(1201),

    /**
     * 总登陆天数
     */
    SEVEN_LOGIN_DAY(1202),

    /**
     * 通关剧情
     */
    SEVEN_CHAPTER_NUM(1203),

    /**
     * 公会捐赠
     */
    SEVEN_CLAN_DONATE(1204),

    /**
     * 七天普通招募
     */
    SEVEN_HERO_SUMMON(1205),

    /**
     * 七天挑战竞技场
     */
    SEVEN_JOIN_ARENA(1206),

    /**
     * 七天完成酒馆订单
     */
    SEVEN_TAVERN_TASK(1207),

    /**
     * 用道具新增酒馆订单
     */
    SEVEN_ADD_TAVERN_TASK(1208),

    /**
     * 七天试炼胜利
     */
    SEVEN_ADVEN_BATTLE_WIN(1209),

    /**
     * 五星英雄
     */
    SEVEN_UP_FIVE_HERO(1251),
    /**
     * 六星英雄
     */
    SEVEN_UP_SIX_HERO(1252),
    /**
     * 七星英雄
     */
    SEVEN_UP_SEVEN_HERO(1253),
    /**
     * 八星英雄
     */
    SEVEN_UP_EIGHT_HERO(1254),
    /**
     * 九星英雄
     */
    SEVEN_UP_NINE_HERO(1255),
    /**
     * 十星英雄
     */
    SEVEN_UP_TEN_HERO(1256),
    /**
     * 十一星英雄
     */
    SEVEN_UP_ELEVEN_HERO(1257),
    /**
     * 十二星英雄
     */
    SEVEN_UP_TWELVE_HERO(1258),
    /**
     * 十三星英雄
     */
    SEVEN_UP_THIRTEEN_HERO(1259),

    /**
     * 领取七天登录的第N天奖励
     */
    GET_SEVEN_DAYS_LOGIN(1260),


    //新的----------------------------------


    ;
    private int type;

    private OperatorType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

    private static Map<Integer, OperatorType> map = new HashMap<>();

    static {
        try {
            map = Arrays.stream(OperatorType.values()).collect(Collectors.toMap(OperatorType::getType, Function.identity()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static OperatorType getEnumType(int type) {
        OperatorType result = map.get(type);
        if (result == null)
            throw new RuntimeException(String.format("不存在该枚举类型[%s]", type));
        return map.get(type);
    }
}
