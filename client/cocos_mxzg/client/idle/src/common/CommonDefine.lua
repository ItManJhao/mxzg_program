
SPLIT_CHAR = "◆"
UI_ENABLE_MOVE_DISTANCE = 5

FONT_BLUE = cc.c3b(180, 218, 236)
FONT_LIGHT_BLUE = cc.c3b(222, 244, 255)
FONT_DARK_BLUE = cc.c3b(10, 80, 108)
FONT_GRAY = cc.c3b(127, 127, 127)
FONT_RED = cc.c3b(171, 77, 0)
FONT_YELLOW = cc.c3b(241, 227, 133)
FONT_LIGHT_YELLOW = cc.c3b(255, 250, 185)
FONT_GREEN = cc.c3b(0, 255, 120)
FONT_BROWN = cc.c3b(100, 50, 0)
FONT_BROWN_2 = cc.c3b(122,71,45)
FONT_BLACK = cc.c3b(67, 22, 17)
FONT_WHITLE = cc.c3b(255, 255, 255)
TIPS_BLUE = cc.c3b(46, 167, 218)
TIPS_RED = cc.c3b(255, 0, 0)
SKILL_YELLOW = cc.c3b(235,203,159)
FONT_GREY_CHOOSE = cc.c3b(233, 55, 47)

FONT_BLACK2 = cc.c3b(0, 0, 0)

FONT_BTN_OUTLINE_GREEN = cc.c3b(13, 91, 45)
FONT_BTN_OUTLINE_ZI = cc.c3b(131, 43, 22)

FONT_WHITE_2_GRAY = cc.c3b(200, 200, 200)
FONT_OUTLINE_2_GRAY = cc.c3b(100, 100, 100)


FONT_BLACK_TEXT = cc.c4b(0, 0, 0, 255)
FONT_BLACK_HALF_C4B = cc.c4b(0, 0, 0, 170)
FONT_BLACK_C4B = cc.c4b(67, 22, 17, 255)
FONT_WHITE_C4B = cc.c4b(255, 255, 255, 255)
FONT_BLUE_C4B = cc.c4b(180, 218, 236, 255)
FONT_LIGHT_BLUE_C4B = cc.c4b(222, 244, 255, 255)
FONT_DARK_BLUE_C4B = cc.c4b(10, 80, 108, 255)
FONT_GRAY_C4B = cc.c4b(127, 127, 127, 255)
FONT_LIGHT_GRAY_C4B = cc.c4b(0, 0, 0, 127)
FONT_RED_C4B = cc.c4b(178, 59, 63, 255)
FONT_YELLOW_C4B = cc.c4b(241, 227, 133, 255)
FONT_LIGHT_YELLOW_C4B = cc.c4b(255, 250, 185, 255)
FONT_GREEN_C4B = cc.c4b(0, 255, 119, 255)
FONT_BROWN_C4B = cc.c4b(100, 50, 0, 255)

FONT_LABEL_SELECTED = cc.c3b(255, 255, 255)
FONT_LABEL_NOT_SELECTED = cc.c3b(211, 225, 238)

SERVER_SHEN_HE_ID = 9999 --定义的一个审核服id

-- 神装品质颜色表
GOD_EQUIP_RARE_COLOR = {
    HEX = {
        [1] = "#3a80ff",
        [2] = "#9a0bff",
        [3] = "#ef6b00"
    },
    RGB = {
        [1] = cc.c3b(58, 128, 255),
        [2] = cc.c3b(154, 11, 255),
        [3] = cc.c3b(239, 107, 0)
    }
}

RomanNumber = {
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII",
}


-- 对应的是item表中的mode.
ItemData = {}
ItemData.IT_INVALID 	    = 0
ItemData.IT_EQUIP 		    = 1     -- 装备
ItemData.IT_PROP 		    = 2     -- 道具
ItemData.IT_PIECE 		    = 3     -- 碎片
ItemData.IT_SPECIAL 	    = 4	    -- 特殊
ItemData.IT_RES 		    = 5     -- 资源
ItemData.IT_RUNES 		    = 6     -- 符文
ItemData.IT_HERO 		    = 7     -- 英雄
ItemData.IT_SPECIAL_ELITE   = 8     -- 精英碎片
ItemData.IT_HERO_MATERIAL   = 9     -- 5星狗粮
ItemData.IT_HERO_STONE      = 10    -- 宝石
ItemData.IT_HERO_GODEQUIP   = 11    -- 神装
ItemData.IT_HERO_FASHION    = 13    -- 皮肤
ItemData.IT_GODEQUIP_ITEM   = 14    -- 神装道具
ItemData.IT_HALLOWS         = 15    -- 圣物
ItemData.IT_PROP_LIMIT_TIME = 17    -- 限时道具
ItemData.ARTIFACTS          = 18    -- 灵器
ItemData.PET                = 19    -- 宠物
ItemData.TOTEM              = 21    -- 图腾
ItemData.SHEN_BING          = 22    -- 神兵
ItemData.MAGIC_WAND         = 23    -- 魔杖
ItemData.RECHAR_CARD        = 24    -- 充值卡

-- Rechargeable card

BackpackType = {}
BackpackType.AbilityEssence = 901201

RecoveryType = {}
RecoveryType.RT_CO_EXIST = 1      -- 不移除父节点。
RecoveryType.RT_REMOVE_PARENT = 2 -- 移除父节点


FontAbility = {}
FontAbility.Shadow = {cc.c3b(0, 0, 0), cc.size(0, -1), 2}

CPPHandlerType = {}
CPPHandlerType.EVENT_CUSTOM_BEGAN = 10000

FONT_DEFAULT_NAME = "font/HYZhongJianHeiJ.ttf"
FONT_DEFAULT_NAME_BOLD = cc.UserDefault:getInstance():getStringForKey("font_file", "font/CloudYuanCuGBK.ttf")


CLAN_NAME_LENGTH = 25
NAME_LENGTH = 25
CHAT_LENGTH = 200
PASSCODE_LENGTH = 7
INPUT_CODE_LENGTH = 51

