package com.ayjs.mxzg.template.constant;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.SQLException;
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

    //万圣
    PROMOTION_078_CANT_SELECT(30050, "不能选择奖励"),
    PROMOTION_078_HAD_SELECT(30051, "已经选择了奖励"),
    PROMOTION_078_TYPE_NOT_SELECT(30052, "没有选择奖励"),
    PROMOTION_078_LOTTERY_NUM_ERROR(30053, "抽奖次数错误"),
    PROMOTION_078_OPEN_COUNT_LOW(30054, "抽奖次数不足"),
    PROMOTION_078_COUNT_HAD_REWARD(30055, "奖励已经领取"),

    PROMOTION_080_MISSION_ERROR(30056, "任务错误"),
    PROMOTION_080_PROCESS_LOW(30057, "进度不足"),
    PROMOTION_080_MISSION_BOX_HAD_REWARD(30058, "箱子奖励已经领取"),
    PROMOTION_080_MISSION_REWARD_LOW(30059, "任务数量不足"),

    // 301 Role
    ERROR_PARAM(30100, "参数错误"),
    ROLE_USERID_ERROR(30101, "账号ID错误"),
    ROLE_FORBIDDEN(30102, "该账号已被封"),
    ROLE_NICK_EMPTY(30103, "昵称不能为空"),
    ROLE_LOGIN_FIRST(30104, "请先进行登录"),
    ROLE_CREATED(30106, "您已经创号"),
    ROLE_NICK_SENSITIVE(30107, "昵称不可以使用特殊字符哟"),
    ROLE_EDITED_NICK(30108, "您已经改过名"),
    ROLE_NICK_EXISTS(30109, "已经有人使用这个昵称了"),
    ROLE_GUIDE_NOT_MATCH(30110, "新手引导还没有到指定步骤"),
    ROLE_NOT_EXIST(30111, "未找到该玩家"),
    ROLE_NICK_TOO_LONG(30112, "昵称太长了"),
    ROLE_NEWBIE_REWARD(30113, "新手奖励重复领取"),
    ROLE_LEVEL_LACK(30114, "您的冒险等级不足"),
    ROLE_SERVERID_ERROR(30115, "服务器ID错误"),
    ROLE_NICK_SAME(30116, "您当前已经是这个昵称了"),
    ROLE_COMMENT_SHARED_COMPLETED(30117, "未完成任务"),
    WORLD_LEVEL_LACK(30118, "世界等级未满足要求"),
    ROLE_CHANGE_OF_NAME(30119, "当前角色已经是这个昵称了"),
    ROLE_NICK_EXIST_MASKED_WORD(30120, "昵称包含屏蔽字"),

    // 302 Battle 战斗,主线关卡
    IDLE_AWARD_NOT_ENOUGH(30201, "没有挂机收益"),
    CHAPTER_FIRST_REWARD_ALREADY_RECEIVED(30202, "第一次通关奖励已领取"),
    CHAPTER_NOT_PASS(30203, "未通关该关卡，不能领取"),
    ALREADY_PASSED(30204, "您已经通关过该关卡啦"),
    MOSTER_IS_EMPTY(30205, "该关卡没有找到怪物"),
    INSUFFICIENT_LEVEL(30206, "未达到挑战等级"),
    INSUFFICIENT_COMBAT_POWER(30207, "未满足挑战战力要求"),
    EXTRA_REWARD_ALREADY_RECEIVED(30208, "已经领取领取过该奖励"),
    BATTLE_REPORT_TIMEOUT(30209, "战报已过期"),
    RECEIVE_CUSTOMS_CLEARANCE_REWARDS_FIRST(30210, "请先领取通关奖励"),
    ALL_CLEARED(30211, "已经全部通关拉"),
    BATTLE_SHARE_MISS(30212, "战斗分享不存在"),
    UNLOCK_CONDITION_NOT_MET(30213, "解锁条件未满足"),
    ALREADY_UNLOCK(30214, "已经解锁"),
    FORMATION_NOT_UNLOCK(30215, "阵法未解锁"),
    FIRST_NOT_UNLOCK(30216, "第一契约未解锁"),


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
    NOT_ENOUGH_HEROES_SELECTED(30428, "选择的英雄数量不足"),
    MUST_CHOOSE_THE_SAME_HERO(30429, "必须全部选择同样的英雄"),
    MUST_CHOOSE_THE_5_STAR_HERO(30430, "必须全部选择5星的英雄"),
    SWATCH_HERO_ELEMENT_ILLEGAL(30431, "置换的英雄元素类型不合法"),
    HERO_STAR_LESS_THAN_9(30432, "英雄星级小于等于9星"),
    SWATCH_HERO_CANNOT_RISE_10_STAR(30433, "置换的英雄不能升10星"),
    CANT_SWITCH_MYSELF(30434, "不能置换自己"),
    HERO_LOCK(30435, "该英雄被锁定了"),
    HERO_JEWEL_EMPTY(30436, "没有镶嵌着的宝石"),
    HERO_JEWEL_STAR(30437, "还没有达到镶嵌该宝石的星级要求"),
    HERO_JEWEL_LACK(30438, "没有可用的宝石"),
    HERO_PRAYER_PRIVILEGE(30439, "祈愿权限未开通"),
    HERO_PRAYER_ELEM(30440, "不存在该类型的祈愿"),
    HERO_LINEUP_REPEAT(30441, "英雄布阵不允许重复"),
    HERO_LINEUP_ONE_REPEAT(30442, "英雄布阵只允许一个重复"),

    HERO_TALENT_STAR_LOW(30443, "还没有达到领悟该天赋的星级"),
    HERO_TALENT_NOT_EMPTY(30444, "请先遗忘原先天赋再重新领悟"),
    HERO_TALENT_NOT_LEARN(30445, "还没有领悟到天赋"),
    HERO_TALENT_REPETITIVE(30446, "无法重复领悟相同的天赋技能"),

    HERO_FASHION_NOT_ACTIVE(30447, "当前皮肤尚未解锁或已过期"),
    HERO_FASHION_NOT_UP_LEVEL(30448, "期限皮肤不能升级"),
    HERO_FASHION_MAX_LEVEL(30449, "当前皮肤已达最大等级"),
    HERO_FASHION_NOT_IMAGE(30450, "当前皮肤形象尚未解锁或已过期"),
    HERO_FASHION_PERMANENT_ACTIVATION(30451, "该皮肤已激活"),

    HERO_UP_STAR_WORLD_LEVEL(30452, "升星的世界等级要求未达成"),
    HERO_LINEUP_MATRIX_ERROR(30453, "无效的布阵类型"),
    HERO_LINEUP_MATRIX_UNUSE(30454, "该布阵类型不支持该站位"),
    HERO_SUMMON_DISABLE(30455, "该类型的英雄召唤功能暂时不可用"),

    HERO_HAD_EVOLVE(30456, "已经进化"),
    HERO_NUM_LOW(30457, "英雄数量不足"),
    HERO_CONSUME_NOT_MATCH(30458, "英雄消耗不匹配"),
    HERO_CANT_DELETE_LINEUP_ALL(30459, "特定冒险阵容的英雄队伍不能都为空"),
    HERO_NOT_EVOLVE(30460, "未进化"),
    HERO_LEVEL_RESET_LIMIT(30461, "重生等级错误"),

    HERO_AWAKEN_ATTR_COUNT_ERROR(30470, "觉醒属性数量错误"),
    HERO_STAR_NUM_LOW(30471, "星级以上的英雄数量不足"),

    HERO_EQUIP_STAR_LOW(30480, "装备星级太低"),
    HERO_EQUIP_NOT_SOUL_LV(30481, "装备没有附魂"),
    //英雄六芒星
    HERO_HEXAGRAM_NOT_ENOUGH(30482, "升级突破六芒星材料不足"),
    HERO_HEXAGRAM_STAR_LOW(30483, "六芒星英雄星级太低"),
    HERO_HEXAGRAM_LEVEL_ERROR(30484, "六芒星等级错误"),
    HERO_HEXAGRAM_TYPE_ERROR(30485, "六芒星类型错误"),
    HERO_HEXAGRAM_BATTLE_NULL(30486, "六芒星战斗数据错误"),
    MAGIC_WAND_NEED_LEVEL_LOW(30487, "所需等级不足"),
    MAGIC_WAND_IS_WEAR_ON_OTHER(30488, "魔杖已经穿戴在其他英雄身上"),
    MAGIC_WAND_HAVE_WEARING(30489, "该魔杖已经穿戴在此英雄身上"),
    MAGIC_WAND_NOT_ENOUGH(30490, "魔杖数量不足"),
    BAG_NOT_CONTAIN_THIS(30491, "背包中不存在此魔杖"),
    MAGIC_WAND_IS_WEARING(30492, "穿戴的魔杖无法消耗"),
    HERO_STAR_UNABLE_WEAR_MAGIC_WAND(30493, "英雄星级不足以穿戴魔杖"),
    THE_MAGIC_WAND_NOT_IN_HERO(30494, "该魔杖不存在于该玩家身上"),
    THE_MAGIC_WAND_IS_MAX_STRENGTHEN_LV(30495, "魔杖强化已达最大等级"),
    MAGIC_WAND_TYPE_ERROR(30496, "类型错误，检查魔杖是否是所需消耗类型"),
    MAGIC_WAND_BAPTISM_CONDITION_NOT_SATISFIED(30497, "洗练条件不满足"),
    MAGIC_WAND_HAVE_NOT_RANDOM_ATTR(30498, "该魔杖品质不足以拥有随机属性"),
    MAGIC_WAND_HAVE_NOT_NEW_WASH_ATTR(30499, "该魔杖没有新的洗练属性可以保存"),


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
    BAG_SUPER_GEM_LACK(30509, "超级钻石不足"),
    MAKE_ALL_UNCONDITION(30510, "还没有达到一键合成装备的要求"),
    BAG_ADVENTURE_COUNT_LACK(30511, "冒险点数不足"),
    BAG_NOT_DECOMPOSITION(30512, "该类型道具不可分解"),
    RECHARGE_CARD_USE_ERROR(30513, "充值卡使用错误"),

    // 306 Chat 聊天
    CHAT_TYPE_NOT_EXIST(30601, "聊天频道不存在"),
    CHAT_LEVEL_NOT_ENOUGH(30602, "等级不够还不能聊天"),
    CHAT_SEND_TOO_FREQUENTLY(30603, "消息发送太频繁了"),
    CHAT_FORBID(30604, "被禁止发言"),
    CHAT_CONTENT_LENGTH_LONG(30605, "聊天内容过长"),
    HERO_SHARE_NOT_CHAT_TYPE(30606, "英雄不允许分享此频道"),
    CHAT_SET_PROVINCE(30607, "请设置省份信息"),
    BATTLE_SHARE_NOT_CHAT_TYPE(30608, "战斗不允许分享在此频道"),

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

    CLAN_SKILL_LEVEL_GAP(30733, "公会技能等级差超过上限"),

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

    BLACK_LIST_HAD_ADD(30815, "已经加入黑名单"),
    BLACK_LIST_NOT_ADD(30816, "未加入黑名单"),
    BLACK_LIST_NUM_LIMIT(30817, "黑名单数量太多"),


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
    INVITEES_CAN_NOT_EMPTY(31152, "邀请人不能为空"),
    BE_INVITEES_CAN_NOT_EMPTY(31153, "被邀请人不能空"),
    INVITEES_IS_NOT_EXIST(31154, "邀请人不存在"),
    BE_INVITEES_IS_NOT_EXIST(31155, "被邀请人不存在"),
    CAN_NOT_MUTUAL_INVITATION(31156, "双方不能互相邀请"),
    CAN_NOT_INVITE_YOURSELF(31157, "无法邀请自己"),


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

    ADVEN_ASSIST_HAD_BATTLE(31506, "该英雄已经上过阵，不允许取消"),
    ADVEN_ASSIST_HAD_SELECT_LV(31507, "已经选择了难度"),
    FRIEND_NOT_ASSIST(31508, "好友未上阵助战"),
    ADVEN_FIGHTING_LOW(31509, "战力不足"),
    ADVEN_PASS_LV_LOW(31510, "上一关未通关"),
    ADVEN_LV_NOT_EXIST(31511, "不存在该关卡"),
    ADVEN_HAD_ASSIST_IN_LINE_UP(31512, "阵容里面已经上阵了支援"),


    // 316 BuyGold 点金
    BUY_GOLD_TYPE_NOT_EXISTENT(31601, "点金类型不存在"),

    BUY_GOLD_NUM_NOT_ENOUGH(31602, "点金类型不存在"),

    // 317 Pvp 竞技场
    PVP_LIKE_COUNT_MAX(31701, "今天的点赞次数已经用光"),
    PVP_SEASON_REWARD(31702, "已经领取了该赛季奖励"),
    PVP_SEASON_COUNT(31703, "未达到领取该赛季奖励的挑战次数"),
    PVP_LIKED(31704, "今天已经点赞过该玩家"),

    //  318 DailyDungeon 日常副本
    DAILY_DUNGEON_BATTLE_NUM(31801, "挑战次数不足"),

    DAILY_MISSION_FIGHTING_NOT_ENOUGH(31802, "战力不够"),

    DAILY_MISSION_CAN_NOT_FIGHT(31803, "还不能够挑战"),

    DAILY_MISSION_CAN_NOT_SWEEP(31804, "还不能够扫荡"),

    DAILY_MISSION_NOT_TOP_LEVEL(31805, "未达到该副本开放等级"),

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

    FESTIVAL_LOGIN_DAY_LOW(31931, "节日登陆活动天数不足"),

    FESTIVAL_GIFT_TYPE(31932, "节日礼包类型不符合"),

    FESTIVAL_GIFT_NOT_BUY(31933, "节日礼包尚未购买"),

    FESTIVAL_GIFT_LOGIN_DAY(31934, "节日礼包登陆天数不满足"),

    MONTH_INVEST_MISS(31935, "还没有购买该基金"),

    MONTH_INVEST_EMPTY(31936, "没有基金奖励可以领取"),

    PROMOTION_LOOP_MISS(31937, "活动循环配置未找到"),

    PROMOTION_THREE_DAY_NOT_GET(31938, "三天任务未领取"),

    PROMOTION_THREE_DAY_ULTIMATE(31939, "该终极奖励已领取"),

    PROMOTION_THREE_DAY_NOT_DAY_REWARD(31940, "不可提前领取终极奖励"),

    PROMOTION_THREE_DAY_NOT_TASK_REWARD(31941, "不可提前领取任务奖励"),

    PROMOTION_RECHARGE_GIFT_TIME_LIMIT(31942, "超值赠礼活动尚未激活"),

    PROMOTION_RECHARGE_GIFT_TYPE_NOT_ACTIVE(31943, "超值赠礼奖励未激活"),

    PROMOTION_RECHARGE_GIFT_TYPE_NOT_REWARD(31944, "当前超值赠礼没有奖励可领取"),

    // 320 SevenDayTarget 七天目标
    SEVEN_DAY_TARGET_HAD_REWARD(32001, "七日目标奖励已领取"),

    OPERATOR_COUNT_LOW(32002, "未达成领取条件"),

    SEVEN_DAY_TARGET_VALUE_LOW(32003, "未达成领取所需进度"),

    VIP_LV_LOW(32004, "vip奖励不足"),

    SEVEN_DAY_TARGET_BOX_HAD_REWARD(32005, "七日目标宝箱已领取"),

    NHA_COUNT_LOW(32006, "还没有达到领取该奖励的要求"),
    NHA_TOOK(32007, "已经领取该奖励"),

    //龙舟活动
    DRAGON_BOAT_TASK_REWARD(32100, "龙舟活动任务奖励已领取"),
    DRAGON_BOAT_TASK_PROGRESS(32101, "龙舟活动任务进度不足"),
    DRAGON_BOAT_BOX_TASK_COUNT(32102, "龙舟宝箱进度不足"),
    DRAGON_BOAT_BOX_REWARD(31203, "龙舟宝箱奖励已领取"),
    DRAGON_BOAT_NOT_CARD_TURNS(31204, "牌组不可选择非本轮次的目标奖励"),
    DRAGON_BOAT_TARGET_REWARD(31205, "目标奖励已被领走，不可再次选择"),
    DRAGON_BOAT_TARGET_REWARD_TYPE(31206, "当前替换的奖励非目标奖励池内容"),
    DRAGON_BOAT_CARDS_ALL_TURN_OVER(31207, "卡牌已全部抽取完"),
    DRAGON_BOAT_CARDS_TURN_OVER(31208, "当前卡牌已抽取"),
    DRAGON_BOAT_CARDS_NOT_EXISTS(31309, "未抽取到卡牌"),
    DRAGON_BOAT_CARDS_NOT_CHOOSE_TARGET_REWARD(31310, "龙舟卡牌未选择目标大奖"),
    DRAGON_BOAT_REWARD_POND_NOT_NULL(31311, "龙舟翻牌奖池为空"),

    //周末锦鲤
    WEEKEND_KOI_BLESSING(31320, "赐福次数超过上限"),

    //时空异宝
    SPACE_TIME_TREASURE_CHOOSE(31321, "当天的时空异宝道具已选择，不可再次选择"),
    SPACE_TIME_TREASURE_CONFIG_NOT(31322, "当天不存在该配置可选择"),
    SPACE_TIME_TREASURE_CONFIG_REPEAT(31323, "不能重复选择一个奖励"),

    // 322 HeroArrive 英雄降临
    HERO_ARRIVE_END(32200, "活动已结束"),
    PROMOTION_NOT_STARTING(32201, "活动未开启"),
    //
    HERO_ARRIVE_CANT_REWARD(32202, "该奖励不可领取"),
    HERO_ARRIVE_HAD_REWARD(32203, "该奖励不可领取"),

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

    SHELTER_BOX_REWARD(32312, "网格宝箱已领取"),

    //324 OnlineReward 在线奖励
    REWARD_REPEAT_GET(32401, "奖励重复领取"),

    ONLINE_TIME_SHORTAGE(32402, "在线时长不足"),

    FIRST_REWARD_NOT_GET(32403, "首次奖励尚未领取"),

    REWARD_NOT_ONCE_AGAIN(32404, "该奖劢不能再次领取"),

    ONLINE_REWARD_MONTH_CARD_(32405, "请开通月卡后"),

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

    GODDESS_SOUL_LEVEL_LIMIT(32710, "铸魂等级超过限制"),

    CONTRACT_ACTIVE(32711, "该契约已经解锁"),

    CONTRACT_NOT_ACTIVE(32712, "该契约还没有达到解锁条件"),
    GODDESS_CANT_UN_EQUIP(32713, "女神不能卸载"),
    GODDESS_WASH_LEVEL_MAX(32714, "洗炼等级已达最高级"),
    GODDESS_WASH_NOT_LEVEL(32715, "羁绊女神等级未达到洗炼等级要求"),

    GODDESS_FASHION_NOT_ACTIVE(32730, "未激活皮肤"),
    GODDESS_FASHION_TASK_HAD_GET(32731, "皮肤任务已经领取"),
    GODDESS_FASHION_PROCESS_LOW(32732, "进度不足"),
    GODDESS_FASHION_EXP_LOW(32733, "经验值不够"),
    GODDESS_FASHION_UNLOCK_TYPE_ERROR(32734, "解锁类型错误"),
    GODDESS_FASHION_NOT_USE(32735, "未使用皮肤"),
    GODDESS_FASHION_TASK_NOT_COMPLETE(32736, "任务未完成"),

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

    RECHARGE_CARD_BUY_FAIL(32904, "购买失败"),

    HERO_LEVEL_NOT_ENOUGH(32905, "英雄等级无法购买"),

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

    WAR_ONLY_LEADER_ADJUST(33013, "调整阶段只有会长和副会长可以进行操作"),

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

    SHOP_STALL_CLERGY(33106, "神职等级不够，无法购买该商品"),


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

    TAVERN_TASK_UNLOCK(33409, "该任务未上锁，无需解锁"),

    TAVERN_TASK_UP_LOCK(33410, "该任务已上锁"),

    TAVERN_REFRESH_NUM(33411, "酒馆刷新道具不足"),

    // 335 头像
    Head_Portrait_NOT_UNLOCK(33501, "头像未解锁"),

    //340 永恒梦境
    DREAMLAND_NOT_ASSIST(34001, "未选择助战英雄"),
    DREAMLAND_LV_HAD_REWARD(34002, "关卡奖励已经领取"),
    DREAMLAND_MAX_LV_LOW(34003, "关卡数不够"),
    DREAMLAND_NOT_IN_BATTLE(34005, "不在战斗状态"),
    DREAMLAND_NOT_IN_SELECT(34006, "不在选择状态"),
    DREAMLAND_BUFF_NOT_EXIST(34007, "buff不存在"),
    DREAMLAND_MAX_LV(34008, "最大关卡"),
    DREAMLAND_NOT_HERO(34009, "英雄不存在"),
    DREAMLAND_DISPATCH_HERO(34010, "英雄已派遣,不可重复派遣"),
    DREAMLAND_IN_BATTLE(34011, "战斗状态中。"),
    DREAMLAND_NOT_HERO_LINEUP(34012, "不存在永恒梦境队伍"),
    DREAMLAND_EXIST_FRIEND_HERO(34013, "已存在好友助阵英雄"),
    FRIEND_HERO_HIGH(34014, "战力过高"),
    DREAMLAND_BATTLE_DEFEAT(34015, "战斗失败"),

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
    CHAMPION_MAX_LIKE(34112, "你今天的膜拜次数已经用完"),
    CHAMPION_MAX_GUESS(34113, "你的竞猜投注太多了"),
    CHAMPION_CROSS_GROUP_MISS(34114, "跨服冠军赛分组不存在"),
    CHAMPION_CROSS_NOT_KO(34115, "跨服冠军赛当前不在淘汰赛阶段"),

    //342 录像馆
    VIDEO_TYPE_ERROR(34201, "录像馆类型错误"),
    VIDEO_NOT_EXIST(34202, "系统录像馆不存在"),
    VIDEO_HAD_KEEP(34203, "已经收藏了该录像"),
    VIDEO_EXPIRE(34204, "录像已过期"),
    VIDEO_SHARE_MISS(34205, "战斗分享不存在"),

    //跨服天梯343,
    LADDER_BATTLE_TIMES_NOT_ENOUGH(34301, "挑战次数不足"),
    LADDER_DEFEND_NOT_EXIST(34302, "防守方不存在"),
    LADDER_IN_CD(34303, "cd中"),
    LADDER_BUY_TIMES_MAX(34304, "购买次数上限"),
    LADDER_HAD_LIKE(34305, "今日已点赞"),
    LADDER_NOT_HAVE_LIST(34306, "不存在可点赞玩家"),
    LADDER_BATTLE_NOT_EXIST(34307, "战报不存在"),
    LADDER_NOT_OPEN(34308, "天梯未开启"),


    // 344 超值养成礼包
    GIFT_PURCHASED(34401, "礼包已经购买"),

    // 345 跨服
    CROSS_SERVICE_HAS_BEEN_DISCONNECTED(34501, "跨服服务器已经断开连接"),
    REMOTE_SERVICE_HAS_BEEN_DISCONNECTED(34502, "远程服务器已经断开连接"),

    //346 通行证
    TRAFFIC_PERMIT_MAX_LEVEL(34601, "通行证活动等级超过上限。"),
    TRAFFIC_PERMIT_LEVEL_LOW(34602, "通行证等级不足以领取该奖励"),
    TRAFFIC_PERMIT_LEVEL_REWARD(34603, "通行证等级奖励已领取"),
    TRAFFIC_PERMIT_ALL_LEVEL_REWARD(34604, "通行证等级奖励已全部领取"),
    TRAFFIC_PERMIT_TASK_NOT_EXIST(34605, "当前轮次无该通行证活动任务"),
    TRAFFIC_PERMIT_TASK_NOT_TARGET(34606, "通行证任务未达标"),
    TRAFFIC_PERMIT_TASK_REWARD(34607, "通行证任务奖励已领取"),

    //347 彩虹圣殿
    RAINBOW_ERROR(34701, "不存在该彩虹圣殿位置"),
    RAINBOW_RANK_LOW(34702, "竞技场排名未达到挑战要求"),
    RAINBOW_FORMATION_EMPTY(34703, "彩虹圣殿的挑战阵容不能为空"),
    RAINBOW_HOLDING(34704, "你已经占据了该彩虹圣殿位置"),
    RAINBOW_LV_LOW(34705, "你的角色等级还没有达到挑战彩虹圣殿的要求"),
    RAINBOW_CD(34706, "彩虹圣殿的挑战时间还在冷却中"),

    //周末活动
    WEEKEND_GIFT_NOT_OPEN(34801, "周末活动未开启"),
    WEEKEND_GIFT_STATUS_ERROR(34802, "活动状态不对"),

    //349
    GODEQUIP_NOT_EXIST(34901, "该神装不存在"),
    GODEQUIP_WEARING(34902, "该神装已经装备在英雄身上"),
    GODEQUIP_NOT_WEARING(34903, "该神装没有装备在英雄身上"),
    GODEQUIP_LOTTERY_TYPE(34904, "神装探宝类型错误"),
    GODEQUIP_WASH_ABILITY_SAVE(34905, "该神装无洗炼数据"),
    GODEQUIP_UP_STAR_COUNT(34906, "神装升星需求数量不足"),
    GODEQUIP_UP_STAR_TYPE(34907, "神装升星需求道具错误"),
    GODEQUIP_UP_STAR_NOT_EXIST(34908, "神装升星目标不存在"),
    GODEQUIP_UP_STAR_ATTR(34909, "神装升星属性继承重复"),
    GODEQUIP_UP_STAR_ATTR_NUM(34910, "神装升星属性数量不正确"),
    GODEQUIP_RECYCLE(34911, "神装回收数量为0"),
    GODEQUIP_NOT_WASH(34912, "该神装无法洗炼"),
    GODEQUIP_LEVEL_LACK(34913, "角色等级还未满足神装穿戴要求"),
    GODEQUIP_WORLD_LACK(34914, "世界等级还未满足开启神装系统要求"),
    GODEQUIP_STAR_LACK(34915, "该英雄星级还没有达到穿戴神装的要求"),
    GODEQUIP_SORT_ATTR(34916, "神装不存在该槽位号的属性"),
    GODEQUIP_WASH_ATTR_MAX_LEVEL(34917, "锁定属性已达最大值，不可锁定洗炼"),
    GODEQUIP_PRIVILEGE_NOT_BUY(34918, "神装特权未购买"),
    GODEQUIP_PRIVILEGE_REWARD_RECEIVE(34919, "当天的神装特权奖励已领取"),
    GODEQUIP_PRIVILEGE_RECEIVE_DAY_MAX(34920, "神装特权奖励领取天数已达上限"),


    GOD_RELIC_BUY_COUNT_OVER(35001, "诸神遗迹购买次数上限"),
    GOD_RELIC_STAR_HAD_REWARD(35002, "该星级奖励已经领取"),
    GOD_RELIC_CHAPTER_STAR_LOW(35003, "星级数不够"),
    GOD_RELIC_PASS_LEVEL_LOW(35004, "通关关卡数不够"),
    GOD_RELIC_CHALLENGE_COUNT_LOW(35005, "挑战次数不足"),

    HERO_PALACE_NOT_EXIST(36001, "该榜膜拜不存在"),
    HERO_PALACE_TYPE_HAD_REWARD(36002, "该排行榜奖励已经领取"),

    TEAM_ARENA_HAD_TEAM(36101, "玩家已经有队伍"),
    TEAM_ARENA_NOT_HAD_TEAM(36102, "玩家没有队伍"),
    TEAM_ARENA_NOT_CAPTAIN(36103, "玩家不是队长"),
    TEAM_ARENA_NOT_APPLY(36104, "未申请该队伍"),
    TEAM_ARENA_NOT_MEMBER(36105, "玩家不在队伍里面"),
    TEAM_ARENA_CANT_KICK_OUT_SELF(36106, "不能踢自己"),
    TEAM_ARENA_FIGHTING_LOW(36107, "战斗力过低"),
    TEAM_ARENA_NOT_EXIST(36108, "队伍不存在"),
    TEAM_ARENA_TEAM_MEMBER_MAX(36109, "成员已满"),
    TEAM_ARENA_NAME_EXIST(36110, "名字已存在"),
    TEAM_ARENA_MEMBER_ILLEGAL(36111, "成员错误"),
    TEAM_ARENA_STATE_ILLEGAL(36112, "组队竞技场状态错误"),
    TEAM_ARENA_HAD_SIGN(36113, "已经报名"),
    TEAM_ARENA_NOT_SIGN(36114, "未报名"),
    TEAM_ARENA_CHALLENGE_COUNT_LOW(36115, "挑战次数不足"),
    TEAM_ARENA_NAME_ILLEGAL(36116, "名字不合法"),
    TEAM_ARENA_MEMBER_LOW(36117, "成员不足"),
    TEAM_ARENA_HAD_INVITE(36118, "已经邀请了"),
    TEAM_ARENA_LINE_UP_ERROR(36119, "阵容获取失败"),
    TEAM_ARENA_REWARD_HAD_GET(36120, "奖励已经领取"),
    TEAM_ARENA_NAME_HAD_EXIST(36121, "队伍名已存在"),

    BORDER_NOT_EXIST(37001, "头像框不存在"),
    BORDER_NOT_ACTIVE(37002, "头像框未激活"),
    BORDER_HAD_USE(37003, "头像框已使用"),
    BORDER_ACTIVATED(37004, "头像框已激活"),

    CLERGY_LEVEL_UNLOCK(38001, "神职等级已解锁"),
    CLERGY_EXP_COUNT_LOW(38002, "神职经验值不够升级所需"),

    DRAGON_IDENTITY_RUNNING(39001, "当前鉴定还没有完成"),
    DRAGON_NEED_PRIVILEGE(39002, "还没有开通该特权"),
    DRAGON_IDENTITY_MAX(39003, "鉴定等级已达到最大"),
    DRAGON_NEED_RECHARGE(39004, "累充金额还没有达到升级要求"),
    DRAGON_NEED_STONE(39005, "请先放进源石开始鉴定"),
    DRAGON_ATTR_MAX(39006, "属性等级已达到上限"),
    DRAGON_SLOT_LOCK(39007, "还没有解锁该圣物槽位"),
    DRAGON_SAME_KIND(39008, "已经有同类型的圣物在别的槽位中"),
    DRAGON_STAR_MAX(39009, "该圣物已经达到最大星级"),
    DRAGON_SLOT_EMPTY(39010, "该圣物槽位还没有放入圣物"),
    DRAGON_IDENTITY_NOTMATCH(39011, "提升鉴定等级所需的英雄未满足要求"),

    ASTROLABE_ELEM_HAD_ACTIVE(40000, "元素已激活"),
    ASTROLABE_MAX_STAR_LOW(40001, "最大星级数不足"),
    ASTROLABE_STAR_HAD_LIGHT(40002, "该星级已经点亮"),
    ASTROLABE_SKILL_ERROR(40003, "技能选择错误"),
    ASTROLABE_HAD_ACTIVE(40004, "星盘已经激活"),
    ASTROLABE_NOT_ACTIVE(40005, "星盘未激活"),
    ASTROLABE_LOW_STAR_NOT_ACTIVE(40006, "低星级未激活"),

    //灵器
    REIKI_EQUIP_NOT_PLACE(40101, "灵器槽位已激活"),
    REIKI_EQUIP_PLACE_NOT_ACTIVE_STAR(40102, "英雄星级未达槽位激活条件"),
    REIKI_EQUIP_PLACE_ACTIVE_HERO(40103, "材料英雄星级未达消耗要求星级"),
    REIKI_EQUIP_PLACE_NOT_ACTIVE(40104, "英雄灵器槽位未激活"),
    REIKI_EQUIP_NOT_EXIST(40105, "灵器不存在"),
    REIKI_EQUIP_NOT_WEAR(40106, "灵器未穿戴在英雄身上"),
    REIKI_EQUIP_TRANSFORM_TARGET_NOT_EXIST(40107, "该灵器不能转换为其他目标"),
    REIKI_EQUIP_COMBINE_TARGET_NOT_EXIST(40108, "目标灵器不能合成"),
    REIKI_EQUIP_USED(40109, "该灵器已经装备在其他英雄上"),
    REIKI_EQUIP_COMBINE_NEED_ITEM(40110, "灵器合成素材道具不足"),
    REIKI_EQUIP_COMBINE_NEED_HERO(40111, "灵器合成素材英雄不足"),
    REIKI_EQUIP_PLACE_NOT_ACTIVE_LEVEL(40112, "英雄等级未达槽位激活条件"),
    REIKI_EQUIP_TARGET_NOT_EXIT(40113, "本体灵器不能升级为目标灵器"),
    REIKI_EQUIP_COMBINE_HERO_IDENTICAL(40114, "素材英雄中有相同的英雄"),
    REIKI_EQUIP_COMBINE_IDENTICAL(40115, "素材灵器与本体灵器相同"),

    CUSTOM_PLACE_HAD(40130, "位置相同"),
    CUSTOM_PRODUCT_ID_DIFF(40131, "不是同一个奖励"),

    HERO_COMMENT_LIKE_HERO_COUNT_OVER(40201, "英雄点赞次数超标"),
    HERO_COMMENT_HAD_LIKE_HERO(40202, "已经点赞过"),
    HERO_COMMENT_COMMENT_NOT_EXIT(40203, "评论不存在"),
    HERO_COMMENT_COMMENT_HAD_LIKE(40204, "评论已经点赞过"),
    HERO_COMMENT_CONTEXT_LONG(40205, "长度过长"),
    HERO_COMMENT_CONTEXT_NOT_ILLEGALITY(40206, "评论包含敏感字"),

    //段位赛
    STATE_TOKEN_HAD_GET(40301, "奖励已经领取"),
    STATE_SEASON_ID_ERROR(40302, "赛季id错误"),
    EXIST_MATCHING_OPPONENT(40303, "已经存在匹配对手"),
    MATCHING_CD(40304, "匹配cd中，请稍后"),
    NOT_MATCH_STAGE(40305, "不在匹配阶段"),
    INSUFFICIENT_MATCHES(40306, "匹配次数不足"),
    OPPONENT_INFORMATION_NOT_EXIST(40307, "对手信息不存在"),
    PURCHASE_LIMIT(40308, "今日已达到购买次数上限"),
    NO_REWARDS_AVAILABLE(40309, "没有可以领取的奖励"),
    STATE_SEASON_SHARE_NOT_CHAT_TYPE(40310, "至尊段位赛不允许分享到此频道"),
    NO_MATCH(40311, "没有匹配到对手"),
    NO_GROUP(40312, "没有找到跨服分组"),
    PRELIMINARIES_NOT_OPEN(40313, "预赛未开启"),
    NOT_ENOUGH_CHALLENGES(40314, "挑战次数不足"),
    THE_RANKING_HAS_CHANGED(40315, "对手排名已经发生变化，请重新刷新后挑战"),
    PINNACLE_MAX_LIKE(40316, "已经达到每日点赞次数上限"),
    ALREADY_LIKED(40317, "已经给该玩家点过赞"),

    //------浮空岛
    FLOATING_ISLANDS_BUY_COUNT_MAX(40350, "购买次数达到上限"),
    FLOATING_ISLANDS_STAGE_ERROR(40351, "阶段错误"),
    FLOATING_ISLANDS_COUNT_LOW(40352, "次数不足"),

    //时空魔塔
    TIME_TOWER_MAX_LAYER(40381, "你已经通过最高关卡"),
    TIME_TOWER_MAX_FAIL(40382, "你的挑战生命已经用完了"),
    TIME_TOWER_TIME_LIMIT(40383, "当前不在赛季时间内"),

    //宠物
    PET_LEVEL_MAX(40390, "宠物等级已达上限"),
    PET_NOT_EXISTS(40391, "宠物不存在"),
    PET_UP_LEVEL_NEED_NUM(40392, "素材宠物数量不匹配"),
    PET_UP_LEVEL_NEED_TYPE(40393, "素材宠物类型不匹配"),
    PET_NOW_CARRY_HERO(40394, "当前宠物携带在英雄身上"),
    HERO_NOW_CARRY_RET(40395, "当前英雄已携带宠物"),
    HERO_CARRY_PET_DISAFFINITY(40396, "英雄携带宠物与要卸下的宠物不相同"),
    PET_NOT_CARRY(40397, "当前宠物未携带在英雄身上"),
    HERO_NOT_CARRY_PET(40398, "当前英雄未携带宠物"),
    HERO_STAR_NOT_OPEN_NEED(40399, "英雄星级未达携带要求"),
    PET_ELEM_DISAFFINITY(40400, "英雄和宠物的元素不一致"),
    PET_NOT_UP_LEVEL_REWARD(40401, "宠物素材不可与宠物本体相同"),
    //时空冒险
    SPACE_TIME_NOT_SAILING(40420, "当前航队未航行"),
    SPACE_TIME_SAILING_NOT_FINISHED(40421, "航行未结束"),
    SPACE_TIME_ROUTE_NOT_UNLOCK(40422, "航线未解锁"),
    SPACE_TIME_FLEET_SAILING(40423, "舰队处于航行状态"),
    SPACE_TIME_SKILL_MAX_LEVEL(40424, "技能等级已达最大值"),
    SPACE_TIME_SKILL_NUM(40425, "技能点为空"),
    SPACE_TIME_SKILL_NOT_EXISTS(40426, "技能类型不存在"),
    SPACE_TIME_DURABILITY_MAX(40427, "舰队耐久度已满"),
    SPACE_TIME_ENERGY_NULL(40428, "舰队体力值为空"),
    SPACE_TIME_SHOP_CLOSE(40429, "商店已关闭"),
    SPACE_TIME_SHOP_NOT_ITEM(40430, "商店无该商品数据"),
    SPACE_TIME_HERO_LINEUP(40431, "英雄上阵重复"),
    SPACE_TIME_FLEET_EVENT_NOT_MATCHING(40432, "执行事件与当前事件不匹配"),
    SPACE_TIME_FLEET_EVENT_NULL(40433, "事件类型为空"),
    SPACE_TIME_FLEET_NAME_LENGTH_LIMIT(40434, "舰队名字字节超上限"),
    SPACE_TIME_FLEET_NOT_EVENT(40435, "该事件不需要执行"),
    SPACE_TIME_FLEET_EVENT_NOT_EXISTS(40436, "航行事件不存在"),
    SPACE_TIME_NOT_ENEMY(40437, "尚未匹配到敌人无法挑战"),
    SPACE_TIME_EVENT(40438, "上一个事件尚未执行或没放弃"),
    SPACE_TIME_HERO_LINEUP_REPEA(40439, "异界冒险阵容英雄上阵出现重复"),
    SPACE_TIME_HERO_LINEUP_NULL(40440, "异界冒险阵容英雄上阵为空"),
    //图腾
    TOTEMS_CLIENT_PARAMS_ERRE(40500, "图腾客户端参数错误"),
    TOTEMS_ACHIEVE_NO(40501, "图腾不存在"),
    TOTEMS_SHOULD_QUALITY(40502, "图腾需要升阶"),
    TOTEMS_LEVEL_FULL(40503, "图腾已满级"),
    TOTEMS_QUALITY_FULL(40504, "图腾品阶已达上限"),
    TOTEMS_QUALITY_LEVEL_NO(40505, "图腾没有达到升阶等级"),
    TOTEMS_HERO_NO(40506, "英雄没有装备该图腾"),
    TOTEMS_LEVEL_LOW_NORESET(40507, "图腾当前最低级，无法重置"),
    TOTEMS_HERO_ALREADY(40508, "英雄已经装备该图腾"),

    PROMOTION_070_HAD_SELECT(40601, "已经选择了奖励"),
    PROMOTION_070_TYPE_NUM_LOW(40602, "奖励选择类型数量不够"),
    PROMOTION_070_TYPE_NOT_SELECT(40603, "没有选择奖励"),
    PROMOTION_070_TYPE_REWARD_NUM_LOW(40604, "类型奖励对不上"),
    PROMOTION_070_REWARD_ID_ERROR(40605, "类型不对"),
    PROMOTION_070_MISSION_ERROR(40606, "任务错误"),
    PROMOTION_070_PROCESS_LOW(40607, "进度不足"),
    PROMOTION_070_OPEN_COUNT_LOW(40608, "开箱次数不足"),
    PROMOTION_070_COUNT_HAD_REWARD(40609, "奖励已经领取"),
    PROMOTION_070_HAD_OPEN(40610, "格子已经开启"),
    PROMOTION_070_OPEN_MAX(40611, "格子已经开完"),
    PROMOTION_070_MISSION_REWARD_LOW(40612, "任务领奖数不足"),
    PROMOTION_070_MISSION_BOX_HAD_REWARD(40613, "任务宝箱已领取"),

    //诸神祭坛
    PROMOTION_072_ROLELV(40701, "角色等级不够，不能参与诸神祭坛活动"),
    PROMOTION_072_MONEYBUY(40702, "钻石购买次数不够"),
    PROMOTION_072_PARAM_ERRO(40703, "诸神祭坛抽奖参数错误"),
    PROMOTION_072_TIME_OVER(40704, "诸神祭坛活动已经结束"),

    //魔方共鸣------40750-40800----
    TWEAK_CUBE_RANK_LOW(40750, "共鸣魔方供奉数量不足"),
    TWEAK_CUBE_HERO_CANT_ADD_TRENCH(40751, "英雄不能添加至槽位"),
    TWEAK_CUBE_TRENCH_IN_CD(40752, "槽位cd中"),
    TWEAK_CUBE_TRENCH_INDEX_ERROR(40753, "槽位索引异常"),
    TWEAK_CUBE_TRENCH_HAD_HERO(40754, "该槽位已经有英雄"),
    TWEAK_CUBE_TRENCH_MAX(40755, "槽位数量最大"),
    TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR(40756, "槽位上的英雄不允许该操作"),

    //神兵------40801-40850----
    SHENBIN_TEMPLATE_ERROR(40801, "神兵配置错误"),
    SHENBIN_COMPOSE_ITEM_ERROR(40802, "神兵合成，找不到材料"),
    SHENBIN_EQUIP_PARAM_ERROR(40803, "神兵装备，客户端参数错误"),
    SHENBIN_HOLE_TEMPLATE_ERROR(40804, "神兵孔位配置错误"),
    SHENBIN_EQUIP_ALREADY(40805, "神兵已经装备"),
    SHENBIN_CORE_PARAM_ERROR(40806, "神兵核心，客户端参数错误"),
    SHENBIN_CORE_TEMPLATE_ERROR(40807, "神兵核心配置错误"),
    SHENBIN_CORE_EQUIP_ERROR(40808, "神兵核心升级,装备未装满"),
    SHENBIN_RESOLVE_ITEM_ERROR(40809, "神兵分解,材料解析错误"),
    SHENBIN_RESOLVE_TEMPLATE_ERROR(40810, "神兵分解配置错误"),
    SHENBIN_CORE_OCCUPATION_NO(40811, "神兵核心升级，职级不达标"),
    SHENBIN_NOT_ENOUGH(40812, "神兵不足"),
    SHENBIN_POSITE_NOT(40813, "讨伐团坐标不允许分享到此频道"),
    SHENBIN_NO_CG(40814, "未加入讨伐团，不可分享到此频道"),

    OCCUPATION_TEMPLATE_ERROR(40815, "没有职级模板,不能进阶"),
    OCCUPATION_TASK_TEMPLATE_ERROR(40816, "没有职级任务模板，不能进阶"),
    OCCUPATION_TASK_EMPTY(40817, "任务还没开始 不能进阶"),
    OCCUPATION_TASK_NO_COMPLETE(40818, "任务没有完成"),
    OCCUPATION_TASKID_NO_TEMPLATE(40819, "找不到任务模板"),
    OCCUPATION_TASK_COMPLETE_ALREADY(40820, "手动完成任务，已经操作"),
    SHENBIN_RESOLVE_NUM_NOT_ENOUGH(40821, "分解神兵,数量不够"),
    SHENBIN_RESOLVE_PARAM_ERROR(40822, "分解神兵,客户端参数错误"),

    CRUSADE_GROUP_NOT_REGISTRATION_STAGE(40851, "讨伐团不在报名阶段"),
    ALREADY_SIGNED_UP(40852, "讨伐团已经报名"),
    BACKPACK_BOX_ID_NOT_EXIST(40853, "英雄盒子id不存在"),
    HERO_ALREADY_SET(40854, "英雄已经设置"),
    ALREADY_OCCUPIED(40855, "领地已经被占领"),
    THE_HERO_IS_WEAK(40856, "英雄体力不足"),
    INCORRECT_COORDINATES_REQUESTED(40857, "请求的坐标错误"),
    HERO_NOT_SET(40858, "英雄没有上阵"),
    NO_RESOURCES_TO_CHARGE(40859, "没有资源可以收取"),
    TERRITORY_DATA_ERROR(40860, "领地数据错误"),
    MUST_JOIN_THE_GUILD_FIRST(40861, "必须先加入公会"),
    GROUP_NAME_UNAVAILABLE(40862, "讨伐团名字不能有特殊字符哟"),
    RENAME_UP_LIMIT(40863, "讨伐团名字达到修改次数上限"),
    GROUP_NAME_TOO_LONG(40864, "讨伐团名字太长啦"),
    ONLY_THE_GROUP_LEADER_CAN_RENAME(40865, "只有团长可以重命名"),
    NOT_WITHIN_THE_RENAME_TIME(40866, "不在重命名时间内"),
    CRUSADE_GROUP_NOT_OPEN_STAGE(40867, "讨伐团不在开启阶段"),
    GROUP_NAME_NOT_EMPTY(40868, "讨伐团名字不能为空"),
    CANT_GIVE_UP_THE_ONLY_TERRITORY(40869, "不能放弃唯一领地"),
    TERRITORY_UP_LIMIT(40870, "领地数量达到上限，请提升职级"),
    TERRITORY_NAME_ILLEGAL(40871, "领地名称非法"),
    ENEMY_HAS_BEEN_DEFEATED(40872, "敌方已经被击败"),
    MUST_DEFEAT_THE_GUARDS_FIRST(40873, "必须先击败守卫部队，才能挑战boss"),
    TERRITORY_RECLAMATION_FAILED(40874, "领地开垦失败"),
    TERRITORY_UNDER_PROTECTION(40875, "领地保护中"),

    //位面之战------40901-40950----
    PLANE_WAR_LEVEL_ERROR(40901, "挑战等级错误"),
    PLANE_WAR_NOT_OPEN(40902, "关卡未开放"),
    PLANE_WAR_LINE_UP_ERROR(40903, "阵容错误"),
    PLANE_WAR_COUNT_LOW(40904, "挑战次数不足"),
    PLANE_WAR_BUY_COUNT_MAX(40905, "购买次数达到上限"),
    PLANE_WAR_CHALLENGE_COUNT_MAX(40906, "剩余挑战次数达到上限"),

    //中秋活动------40951-41000----
    PROMOTION_074_HAD_SELECT(40951, "已经选择了奖励"),
    PROMOTION_074_CANT_SELECT(40952, "不能选择奖励"),
    PROMOTION_074_TYPE_NOT_SELECT(40953, "没有选择奖励"),
    PROMOTION_074_TYPE_REWARD_NUM_LOW(40954, "类型奖励对不上"),
    PROMOTION_074_REWARD_ID_ERROR(40955, "类型不对"),
    PROMOTION_074_MISSION_ERROR(40956, "任务错误"),
    PROMOTION_074_PROCESS_LOW(40957, "进度不足"),
    PROMOTION_074_OPEN_COUNT_LOW(40958, "开箱次数不足"),
    PROMOTION_074_COUNT_HAD_REWARD(40959, "奖励已经领取"),
    PROMOTION_074_HAD_OPEN(40960, "格子已经开启"),
    PROMOTION_074_OPEN_MAX(40961, "格子已经开完"),
    PROMOTION_074_MISSION_REWARD_LOW(40962, "任务领奖数不足"),
    PROMOTION_074_MISSION_BOX_HAD_REWARD(40963, "任务宝箱已领取"),
    PROMOTION_076_FASHION_COUNT_HAD_REWARD(40964, "皮肤数量奖励已经领取"),
    PROMOTION_074_LOTTERY_NUM_ERROR(40965, "抽奖次数错误"),

    PROMOTION_081_MISSION_ERROR(60001, "任务错误"),
    PROMOTION_081_PROCESS_LOW(60002, "进度不足"),
    PROMOTION_081_MISSION_BOX_HAD_REWARD(60003, "箱子奖励已经领取"),
    PROMOTION_081_MISSION_REWARD_LOW(60004, "任务数量不足"),

    PROMOTION_083_CANT_SELECT(60050, "不能选择奖励"),
    PROMOTION_083_HAD_SELECT(60051, "已经选择了奖励"),
    PROMOTION_083_TYPE_NOT_SELECT(60052, "没有选择奖励"),
    PROMOTION_083_LOTTERY_NUM_ERROR(60053, "抽奖次数错误"),
    PROMOTION_083_OPEN_COUNT_LOW(60054, "抽奖次数不足"),
    PROMOTION_083_COUNT_HAD_REWARD(60055, "奖励已经领取"),

    PROMOTION_084_RECHARGE_LOW(60070, "充值金额不足"),
    PROMOTION_084_HAD_REWARD(60071, "已经领奖"),

    PROMOTION_085_MISSION_REWARD_LOW(60080, "任务领奖数不足"),
    PROMOTION_085_MISSION_BOX_HAD_REWARD(60081, "任务宝箱已领取"),
    PROMOTION_085_MISSION_ERROR(60082, "任务错误"),
    PROMOTION_085_PROCESS_LOW(60083, "进度不足"),
    PROMOTION_085_OPEN_COUNT_LOW(60084, "开箱次数不足"),
    PROMOTION_085_COUNT_HAD_REWARD(60085, "奖励已经领取"),

    PROMOTION_IS_CLOSE(60086, "活动已关闭"),

    PROMOTION_088_SCORE_LOW(60090, "积分不足"),

    PROMOTION_089_HAD_READ(60100, "今日已读取"),

    HADES_FLOOR_NOT_EXIST(60130, "挑战层数不存在"),
    HADES_FLOOR_MONSTER_NOT_EXIST(60131, "挑战层数怪物不存在"),
    HADES_SWEEP_COUNT_MAX(60132, "扫荡次数上限"),
    HADES_TYPE_ERROR(60133, "类型错误"),

    // 通行证2
    T_PERMIT_MAX_LEVEL(60151, "通行证2活动等级超过上限。"),
    T_PERMIT_LEVEL_LOW(60152, "通行证2等级不足以领取该奖励"),
    T_PERMIT_LEVEL_REWARD(60153, "通行证2等级奖励已领取"),
    T_PERMIT_ALL_LEVEL_REWARD(60154, "通行证2等级奖励已全部领取"),
    T_PERMIT_TASK_NOT_EXIST(60155, "当前轮次无该通行证2活动任务"),
    T_PERMIT_TASK_NOT_TARGET(60156, "通行证2任务未达标"),
    T_PERMIT_TASK_REWARD(60157, "通行证2任务奖励已领取"),

    PROMOTION_091_PLACE_ERROR(60170, "位置错误"),

    PROMOTION_092_HAD_SELECT_HERO(60180, "已经选择英雄"),
    PROMOTION_092_DELIVER_COUNT_LOW(60181, "献花次数不足"),

    PROMOTION_093_COUNT_LOW(60201, "次数不足"),
    PROMOTION_093_HAD_REWARD(60202, "已领取"),

    PROMOTION_094_SCORE_LOW(60220, "积分不足"),

    PROMOTION_096_MISSION_REWARD_LOW(60230, "任务领奖数不足"),
    PROMOTION_096_MISSION_BOX_HAD_REWARD(60231, "任务宝箱已领取"),
    PROMOTION_096_MISSION_ERROR(60232, "任务错误"),
    PROMOTION_096_PROCESS_LOW(60233, "进度不足"),
    PROMOTION_096_OPEN_COUNT_LOW(60234, "开箱次数不足"),
    PROMOTION_096_COUNT_HAD_REWARD(60235, "奖励已经领取"),

    PROMOTION_097_RESET_TIME_UN_ENOUGH(60236, "重置次数不足"),
    PROMOTION_097_NOT_REWARD_YET(60237, "当轮的奖励已经抽取完毕"),
    PROMOTION_097_POSITION_CAN_NOT_CHOICE(60238, "该位置奖励不可选"),
    PROMOTION_097_POSITION_REWARD_NOT_EXIST(60239, "该位置上不存在该奖励"),
    PROMOTION_097_RESET_CONDITION_DISSATISFACTION(60240, "重置条件不满足"),

    PROCESS_LOW(60250, "进度不足"),
    COUNTRY_WAR_SCORE_LOW(60251, "积分不足"),
    COUNTRY_WAR_ROUND_MISSION_NOT_COMPLETE(60252, "战旗轮次任务未完成"),
    COUNTRY_WAR_REPEATED_REWARD(60253, "奖励已经领取"),
    COUNTRY_WAR_NOT_JOIN(60254, "未参与国战"),
    COUNTRY_WAR_CAN_NOT_CONNECTION(60255, "城池未关联"),
    COUNTRY_WAR_SAME_FACTION(60256, "同阵营"),
    COUNTRY_WAR_CLOSING(60257, "国战关闭"),
    COUNTRY_WAR_HAD_IN_CITY(60258, "已经在该城市"),
    COUNTRY_WAR_DIFF_FACTION(60259, "不同阵营"),
    COUNTRY_WAR_STAGE_ERROR(60260, "阶段错误"),
    COUNTRY_WAR_NOT_OCCUPY(60261, "为占领城池"),
    COUNTRY_WAR_ISOLATE(60262, "城池处于孤立状态"),


    MAGIC_TOWER_BUY_COUNT_OVER(60301, "购买次数上限"),
    MAGIC_TOWER_STAR_HAD_REWARD(60302, "该星级奖励已经领取"),
    MAGIC_TOWER_CHAPTER_STAR_LOW(60303, "星级数不够"),
    MAGIC_TOWER_PASS_LEVEL_LOW(60304, "通关关卡数不够"),
    MAGIC_TOWER_CHALLENGE_COUNT_LOW(60305, "挑战次数不足"),
    MAGIC_TOWER_ARENA_CHANGE(60306, "擂主变更"),
    MAGIC_TOWER_NOT_ARENA_LEVEL(60307, "不是擂主关"),
    MAGIC_TOWER_NOT_EXIST_ARENA(60308, "不存在擂主"),

    MAGIC_TOWER_STAR_NO_ENOUGH(60340, "所需星级不足"),
    MAGIC_TOWER_BUY_LIMIT(60341, "已达最大购买次数"),
    MAGIC_TOWER_REWARD_HAD_RECEIVE(60342, "任务奖励已经领取"),
    MAGIC_TOWER_KING_TITLE_UNLOCK(60343, "斩魔王者未解锁"),

    HERO_IS_NOT_ACTIVE(60344, "需要先激活英雄才能使用皮肤"),

    // 通用错误码范围 (30000-39999) -----------------------
    // 错误码id范围段 (60001-69999)
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

    static {
        for (ErrorCode errorCode : ErrorCode.values()) {
            if (ENUMS.containsKey(errorCode.getValue())) {
                log.warn("error code duplicate:{},{}", ENUMS.get(errorCode.getValue()), errorCode);
                continue;
            }
            ENUMS.put(errorCode.getValue(), errorCode);
        }
    }

    public static ErrorCode valueOf(int value) {
        return ENUMS.get(value);
    }

    public static Map<Integer, ErrorCode> getErrorCodes() {
        return ENUMS;
    }

    public String message() {
        return String.format("%s{%s:%s}", super.toString(), value, desc);
    }

    public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException {
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
