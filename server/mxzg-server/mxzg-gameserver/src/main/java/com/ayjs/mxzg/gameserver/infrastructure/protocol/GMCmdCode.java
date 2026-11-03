package com.ayjs.mxzg.gameserver.infrastructure.protocol;

/**
 * GM指令
 */
public interface GMCmdCode {

    /**
     * 增加资源道具(道具id，数量)，item配置表说有资源道具都可以添加
     * exp:ADD_ITEM 900001 100 【增加100个900001，900001为item配置表的idx字段】
     */
    String ADD_ITEM = "ADD_ITEM";

    /**
     * 增加角色经验（调整的经验）
     * exp:ADD_ROLE_EXP 10000 【增加10000点角色经验】
     */
    String ADD_ROLE_EXP = "ADD_ROLE_EXP";

    /**
     * 解锁所有羁绊女神【无参数】
     * exp:ADD_GODDESS
     */
    String ADD_GODDESS = "ADD_GODDESS";

    /**
     * 清除地牢数据【无参数】
     * exp:CLEAN_SHELTER
     */
    String CLEAN_SHELTER = "CLEAN_SHELTER";

    /**
     * 开启所有活动
     * exp:OPEN_ALL_PROMOTION 【无参数，开启所有活动】
     * :OPEN_ALL_PROMOTION 1 【带上任意参数，关闭所有活动】
     */
    String OPEN_ALL_PROMOTION = "OPEN_ALL_PROMOTION";

    /**
     * GM充值 可以购买buygem配置表所有商品
     * exp:RECHARGE 2007 【2007是buygem配置表idx字段】
     */
    String RECHARGE = "RECHARGE";
    /**
     * 角色等级
     * exp:ROLE_LV 10  【角色等级提升10级】
     */
    String ROLE_LV = "ROLE_LV";
    /**
     * 角色名检查-【后端自测数据用】
     */
    String ROLE_NICK_CHECK = "ROLE_NICK_CHECK";
    /**
     * 发所有英雄【无参数】
     */
    String ALL_HERO = "ALL_HERO";
    /**
     * 发所有装备【无参数】
     */
    String ALL_EQUIP = "ALL_EQUIP";
    /**
     * 删除所有不在阵上的英雄【无参数】
     */
    String CLEAN_ALL_HERO = "CLEAN_ALL_HERO";
    /**
     * 公会世界BOSS下一阶段【无参数】
     */
    String CWB_NEXT_STAGE = "CWB_NEXT_STAGE";
    /**
     * 公会世界BOSS重新正常运行【无参数】
     */
    String CWB_RESTART = "CWB_RESTART";
    /**
     * 公会战下一阶段【无参数】
     */
    String CLANWAR_NEXT_STAGE = "CLANWAR_NEXT_STAGE";
    /**
     * 公会boss战斗次数修改
     * exp:CLAN_BOSS_BATTLE_TIMES_UPDATE 10 【公会boss战斗次数增加10次】
     */
    String CLAN_BOSS_BATTLE_TIMES_UPDATE = "CLAN_BOSS_BATTLE_TIMES_UPDATE";
    /**
     * 构建公会战测试环境【无参数】
     */
    String CLANWAR_BUILD = "CLANWAR_BUILD";
    /**
     * 公会战测试数据自动布置路线【无参数】
     */
    String CLANWAR_AUTO_ROAD = "CLANWAR_AUTO_ROAD";
    /**
     * 战斗数据测试【无参数】
     */
    String BATTLE_TEST = "BATTLE_TEST";