AbilityType = {}
AbilityType.AT_INVALID = 0
AbilityType.AT_REPLENISH_BASE      = 100       -- 基础治疗效果。100%。治疗数值就是攻击力数值
AbilityType.AT_SPEED_BASE          = 101       -- 速度固定数值
AbilityType.AT_HP_MAX_BASE         = 102       -- 提升最大生命值
AbilityType.AT_SKILL_DAMAGE        = 110       -- 技能基本伤害
-- 技能相关属性
AbilityType.AT_SKILL_UP            = 200       -- 技能伤害提升
AbilityType.AT_ATTACK_UP           = 201       -- 攻击提升%
AbilityType.AT_DEFENSE_UP          = 202       -- 防御提升%
AbilityType.AT_DEFENSE_IGNORE_UP   = 203       -- 无视防御%
AbilityType.AT_SPEED_UP            = 204       -- 速度提升()
AbilityType.AT_REPLENISH_UP        = 205       -- 治疗效果提升
AbilityType.AT_BEREPLENISH_UP      = 206       -- 被治疗效果提升
AbilityType.AT_CRITICAL_UP         = 207       -- 暴击提升
AbilityType.AT_BECRITICAL_UP       = 208       -- 被暴击提升
AbilityType.AT_DODGE               = 210       -- 格挡几率提升
AbilityType.AT_HIT_RATE            = 211       -- 精准提升
-- 效果抵抗
AbilityType.AT_EXEMPTION_CONFINED  = 212       -- 免除控制的几率
AbilityType.AT_EXEMPTION_SILENCE   = 213       -- 沉默抵抗
AbilityType.AT_EXEMPTION_DISARM    = 214       -- 缴械抵抗
AbilityType.AT_EXEMPTION_IMMOBILIZ = 215       -- 定身抵抗
AbilityType.AT_EXEMPTION_FROZEN    = 216       -- 冰冻抵抗
AbilityType.AT_EXEMPTION_DIZZY     = 217       -- 眩晕抵抗
AbilityType.AT_EXEMPTION_PETRIFY   = 218       -- 石化抵抗
AbilityType.AT_EXEMPTION_PETRIFY   = 219       -- 无视控制抵抗

-- 基础属性
AbilityType.AT_ATTACK_ADD          = 220       -- 攻击增加固定
AbilityType.AT_DAMAGE_UP           = 221       -- 伤害提升
AbilityType.AT_DAMAGE_CRITICAL_UP  = 222       -- 暴击伤害提升
AbilityType.AT_HP_ADD              = 223       -- 血量固定数值增加
AbilityType.AT_DEFENSE_ADD         = 224       -- 护甲固定数值增加
AbilityType.AT_DAMAGE_HOLY         = 225       -- 神圣伤害增加
AbilityType.AT_SKILL_ADD           = 226       -- 技能固定伤害增加
AbilityType.AT_SKILL_ADD           = 226       -- 技能固定伤害增加
AbilityType.AT_DEFENSE_IGNORE      = 227       -- 无视所有防御

-- 天赋属性
AbilityType.AT_DAMAGE_FIRE         = 251       -- 火的伤害提升
AbilityType.AT_DAMAGE_FOREST       = 252       -- 森林的伤害提升
AbilityType.AT_DAMAGE_WATER        = 253       -- 水的伤害提升
AbilityType.AT_DAMAGE_LIGHT        = 254       -- 光的伤害提升
AbilityType.AT_DAMAGE_SHADOW       = 255       -- 暗的伤害提升
-- 特殊伤害
AbilityType.AT_DAMAGE_SILENCE      = 260       -- 对沉默目标伤害加成
AbilityType.AT_DAMAGE_DISARM       = 261       -- 对缴械目标伤害加成
AbilityType.AT_DAMAGE_IMMOBILIZ    = 262       -- 对定身目标伤害加成
AbilityType.AT_DAMAGE_FROZEN       = 263       -- 对冰冻目标伤害加成
AbilityType.AT_DAMAGE_DIZZY        = 264       -- 对眩晕目标伤害加成
AbilityType.AT_DAMAGE_PETRIFY      = 265       -- 对石化目标伤害加成
AbilityType.AT_DAMAGE_RESULT_UP    = 270       -- 最终伤害结果增加
-- 职业加成
AbilityType.AT_DAMAGE_FIGHTER      = 281       -- 对战士伤害加成
AbilityType.AT_DAMAGE_MAGE         = 282       -- 对法师伤害加成
AbilityType.AT_DAMAGE_PRISET       = 283       -- 对牧师伤害加成
AbilityType.AT_DAMAGE_ASSASSIN     = 284       -- 对刺客伤害加成
AbilityType.AT_DAMAGE_RANGER       = 285       -- 对游侠伤害加成
AbilityType.AT_DAMAGE_REDUCTION    = 291       -- 伤害减免

-- 国战
AbilityType.AT_DRIVE                = 340       -- 驱使
AbilityType.AT_INCANTATION          = 341       -- 咒术


NULL_ID = 0
ShaderType = {}
ShaderType.ST_POSITION_TEXTURE_DEFAULT = 0
ShaderType.ST_POSITION_TEXTURE_DEFAULT_HIGHP = 1
ShaderType.ST_POSITION_TEXTURE_GRAY = 2
ShaderType.ST_POSITION_TEXTURE_GRAY_UNIFORM = 3

MainSceneType = {}
MainSceneType.MAINCITY_LAYER = 100000				-- 主城
MainSceneType.MAINCITY_SUMMON= 100100				-- 召唤法阵
MainSceneType.MAINCITY_PUB_TASK = 100200			-- 酒馆派遣
MainSceneType.MAINCITY_BLESSING_POOL = 100300		-- 许愿池
MainSceneType.MAINCITY_FANTASY_TOWER = 100400		-- 幻境之塔 
MainSceneType.MAINCITY_FANTASY_TOWER_BATTLE = 100401-- 幻境之塔战斗
MainSceneType.MAINCITY_MAGIC_TOWER = 100410		    -- 幻魔塔 
MainSceneType.MAINCITY_MAGIC_TOWER_BATTLE = 100411  -- 幻魔塔战斗
MainSceneType.MAINCITY_PROPHET_TREE = 100500		-- 先知之树
MainSceneType.MAINCITY_DUNGEON = 100600				-- 地牢 
MainSceneType.MAINCITY_DUNGEON_SHOP = 100601	    -- 地牢商店
MainSceneType.MAINCITY_RECHARGE = 100700			-- 充值
MainSceneType.MAINCITY_DAILY_CHECK = 100800			-- 签到
MainSceneType.SEVEN_DAY_TARGET_LAYER = 100810		-- 七天目标任务
MainSceneType.MAINCITY_ALTAR = 100900				-- 祭坛
MainSceneType.MAINCITY_TRIAL = 101000				-- 勇者试炼
MainSceneType.MAINCITY_TRIAL_BATTLE = 101001		-- 勇者试炼战斗
MainSceneType.MAINCITY_LIMIT_GIFT = 101100			-- 限时礼包
MainSceneType.MAINCITY_MONTH_INVEST = 101200		-- 月度返利(投资)
-- MainSceneType.SEVEN_DAY_GIFT_LAYER = 101200		-- 七天登陆
MainSceneType.MAINCITY_LIMIT_TIME_ACTIVITY  = 101300    -- 限时活动
MainSceneType.MAINCITY_PVP_BATTLE		    = 101400	-- PVP战斗场景
MainSceneType.MAINCITY_ANCIENT		        = 101500	-- 远古战场
MainSceneType.MAINCITY_GOD_RELIC            = 101600	-- 诸神遗迹
MainSceneType.MAINCITY_GOD_RELIC_LIST       = 101601	-- 诸神遗迹列表
MainSceneType.MAINCITY_GOD_RELIC_BATTLE     = 101602	-- 诸神遗迹列表
MainSceneType.MAIN_MAGIC_CUBE = 101900                  -- 魔方

