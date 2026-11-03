package com.ayjs.mxzg.center.infrastructure.constant;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public enum ErrorCode {
    // 通用错误码范围 (30000-39999) -----------------------

    // 300 Login 和系统模块
    /**
     * 处理成功
     */
    NO_ERROR(30000, "处理成功"),
    /**
     * 严重的系统错误(30001),请联系客服处理
     */
    TERRIBLE_ERROR(30001, "操作失败(30001),请联系客服处理"),
    /**
     * 请求失败(30002),请联系客服处理
     */
    SYSTEM_ERROR(30002, "操作失败(30002),请联系客服处理"),
    /**
     * 操作失败(30003),请联系客服处理
     */
    OPERATION_FAILED(30003, "操作失败(30003),请联系客服处理"),
    /**
     * 参数不对(30004),请联系客服处理
     */
    WRONG_PARAMETERS(30004, "参数不对,请联系客服处理"),
    /**
     * 服务器正在维护中
     */
    SERVER_MAINTENANCE(30005, "服务器正在维护中"),
    /**
     * 配置文件不存在(30006),请联系客服处理
     */
    CONFIG_NOT_EXISTS(30006, "配置文件不存在,请联系客服处理"),
    /**
     * 配置数据错误(30007),请联系客服处理
     */
    CONFIG_DATA_ERROR(30007, "配置数据错误,请联系客服处理"),
    /**
     * 签名校验失败(30008),请联系客服处理
     */
    SIGNATURE_VERIFY_FAILED(30008, "签名校验失败,请联系客服处理"),
    /**
     * 服务器繁忙(30009),请联系客服处理
     */
    SERVER_BUSY(30009, "服务器繁忙,请联系客服处理"),
    /**
     * 验证失败(30010),请联系客服处理
     */
    SESSION_INVALIDATE(30010, "验证失败,请联系客服处理"),
    /**
     * 验证失败(30011), 请重新登录
     */
    SESSION_INVALIDATE_LOGIN_AGAIN(30011, "验证失败, 请重新登录"),
    /**
     * 异地登录(30012)
     */
    DISTANCE_LOGIN(30012, "账号异地登录"),

    FUNCTION_NOT_OPEN(30013, "功能未开放"),

    // 301 Role
    ERROR_PARAM(30100, "参数错误"),
    ROLE_USERID_ERROR(30101, "账号ID错误"),
    ROLE_FORBIDDEN(30102, "该账号已被封"),
    ROLE_NICK_EMPTY(30103, "昵称不能为空"),
    ROLE_LOGIN_FIRST(30104, "请先进行登录"),
    ROLE_CREATED(30106, "您已经创号"),
    ROLE_NICK_SENSITIVE(30107, "昵称含有屏蔽字"),
    ROLE_EDITED_NICK(30108, "您已经改过名"),
    ROLE_NICK_EXISTS(30109, "该昵称已被占用"),
    ROLE_GUIDE_NOT_MATCH(30110, "新手引导还没有到指定步骤"),
    ROLE_NOT_EXIST(30111, "未找到该玩家"),
    ROLE_NICK_TOO_LONG(30112, "昵称太长了"),
    ROLE_NEWBIE_REWARD(30113, "新手奖励重复领取"),
    ROLE_LEVEL_LACK(30114, "您的冒险等级不足"),
    ROLE_SERVERID_ERROR(30115, "服务器ID错误"),

    // 302 Battle 战斗,主线关卡
    IDLE_AWARD_NOT_ENOUGH(30201, "没有挂机收益"),
    CHAPTER_FIRST_REWARD_ALREADY_RECEIVED(30202, "第一次通关奖励已领取"),
    CHAPTER_NOT_PASS(30203, "未通关该关卡，不能领取"),
    ALREADY_PASSED(30204, "您已经通关过该关卡啦"),
    MOSTER_IS_EMPTY(30205, "该关卡没有找到怪物"),
    INSUFFICIENT_LEVEL(30206, "未达到挑战等级"),
    INSUFFICIENT_COMBAT_POWER(30207, "未满足挑战战力要求"),
    EXTRA_REWARD_ALREADY_RECEIVED(30208, "已经领取领取过该奖励"),
    BATTLE_REPORT_TMEOUT(30209, "战报已过期"),
    RECEIVE_CUSTOMS_CLEARANCE_REWARDS_FIRST(30210, "请先领取通关奖励"),
    ALL_CLEARED(30211, "已经全部通关拉"),


    // 303 Tower 幻境之塔
    SPEED_UP_COST_MORE_THAN_MAX_TIMES(30301, "超过最大次数"),
    TOWER_ENERGY_NOT_ENOUGH(30302, "挑战密钥不足"),
    TOWER_STAGE_REWARD_RECEIVED(30303, "奖励已领取"),
    TOWER_REWARD_CONDITION_NOT_SATISFIED(30304, "奖励条件不满足"),
    TOWER_MAX_LAYER(30305, "已经到达幻境之塔最顶层"),
    TOWER_MAX_SWEEP(30306, "扫荡次数已经用完"),

    // 304 Hero 英雄
    HERO_ROLL_MISS(30401, "无法找到英雄抽奖配置"),
    HERO_NUM_LIMIT(30402, "英雄背包已达上限，提升VIP可提升背包空间"),
    HERO_RECHARGE_NOT_ENOUGH(30403, "未满足积分抽奖需求"),
    HERO_NOT_EXIST(30404, "没有找到该英雄"),
    HERO_STAR_LIMIT(30405, "该英雄等级已达到星级限制上限"),
    HERO_STAGE_LIMIT(30406, "该英雄等级已达到等阶限制上限"),
    HERO_STAGE_STAR(30407, "英雄等阶不能超过星级"),
    HERO_LEVEL_LACK(30408, "英雄等级未满足升阶要求"),
    HERO_NOT_FOUND(30409, "没有找到需要吞噬的英雄"),
    HERO_NOT_MATCH(30410, "选择的英雄不满足吞噬条件"),
    HERO_EQUIP_MISS(30411, "没找到装备配置数据"),
    HERO_EQUIP_EMPTY(30412, "没有装备着的装备"),
    HERO_CONFIG_MISS(30413, "英雄配置未找到"),
    HERO_LINEUP_EMPTY(30414, "英雄阵容为空"),
    HERO_LINEUP_REPEA(30415, "英雄重复上阵"),
    HERO_LINEUP_POS_REPEA(30416, "上阵位置重复"),
    HERO_LINEUP_TYPE_ERROR(30417, "无效的阵容类型"),
    HERO_LINEUP_NOT_MATCH(30418, "英雄不符合上阵要求"),
    HERO_LINEUP_ERROR_TYPE(30419, "不可在此上阵庇护所类型队伍"),
    HERO_LINEUP_RUNNING(30420, "该阵容现在无法编辑"),
    HERO_LEVEL_LIMIT(30421, "该英雄等级已达到等阶、星级限制上限"),
    HERO_MAX_GRADE(30422, "该英雄已达到最大等阶"),
    HERO_MUST_IDLE(30423, "素材英雄不能在阵上"),
    HERO_LOCKIN_LINEUP(30424, "该英雄在阵上"),
    HERO_CANT_DELETE_LINEUP(30425, "不能删除在指定阵容上的英雄"),
    HERO_ALTAR_NO_NULL(30426, "献祭的英雄列表不能为空"),
    HERO_SHARE_MIRROR(30427, "英雄分享不存在"),
    HERO_REBORN_NOT_CONFIG(30428, "英雄重生配置不存在"),

    // 305 BackPack 背包
    BAG_COST_ERROR(30500, "消耗配置错误"),
    BAG_GEM_LACK(30501, "钻石不足"),
    BAG_GOLD_LACK(30502, "金币不足"),
    BAG_ITEM_LACK(30503, "道具不足"),
    BAG_HERO_EXP_LACK(30504, "英雄经验不足"),
    BAG_HERO_PIECE_COMBINE(30505, "合成数量不能少于1"),
    BAG_BOX_OPEN(30506, "宝箱开启数量不能少于1"),
    BAG_BOX_OPEN_ERROR(30507, "非宝箱类型道具"),
    ITEM_USE_TYPE_ERROR(30508, "道具效用类型错误"),

    // 306 Chat 聊天
    CHAT_TYPE_NOT_EXIST(30601, "聊天频道不存在"),
    CHAT_LEVEL_NOT_ENOUGH(30602, "等级不够还不能聊天"),
    CHAT_SEND_TOO_FREQUENTLY(30603, "消息发送太频繁了"),
    CHAT_FORBID(30604, "被禁止发言"),
    CHAT_CONTENT_LENGTH_LONG(30605, "聊天内容过长"),

    // 307 Clan 公会
    CLAN_NOT_EXIST(30701, "公会不存在"),

    CLAN_POSITION(30702, "权限不足，无权进行该操作"),

    CLAN_NOW_JOIN(30703, "玩家已加入其他公会。"),

    CLAN_MAX_MENBER(30704, "公会成员已满"),

    CLAN_REPEA_NAME(30705, "公会名字重复"),

    CLAN_DONATE(30706, "公会捐献冷却中"),

    CLAN_DONATE_COST(30707, "公会捐献扣除不足"),

    CLAN_DONATE_BOX(30708, "公会捐献宝箱开启条件未到达"),

    CLAN_DONATE_BOS_REPEA(30709, "公会捐献宝箱重复领取"),

    CLAN_SKILL_MAX(30710, "公会技能已达满级"),

    CLAN_SKILL_COST(30711, "升级公会技能升级资源不足"),

    CLAN_BATTLE_NUM_BUY(30712, "公会副本购买失败"),

    CLAN_BOSS_BATTLE_NUM(30713, "公会副本挑战次数不足"),

    CLAN_REMOVE_SKILL(30714, "公会技能等级为零，无需重置"),

    CLAN_PRESIDENT_NOT_QUIT(30715, "公会会长不能退出公会"),

    CLAN_EXP_NOT_ENOUGH(30716, "公会经验不够"),

    CLAN_BATTLE_RUNNING(30717, "公会战期间不允许此操作"),
    CLAN_NAME_UNAVAILABLE(30718, "公会名字不能有特殊字符哟"),
    CLAN_NAME_TOO_LONG(30719, "公会名字太长啦"),
    CLAN_NOTICE_UNAVAILABLE(30720, "公会公告不能有特殊字符哟"),

    CLAN_JOIN_TIME_CD(30721, "公会退出再加入时间冷却中"),

    CLAN_NOT_JOIN(30722, "您还没有加入公会"),

    CLAN_NOT_SKILL_TYPE(30732, "不存在该职业的公会技能"),

    // 308 Friend 好友
    FRIEND_SEARCH_NAME(30801, "请输入您要搜索的公会名字"),

    FRIEND_NOT_SELF(30802, "不能加自己为好友"),

    FRIEND_NUM_LIMIT(30803, "您的好友数量已到上限"),

    FRIEND_TARGET_LIMIT(30804, "对方的好友数量已到上限"),

    FRIEND_ALREADY(30805, "你们已经是好友"),

    FRIEND_APPLYED(30806, "已经申请对方为好友"),

    FRIEND_APPLY_MISS(30807, "未找到该好友申请信息"),

    FRIEND_SHIP_MISS(30808, "未找到好友关系信息"),

    FRIEND_HAD_GIVE(30809, "已经赠送过该好友"),

    FRIEND_NO_GIVING(30810, "已经没有可以赠送的好友"),

    FRIEND_GOT_GIFT(30811, "已经领取该友情奖励"),

    FRIEND_GIFT_LIMIT(30812, "友情奖励已经达到上限"),

    FRIEND_NO_GIFT(30813, "没有友情奖励可以领取"),

    FRIEND_GIVING_FULL(30814, "今天赠送的友情点已达到上限"),

    // 309 Rank 排行榜
    RANK_TYPE_HAD_WORSHIP(30901, "该排行榜已经膜拜"),

    RANK_TYPE_CANT_WORSHIP(30902, "该排行榜不存在膜拜对象"),

    // 310 Achievement 成就
    CONFIG_NOT_EXIST(31000, "配置不存在"),
    ACHIEVEMENT_LEVEL_LOW(31001, "成就等级不足"),
    ACHIEVEMENT_PROCESS_LOW(31002, "成就进度不足"),
    ROLE_LEVEL_LOW(31004, "角色等级不足"),
    ACHIEVEMENT_TASK_NOT_EXIST(31005, "任务不存在"),
    ACHIEVEMENT_HAD_REWARD(31006, "已领取过该奖励"),


    // 311 Task 任务活动
    DAILY_TASK_HAD_REWARD(31101, "每日任务奖励已领取"),
    DAILY_TASK_VALUE_LOW(31102, "每日任务值不足"),
    DAILY_TASK_PROCESS_LOW(31103, "任务进度不足"),
    DAILY_TASK_VALUE_HAD_REWARD(31104, "该活跃值已经领取"),
    HERO_COMBINE_HAD_REWARD(31105, "合成觉醒已经领取完"),
    DAILY_TASK_NOT_EXIST(31106, "每日任务不存在"),

    //邀请礼包
    INVITE_HAD_REWARD(31150, "邀请礼包已经领取"),
    INVITE_CODE_HAD_USED(31151, "邀请礼包已经使用"),

    // 312 prophecy 先知
    PROPHECY(31241, "先知之球不足"),

    PROPHECY_HERO_CHANGE(31142, "先知置换英雄有误"),

    PROPHECY_CHANGE_ITEM_NUM_LOW(31143, "先知置换道具不足"),

    PROPHECY_TYPE_NOT_EXIST(31144, "先知召唤元素不存在"),

    // 313 Buy 购买道具
    BUY_SPACE_MAX_TIMES(31301, "购买次数已到上限"),

    // 314 Mail 邮件
    EXCHANGE_CODE_ERROR(31401, "兑换码错误"),// 和平台兑换码错误id同步
    EXCHANGE_CODE_EXIST(31402, "兑换码不存在"),// 和平台兑换码错误id同步
    EXCHANGE_CODE_USED(31403, "兑换码已被使用"),// 和平台兑换码错误id同步
    EXCHANGE_CODE_EXPIRE(31404, "兑换码已过期"),// 和平台兑换码错误id同步
    EXCHANGE_CODE_RECEIVED_REWARD(31405, "兑换码已领取"),// 和平台兑换码错误id同步


    // 315 Adven 英雄试炼
    ADVEN_REWARD_STAGE(31501, "当前关卡为宝箱奖励关卡"),

    ADVEN_CAN_NOT_REWARD(31502, "当前关卡不能奖励"),

    ADVEN_REWARD_RECEIVED(31503, "当前关卡奖励已领取"),

    ADVEN_CAN_NOT_BATTLE(31504, "当前关卡还不能挑战"),

    ADVEN_COMPLETED(31505, "关卡已通关"),

    // 316 BuyGold 点金
    BUY_GOLD_TYPE_NOT_EXISTENT(31601, "点金类型不存在"),

    BUY_GOLD_NUM_NOT_ENOUGH(31602, "点金类型不存在"),

    // 317 Pvp 竞技场


    //  318 DailyDungeon 日常副本
    DAILY_DUNGEON_BATTLE_NUM(31801, "挑战次数不足"),

    DAILY_MISSION_FIGHTING_NOT_ENOUGH(31802, "战力不够"),

    DAILY_MISSION_CAN_NOT_FIGHT(31803, "还不能够挑战"),

    DAILY_MISSION_CAN_NOT_SWEEP(31804, "还不能够扫荡"),


    // 319 Promotion 活动
    RECHARGE_DAY_LOW(31901, "累充天数不足"),

    PROMOTION_ID_HAD_REWARD(31902, "奖励已经领取"),

    FOUNDATION_NOT_BUY(31903, "未购买基金"),

    MONTH_CAR_EXPIRE(31904, "月卡过期"),

    FIRST_RECHARGE_NOT_ACTIVE(31905, "超值首充未激活"),

    PRIVILEGE_GIFT_LIMIT(31906, "特权礼包限购"),

    ITEM_NUM_LOW(31907, "道具数量不足"),

    RECHARGE_LOW(31908, "充值不足"),

    SERVER_OPEN_TIME_LOW(31909, "开服时间不足"),

    GROWTH_GIFT(31910, "该成长礼包已购买或已领取"),

    GROWTH_GEM_LOW(31911, "购买成长礼包钻石不足"),

    MONTH_CARD_PAST_DUE(31912, "月卡已过期"),

    MONTH_CARD_DAILY_REWARD_CD(31913, "成长礼包月卡每日领取还未重置"),

    MONTH_BEST_CARD(31914, "至尊月卡未开通"),

    DAILY_GIFT_PRODUCTION_MISS(31915, "每日限购商品无法找到"),

    PROMOTION_TIME(31916, "活动已结束或未开启"),

    PROMOTION_REWARD_ALREADY_GET(31917, "该活动任务奖励已领取"),

    PROMOTION_NOT_PROGRESS(31918, "活动进度不足"),

    PROMOTION_CANT_TAKE(31919, "还没有达到领取奖励要求"),

    PROMOTION_CANT_CHANGE(31920, "已经没有兑换次数"),

    PROMOTION_REWARD_EMPTY(31921, "该活动奖励已经被领光"),

    PROMOTION_LEVEL_LOW(31922, "你的等级还没有达到要求"),

    PROMOTION_NOT_RUNNING(31923, "不在活动期间"),

    PROMOTION_CONFIG_MISS(31924, "该奖励不属于当前活动"),

    PROMOTION_TOOK_REWARD(31925, "已经领取过该奖励"),

    PRIVILEGE_NOT_GEM_BUY(31926, "该特权不能通过钻石购买"),

    PRIVILEGE_HAS(31927, "已经拥有该特权"),

    SIGNIN_TODAY(31928, "今天已经签到过"),

    PROMOTION_ASTROLOGY_HERO_LINEUP(31929, "占星阵材料英雄上阵中不可用于兑换"),

    PROMOTION_SACRIFICE_SHOP_BUY_LIMIT(31930, "祭坛商店活动商品已达限购次数"),

    // 320 SevenDayTarget 七天目标
    SEVEN_DAY_TARGET_HAD_REWARD(32001, "七日目标奖励已领取"),

    OPERATOR_COUNT_LOW(32002, "未达成领取条件"),

    SEVEN_DAY_TARGET_VALUE_LOW(32003, "未达成领取所需进度"),

    VIP_LV_LOW(32004, "vip奖励不足"),

    SEVEN_DAY_TARGET_BOX_HAD_REWARD(32005, "七日目标宝箱已领取"),

    // 321 SevenDayLogin 七天登录


    // 322 HeroArrive 英雄降临
    HERO_ARRIVE_END(32200, "活动已结束"),
    PROMOTION_NOT_STARTING(32201, "活动未开启"),
    //
    HERO_ARRIVE_CANT_REWARD(32202, "该奖励不可领取"),

    // 323 Dungeon 地牢
    //Shelter
    SHELTER_BATTER_LINEUP(32301, "庇护所战斗队伍已存在"),

    SHELTER_DUNGEON_OPEN(32302, "庇护所网格打开失败"),

    SHELTER_EVENT_ERROR(32303, "庇护所事件不匹配"),

    SHELTER_ITEM_ERROR(32304, "庇护所道具资源不足"),

    SHELTER_MONSTER_NOT_HP(32305, "该怪物已阵亡"),

    SHELTER_HERO_NOT_HP(32306, "该英雄已阵亡"),

    SHELTER_LINEUP_NOT_NULL(32307, "保存的英雄阵容不能为空"),

    SHELTER_LINEUP_INDEX_LINEUP_NULL(32308, "该位置英雄为空"),

    SHELTER_LINEUP_HERO_NOT_EXIST(32309, "庇护所上阵英雄不存在"),

    SHELTER_LINEUP_HERO_LINEUP_REPEAT(32310, "庇护所上阵英雄重复"),

    SHELTER_GRID_REPEAT_OPEN(32311, "庇护所网格重复开启"),

    //324 OnlineReward 在线奖励
    REWARD_REPEAT_GET(32401, "奖励重复领取"),

    ONLINE_TIME_SHORTAGE(32402, "在线时长不足"),

    // 325 Welfare 福利

    // 326 BlessingPool 许愿池
    BLESSING_POOL_TYPE_ERROR(32601, "许愿池类型错误"),
    BLESSING_POOL_LUCKY_HAD_REWARD(32602, "该奖励已经领取"),
    BLESSING_POOL_LUCKY_VALUE_LOW(32603, "幸运值不足"),

    // 327 Fetter 神器系统\羁绊
    GODDESS_TASK_REWARD(32701, "任务奖励重复领取"),

    GODDESS_UP_LEVEL(32702, "羁绊女神提升属性资源不足"),

    GODDESS_TASK_PROCESS(32703, "羁绊任务进度不足领取"),

    GODDESS_NOT_UNLOCK(32704, "女神未解锁"),

    GODDESS_VIP(32705, "羁绊VIP等级不足"),

    GODDESS_SKILL_LEVEL(32706, "羁绊技能等级已达最高"),

    GODDESS_UP(32707, "条件不足"),

    GODDESS_REFINE_LEVEL(32708, "精炼等级已达最高级"),

    GODDESS_BREAK_LEVEL(32709, "突破等级已达最高级"),


    // 328 Rune 符文
    RUNE_LOCK(32801, "英雄的精灵部分未解锁"),

    RUNE_NOT_EXIST(32802, "未找到该精灵"),

    RUNE_USED(32803, "该精灵已经装备在其他英雄上"),

    RUNE_CANT_RESOLVE(32804, "装备着的精灵不能分解"),

    RUNE_NOT_WASH(32805, "还没有洗练精灵"),

    RUNE_NOT_ENOUGH(32806, "精灵数量不足"),

    RUNE_NOT_IDLE(32807, "已穿戴的精灵"),

    RUNE_NEED_LOW(32808, "只能用低级别的精灵作为素材"),

    RUNE_NEED_EXP(32809, "所需精灵经验不足"),

    // 329 Recharge 充值
    RECHARGE_TYPE_NOT_FOUND(32901, "未找到该充值类型"),

    BUY_GEM_NOT_FOUND(32902, "未找到充值商品"),

    RECHARGE_CANT_BUY(32903, "该充值商品无法再购买"),

    // 330 ClanWar 公会战
    WAR_NOT_OPEN(33001, "公会战还没有开始"),

    WAR_NOT_IN_CLAN(33002, "你还没有加入任何公会"),

    WAR_NOT_IN_BATTLE(33003, "你的公会没有匹配到对战公会"),

    WAR_NOT_ALLOW(33004, "本次的公会战你还不具备参战资格"),

    WAR_FORMATION_ERROR(33005, "无法保存错误的公会战阵容"),

    WAR_HERO_REPEAT(33006, "使用了重复的英雄进行布阵"),

    WAR_FORMATION_EMPTY(33007, "无法保存空的英雄布阵"),

    WAR_HERO_LV_LOW(33008, "英雄等级未满足公会战要求"),

    WAR_NOT_IN_PREPARE(33009, "当前不在公会战备战阶段"),

    WAR_FORMATION_LOCK(33010, "公会战当前阶段无法调整队伍编排"),

    WAR_HAS_NO_TEAM(33011, "你还没有布阵到公会战当中"),

    WAR_ROAD_NO_CHANGE(33012, "战路编排没有发生变化"),

    WAR_ONLY_LEADER_ADJUST(33013, "调整阶段只有会长可以进行操作"),

    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),

    WAR_NOT_IN_BATTLING(33015, "当前不在公会战对抗阶段"),

    WAR_BOX_END(33016, "公会战宝箱抽奖时间已结束"),

    WAR_BOX_NOT_EXIST(33017, "公会宝箱不存在"),

    WAR_BOX_EMPTY(33018, "该公会宝箱已经被抽取"),

    WAR_BOX_TAKE(33019, "你已经抽取了公会宝箱"),

    WAR_NOT_BATTLE(33020, "你没有参与到本轮公会战中"),