    /**
     * 角色关卡
     * exp:ROLE_MISSION 10 【通过主线关卡前进10关】
     */
    String ROLE_MISSION = "ROLE_MISSION";
    /**
     * 挂机奖励-【测试概率用】
     * exp:IDLE_AWARD_TEST 3 10 100 20
     * 测试第三关掉落，总共掉落100回合，每20回合重置一次限制数据，单回合是测试服10分钟的数据
     */
    String IDLE_AWARD_TEST = "IDLE_AWARD_TEST";
    /**
     * 跑马灯测试【无参数】
     */
    String MARQUEE_TEST = "MARQUEE_TEST";
    /**
     * 许愿池测试【测试概率用】
     * exp:BLESSING_POOL_TEST 1 100 10 普通关卡跑100次10连抽，每10连抽刷新一次奖池
     */
    String BLESSING_POOL_TEST = "BLESSING_POOL_TEST";
    /**
     * 竞技场奖励测试【无参数】
     */
    String PVP_REWARD_TEST = "PVP_REWARD_TEST";
    /**
     * 先知召唤测试【测试概率用】
     * exp:PROPHET_SUMMON_TEST 2 100, 水系先知召唤100次
     */
    String PROPHET_SUMMON_TEST = "PROPHET_SUMMON_TEST";
    /**
     * 七日目标测试【无参数】
     */
    String SEVEN_DAY_TEST = "SEVEN_DAY_TEST";
    /**
     * 升级羁绊VIP【无参数】
     */
    String UP_GODDESS_VIP = "UP_GODDESS_VIP";
    /**
     * 升级羁绊VIP
     * exp:GODDESS_LEVEL 10 【羁绊vip提升10级】
     */
    String GODDESS_LEVEL = "GODDESS_LEVEL";
    /**
     * 龙纹印记掉落测试【无参数】
     */
    String DRAGON_DROP_TEST = "DRAGON_DROP_TEST";
    /**
     * 概率测试【无参数】
     */
    String RATE_TEST = "RATE_TEST";
    /**
     * 增加在线时长【无参数】
     */
    String ADD_ONLINE_TIME = "ADD_ONLINE_TIME";
    /**
     * 添加英雄
     * exp:ADD_HERO 10505010 9【添加一个9星的10505010英雄】
     */
    String ADD_HERO = "ADD_HERO";
    /**
     * 庇护所商场测试
     * exp:ADD_SHELTER_SHOP_ITEM 10【庇护所商场掉落10次】
     */
    String ADD_SHELTER_SHOP_ITEM = "ADD_SHELTER_SHOP_ITEM";
    /**
     * 庇护所道具增加【已经弃用】
     String ADD_SHELTER_ITEM = "ADD_SHELTER_ITEM";
     *//**
     * 英雄积分抽奖【已经弃用】
     *//*
    String ADD_HERO_POINT = "ADD_HERO_POINT";
    *//**
     * 酒馆任务刷新【已经弃用】
     *//*
    String ADD_TAVERN_TASK = "ADD_TAVERN_TASK";*/
    /**
     * 冠军赛下一阶段【无参数】
     */
    String CHAMPION_NEXT_STAGE = "CHAMPION_NEXT_STAGE";

    /**
     * 跨服冠军赛下一阶段【无参数】
     */
    String CHAMPION_CROSS_NEXT_STAGE = "CHAMPION_CROSS_NEXT_STAGE";

    /**
     * 构建冠军赛测试环境【无参数】
     */
    String CHAMPION_BUILD = "CHAMPION_BUILD";
    /**
     * 测试录像【无参数】
     */
    String VIDEO_TEST = "VIDEO_TEST";

    String RESET_DREAMLAND = "RESET_DREAMLAND";

    /**
     * 通行证任务【无参数】
     */
    String TRAFFIC_PERMIT = "TRAFFIC_PERMIT";

    /**
     * 全符文【无参数】
     */
    String ALL_RUNES = "ALL_RUNES";

    /**
     * 增加冒险点数
     * exp:ADD_ADVENTURE_COUNT 100【冒险点数增加100】
     */
    String ADD_ADVENTURE_COUNT = "ADD_ADVENTURE_COUNT";

    /**
     * 测试不发邮件【无参数】
     */
    String TEST_REFUSE_MAIL = "TEST_REFUSE_MAIL";

    /**
     * 全宝石【无参数】
     */
    String ALL_JEWEL = "ALL_JEWEL";

    /***
     * 诸神遗迹增加关卡
     * exp:GOD_RELIC_ADD_LEVEL 关卡 等级
     */
    String GOD_RELIC_ADD_LEVEL = "GOD_RELIC_ADD_LEVEL";
    /***
     * 诸神遗迹增加使用次数
     * exp:GOD_RELIC_ADD_COUNT 10 【增加诸神遗迹使用10次】
     */
    String GOD_RELIC_ADD_COUNT = "GOD_RELIC_ADD_COUNT";

    /***
     * 随机上阵战斗测试【无参数】
     */
    String HERO_RANDOM_TEST = "HERO_RANDOM_TEST";