MainSceneType.MAINCITY_NEW_SERVER_LIMIT = 101603 -- 新服限购
MainSceneType.MAINCITY_SMITH = 101700 -- 铁匠铺
MainSceneType.MAINCITY_HERO_PALACE = 101800 -- 英雄殿堂
MainSceneType.COMMON1ACTIVITYLAYER = 102000 -- 通用活动1号类型窗体

MainSceneType.MAINCITY_BLACKMARKETSHOP = 102101 -- 黑市
MainSceneType.MAINCITY_MARKETSHOP = 102100 -- 市场

MainSceneType.DREAM_LAYER = 102200 -- 永恒梦见
MainSceneType.DREAM_LANG_BATTLE = 102201 -- 永恒梦境

MainSceneType.MAINCITY_CHAMPIONSHIP_LIKE = 102300 -- 冠军赛排名展示界面
MainSceneType.MAINCITY_CHAMPIONSHIP = 102301 -- 冠军赛

MainSceneType.MAINCITY_CHAMPIONCROSS_LIKE = 102600 -- 冠军赛排名展示界面
MainSceneType.MAINCITY_CHAMPIONCROSS = 102601 -- 冠军赛

MainSceneType.MAINCITY_DEVELOP_GIFT = 102401 -- 超值养成
MainSceneType.MAINCITY_LIMIT_TIME_SERVER = 102402 -- 购买皮肤

MainSceneType.LEAGUE_PORTAL = 102501 -- 联赛(跨服时空)入口
MainSceneType.LADDER_WAR_MAIN = 102511 -- 天梯主界面

MainSceneType.MAINCITY_TEAM_ARENA = 102700 --
MainSceneType.MAINCITY_TEAM_ARENA_BATTLW = 102710 --

MainSceneType.MAINCITY_SUPER_STAGE_MAIN = 102801 -- 超凡段位赛主界面
MainSceneType.MAINCITY_SUPER_STAGE_TOKEN = 102802 -- 超凡段位赛战令
MainSceneType.MAINCITY_SUPER_STAGE_LEGEND = 102803 -- 超凡段位赛赛季传奇界面
MainSceneType.MAINCITY_SUPER_STAGE_MATCH = 102804 -- 超凡段位赛匹配界面
MainSceneType.MAINCITY_SUPER_STAGE_TOP = 102805 -- 超凡段位赛巔峰賽決賽界面

MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS1 = 102901 -- 浮空岛boss主界面
MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS_BATTLE = 102902 -- 浮空岛boss战斗

MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN = 103001 -- 时空魔塔主界面
MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_RANK = 103002 -- 时空魔塔排行界面

MainSceneType.MAINCITY_HERO_PERNUTE = 103100 -- 英雄置换
MainSceneType.HERO_CREAT_LAYER = 104000 -- 创造法阵
MainSceneType.EXOTIC_ADVENTURE = 104100 -- 异界冒险
MainSceneType.EXOTIC_ADVENTURE_SAILING = 104200 -- 异界冒险-航行界面

MainSceneType.MAIN_ACT_SECRET_TREASURE = 104300 -- 活动-梦境秘宝

MainSceneType.MAIN_ACT_SEVEN_ARTIFACT = 104400 -- 活动-七神器

MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER = 104500 -- 讨伐团
MainSceneType.MAINCITY_CRUSADE_GROUP_BATTLE_LAYER = 104501 -- 讨伐团战斗
MainSceneType.MAINCITY_CRUSADE_GROUP_BOSS_LAYER = 104510 -- 讨伐团Boss界面

MainSceneType.MAINCITY_CRUSADE_GROUP_SHEN_BING_LAYER = 104600 -- 讨伐团-神兵

MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER = 104700 -- 位面之战
MainSceneType.MAINCITY_PLANE_WAR_MISSION_LAYER = 104701 -- 位面之战-关卡
MainSceneType.MAINCITY_PLANE_WAR_MISSION_BATTLE_LAYER = 104702 -- 位面之战-关卡战斗

MainSceneType.MAIN_ACT_APPRECIATE_MOON = 104800 -- 活动-秋赏明月

MainSceneType.MAIN_ACT_HALLOWEEN = 104900 -- 活动-万圣节

MainSceneType.MAIN_BLACK_FRIDAY = 105000 -- 活动-黑色星期五

MainSceneType.MAIN_THREE_DAYS_RECHARGE = 105100 -- 活动-三日累充

MainSceneType.MAIN_CHRISTMAS = 105200 -- 活动-圣诞节活动

MainSceneType.MAINCITY_UNDERWORLD_PAGODA = 105300 -- 冥界魔都主界面
MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS = 105400 -- 冥界魔都主界面

MainSceneType.MAIN_SPRING = 105500 -- 活动-春日踏青

MainSceneType.MAIN_COUNTRY_WAR = 105600       -- 国战
MainSceneType.MAIN_COUNTRY_WAR_CITY = 105700  -- 国战-城市界面

MainSceneType.ALICE_WONDERLAND = 105800  -- 爱丽丝仙境


MainSceneType.MAINCITY_EDIT_BATTLE          = 109998 -- GM战斗界面
MainSceneType.MAINCITY_EDIT                 = 109999 -- GM编辑界面

MainSceneType.HERO_LAYER = 200000					-- 英雄背包
MainSceneType.HERO_INFO_LAYER = 201000				-- 英雄详细信息
MainSceneType.HERO_ILLUSTRAT_INFO_LAYER = 202000	-- 英雄图鉴详细信息
MainSceneType.HERO_EVOLUTION_LAYER = 203000         -- 英雄进化
MainSceneType.HERO_EVOLUTION_PREVIEW_LAYER = 204000         -- 英雄进化图鉴预览
MainSceneType.HERO_SKIN_SHOP = 205000          --永久皮肤商城

