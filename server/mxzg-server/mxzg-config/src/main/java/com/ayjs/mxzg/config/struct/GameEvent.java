/**
 *
 */
package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.util.Asserts;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum GameEvent {
    // 1 Login 登录和系统模块

    // 2 Role 角色
    LEVEL_REWARD(2001, "等级奖励"),
    ONLINE_TIME(2002, "在线时长奖励"),
    GM(2003, "GM命令"),
    NEWBIE_REWARD(2004, "新手指引奖励"),
    RENAME_NICK(2005, "修改昵称扣费"),
    COMMENT_SHARED_REWARD(2006, "评论分享奖励"),
    CREATE_ROLE_MAIL(2007, "创角邮件奖励"),
    RENAME_PROP(2008, "修改昵称所耗道具"),
    ROLE_RENAMING(2019, "修改昵称所耗道具"),

    // 3 Battle 战斗,主线关卡
    IDLE_RESOURCE(3001, "挂机资源"),
    SWEEP_MISSION(3002, "主线扫荡"),
    CHAPTER_FIRST_REWARD(3003, "关卡首通"),
    CHAPTER_EXTRA_REWARD(3004, "关卡通关额外奖励"),
    BATTLE(3010, "战斗"),

    // 32 Tower 试练塔
    TOWER_AWARD(3201, "幻境塔奖励"),
    TOWER_SWEEP(3202, "幻镜之塔扫荡花费"),
    MISSION_QUICK_BATTLE(3203, "快速战斗花费"),
    MISSION_QUICK_BATTLE_REWARD(3204, "快速战斗奖励"),
    TOWER_FIRST_REWARD(3205, "幻境首通"),

    // 4 Hero 英雄
    HERO_SELL(4001, "出售英雄"),
    INCREASE_HERO(4002, "增加英雄"),
    HERO_ILLUSTRATED(4003, "英雄图鉴"),
    EQUIP_CHANGE(4004, "装备替换"),
    EQUIP_ALL_WEAR(4005, "装备一键穿戴"),
    EQUIP_ALL_OFF(4006, "装备一键脱下"),
    EQUIP_OFF(4008, "装备脱下"),
    COMBINE_PIECE_HERO(4009, "英雄碎片合成英雄"),
    HERO_UP_STAR(4010, "英雄升星"),
    HERO_UP_LEVEL(4011, "英雄升级"),
    HERO_UP_GRADE(4012, "英雄升阶"),
    UP_HERO_LEVEL(4013, "升级英雄"),
    ALTAR_HERO(4015, "英雄献祭"),
    HERO_LOTTERY(4016, "英雄抽奖"),
    HERO_UP_LINE(4017, "英雄上阵"),
    HERO_ON_LOGIN(4018, "玩家登录"),
    HERO_REBORN(4019, "英雄重生"),
    HERO_SWITCH(4020, "英雄置换"),
    HERO_COME_BACK(4021, "英雄回退"),
    JEWEL_CHANGE(4022, "宝石替换"),
    JEWEL_ALL_WEAR(4023, "宝石一键穿戴"),
    JEWEL_ALL_OFF(4024, "宝石一键脱下"),
    JEWEL_OFF(4025, "宝石卸下"),
    JEWEL_MAKE(4026, "宝石合成"),
    JEWEL_ALL_MAKE(4027, "宝石一键合成"),
    HERO_PRAYER(4028, "英雄祈愿"),
    TALENT_LEARN(4029, "天赋领悟"),
    TALENT_UPGRADE(4030, "天赋升级"),
    TALENT_FORGET(4031, "天赋遗忘"),
    HERO_FASHION_UP_LEVEL(4032, "皮肤升级"),
    HERO_ATTR_FIX(4033, "英雄属性补算"),
    HERO_FASHION_ACTIVE(4034, "皮肤激活"),
    HERO_FASHION_EXPIRES(4035, "皮肤过期"),
    HERO_REFRESH(4036, "战力异常单纯刷新一次战力"),
    HERO_NEW_ROLLING(4037, "新英雄抽卡"),
    HERO_EVOLVE_BACK(4038, "英雄进化回退"),
    HERO_LOTTERY_NORMAL_ONE(4039, "普通单抽"),
    HERO_LOTTERY_NORMAL_TEN(4040, "普通十抽"),
    HERO_LOTTERY_FRIEND_ONE(4041, "友情单抽"),
    HERO_LOTTERY_FRIEND_TEN(4042, "友情十抽"),
    HERO_LOTTERY_SENIOR_ONE(4043, "高级单抽"),
    HERO_LOTTERY_SENIOR_TEN(4044, "高级十抽"),
    HERO_LOTTERY_NEW_HERO_ONE(4045, "新英雄单抽"),
    HERO_LOTTERY_NEW_HERO_TEN(4046, "新英雄十抽"),
    HERO_LOTTERY_POINT_ONE(4047, "积分抽"),
    HERO_LEVEL_RESET(4048, "英雄等级重生"),

    HERO_EVOLVE(4101, "英雄进化"),

    HERO_AWAKEN_COST(4200, "觉醒重置消耗"),

    HERO_EQUIP_SOUL(4300, "装备附魂"),
    HERO_EQUIP_SOUL_RESET(4301, "装备附魂重置"),

    HERO_HEXAGRAM_UPGRADE(4351, "六芒星升级突破"),
    HERO_HEXAGRAM_RESET(4352, "六芒星重置"),
    // 5 BackPack 背包
    INCREASE_BACK_PACK(5001, "增加背包"),
    ITEM_COMPOSE(5002, "物品合成"),
    SHOP_RESOURCE(5003, "购买资源"),
    USE_ITEM(5004, "使用物品"),
    MAKE_ALL_EQUIP(5005, "装备一键合成"),
    OPEN_BOX(5006, "开启宝箱"),
    COMBINE_ELITE_PIECE_HERO(5007, "精英英雄碎片合成"),
    MAKE_EQUIP(5008, "装备合成"),
    SELF_SELECT_GIFT(5009, "自选礼包"),
    ITEM_DECOMPOSITION(5010, "道具分解"),
    RECHARGE_CARD_USE(5011, "充值卡使用"),

    // 6 Chat 聊天

    // 7 Clan 公会
    CLAN_DONATE_BOX(7002, "公会捐献宝箱"),
    CLAN_CREATE(7003, "公会创建"),
    CLAN_UP_SKILL(7004, "公会升级技能"),
    CLAN_BOSS_BATTLE(7005, "公会Boss单次挑战奖励"),
    CLAN_BOSS_BATTLE_NUM(7006, "购买公会Boss挑战次数"),
    CLAN_DONATE(7007, "公会捐献"),
    CLAN_BOSS_KILL(7008, "公会BOSS击杀"),
    CLAN_DUNGEON_BOSS_RANK(7009, "公会副本伤害排行榜"),
    CLAN_SKILL_RESET(7010, "重置公会技能消耗"),
    HERO_SUMMON_AWARD(7011, "累积召唤英雄"),
    WAR_BOX(7012, "抽取公会宝箱"),
    CLAN_SKILL_VERSION(7013, "公会技能改版补回"),

    CLAN_RENAMING_CARD(7014, "修改昵称所耗道具"),

    // 9 Friend 好友
    FRIEND_REWARD(9001, "好友赠送友情点"),

    // 11 Rank 排行榜
    RANK_WORSHIP(11001, "膜拜"),

    // 12 Achievement 成就
    ACHIEVEMENT(12001, "成就"),
    DAILY_TASK(12002, "每日任务"),
    ACHIEVEMENT_ACHIEVE_GET(12003, "成就奖励"),
    EVERY_DAY_TASK(12004, "每日任务"),
    ACHIEVEMENT_REWARD(12005, "成就奖励"),

    // 13 Task 任务活动
    PRIVILEGE_GIFT(13001, "特权礼包"),
    SIGN_GET(13002, "签到所得"),
    TAVERN_TASK(13003, "酒馆任务奖励"),
    TAVERN_TASK_RETURN(13004, "酒馆快速完成"),
    CYCLE_PROMOTION(13005, "循环活动奖励"),
    HERO_UP_STAGE(13006, "循环活动奖励"),
    TAVERN_TASK_REFRESH(13007, "酒馆刷新"),
    SUMMON_TIMES(13008, "召唤达标"),
    PROPHECY_GIFT(13009, "先知馈赠"),
    INVEST_GAIN(13010, "月卡基金"),
    MONTH_VIP_REWARD(13011, "至尊月卡每日VIP领取"),
    EXCHANGE_BUY(13012, "限时兑换"),
    LIMITED_TIME_RECHARGE(13013, "同步限时兑换限时累充活动"),

    // prophecy 先知
    PROPHECY_CHANGE_COST(13014, "先知英雄置换消耗"),
    PROPHECY_LOTTERY_GET(13015, "先知召唤所得"),
    PROPHECY_LOTTERY_COST(13016, "先知召唤消耗"),
    BUY_INVEST_GAIN(13017, "月卡基金"),
    PROPHECY_HERO_EXCHANGE(13018, "英雄置换"),


    EXCHANGE_SHOP(13019, "碎片进化"),
    LOGIN_GIFT(13020, "登录有礼"),
    WEEKLY_RECHARGE(13021, "每周累充"),

    BUY_PRIVILEGE(13022, "购买特权"),
    DAILY_FREE_GIFT(13023, "领取每日礼包免费奖励"),

    RECHARGE_DAYS_REWARD(13024, "领取积天累充奖励"),
    INVEST_SYS_GAIN(13025, "投资基金到期未领补发"),
    FIRES_SHOP(13026, "七彩华章"),
    RECHARGE_DAYS_AUTO_REWARD(13027, "自动补发积天累充奖励"),

    INVITE_GIFT(13050, "邀请有礼"),

    LIMITED_PRODUCTION(13060, "限时礼包"),

    TAVERN_TASK_DISPATCH(13070, "酒馆任务派遣"),

    TAVERN_POINTS_CREATE_ROLE(13071, "创号添加默认的冒险积分"),

    PROMOTION_RECHARGE_GIFT_REWARD(13072, "超值赠礼奖励"),

    FOREVER_HERO_SKIN_REWARD(13073, "永久皮肤商店奖励发放"),

    // 14 Buy 购买道具


    // 15 Mail 邮件
    MAIL_GET_ALL(15001, "邮件一键领取"),
    EXCHANGE_CODE(15002, "兑换码"),
    MAIL_FROM_SYS(15003, "系统邮件"),

    // 16 Adven 英雄试炼
    ADVEN_REWARD(16001, "试炼奖励"),

    // 17 BuyGold 点金
    BUY_GOLD(17001, "点金礼包购买"),

    // 18 Pvp 竞技场
    PVP(18001, "PVP"),
    PVP_BUY_TICKET(18002, "购买竞技场参赛卷"),
    PVP_DAILY_REWARD(18003, "竞技场每日结算奖励"),
    PVP_SEASON_REWARD(18004, "竞技场每赛季结算奖励"),
    PVP_LIKE(18005, "竞技场点赞奖励"),
    PVP_SEASON_TIME(18006, "竞技场赛季累计挑战次数奖励"),

    // 19 DailyDungeon 日常副本
    DAILY_NUM(19001, "日常副本次数购买"),
    DAILY_DUNGEON(19002, "日常副本"),
    DAILY_DUNGEON_SWEEP(19003, "日常副本扫荡"),

    // 20 Promotion 活动
    PROMOTION_FOUND(20001, "成长基金"),
    SUMMON_CRYSTAL(20002, "召唤水晶"),
    WISH_TIMES(20003, "许愿池活动"),
    COMBINE_GIFT(20004, "合成觉醒活动"),
    BUY_GOLD_REWARD(20005, "领取点金活动奖励"),
    TAVERN_GOT(20006, "酒馆达标"),
    ASTROLOGY_TASK_SUBMIT(20007, "占星阵任务"),
    ADVEN_PATH_GIFT(20008, "试炼之路活动"),
    SPEED_FIGHT_GIFT(20009, "速战之王活动"),
    TAVERN_WEEKLY_GIFT(20010, "酒馆常客活动"),
    SHOP_BUY_SACRIFICE(20011, "献祭限时兑换"),
    ALTAR_HERO_EQUIP(20012, "英雄献祭装备返还"),
    DIAN_SHI_CHENG_JIN_RANK(20013, "点石成金排名奖励"),
    SU_ZHAN_ZHI_WANG_RANK(20014, "速战之王排名奖励"),
    SHI_LIAN_ZHI_LU_RANK(20015, "试炼之路排名奖励"),
    JIU_GUAN_CHANG_KE_RANK(20016, "酒馆常客排名奖励"),
    BUY_NEWSEVER_GIFT(20017, "购买新服限购礼包"),
    BUY_DAILY_GIFT(20018, "购买每日礼包"),
    BUY_MONTH_GIFT(20019, "购买每月福利"),
    SEVEN_LOGIN_REWARD(20020, "七日登录"),
    HAPPY_TIME(20021, "狂欢时刻"),
    ADVENTURE_NOTES(20022, "冒险笔记"),
    MYSTERY_BOX(20023, "神秘宝盒"),
    GROWTH_GIFT_BUY(20024, "成长礼包购买"),
    GROWTH_GIFT_GET(20025, "成长礼包领取"),
    GROWTH_GIFT_BEST_CARD(20026, "成长礼包至尊月卡每日领取"),
    ZHU_SHEN(20027, "诸神之战"),
    OVERVALUE_GIFT(20028, "超值礼包"),
    MONTH_CARD(20029, "月卡"),
    FESTIVAL_LOGIN_GIFT(20030, "节日登陆赠礼"),
    FESTIVAL_OVERVALUE_GIFT(20031, "节日豪礼"),
    EVERY_DAY_LOGIN_REWARD(20032, "每日登陆奖励"),
    PROMOTION_CLEAN_BACKPACK(20033, "活动结束清除活动道具"),

    HAPPY_TIME_REPAIR(20050, "狂欢时刻补贴"),

    PROMOTION_HIGH_WEEKS_CARD(20051, "高级周卡活动"),
    PROMOTION_SUMMON_WEEKS_CARD(20052, "召唤周卡活动"),
    PROMOTION_ELF_WEEKS_CARD(20053, "精灵周卡活动"),

    PROMOTION_THREE_DAY_TASK_REWARD(20061, "三天任务奖励"),
    PROMOTION_THREE_DAY_ULTIMATE_REWARD(20062, "三天任务终极奖励"),

    //龙舟活动
    PROMOTION_DRAGON_BOAT_PRODUCT(20071, "龙舟活动直购礼包"),
    PROMOTION_DRAGON_BOAT_TASK_REWARD(20072, "龙舟活动任务奖励"),
    PROMOTION_DRAGON_BOAT_BOX_REWARD(20073, "龙舟活动宝箱奖励"),
    PROMOTION_DRAGON_LOTTERY_CARD(20074, "龙舟活动翻牌"),

    PROMOTION_NHA_REWARD(20081, "新英雄抽卡领取目标奖励"),
    PROMOTION_NHA_MAIL(20082, "新英雄抽卡领取补发奖励"),

    PROMOTION_WEEKEND_KOI_BUY_PRODUCT(20090, "周末锦鲤购买礼包"),
    PROMOTION_WEEKEND_KOI_BLESSING_COST(20091, "周末锦鲤赐福消耗"),
    PROMOTION_WEEKEND_KOI_BLESSING_ADD(20092, "周末锦鲤赐福获得"),
    PROMOTION_WEEKEND_KOI_REWARD(20093, "锦鲤大奖"),

    PROMOTION_SPACE_TIME_TREASURE_REWARD(20094, "时空异宝选择的邮件奖励"),

    // 21 SevenDayTarget 七天目标
    SEVEN_TASK_REWARD(23001, "七天目标奖励"),
    SEVEN_TASK_COST(23002, "七天目标消耗"),
    SEVEN_TASK_BOX_REWARD(23003, "七天宝箱奖励"),
    // 22 SevenDayLogin 七天登录

    // 23 HeroArrive 英雄降临
    HERO_ARRIVE_REWARD(23501, "英雄降临奖励"),
    HERO_ARRIVE_COST(23502, "七天目标消耗"),

    // 24 Dungeon 地牢
    DUNGEON_SHOP_BUY(24001, "地牢商店购买消耗"),
    DUNGEON(24002, "地牢事件收获"),
    DUNGEON_KILL_BOX(24003, "地牢击杀宝箱奖励"),

    //七神器
    QI_SHEN_QI(24101, "七神器奖励"),
    //诸神祭坛奖励
    ZHU_SHEN_JI_TAN(24111, "诸神祭坛奖励"),
    //赏月佳肴
    MID_FOOD(24115, "赏月佳肴"),
    //25 OnlineReward 在线奖励

    // 26 Welfare 福利


    // 27 BlessingPool 许愿池
    BLESSING_POOL_REFRESH(27001, "许愿池刷新"),
    BLESSING_POOL_SHOP_REFRESH(27002, "许愿池商城刷新"),
    BLESSING_POOL_NORMAL(27003, "许愿池普通抽奖"),
    BLESSING_POOL_LUCKY_REWARD(27004, "许愿池幸运值领奖"),
    BLESSING_POOL_DONE_REWARD(27005, "许愿池抽奖固定奖励"),
    BLESSING_POOL_ADVANCE(27006, "许愿池高级抽奖"),


    // 28 Fetter 神器系统\羁绊
    GODDESS_REWARD(28001, "神器奖励"),
    GODDESS(28002, "神器消耗"),
    GODDESS_RESET_COST(28003, "羁绊女神重置消耗"),
    GODDESS_RESET_REWARD(28004, "羁绊女神重置奖励"),
    GODDESS_UP_LEVEL(28005, "羁绊女升级"),
    GODDESS_BREAK(28006, "羁绊女神突破"),
    GODDESS_SOUL(28007, "羁绊女神铸魂"),
    GODDESS_REFINE(28008, "羁绊女神精炼"),
    GODDESS_WASH(28009, "羁绊女神洗炼"),
    GODDESS_FASHION(28010, "羁绊女神皮肤"),
    GODDESS_FASHION_SMELT(28011, "羁绊皮肤熔炼"),
    GODDESS_FASHION_ACTIVE(28012, "羁绊皮肤激活"),
    GODDESS_FASHION_TASK_REWARD(28013, "羁绊皮肤任务领奖"),

    // 29 Rune 符文
    RUNE_RESOLVE(29001, "精灵符文分解"),
    RUNE_COMBINE(29002, "精灵符文合成"),
    RUNE_WASH(29003, "符文重铸"),
    RUNE_CHANGE(29004, "符文穿戴脱下"),


    // 30 Recharge 充值
    FIRST_RECHARGE_REWARD(30001, "每日首充奖励"),
    DAILY_TOTAL_RECHARGE(30002, "每日累充"),
    MARKET_SHOP_GET(30003, "市场购买"),
    RECHARGE(30004, "充值"),
    GM_RECHARGE(30005, "GM充值"),

    // 31 ClanWar 公会战
    CLANWAR_JOIN(31001, "公会战结束奖励"),

    // 32 Border 头像框
    BORDER(32001, "头像框"),


    // 33 ClanWorldBoss 公会世界BOSS,
    CWB_CLAN_REWARD(33001, "公会世界BOSS公会排名奖励"),
    CWB_ROLE_REWARD(33002, "公会世界BOSS角色排名奖励"),

    // 40 永恒梦境
    DREAMLAND(40001, "永恒梦境"),

    // 41 冠军赛
    CHAMPION_RANK(41001, "冠军赛排名奖励"),
    CHAMPION_GUESS(41002, "冠军赛竞猜换算奖励"),
    CHAMPION_LIKE(41003, "冠军赛点赞奖励"),
    CHAMPION_BIUBIUBIU(41004, "冠军赛发弹幕消耗"),
    CHAMPION_COIN(41005, "冠军赛竞猜币邮件"),
    CHAMPION_GUESS_BATTLE(41006, "冠军赛竞猜比赛"),
    CHAMPION_GUESS_RESULT(41007, "冠军赛竞猜比赛结算"),
    CHAMPION_CROSS_LIKE(41008, "跨服冠军赛点赞奖励"),
    CHAMPION_CROSS_RANK(41009, "跨服冠军赛排名奖励"),
    CHAMPION_COIN_RANK(41010, "跨服冠军赛竞猜比赛结算"),

    // 43 永恒梦境
    LADDER_CHALLENGE_COST(43001, "天梯挑战消耗"),
    LADDER_CHALLENGE_REWARD(43002, "天梯挑战奖励"),
    LADDER_RANK(43003, "天梯排名"),

    // 44 超值养成礼包
    DevelopGift(44001, "超值养成礼包"),

    // 50 shop 商店
    MARKET_SHOP_BUY_COST(50001, "市场购买消耗"),
    SHOP_REFRESH(50002, "手动刷新商店"),

    // 51 TrafficPermit
    BUY_PRIVILEGE_REWARD(51000, "购买通行证特权奖励"),
    TRAFFIC_PERMIT_UP_LEVEL(51001, "购买通行证等级扣费"),
    TRAFFIC_PERMIT_LEVEL_REWARD(51002, "通行证等级奖励"),
    TRAFFIC_PERMIT_TASK_REWARD_EXP(51003, "通行证任务奖励戏经验值"),
    TRAFFIC_PERMIT_EXP(51004, "活动结束清楚活动任务道具"),

    //52
    FLASH_SALE(52001, "限时抢购"),

    //53 彩虹圣殿
    RAINBOW_LOSS(53001, "彩虹圣殿神位失去"),
    RAINBOW_END(53002, "彩虹圣殿神位失效"),
    RAINBOW_TAKE(53003, "彩虹圣殿神位占领"),

    //54 称号
    TITLE_RECOVER(54001, "称号回收"),
    TITLE_PROVIDE(54002, "称号发放"),

    //
    DRAGON_UP_IDENTITY(59001, "提升圣物鉴定等级"),
    DRAGON_IDENTITY(59002, "圣物鉴定"),
    DRAGON_SPEED_UP(59003, "圣物鉴定加速"),
    DRAGON_ATTR_UP(59004, "圣物属性等级提升"),
    DRAGON_CHANGE_BACK(59005, "圣物替换返还"),
    DRAGON_CHANGE_PUT(59006, "圣物替换装上"),
    DRAGON_STAR_BAG(59007, "圣物在背包中升星"),
    DRAGON_STAR_SLOT(59008, "圣物在槽位中升星"),
    DRAGON_RESOLVE(59009, "圣物分解"),
    DRAGON_IDENTITY_FINISH(59010, "圣物鉴定完成"),
    DRAGON_CHANGE_SORT(59011, "圣物槽位换顺序"),

    //61 周末礼包
    WEEK_END_GIFT(61001, "周末礼包奖励"),

    //62 诸神遗迹
    GOD_RELIC_BUY_COUNT_COST(62001, "诸神遗迹购买消耗"),
    GOD_RELIC_STAR_REWARD(62002, "诸神遗迹星级奖励"),
    GOD_RELIC_PASS_REWARD(62003, "诸神遗迹通关奖励"),

    //63 神装
    GOD_EQUIP_LOTTERY(63001, "神装探宝消耗"),
    GOD_EQUIP_LOTTERY_REWARD(63002, "神装探宝获得"),
    GOD_EQUIP_WISH_COST(63003, "神装洗炼消耗"),
    GOD_EQUIP_WISH_LOCK_COST(63004, "神装洗炼锁属性消耗"),
    GODEQUIP_CHANGE(63005, "神装穿戴"),
    GODEQUIP_DISBOARD(63006, "神装脱下"),
    GOD_EQUIP_UP_STAR(63007, "神装升星"),
    GOD_EQUIP_WISH(63008, "神装洗炼"),
    GOD_EQUIP_RECYCLE(63009, "神装回收"),
    GOD_EQUIP_LOTTERY_GUARANTEE_REWARD(63010, "神装探宝保底必出神装"),
    GOD_EQUIP_PRIVILEGE_REWARD(63011, "神装特权奖励"),

    HERO_PALACE_LIKE_REWARD(64001, "英雄殿堂膜拜奖励"),
    HERO_PALACE_RANK_REWARD(64002, "排名奖励"),


    FASHION_BUY(65001, "皮肤购买活动"),

    CLERGY_UP_LEVEL_REWARD(66001, "神职升级奖励"),

    TEAM_ARENA_RANK(67001, "组队竞技场排名奖励"),
    TEAM_ARENA_CHALLENGE(67002, "组队竞技场挑战奖励"),
    TEAM_ARENA_APPLY_PASS(67003, "组队竞技场申请通过"),
    TEAM_ARENA_NUM_MAX(67004, "组队竞技场满员"),

    WEEKS_CARD_REWARD(68001, "周卡每日奖励"),

    ASTROLABE_ACTIVE_ELEMENT_COST(69001, "星盘激活元素消耗"),
    ASTROLABE_ACTIVE_LIGHT(69002, "星盘点亮星级消耗"),
    ASTROLABE_RESET(69003, "星盘重置消耗"),
    ASTROLABE_RESET_BACK(69004, "星盘重置返回道具"),

    RECHARGE_DAYS2_REWARD(70001, "积天豪礼"),
    RECHARGE_DAYS2_AUTO_REWARD(70002, "自动补发积天累充奖励"),

    PLATFORM(71001, "平台扣除"),

    CUSTOM_REWARD(71101, "定制奖励"),

    //灵器
    REIKI_EQUIP_PLACE_ACTIVE(72001, "灵器槽位激活扣除"),
    REIKI_EQUIP_TRANSFORM(72002, "灵器转换消耗"),
    REIKI_EQUIP_COMBINE(72003, "灵器合成"),
    REIKI_EQUIP_CHANGE(72004, "灵器穿戴或卸下"),
    REIKI_EQUIP_ACTIVE(72005, "灵器激活"),

    STAGE_TOKEN_REWARD(73001, "段位战令奖励"),
    STAGE_TOKEN_BUY_REWARD(73002, "购买段位战令奖"),
    STAGE_SETTLEMENT_REWARD(73003, "段位结算奖励"),
    STAGE_SETTLEMENT_RANK(73004, "段位排名奖励"),

    NEW_GAME_PLAY_PREDICTION_REWARD(73101, "功能预告每日奖励"),

    //段位赛
    PURCHASE_MATCHES(74001, "购买匹配次数"),
    STAGE_MATCH_BATTLE_REWARD(74002, "段位赛战斗奖励"),
    STAGE_MATCH_FIRST_REWARD(74003, "段位赛首次奖励"),
    PRELIMINARIES_CHALLENGE_REWARD(74201, "预赛挑战奖励"),
    PRELIMINARIES_LIKE_REWARD(74202, "预赛点赞奖励"),
    PINNACLE_LIKE_REWARD(74301, "巅峰赛点赞奖励"),
    PINNACLE_GUESS_BATTLE(74302, "巅峰赛竞猜"),
    PINNACLE_GUESS_RESULT(74303, "巅峰赛竞猜比赛结算"),
    PINNACLE_RANK(74304, "巅峰赛排行榜"),
    PINNACLE_COIN_RANK(74305, "巅峰赛排名竞猜币奖励"),

    //浮空岛
    FLOATING_ISLANDS_BUY_COUNT_COST(75001, "浮空岛购买消耗"),
    FLOATING_ISLANDS_RANK_REWARD(75002, "浮空岛排名奖励"),
    FLOATING_ISLANDS_DMG_REWARD(75003, "浮空岛伤害奖励"),
    FLOATING_ISLANDS_CHALLENGE_REWARD(75004, "浮空岛挑战奖励"),

    //时空魔塔
    TIME_TOWER_MISSION(76001, "时空魔塔过关奖励"),
    TIME_TOWER_RANK(76002, "时空魔塔排名奖励"),
    TIME_TOWER_JOIN(76003, "时空魔塔参与奖励"),

    //宠物
    PET_UP_LEVEL_COST(76101, "宠物升级扣除"),
    PET_DEL_COME_BACK(76102, "宠物删除回退"),
    PET_UP_LEVEL(76103, "宠物升级战力变动"),
    PET_CARRY_STATUS(76104, "宠物携带或卸下战力变动"),

    //时空冒险
    SPACE_TIME_SAILING_END(77101, "异界冒险航行结算"),
    FLEET_REPAIR_COST(77102, "舰队维修扣除"),
    SPACE_TIME_SHOP_COST(77103, "异界商店购买扣除"),
    SPACE_TIME_SHOP_BUY(77104, "异界商店购买获得"),
    SPACE_TIME_EVENT_REWARD(77105, "航行事件奖励"),
    SPACE_TIME_EVENT_COST(77106, "事件开启扣除"),
    SPACE_TIME_BUY_PRODUCT(77107, "异界冒险航线礼包购买"),


    //图腾
    TOTEMS_UP_LEVEL_COST(77201, "图腾升级扣除"),
    TOTEMS_UP_QUALITY_COST(77202, "图腾升阶扣除"),
    TOTEMS_RESET_ITEM(77203, "图腾重置回收材料"),
    TOTEMS_UP_BATTLE(77204, "图腾升级、升阶战力变动"),
    TOTEMS_OPREA_BATTLE(77205, "图腾装备、卸载、更换战力变动"),
    TOTEMS_RESET_BATTLE(77206, "图腾重置战力变动"),

    PROMOTION_070_OPEN_REWARD(78201, "开箱奖励"),
    PROMOTION_070_OPEN_COUNT_REWARD(78202, "开箱次数奖励"),
    PROMOTION_070_OPEN_COST(78203, "开箱消耗"),
    PROMOTION_070_MISSION_REWARD(78204, "任务奖励"),
    PROMOTION_070_BUY_GEM_REWARD(78205, "购买道具奖励"),

    //诸神祭坛
    PROMOTION_072_MONEYDRAW(78301, "诸神祭坛钻石抽奖扣除"),
    PROMOTION_072_ITEMDRAW(78302, "诸神祭坛道具抽奖扣除"),
    PROMOTION_072_TLUCKDRAW(78303, "诸神祭坛抽奖奖励"),

    //讨伐团-神兵、职级 78350-78400
    SHENBIN_COMPOSE_ITEM(78350, "神兵合成材料扣除"),
    SHENBIN_COMPOSE_SB(78351, "神兵合成神兵装备扣除"),
    SHENBIN_COMPOSE_SB_ADD(78352, "神兵合成装备添加"),
    SHENBIN_EQUIP_SB(78353, "神兵装备,背包扣除"),
    SHENBIN_RESOLVE_SB(78354, "神兵分解,背包扣除"),
    SHENBIN_RESOLVE_ITEM(78355, "神兵分解,添加材料"),
    OCCUPATION_UP_REWARD(78356, "职级进阶,发送奖励"),
    SHENBIN_ITEM_ADD(78357, "神兵精华获取"),

    //魔方 78400-78450
    TWEAK_CUBE_TRENCH_OPEN_COST(78400, "魔方槽位开启消耗"),
    TWEAK_CUBE_TRENCH(78401, "槽位英雄发生变化"),
    //位面之战 78450-78500
    PLANE_WAR_CHALLENGE(78450, "挑战奖励"),
    PLANE_WAR_BUY_COUNT_COST(78451, "购买次数消耗"),
    PLANE_WAR_RANK(78452, "排名奖励"),
    //中秋 78501-78550
    PROMOTION_074_MISSION_REWARD(78501, "中秋活动任务奖励"),
    PROMOTION_074_LOTTERY_COST(78502, "中秋活动抽奖消耗"),
    PROMOTION_074_LOTTERY_REWARD(78503, "中秋活动抽奖奖励"),
    PROMOTION_074_LOTTERY_COUNT_REWARD(78504, "中秋活动抽奖次数奖励"),
    PROMOTION_074_MISSION_BOX_REWARD(78505, "中秋活动任务宝箱奖励"),
    PROMOTION_074_FASHION_COUNT_REWARD(78506, "中秋活动皮肤道具数量奖励"),
    PROMOTION_074_FASHION_EXCHANGE_REWARD(78508, "中秋活动兑换奖励"),
    PROMOTION_074_FASHION_EXCHANGE_COST(78509, "中秋活动兑换消耗"),
    PROMOTION_074_CHANGE_COST(78510, "中秋活动改变奖励消耗"),

    //万圣
    PROMOTION_078_CHANGE_COST(78550, "万圣活动改变奖励消耗"),
    PROMOTION_078_LOTTERY_COST(78551, "万圣活动改变奖励消耗"),
    PROMOTION_078_LOTTERY_REWARD(78552, "万圣活动抽奖奖励"),
    PROMOTION_078_LOTTERY_COUNT_REWARD(78553, "万圣活动抽奖次数奖励"),


    PROMOTION_080_MISSION_REWARD(78590, "黑五任务奖励"),
    PROMOTION_080_MISSION_BOX_REWARD(78591, "黑五任务箱子奖励"),

    PROMOTION_081_MISSION_REWARD(79000, "黑五任务奖励"),
    PROMOTION_081_MISSION_BOX_REWARD(79001, "黑五任务箱子奖励"),
    PROMOTION_081_MISSION_GIFT_REWARD(79002, "黑五任务礼包奖励"),

    PROMOTION_082_GIFT_REWARD(79021, "黑五礼包奖励"),

    PROMOTION_083_CHANGE_COST(79050, "黑五活动改变奖励消耗"),
    PROMOTION_083_LOTTERY_COST(79051, "黑五活动改变奖励消耗"),
    PROMOTION_083_LOTTERY_REWARD(79052, "黑五活动抽奖奖励"),
    PROMOTION_083_LOTTERY_COUNT_REWARD(79053, "黑五活动抽奖次数奖励"),

    PROMOTION_084_GET_REWARD(79070, "三天累充领奖"),
    MERGE_SERVER(79080, "合服补偿改名卡"),

    PROMOTION_085_MISSION_REWARD(78090, "圣诞任务奖励"),
    PROMOTION_085_MISSION_BOX_REWARD(78091, "圣诞任务宝箱奖励"),

    PROMOTION_086_GIFT_REWARD(78100, "圣诞礼包"),
    PROMOTION_087_LOTTERY(78110, "圣诞抽奖"),
    PROMOTION_088_EXCHANGE_SCORE(78120, "兑换积分"),
    PROMOTION_088_OPEN_BOX(78121, "开箱"),
    PROMOTION_089_NOTE(78130, "感恩信奖励"),

    HADES_CHALLENGE_COST(78150, "冥域魔都挑战消耗"),
    HADES_CHALLENGE_REWARD(78151, "冥域魔都挑战奖励"),
    HADES_SWEEP_REWARD(78152, "冥域魔都扫荡奖励"),
    HADES_SWEEP_COST(78153, "冥域魔都扫荡消耗"),

    T_PERMIT_BUY_PRIVILEGE_REWARD(78170, "购买通行证2特权奖励"),
    T_PERMIT_UP_LEVEL(78171, "购买通行证2等级扣费"),
    T_PERMIT_LEVEL_REWARD(78172, "通行证2等级奖励"),
    T_PERMIT_TASK_REWARD_EXP(78173, "通行证2任务奖励戏经验值"),
    T_PERMIT_EXP(78174, "活动结束清除通行证2任务道具"),

    PROMOTION_091_BOX_LOTTERY_REWARD(78190, "盲盒抽奖"),
    PROMOTION_091_GASHAPON_LOTTERY_REWARD(78191, "扭蛋抽奖"),
    PROMOTION_091_BOX_LOTTERY_COST(78192, "盲盒抽奖消耗"),
    PROMOTION_091_GASHAPON_LOTTERY_COST(78193, "扭蛋抽奖消耗"),

    PROMOTION_092_DELIVER_COST(78210, "献花消耗"),
    PROMOTION_092_DELIVER_REWARD(78211, "献花奖励"),
    PROMOTION_092_DELIVER_COUNT_RANK(78212, "献花次数排名奖励"),
    PROMOTION_092_HERO_SCORE_RANK(78213, "献花英雄积分排名奖励"),
    PROMOTION_092_BUY_FLOWER_COST(78214, "购买献花消耗"),
    PROMOTION_092_BUY_FLOWER_REWARD(78215, "购买献花奖励"),
    PROMOTION_092_DELIVER_COUNT_REWARD(78216, "献花次数达标奖励"),

    PROMOTION_093_DICE(78250, "丢骰子"),
    PROMOTION_093_SCENIC(78251, "景点奖励"),
    PROMOTION_093_RESET(78252, "重置"),

    PROMOTION_094_EXCHANGE_SCORE(78270, "兑换积分"),
    PROMOTION_094_OPEN_BOX(78271, "开箱"),

    PROMOTION_095_GIFT_REWARD(78290, "春游记"),

    PROMOTION_096_MISSION_REWARD(78310, "出游寻春奖励"),
    PROMOTION_096_MISSION_BOX_REWARD(78311, "出游寻春宝箱奖励"),

    PROMOTION_097_LUCK_DRAW_REWARD(78312, "五一抽奖奖励"),
    PROMOTION_097_LUCK_DRAW_COST(78312, "五一抽奖消耗"),


    COUNTRY_WAR_RANK(78330, "排行榜奖励"),
    COUNTRY_WAR_SCORE(78331, "积分奖励"),
    COUNTRY_WAR_CITY_SCHEDULER(78332, "城池定时奖励"),
    COUNTRY_WAR_LOTTERY(78333, "抽奖"),
    COUNTRY_WAR_FLAG(78334, "战旗"),
    COUNTRY_WAR_RANDOM_SHOP(78335, "随机商城"),
    COUNTRY_WAR_ATTACK(78336, "进攻城池"),
    COUNTRY_WAR_SCORE_BUY(78337, "购买商品"),

    // 魔杖背包
    MAGIC_WAND_DECOMPOSE_RETURN(78338, "魔杖消耗强化材料返回"),
    MAGIC_WAND_STRENGTHEN_COST(78339, "魔杖强化消耗"),
    MAGIC_WAND_BAPTISM_COST(78340, "魔杖洗练消耗"),
    MAGIC_WAND_BAPTISM_RETURN(78340, "魔杖分解后洗练材料返回"),
    MAGIC_WAND_TAKE_OFF(78341, "英雄卸下魔杖"),
    MAGIC_WAND_TAKE_ON(78342, "英雄穿戴替换魔杖"),
    MAGIC_WAND_STRENGTHEN(78343, "英雄强化魔杖"),
    MAGIC_WAND_BAPTISM_SAVE(78344, "英雄魔杖洗练属性保存"),
    MAGIC_WAND_STRENGTHEN_BAPTISM(78345, "魔杖强化和洗练材料返回"),


    // 幻魔塔
    MAGIC_TOWER_BUY_COUNT_COST(   78501, "幻魔塔购买消耗"),
    MAGIC_TOWER_STAR_REWARD(      78502, "幻魔塔星级奖励"),
    MAGIC_TOWER_PASS_REWARD(      78503, "幻魔塔通关奖励"),

    MAGIC_TOWER_SHOP_BUY_COST(78540, "幻魔塔商城购买消耗"),
    MAGIC_TOWER_SHOP_BUY_REWARD(78541, "幻魔塔商城购买奖励"),
    MAGIC_TOWER_ROAD_REWARD(78542, "斩魔之路普通奖励"),
    MAGIC_TOWER_KING_ROAD_REWARD(78543, "斩魔之路王者奖励"),
    MAGIC_TOWER_KING_GIFT(78544, "斩魔王者礼包奖励"),


    //
    ;


    private final int value;
    private final String remark;

    private static Map<Integer, GameEvent> ENUMS;

    static {
        ENUMS = new HashMap<>();
        for (GameEvent event : GameEvent.values()) {
            ENUMS.put(event.getValue(), event);
        }
    }

    private GameEvent(int value, String remark) {
        this.value = value;
        this.remark = remark;
    }

    public int getValue() {
        return value;
    }

    public static GameEvent of(int value) {
        GameEvent event = ENUMS.get(value);
        Asserts.notNull(event, () -> String.format("Invalid value for GameEvent: %s", value));
        return event;
    }

    public String getRemark() {
        return remark;
    }

    public static void main(String[] args) throws IOException {
        for (GameEvent event : GameEvent.values()) {
            System.out.println(event.getValue());
        }
        for (GameEvent event : GameEvent.values()) {
            System.out.println(event.remark);
        }
        /*List<Integer> list = new ArrayList<>();

        String filePath = "E:\\GameEvent";
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }

        File outputFile = new File(file, "gameevent.txt");
        if (!outputFile.exists()) {
            outputFile.createNewFile();
        }

        FileWriter fw = new FileWriter(outputFile);
        StringBuilder str = new StringBuilder();
        for (GameEvent gameEvent : GameEvent.values()) {
            if (list.contains(gameEvent.getValue())) {
                System.out.println("重复的event:" + gameEvent.getValue());
                continue;
            }
            str.append(gameEvent.getValue());
            str.append("|");
            str.append(gameEvent.getRemark());
            str.append("\n");
            list.add(gameEvent.getValue());
        }
        fw.write(str.toString());
        fw.flush();
        System.out.println("文件输出路径：" + outputFile.getAbsolutePath());*/

        Map<Integer, GameEvent> map = new HashMap<>();

        String filePath = "F:\\GameEvent";
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }

        File outputFile = new File(file, "gameevent.txt");
        if (!outputFile.exists()) {
            outputFile.createNewFile();
        }

        FileWriter fw = new FileWriter(outputFile);
        StringBuilder builder = new StringBuilder();
        for (GameEvent errorCode : GameEvent.values()) {
            GameEvent old = map.put(errorCode.getValue(), errorCode);
            if (old != null) {
                System.out.println(String.format("错误码重复：{%s}-{%s}", errorCode, old));
            }
            builder.append(errorCode.getValue());
            builder.append("|");
            builder.append(errorCode.getRemark());
            builder.append("\n");
        }

        fw.write(builder.toString());
        fw.flush();
        System.out.println("文件输出路径：" + file.getAbsolutePath());
    }
}