    /**
     * 取主线阵容，对阵所有怪物阵容【无参数】【测试战斗是否报错用】
     */
    String MONSTER_TEAM_CHECK = "MONSTER_TEAM_CHECK";
    /**
     * 永恒梦境
     * exp:DREAMLAND_END 10 【打永恒梦境10次】
     */
    String DREAMLAND_END = "DREAMLAND_END";
    /**
     * 三日任务重置【无参数】
     */
    String SAN_RI_REN_WU = "SAN_RI_REN_WU";
    /**
     * 私人定制数据清理【无参数】
     */
    String CUSTOM_REWARD_CLEAR = "CUSTOM_REWARD_CLEAR";
    /**
     * 删除所有钻石【无参数】
     */
    String CLEAN_GEM = "CLEAN_GEM";
    /**
     * 重置新英雄抽卡玩家数据【无参数】
     */
    String HERO_ROLLING_RESET = "HERO_ROLLING_RESET";
    /**
     * 进入下一个阶段【无参数】
     */
    String SUPER_MATCH_NEXT_STAGE = "SUPER_MATCH_NEXT_STAGE";
    /**
     * 重置到当前阶段【无参数】
     */
    String SUPER_MATCH_RESET_STAGE = "SUPER_MATCH_RESET_STAGE";
    /**
     * 巅峰赛下一阶段【无参数】
     */
    String PINNACLE_NEXT_STAGE = "PINNACLE_NEXT_STAGE";
    /**
     * 段位赛重置次数【无参数】
     */
    String SUPER_STAGE_RESET = "SUPER_STAGE_RESET";
    /**
     * 段位赛清理对手【无参数】
     */
    String CLEAN_OPPONENT = "CLEAN_OPPONENT";
    /**
     * 段位赛上传所有的用户【无参数】
     */
    String PINNACLE_UPLOAD_ALL = "PINNACLE_UPLOAD_ALL";
    /**
     * 段位赛设置段位
     * <p>
     * exp:STAGE_MATCH_SET_STAGE 1 【 1是段位id 配置表SuperStage字段idx】
     */
    String STAGE_MATCH_SET_STAGE = "STAGE_MATCH_SET_STAGE";
    /**
     * 时空魔塔重置每天【无参数】
     */
    String TIME_TOWER_RESET = "TIME_TOWER_RESET";
    /**
     * 时空魔塔GM发奖【无参数】
     */
    String TIME_TOWER_REWARD = "TIME_TOWER_REWARD";

    /**
     * 重置活动
     * exp:RESET_PROMOTION 30 【30活动类型重置】
     */
    String RESET_PROMOTION = "RESET_PROMOTION";

    /**
     * 时空冒险增加体力
     * exp:SPACE_TIME_ENERGY 10 【时空冒险增加体力10点】
     */
    String SPACE_TIME_ENERGY = "SPACE_TIME_ENERGY";

    /**
     * 时空冒险增加科技点
     * exp:SPACE_TIME_SKILL 100 【增加时空冒险100科技点】
     */
    String SPACE_TIME_SKILL = "SPACE_TIME_SKILL";

    /**
     * 时空冒险降低耐久度
     * exp:SPACE_TIME_DURABILITY 100【时空冒险降低100耐久度】
     */
    String SPACE_TIME_DURABILITY = "SPACE_TIME_DURABILITY";

    /**
     * 增加航行进度(百分比)
     * exp:SPACE_TIME_PROGRESS 10【增加航行10%进度】
     */
    String SPACE_TIME_PROGRESS = "SPACE_TIME_PROGRESS";

    /**
     * 解锁事件
     * exp:SPACE_TIME_UNLOCK_EVENT 1001  【解锁1001时空冒险事件】
     */
    String SPACE_TIME_UNLOCK_EVENT = "SPACE_TIME_UNLOCK_EVENT";

    /**
     * 时空冒险添加临时背包【无参数】
     */
    String SPACE_TIME_ADD_BACKPACK = "SPACE_TIME_ADD_BACKPACK";

    /**
     * 时空冒险指定下一个事件类型
     * exp:SPACE_TIME_NEXT_EVENT 1001【异界冒险指定下一个1001事件类型】
     */
    String SPACE_TIME_NEXT_EVENT = "SPACE_TIME_NEXT_EVENT";

    /**
     * 时空冒险清除激活的隐藏航线【无参数】
     */
    String SPACE_TIME_CLEAN_ROUTE = "SPACE_TIME_CLEAN_ROUTE";

    /**
     * 时空冒险增加舰队经验
     * exp:SPACE_TIME_ADD_EXP 100 【增加100舰队经验】
     */
    String SPACE_TIME_ADD_EXP = "SPACE_TIME_ADD_EXP";

    /**
     * 将超值赠礼激活时间调整为当前时间【无参数】
     */
    String UPDATE_RECHARGE_GIFT_TIME = "UPDATE_RECHARGE_GIFT_TIME";

    /**
     * 将超值赠礼礼包激活时间调前一天【无参数】
     */
    String RECHARGE_GIFT_TIME = "RECHARGE_GIFT_TIME";

    /**
     * 重置诸神祭坛钻石抽奖次数【无参数】
     */
    String RESET_ZSJT = "RESET_ZSJT";