MainSceneType.BACKPACK_LAYER = 300000				-- 背包
MainSceneType.MLT_BATTLE = 400000					-- 战斗
MainSceneType.MLT_BATTLE_TEST = 400001              -- 测试战斗
MainSceneType.MLT_BATTLE_OLD = 400002				-- 旧战斗
MainSceneType.CLAN = 600000							-- 公会
MainSceneType.CLAN_GVG = 601000					    -- 公会战
MainSceneType.CLAN_BOSS = 602000					-- 公会Boss
MainSceneType.MAINCITY_CLAN_MISSION_BATTLE = 603000 -- 公会副本战斗场景

MainSceneType.MAINCITY_SLZM = 500000				-- 失恋之门
MainSceneType.MISSION = 500001					    -- 副本
MainSceneType.MAINCITY_CHSD = 500011                -- 彩虹圣殿
MainSceneType.FETTER_MAIN_VIEW = 700000 			-- vip界面
MainSceneType.FETTER_INFO = 701000					-- 羁绊

MainSceneType.DRAGON_VIEW = 700001
MainSceneType.FETTER_VIP_INFO = 700002			


MainSceneType.ACTIVE_ZHUSHEN = 800000				-- 活动诸神之战





MainBattleLayerType = {}
MainBattleLayerType.DAILY_BATTLE = 1

SceneCtrType = {}
SceneCtrType.SCT_VALID = -1
SceneCtrType.SCT_LOADING_SCENE = 0
SceneCtrType.SCT_MAIN_SCENE = 1
SceneCtrType.SCT_BATTLE_SCENE = 2
SceneCtrType.SCT_LOGO_SCENE = 3

ItemType = {}
-- GM类型
ItemType.FETTER_LEVEL = 800000	-- 羁绊等级
ItemType.VIP_LV = 800008		-- 贵族等级
ItemType.DUNGEON_CLEAR = 800010	-- 地牢布阵

ItemType.VIP_EXP = 900000		-- VIP经验
ItemType.IT_GOLD = 900001		-- 金币
ItemType.IT_GEM = 900002		-- 钻石
ItemType.IT_ROLE_EXP = 900003	-- 角色经验
ItemType.IT_CLAN_EXP = 900004	-- 公会经验
ItemType.IT_HERO_EXP = 900101	-- 英雄经验
ItemType.IT_HERO_UP_STONE = 900102	-- 英雄进阶石
ItemType.IT_TICKET_SMALL = 900201	-- 普通招募券
ItemType.IT_TICKET_HIGH = 900202	-- 高级招募券
ItemType.IT_MAGIC_BUTTER_TICKET = 908201 -- 活动招募券1  魔蝶招募券
ItemType.IT_FRIEND_SHIP_POINT = 900301	-- 友情点数
ItemType.IT_SUMMON_POINT = 900302		-- 召唤点数
ItemType.IT_SUMMON_HERO_PRAYER = 900303 -- 许愿点数
ItemType.IT_PUB_TICKET_SMALL = 900401	-- 酒馆普通任务券（杯装烈酒）
ItemType.IT_PUB_TICKET_HIGH = 900402	-- 酒馆高级任务券（桶装烈酒）
ItemType.IT_RANK_TICKET = 900501		-- 竞技场挑战券
ItemType.IT_PROPHET_BALL = 900601		-- 先知之球
ItemType.IT_PROPHET_PIECE = 900602		-- 先知碎片
ItemType.IT_PROPHET_SHOP = 900603		-- 

ItemType.IT_BLESSING_POOL_SMALL = 900701-- 普通转盘硬币（银色硬币）
ItemType.IT_BLESSING_POOL_HIGH = 900702	-- 高级转盘硬币（金色硬币）
ItemType.IT_BLESSING_POOL_SHOP = 900703 -- 
ItemType.IT_ALTAR_SHOP = 900801
ItemType.IT_PVP_SHOP = 900901			-- PVP商店消耗材料
ItemType.IT_CLAN_UNITY = 901301			-- 公会团结之力
ItemType.IT_ADVENTURE = 901201			-- 试炼之血 勇者之路 
ItemType.IT_FETTER_UNITY = 901501		-- 羁绊之力 羁绊升级材料
ItemType.IT_FETTER_SIGNAL = 901502		-- 同调信号 羁绊突破材料
ItemType.IT_FETTER_STONE = 901503		-- 解放灵石 羁绊技能升级材料
ItemType.IT_FETTER_REFINE = 901504		-- 		   羁绊精炼升级材料
ItemType.IT_TIME_EXCHANGE = 901701		-- 限时兑换物品
ItemType.IT_COLORFUL = 901702		    -- 七彩华章
ItemType.IT_LIMIT_SHOP = 901801		-- 狗鱼
ItemType.IT_FETTERS_SOUL = 901811	-- 羁绊铸魂材料
ItemType.SUPER_SUMMON_WEEK_CARD = 902025	-- 高级召唤周卡
ItemType.SUMMON_WEEK_CARD = 902026	        -- 召唤周卡
ItemType.SPIRIT_WEEK_CARD = 902027	     -- 精灵周卡
ItemType.IT_WEAPON_ESSENCE = 902048	     -- 神兵精华


ItemType.RUNES_1 = 2000001			-- 添加符文
ItemType.RUNES_2 = 2000002			-- 添加符文
ItemType.RUNES_3 = 2000003			-- 添加符文
ItemType.RUNES_4 = 2000004			-- 添加符文
ItemType.RUNES_5 = 2000005			-- 添加符文

-- 元素类型
ElemType = {}
ElemType.ALL 	= 0	-- 全属性
ElemType.FIRE 	= 1	-- 火
ElemType.WATER 	= 2	-- 水
ElemType.FOREST = 3	-- 木
ElemType.LIGHT 	= 4	-- 光
ElemType.SHADOW = 5	-- 暗


EquipPlaceType = {}
EquipPlaceType.WEAPONS = 1		-- 武器
EquipPlaceType.HELMET = 2		-- 头盔
EquipPlaceType.ARMOUR = 3		-- 铠甲
EquipPlaceType.SHOES = 4		-- 鞋子
EquipMaxCount = 4			    -- 装扮栏个数

LineupNum = 8
LineupIdxMax = 9
LineupIdxAssist = 9
LineupSeparation = 10

ClanSkillNumPerStage = 6