//    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),
//    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),
//    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),
//    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),
//    WAR_NOT_JOIN(33014, "该成员没有参与到公会战中"),


    // 331 shop 商店
    SHOP_CAN_NOT_REFRESH(33101, "商店不能刷新"),

    SHOP_NOT_EXIST(33102, "商店不存在"),

    SHOP_BUY_TIMES_NOT_ENOUGH(33103, "商店购买次数到最大次数"),

    SHOP_MAX_REFRESH(33104, "商店刷新次数已达上限"),

    SHOP_GOOD_MISS(33105, "你的商店中并未出现该商品"),


    // 333 ClanWorldBoss 公会世界BOSS
    CWB_NOT_CHALLENGE(33301, "不在世界BOSS挑战阶段"),

    CWB_NO_CHALLENGE_COUNT(33302, "已经没有挑战次数"),

    CWB_CHALLENGE_CD(33303, "挑战正在冷却中"),

    CWB_NOT_ROB(33304, "不在世界BOSS掠夺阶段"),

    CWB_NO_ROB_COUNT(33305, "已经没有掠夺次数"),

    CWB_ROB_CD(33306, "掠夺正在冷却中"),

    CWB_NOT_IN_ROBLIST(33307, "该玩家不在你的可掠夺列表中"),

    CWB_NO_FORMATION(33308, "还没有布设世界BOSS战斗阵容"),