    /**
     * 讨伐团进入下一阶段【无参数】
     */
    String CRUSADE_GROUP_NEXT = "CRUSADE_GROUP_NEXT";

    /**
     * 重置讨伐团【无参数】
     */
    String RESET_CRUSADE_GROUP = "RESET_CRUSADE_GROUP";
    /**
     * 讨伐团信息增加體力
     * exp:INCREASE_PHYSICAL_STRENGTH 100【讨伐团信息增加100體力】
     */
    String INCREASE_PHYSICAL_STRENGTH = "INCREASE_PHYSICAL_STRENGTH";

    /**
     * 升级讨伐团职级【无参数】
     */
    String UP_OCCUPATION = "UP_OCCUPATION";

    /**
     * 占领领地
     * exp:OCCUPIED_TERRITORY 100【占领领地ID100】
     * OCCUPIED_TERRITORY 10 10 【占领坐标为10，10的领地】
     */
    String OCCUPIED_TERRITORY = "OCCUPIED_TERRITORY";

    /**
     * 清理讨伐团boss小怪
     */
    String CLEAN_BEATER = "CLEAN_BEATER";

    //浮空岛
    /***
     * 设置阶段
     * exp:FLOATING_ISLANDS_SET_STATE 1或者2或者3
     */
    String FLOATING_ISLANDS_SET_STATE = "FLOATING_ISLANDS_SET_STATE";

    /***
     * 增加次数【无参数】
     */
    String FLOATING_ISLANDS_ADD_COUNT = "FLOATING_ISLANDS_ADD_COUNT";

    /***
     * 增加伤害【无参数】
     */
    String FLOATING_ISLANDS_ADD_DMG = "FLOATING_ISLANDS_ADD_DMG";

    /***
     * 70活动随机奖励测试【无参数】
     */
    String PROMOTION070_RANDOM_REWARD = "PROMOTION070_RANDOM_REWARD";

    /***
     * 组队竞技场设置状态
     * exp:TEAM_ARENA_SET_STATE 1或2或3或4【1：休战阶段，2：组队阶段，3：挑战阶段，4：结算阶段】
     */
    String TEAM_ARENA_SET_STATE = "TEAM_ARENA_SET_STATE";

    /***
     * 组队竞技场创建队伍【无参数】
     */
    String TEAM_ARENA_CREATE = "TEAM_ARENA_CREATE";

    /***
     * 一键创建三个队伍并报名【无参数】
     */
    String TEAM_ARENA_ONE_KEY = "TEAM_ARENA_ONE_KEY";
    /***
     * 给本服所有队伍报名【无参数】
     */
    String TEAM_ARENA_SIGN = "TEAM_ARENA_SIGN";
    /***
     * 组队竞技场增加100次数【无参数】
     */
    String TEAM_ARENA_ADD_COUNT = "TEAM_ARENA_ADD_COUNT";

    /***
     * 冥域魔都重置层数【无参数】
     */
    String HADES_RESET_LV = "HADES_RESET_LV";

    /***
     * 设置主线关卡
     */
    String SET_CHAPTER_ID = "SET_CHAPTER_ID";

    /***
     * 增加攻击和迁移令
     */
    String COUNTRY_WAR_ADD_ITEM = "COUNTRY_WAR_ADD_ITEM";

    /***
     * 下一阶段,使用后，要重新登陆
     */
    String COUNTRY_WAR_GM_NEXT = "COUNTRY_WAR_GM_NEXT";

    /***
     * 清除商城
     */
    String COUNTRY_WAR_CLEAR_SHOP = "COUNTRY_WAR_CLEAR_SHOP";

    /***
     * 积分任务进度
     */
    String COUNTRY_WAR_MISSION = "COUNTRY_WAR_MISSION";

    /***
     * 清除商城
     */
    String COUNTRY_WAR_CLEAR_CITY = "COUNTRY_WAR_CLEAR_CITY";

    /***
     * 强制分组
     */
    String COUNTRY_WAR_FORCE_GROUP = "COUNTRY_WAR_FORCE_GROUP";

    /***
     * 重置阵营
     */
    String COUNTRY_WAR_RESET_FACTION = "COUNTRY_WAR_RESET_FACTION";

    /***
     * 幻魔塔增加关卡
     * exp:MAGIC_TOWER_ADD_LEVEL 关卡
     */
    String MAGIC_TOWER_ADD_LEVEL = "MAGIC_TOWER_ADD_LEVEL";
    /***
     * 幻魔塔增加使用次数
     * exp:MAGIC_TOWER_ADD_COUNT 10 【增加幻魔塔使用10次】
     */
    String MAGIC_TOWER_ADD_COUNT = "MAGIC_TOWER_ADD_COUNT";
}