LineupType = {}
LineupType.CHAPTER = 0		-- 主线战斗
LineupType.TOWER = 1		-- 幻境之塔布阵
LineupType.DUNGEON = 2		-- 地牢布阵
LineupType.TRIAL = 3		-- 试炼布阵
LineupType.PVP_DEFENSE = 4  -- PVP防守阵容
LineupType.CLAN_MISSION = 5 -- 工会副本
LineupType.CLAN_GVG = 6     -- 工会战
LineupType.CLAN_BOSS = 7    -- 工会BOSS
LineupType.CHAMPIONSHIP = 8    -- 冠军赛布阵
LineupType.CHAMPIONCROSS = 9    -- 周冠军赛布阵
LineupType.ZHU_SHEN_BOSS_1 = 11    -- 猪神之战1，一个活动要4个坑
LineupType.ZHU_SHEN_BOSS_2 = 12    -- 猪神之战2
LineupType.ZHU_SHEN_BOSS_3 = 13    -- 猪神之战3
LineupType.ZHU_SHEN_BOSS_4 = 14    -- 猪神之战4
LineupType.LADDER_ATTACKER = 16    -- 天梯进攻阵型
LineupType.LADDER_DEFENDER = 17    -- 天梯防守阵型
LineupType.RAINBOW_ATTACKER= 18    -- 彩虹圣殿进攻阵型
LineupType.GOD_RELIC       = 19    -- 诸神遗迹
LineupType.TEAM_ARENA      = 20    -- 组队竞技场防守阵型
LineupType.SUPER_STAGE     = 22    -- 超凡段位赛
LineupType.SUPER_STAGE_TOP = 25    -- 超凡段位赛巅峰赛
LineupType.EXOTIC_ADVENTURE_ARMS = 26    -- 异界冒险武器系统
LineupType.EXOTIC_ADVENTURE_POWER = 27    -- 异界冒险动力系统
LineupType.PLANE_WAR_1 = 29     -- 位面之战-元素-1
LineupType.PLANE_WAR_2 = 30     -- 位面之战-元素-2
LineupType.PLANE_WAR_3 = 31     -- 位面之战-元素-3
LineupType.PLANE_WAR_4 = 32     -- 位面之战-元素-4
LineupType.PLANE_WAR_5 = 33     -- 位面之战-元素-5
LineupType.CRUSADE_GROUP_AREA = 34     -- 讨伐团-领地
LineupType.CRUSADE_GROUP_BOSS = 35     -- 讨伐团-boss
LineupType.MAGIC_TOWER = 38
LineupType.ALICE_TEAM_ONE = 39         --爱丽丝阵容1
LineupType.ALICE_TEAM_TWO = 40         --爱丽丝阵容2
LineupType.ALICE_TEAM_THREE = 41       --爱丽丝阵容3

BattleType = {}
BattleType.CHAPTER = 1			  	-- 主线战斗
BattleType.DAILY = 2			  	-- 日常战斗
BattleType.TOWER = 3			  	-- 幻境之塔
BattleType.PVP_DEFENSE = 4  	  	-- PVP防守
BattleType.CLAN_MISSION = 5 	  	-- 工会副本
BattleType.TRIAL = 6			  	-- 勇者试炼
BattleType.DUNGEON = 7    	  		-- 月神
BattleType.CLAN_BOSS = 8     	  	-- 工会BOSS 
BattleType.CLAN_GVG = 9    	  		-- 工会战
BattleType.IDLE = 10    	  		-- 主线挂机
BattleType.CHAMPIONSHIP = 12    	-- 冠军赛布阵
BattleType.COMP = 13    	        -- 切磋
BattleType.LADDER_ATTACKER = 14     -- 天梯进攻战斗
BattleType.LADDER_DEFENDER = 15     -- 天梯防守战斗
BattleType.LADDER_REPORT = 16       -- 天梯录像战斗
BattleType.RAINBOW_ATTACKER = 17    -- 彩虹圣殿进攻战斗
BattleType.RAINBOW_REPORT = 18      -- 彩虹圣殿录像战斗
BattleType.GOD_RELIC = 19           -- 诸神遗迹
BattleType.TEAM_ARENA = 20          -- 组队竞技场
BattleType.CHAMPIONCROSS = 21    	-- 周冠军赛布阵
BattleType.ZHU_SHEN_BOSS_1 = 51    	-- 猪神之战1，一个活动要4个坑
BattleType.ZHU_SHEN_BOSS_2 = 52    	-- 猪神之战2
BattleType.ZHU_SHEN_BOSS_3 = 53    	-- 猪神之战3
BattleType.ZHU_SHEN_BOSS_4 = 54    	-- 猪神之战4
BattleType.SUPER_STAGE = 22    	    -- 超凡段位赛
BattleType.FLOATING_ISLANDS = 23    -- 浮空岛战斗
BattleType.SPACE_TIME_MAGIC_TOWER = 24  -- 时空魔塔
BattleType.SUPER_STAGE_TOP = 25    	    -- 超凡段位赛巅峰赛
BattleType.EXOTIC_ADVENTURE_ARMS = 26   -- 异界冒险武器系统
BattleType.EXOTIC_ADVENTURE_POWER = 27  -- 异界冒险动力系统
BattleType.EXOTIC_ADVENTURE = 28        -- 异界冒险怪物
BattleType.PLANE_WAR_1 = 29             -- 位面之战-元素-1
BattleType.PLANE_WAR_2 = 30             -- 位面之战-元素-2
BattleType.PLANE_WAR_3 = 31             -- 位面之战-元素-3
BattleType.PLANE_WAR_4 = 32             -- 位面之战-元素-4
BattleType.PLANE_WAR_5 = 33             -- 位面之战-元素-5
BattleType.CRUSADE_GROUP_AREA = 34      -- 讨伐团-领地
BattleType.CRUSADE_GROUP_BOSS = 35      -- 讨伐团-boss
BattleType.UNDERWORLD_PAGODA_BOSS = 36  -- 冥域魔都战斗
BattleType.COUNTRY_WAR = 37             -- 国战战斗
BattleType.MAGIC_TOWER = 38             -- 幻魔塔
BattleType.ALICE_TEAM_ONE = 39         --爱丽丝阵容1
BattleType.ALICE_TEAM_TWO = 40         --爱丽丝阵容2
BattleType.ALICE_TEAM_THREE = 41       --爱丽丝阵容3