//    CWB_NOT_Challenge(33301, ""),

    // 334 Tavern 酒馆
    TAVERN_TASK_FULL(33401, "酒馆任务已满"),

    TAVERN_TASK_MISS(33402, "没有找到该酒馆任务"),

    TAVERN_TASK_SEND(33403, "该任务已经派遣"),

    TAVERN_HERO_SEND(33404, "该英雄已被派遣到任务中"),

    TAVERN_HERO_NOT_MATCH(33405, "派遣的英雄不满足任务要求"),

    TAVERN_TASK_NOT_SEND(33406, "任务还没有派遣"),

    TAVERN_NO_IDEL(33407, "当前没有未派遣的任务"),

    TAVERN_NO_REFRESH_TYPE(33408, "没有此酒馆刷新类型"),

    // 335 头像
    Head_Portrait_NOT_UNLOCK(33501, "头像未解锁"),

    //永恒梦境
    DREAMLAND_NOT_ASSIST(34001, "未选择助战英雄"),
    DREAMLAND_LV_HAD_REWARD(34002, "关卡奖励已经领取"),
    DREAMLAND_MAX_LV_LOW(34003, "关卡数不够"),
    DREAMLAND_NOT_IN_BATTLE(34005, "不在战斗状态"),
    DREAMLAND_NOT_IN_SELECT(34006, "不在选择状态"),
    DREAMLAND_BUFF_NOT_EXIST(34007, "buff不存在"),
    DREAMLAND_MAX_LV(34008, "最大关卡"),

    //341 冠军赛
    CHAMPION_NO_GUESS(34101, "当前没有比赛正在进行竞猜"),
    CHAMPION_NOT_GUESS(34102, "当前不是竞猜阶段"),
    CHAMPION_GUESS_OVER(34103, "该比赛已经结束"),
    CHAMPION_HAD_GUESS(34104, "你已经参与了该比赛的竞猜"),
    CHAMPION_GUESS_LACK(34105, "你的竞猜币不足"),
    CHAMPION_NO_BATTLE(34106, "没有找到该比赛"),
    CHAMPION_NO_TOP(34107, "冠军赛还没有产生冠军选手"),
    CHAMPION_KNEEL_TOP(34108, "你已经膜拜过该选手"),
    CHAMPION_BIU_CD(34109, "你发表弹幕信息太快了"),
    CHAMPION_BIU_LONG(34110, "弹幕信息太长了"),
    CHAMPION_BIU_ILLEGAL(34111, "弹幕信息含有违规信息"),

    //342 跨服
    CROSS_SERVER_CONNECTION_DISCONNECTED(34201, "跨服链接已经断开"),


    // 通用错误码范围 (30000-39999) -----------------------


    ;

    private final int value;

    private final String desc;

    private ErrorCode(int value, String desc) {
        this.value = value;
        this.desc = desc;
    }

    public int getValue() {
        return value;
    }

    public String getDesc() {
        return desc;
    }

    private static Map<Integer, ErrorCode> ENUMS = new HashMap<>();

  /*  static {
        for (ErrorCode errorCode : ErrorCode.values()) {
            if (ENUMS.containsKey(errorCode.getValue())) {
                log.warn("error code duplicate:{},{}", ENUMS.get(errorCode.getValue()), errorCode);
                continue;
            }
            ENUMS.put(errorCode.getValue(), errorCode);
        }
    }*/

    public static ErrorCode valueOf(int value) {
        return ENUMS.get(value);
    }

    public static Map<Integer, ErrorCode> getErrorCodes() {
        return ENUMS;
    }

    public String message() {
        return String.format("%s{%s:%s}", super.toString(), value, desc);
    }

    public static void main(String[] args) throws Exception {
        Map<Integer, ErrorCode> map = new HashMap<>();

        File file = new File("/error.txt");

        FileWriter fw = new FileWriter(file);
        StringBuilder builder = new StringBuilder();
        for (ErrorCode errorCode : ErrorCode.values()) {
            ErrorCode old = map.put(errorCode.getValue(), errorCode);
            if (old != null) {
                System.out.println(String.format("错误码重复：{%s}-{%s}", errorCode, old));
            }
            builder.append(errorCode.getValue());
            builder.append("|");
            builder.append(errorCode.getDesc());
            builder.append("\n");
        }

        fw.write(builder.toString());
        fw.flush();
        System.out.println("文件输出路径：" + file.getAbsolutePath());
    }
}