-- buygem kind 说明
RechargeKindType = {}
RechargeKindType.RECHARGE = 1				-- 购买钻石
RechargeKindType.PROMOTION = 2				-- 成长基金
RechargeKindType.MONTHLY_INVESTMENT = 3		-- 月度投资
RechargeKindType.HERO_UPSTAR = 4			-- 英雄升星礼包
RechargeKindType.WEAK_GIFT = 5				-- 每周福利
RechargeKindType.DAY_LIMIT = 6				-- 每日限购
RechargeKindType.SUPER_GIFT = 7				-- 超值礼包
RechargeKindType.PRIVILEGE_GIFT = 8         -- 特权礼包
RechargeKindType.MOUTH_WELFARE = 9          -- 每月福利
RechargeKindType.DAILY_WELFARE = 10         -- 每日福利
RechargeKindType.NEW_SERVER_LIMIT = 11      -- 新服限购
RechargeKindType.UPGRADE_GIFT = 12          -- 升级礼包
RechargeKindType.LEVEL_GIFT = 13            -- 关卡礼包
RechargeKindType.MID_AUTUMN = 14            -- 中秋礼包
RechargeKindType.HAPPY_MONTH = 15           -- 中秋礼包
RechargeKindType.FASHION_BUY = 18           -- 皮肤购买
RechargeKindType.RECHARGE_FIRST = 19        -- 超值首充
RechargeKindType.LIMIT_BUY = 22             -- 诸神遗迹礼包
RechargeKindType.SUPER_SUMMON_WEEK_CARD = 23-- 超级召唤周卡
RechargeKindType.SUMMON_WEEK_CARD = 24      -- 召唤周卡
RechargeKindType.SUPER_STAGE_TOKEN = 28     -- 超凡段位賽王之戰令
RechargeKindType.SECRET_TREASURE = 30       -- 梦境秘宝
RechargeKindType.SEVEN_ARTIFAC = 31         -- 七神器
RechargeKindType.MAGIC_TOWER_ROAD_KING = 44 -- 幻魔塔斩魔王者


-- 活动界面类型
PromotionPageType = {}
PromotionPageType.RECHARGE = 1	                    -- VIP 充值 每日礼包 特权商城
PromotionPageType.WELFARE = 2	                    -- 签到等福利
PromotionPageType.LIMIT_GIFT = 3                    -- 限时礼包
PromotionPageType.LIMIT_TIME_ACTIVITY = 4           -- 限时活动
PromotionPageType.HAPPY_MONTH_ACTIVITY = 5          -- 狂欢时刻
PromotionPageType.DEVELOP_GIFT = 6                  -- 超值养成
PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY = 7    -- 后台限时活动
PromotionPageType.SECRET_TREASURE_ACTIVITY = 8      -- 梦境秘宝活动
PromotionPageType.SEVEN_ARTIFACT_ACTIVITY = 9       -- 七神器活动
PromotionPageType.LIMIT_SHOP_ACTIVITY = 10          -- 限时商城
PromotionPageType.APPRECIATE_MOON_ACTIVITY = 11     -- 秋赏明月活动
PromotionPageType.HALLOWEEN_ACTIVITY = 12           -- 万圣节活动
PromotionPageType.BLACK_FRIDAY_ACTIVITY = 13        -- 黑色星期五活动
PromotionPageType.BLACK_CHRISTMAS = 14              -- 圣诞节活动
PromotionPageType.BLACK_SPRING = 15                 -- 春日活动
-- 活动项目限制购买期限类型
PromotionBuyLimitDateType = {}
PromotionBuyLimitDateType.NONE = 0          -- 无时间限制
PromotionBuyLimitDateType.DAY = 1           -- 每日
PromotionBuyLimitDateType.WEEK = 2          -- 每周
PromotionBuyLimitDateType.MONTH = 3         -- 每月
PromotionBuyLimitDateType.ALWAYS = 4        -- 终身

-- 活动面板标签idx与配置表对应)
-- 福利与配置表“promotionpage”中的“idx”对应
ActivityPanelIdxType = {}
ActivityPanelIdxType.NULL = 0
ActivityPanelIdxType.WELFARE_SIGN_IN = 1                -- 福利-签到
ActivityPanelIdxType.WELFARE_MONTH_CARD = 2             -- 福利-月卡
ActivityPanelIdxType.WELFARE_MONTH_CARD_SUPER = 3       -- 福利-至尊月卡
ActivityPanelIdxType.WELFARE_WEEK_GIFT = 4              -- 福利-每周礼包
ActivityPanelIdxType.WELFARE_MONTH_GIFT = 5             -- 福利-每月礼包
ActivityPanelIdxType.WELFARE_GROWTH_FUND = 6            -- 福利-成长基金
ActivityPanelIdxType.WELFARE_CONTINUITY_WELFARE = 7    --  福利-连充福利
ActivityPanelIdxType.WELFARE_RECHARGE_DAY_REWARD = 8    -- 福利-积天豪礼
ActivityPanelIdxType.WELFARE_SUPER_HERO = 9             -- 福利-超级英雄
ActivityPanelIdxType.WELFARE_INVITATION = 10            -- 福利-邀请有礼（add 熊梦 原为9，活动表未配置9被占用了）

ActivityPanelIdxType.PRIVILEGE_GROWTH_GIFT = 101        -- 特权-成长礼包
ActivityPanelIdxType.PRIVILEGE_DAILY_GIFT = 102         -- 特权-每日礼包
ActivityPanelIdxType.PRIVILEGE_RECHARGE = 103           -- 特权-充值
ActivityPanelIdxType.PRIVILEGE_PRIVILEGE_GIFT = 104     -- 特权-特权礼包
ActivityPanelIdxType.PRIVILEGE_CLERGY = 105             -- 特权-神职特权

ActivityPanelIdxType.DAILY_FIRST_RECHARGE_ONE = 1       -- 每日首充-第一档
ActivityPanelIdxType.DAILY_FIRST_RECHARGE_TWO = 2       -- 每日首充-第二档

ActivityPanelIdxType.RECHARGE_FIRST_ONE = 1             -- 超级首充-第一档
ActivityPanelIdxType.RECHARGE_FIRST_TWO = 2             -- 超级首充-第二档

ActivityPanelIdxType.DEVELOP_GIFT_HERO = 601            -- 超值养成-英雄多多
ActivityPanelIdxType.DEVELOP_GIFT_GOLD = 602            -- 超值养成-金币多多
ActivityPanelIdxType.DEVELOP_GIFT_FETTER = 603          -- 超值养成-羁绊多多

ActivityPanelIdxType.BUY_FASHION = 701                  -- 后台限时活动-购买皮肤
ActivityPanelIdxType.BUY_DRAGONBOAT = 707               -- 后台限时活动-端午活动
ActivityPanelIdxType.BUY_SUPER_GIFT = 402               -- 后台限时活动-超值礼包
ActivityPanelIdxType.BUY_DAILY_RECHARGE_GIFT = 401      -- 后台限时活动-每日累储



ActivityPanelIdxType.SMITH_SHOP = 10                    -- 铁匠铺-装备锻造
ActivityPanelIdxType.SMITH_SHOP_SPRITE = 20             -- 铁匠铺-精灵合成
ActivityPanelIdxType.SMITH_SHOP_GEM = 30                -- 铁匠铺-宝石合成
ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP = 40          -- 铁匠铺-神装升星
ActivityPanelIdxType.SMITH_SHOP_RING = 50               -- 铁匠铺-神装升星


ActivityPanelIdxType.ALTAR_SACRIFICE = 10               -- 祭坛-献祭
ActivityPanelIdxType.ALTAR_RESET = 20                   -- 祭坛-重生

-- 组队竞技场组队大厅页面类型
TeamArenaTeamPanelIdxType = {}
TeamArenaTeamPanelIdxType.NULL = 0                      -- 无
TeamArenaTeamPanelIdxType.TEAM = 1                      -- 组队界面
TeamArenaTeamPanelIdxType.RECV_INVITE = 2               -- 收到邀请界面
TeamArenaTeamPanelIdxType.MY_TEAM = 3                   -- 我的队伍

-- 组队竞技场添加玩家界面页面类型
TeamArenaTeamAddPanelIdxType = {}
TeamArenaTeamAddPanelIdxType.NULL = 0                   -- 无
TeamArenaTeamAddPanelIdxType.REQUEST_LIST = 1           -- 申请列表
TeamArenaTeamAddPanelIdxType.INVITE_PLAYER = 2          -- 邀请玩家


BattleStatuType = {}
BattleStatuType.BST_READY = 0
BattleStatuType.BST_READYING = 1
BattleStatuType.BST_BATTLE = 2
BattleStatuType.BST_END = 3

SEVENT_DAY_TARGET_TYPE = {}
SEVENT_DAY_TARGET_TYPE.TASK = 1		--任务
SEVENT_DAY_TARGET_TYPE.BUY = 2		--购买


PUN_TASK_NAME_BEGIN = 44000

WEATHER_TYPE = {}
WEATHER_TYPE.NIL = 0        -- 无天气
WEATHER_TYPE.THUNDER = 1    -- 雷暴
WEATHER_TYPE.RAIN = 2       -- 雨天
WEATHER_TYPE.SAND = 3       -- 沙暴

TRIAL_TYPE = {}
TRIAL_TYPE.BTN = 1		--关卡按钮
TRIAL_TYPE.BOX = 2		--箱子

TRIAL_BOX = {}
TRIAL_BOX.CAN_GET = 0	--可领取
TRIAL_BOX.GET = 1		--已领取

JUMP_TYPE = {}				--跳转类型
JUMP_TYPE.ACHIEVEMENT 		 = 1	--成就
JUMP_TYPE.DAILY 	 		 = 2	--日常
JUMP_TYPE.SEVENT_DAY_TARGET  = 3	--七天目标

-- 英雄避难所事件类型
DUNGEON_EVENT_TYPE = {}
DUNGEON_EVENT_TYPE.GOLD 	= 101	-- 金币堆
DUNGEON_EVENT_TYPE.STONE 	= 102	-- 石堆
DUNGEON_EVENT_TYPE.FREE_BOX_1   = 103	-- 免费宝箱1
DUNGEON_EVENT_TYPE.KEY 		= 104	-- 宝箱钥匙
DUNGEON_EVENT_TYPE.KEY_BOX 	= 105	-- 钥匙宝箱
DUNGEON_EVENT_TYPE.BUFF 	= 106	-- buff
DUNGEON_EVENT_TYPE.POTION_1 	= 107	-- 药剂道具1
DUNGEON_EVENT_TYPE.SHOP 	= 108	-- 商店事件
DUNGEON_EVENT_TYPE.SHOP_ADD = 109	-- 商品增加道具
DUNGEON_EVENT_TYPE.FREE_BOX_2   = 110	-- 免费宝箱2
DUNGEON_EVENT_TYPE.FREE_BOX_3   = 111	-- 免费宝箱3
DUNGEON_EVENT_TYPE.FREE_BOX_4   = 112	-- 免费宝箱4
DUNGEON_EVENT_TYPE.FREE_BOX_5   = 113	-- 免费宝箱5
DUNGEON_EVENT_TYPE.FREE_BOX_6   = 114	-- 免费宝箱6
DUNGEON_EVENT_TYPE.POTION_2 = 115	-- 药剂道具2


-- 新手指引序号 100为已经布阵战斗阵型
SHOP_TYPE = {}
SHOP_TYPE.MARKET    = 100100	--	市场
SHOP_TYPE.WISHPOOL  = 100200	--	许愿池
SHOP_TYPE.PROPHECY  = 100300	--	先知
SHOP_TYPE.SACRIFICE = 100400	--	祭坛
SHOP_TYPE.PVPNORMAL = 100500	--	竞技场 
SHOP_TYPE.CLAN      = 100600	--	工会 
SHOP_TYPE.ADVENTURE = 100700	--	试炼 
SHOP_TYPE.STALL     = 100800	--	黑市
SHOP_TYPE.PROMOTION = 100900	--	秘境
SHOP_TYPE.CLAN_BOSS = 101100    --	公会Boss战商店
SHOP_TYPE.HERO      = 101000	--	英雄商店
SHOP_TYPE.LADDER    = 101200    --  天梯积分
SHOP_TYPE.FRAGMENT  = 101300    --  碎片商店
SHOP_TYPE.TALENT    = 101400    --  英雄天赋商店
SHOP_TYPE.FASHION   = 101500    --  英雄皮肤商店
SHOP_TYPE.GOD_EQUIP = 101600    --  神装商店
SHOP_TYPE.CHAMPION  = 101700    --  冠军商店
SHOP_TYPE.TEAMARENA = 101800    --  组对竞技场
SHOP_TYPE.SUPERHERO = 101900    --  超级英雄商店
SHOP_TYPE.DAY       = 102000    --  隐藏商城(每日刷新限制)
SHOP_TYPE.SUPERSTAGE= 102100    --  超凡段位賽
SHOP_TYPE.FLOATING_ISLANDS= 102200          --  浮空岛
SHOP_TYPE.SPACE_TIME_MAGIC_TOWER = 102300   --  浮空岛
SHOP_TYPE.SHEN_YU = 102400      --  神谕
SHOP_TYPE.EXOTIC_ADVENTURE = 102500 --  异界冒险
SHOP_TYPE.CHRISTMAS = 102600        --  圣诞活动
SHOP_TYPE.SPRING = 102700           --  春日活动
SHOP_TYPE.COUNTRY_WAR_RANDOM_SHOP = 102900  --  国战随机商城
SHOP_TYPE.COUNTRY_WAR_SHOP = 102800         --  国战军工商城
SHOP_TYPE.MAGIC_TOWER_DAILY_SHOP = 102900   --  幻魔塔每日商城
SHOP_TYPE.MAGIC_TOWER_LIFE_SHOP = 103000    --  幻魔塔終身商城
SHOP_TYPE.ALICE_SHOP = 103100   --  爱丽丝商城


SHOP_TYPE.ORDER = 999999	    --	其他

FUNCTION_OPEN_TYPE = {}
FUNCTION_OPEN_TYPE.DEFAULT_OPEN = 0             -- 默认开启
FUNCTION_OPEN_TYPE.COND_NOTICE_SHOW = 1         -- 条件开启(升级预公告，预显示)
FUNCTION_OPEN_TYPE.NOT_OPEN = 2                 -- 未开放
FUNCTION_OPEN_TYPE.COND_NOTICE_NO_SHOW = 3      -- 条件开放(升级预公告，不预显示)
FUNCTION_OPEN_TYPE.COND_NO_NOTICE_SHOW = 4      -- 条件开放(升级不预公告,预显示)
FUNCTION_OPEN_TYPE.COND_NO_NOTICE_NO_SHOW = 5   -- 条件开放(升级不预公告,不预显示)

TIME = {}
TIME.MINUTE = 60        -- 分
TIME.HOUR = 60*60       -- 小时
TIME.DAY = 60*60*24     -- 天
TIME.WEEK = 60*60*24*7  -- 周

FRIEND_LAYER_TYPE = {}
FRIEND_LAYER_TYPE.FRIEND_LIST = 1
FRIEND_LAYER_TYPE.GIFT_LIST = 2
FRIEND_LAYER_TYPE.REQUEST_LIST = 3
FRIEND_LAYER_TYPE.BLACK_LIST = 4

GEM_PROPERTY_TYPE = {}
GEM_PROPERTY_TYPE.UNDEFINED = 0                 -- 未定义属性
GEM_PROPERTY_TYPE.ATTACK = 1                    -- 攻击属性
GEM_PROPERTY_TYPE.BLOOD = 2                     -- 生命属性
GEM_PROPERTY_TYPE.SPEED = 3                     -- 速度属性

-- 神装星级分级
GOD_EQUIP_STAR_GRADE = {
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
}
-- 神装品质分级
GOD_EQUIP_RARE_GRADE = {
    PuTong = 2,         -- 普通
    JiPin = 3,          -- 极品
    XiYou = 4           -- 稀有
}

-- 品质颜色
COLOR_RARE = {}
COLOR_RARE[1] = cc.c3b(120,236,131)
COLOR_RARE[2] = cc.c3b(86,207,247)
COLOR_RARE[3] = cc.c3b(236,80,255)
COLOR_RARE[4] = cc.c3b(255,146,62)
COLOR_RARE[5] = cc.c3b(255,99,68)
COLOR_RARE[6] = cc.c3b(255,238,99)

-- 圣物品质颜色
COLOR_RARE_HALLOWS = {}
COLOR_RARE_HALLOWS[1] = cc.c3b(120,236,131)
COLOR_RARE_HALLOWS[2] = cc.c3b(4,149,196)
COLOR_RARE_HALLOWS[3] = cc.c3b(170,77,187)
COLOR_RARE_HALLOWS[4] = cc.c3b(255,146,62)
COLOR_RARE_HALLOWS[5] = cc.c3b(255,99,68)
COLOR_RARE_HALLOWS[6] = cc.c3b(229,143,27)

PLATFORM_CHANNEL_ID = cpp.SocialPlatform:instance():getChannelId()
PLATFORM_PF_ID = cpp.SocialPlatform:instance():getPfId()

PLATFORM_LIMIT = {}
PLATFORM_LIMIT.IS_LINEUP_LIMIT = (PLATFORM_CHANNEL_ID == "1" and PLATFORM_PF_ID == "100001") and true or nil

-- 神职特权
CLERGY_PRIVILEGE_TYPE = {
    GOLD_MISSION = "GOLD_DUNGEON",          -- 金币副本
    PVP = "PVP",                            -- 竞技场
    EXP_MISSION = "EXP_DUNGEON",			-- 经验副本
    HERO_MISSION = "HERO_DUNGEON",          -- 英雄副本
    FETTER_MISSION = "FETTER_DUNGEON",      -- 羁绊副本
    IDLE_AWARD = "IDLE_AWARD",              -- 主线挂机
    POINT_SUMMON = "POINT_SUMMON",          -- 积分召唤  
    STALL_SHOP = "STALL_SHOP",              -- 黑市
    RUNE_MISSION = "RUNE_DUNGEON",          -- 精灵副本
}

-- 讨伐团英雄item类型
CRUSADE_GROUP_HERO_ITEM_TYPE = {
    SET_OFF = "SET_OFF", -- 出征英雄
    SET_OFF_SELECT = "SET_OFF_SELECT", -- 出征选择英雄
    UNLOAD = "UNLOAD",  -- 卸下英雄,
    BATTLE = "BATTLE"   -- 战斗选择英雄,
}

TMXMap = {}
TMXMap.TileLayer = 1
TMXMap.BuildingLayer = 10000
TMXMap.UILayer = 1000000

TMXMapLightData = {
    [1] = {r=0, img=2, fx=false, fy=false, a=cc.p(1, 0)},
    [2] = {r=0, img=2, fx=true, fy=false, a=cc.p(0, 0)},
    [3] = {r=0,img=1, fx=false, fy=false,a=cc.p(1, 0.5) },
    [4] = {r=180,img=1, fx=false, fy=false, a=cc.p(1, 0.5) },
    [5] = {r=0, img=2, fx=false, fy=true, a=cc.p(1, 1)},
    [6] = {r=0, img=2, fx=true, fy=true, a=cc.p(0, 1)},
}

-- 讨伐团活动阶段
CRUSADE_GROUP_STATE = {
    NONE = 0, -- 未开启
    SIGN_UP = 1, -- 报名中
    SIGN_UP_END = 2, -- 报名结束
    BATTLE_START = 3, -- 战斗开始
    BATTLE_END = 4, -- 战斗结束
    SETTLE = 5, -- 结算
    CLOSE = 6 -- 结束
}

-- 国战活动阶段
COUNTRY_WAR_STATE = {
    NONE = 1,   -- 未开启
    BATTLE = 2, -- 交战中
    CLOSE = 3   -- 结束
}


UILayout = {}
UILayout.Type = {}
UILayout.Type.NONE = 0
UILayout.Type.HORIZONTAL = 1
UILayout.Type.VERTICAL = 2
UILayout.Type.GRID = 3

UILayout.ResizeMode = {}
UILayout.ResizeMode.NONE = 0
UILayout.ResizeMode.CONTAINER = 1
UILayout.ResizeMode.CHILDREN = 2

UILayout.Direction = {}
UILayout.Direction.LTOR = 1
UILayout.Direction.RTOL = 2
UILayout.Direction.BTOT = 3
UILayout.Direction.TTOB = 4

UILayout.AxisDirection = {}
UILayout.AxisDirection.HORIZONTAL = 0
UILayout.AxisDirection.VERTICAL = 1

