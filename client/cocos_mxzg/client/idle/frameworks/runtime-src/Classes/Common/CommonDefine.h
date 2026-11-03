//
//  CommonDefine.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __________________AVT_CommonDefine_h_______________
#define __________________AVT_CommonDefine_h_______________

#ifdef WIN32
#include <stdio.h>

#include <WinSock2.h>
#include <ws2tcpip.h>
#include <mstcpip.h>
#include <mswsock.h>
#include <Windows.h>

#else
#include <stdint.h>
#endif

#include <vector>
#include <list>
#include <string>
#include <queue>
#include <map>
#include <algorithm>
#include <cmath>

#include "cocos2d.h"
//#include "cocos-ext.h"
#include "cocos-ext.h"
#include "../lib_json/json_lib.h"

using namespace std;

using namespace cocos2d::ui;

USING_NS_CC;
USING_NS_CC_EXT;

#ifdef WIN32
typedef __int64                     t_int64;
#else
typedef long long                   t_int64;
#endif
typedef unsigned long long          t_uint64;

typedef wchar_t						t_wchar;

typedef char						t_byte;
typedef unsigned char				t_ubyte;

typedef short						t_int16;
typedef unsigned short				t_uint16;

typedef int							t_int32;
typedef unsigned int				t_uint32;

typedef long						t_long;
typedef unsigned long				t_ulong;

typedef void						t_void;

typedef float						t_real32;
typedef double						t_real64;

typedef bool						t_bool;



#pragma mark --------宏---------
#define D_TRUE true
#define D_FALSE false

#define NAME_LENGTH 25
#define CHAT_LENGTH 200
#define PASSCODE_LENGTH 7

#define CLAN_DESC_LENGTH 300

#define SERVER_NAME_LENGTH 31

#define SEARCH_NAME_LENGTH 61

// 战斗的角色昵称，昵称后要加服务器名，所以名字长度加长
#define BATTLE_NAME_LENGTH 61

#define BATTLE_KEY_LENGTH 33

//#if (PLATFORM_TYPE == 2)
//#define FONT_DEFAULT_NAME "Daum_Regular"
//#define FONT_DEFAULT_NAME_BOLD "Daum_SemiBold"

//#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
////#define FONT_DEFAULT_NAME "DroidSans"
////#define FONT_DEFAULT_NAME_BOLD "DroidSans-Bold"
//#define FONT_DEFAULT_NAME "font/HYZhongJianHeiJ.ttf"
//#define FONT_DEFAULT_NAME_BOLD "font/FZCSJW--GB1-0.ttf"
//
//#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
////#define FONT_DEFAULT_NAME "Helvetica"
////#define FONT_DEFAULT_NAME_BOLD "Helvetica-Bold"
//
//#define FONT_DEFAULT_NAME "font/HYZhongJianHeiJ.ttf"
//#define FONT_DEFAULT_NAME_BOLD "font/FZCSJW--GB1-0.ttf"
//
//#else
//#define FONT_DEFAULT_NAME "font/HYZhongJianHeiJ.ttf"
//#define FONT_DEFAULT_NAME_BOLD "font/FZCSJW--GB1-0.ttf"
//
//#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */

#define FONT_DEFAULT_NAME "font/HYZhongJianHeiJ.ttf"
#define FONT_DEFAULT_NAME_BOLD "font/STZhongsong.ttf"


#define FONT_DEFAULT_SIZE 16
#define FONT_DEFAULT_STROKE_WEIGHT 0.8

// 请求军团派兵冷却时间:20分钟   ---->   1200秒
#define TROOPS_TIME  1200

// 排行榜对应面板数据的延迟时间
#define RANK_DELAY_TIME 30

// 按钮再次接受响应的间隔时间:500毫秒
#define BTNCLICK_DELAY_TIME 500

// UIMenu、UIControlButton允许的移动距离
#define UI_ENABLE_MOVE_DISTANCE 5

// 军团聊天中观看分享视频的时间上限:3天
#define MAX_REPLAY_TIME 259200

/**添加CCNode的非空节点*/
#define ADD_NON_NULL_CHILD(p , zOrder , tag) if(p) this->addChild(p , zOrder , tag)

// 好友总数量限制值
#define FRIEND_MAX 50

// 限制聊天显示数量
#define GLOBALCHAT_MAX 50
#define CLANCHAT_MAX 50

#define MONEY_SHORT_UNIT 10000

#define EMPTY_TEXT "--"

#define SPLIT_CHAR "◆"

#define BEHAVIOR_DEBUG 0

#define LUA_SUFFIX ".lua"

#define FONT_BLUE  			Color3B(180, 218, 236)
#define FONT_LIGHT_BLUE 	Color3B(222, 244, 255)
#define FONT_RED			Color3B(178, 59, 63)
#define FONT_YELLOW			Color3B(241, 227, 133)
#define FONT_LIGHT_YELLOW	Color3B(255, 237, 193)
#define TIPS_BLUE   		Color3B(46, 167, 218)
#define TIPS_RED    		Color3B(218, 70, 46)

#define DEVICE_ORIENTATION_CHANGE "DeviceOrientationChange"

#pragma mark --------设备相关枚举---------
// 设备类型
typedef enum {
    DEVICE_INVALID = 0, // 1.33333
    DEVICE_IPAD_HD, // ipad3, ipad4  1.33333
    DEVICE_IPAD, // ipad2, ipad mini 1.33333
    DEVICE_IPHONE_3, // iphone3gs 1.5
    DEVICE_IPHONE_4, // iphone4 1.5
    DEVICE_IPHONE_5, // iphone5 1.775
    DEVICE_IPHONE_6, // iphone6 1.77867
    DEVICE_IPHONE_6_PLUS, // iphone6plus 1.77778
    DEVICE_800_480, // 1.66667
    DEVICE_854_480, // 1.779
    DEVICE_960_540, // 1.77778
    DEVICE_1280_720, // 1.77778
    DEVICE_1280_768, // 1.66667
    DEVICE_1280_800, // 1.6
    DEVICE_1800_1080, // 1.66667
    DEVICE_1920_1080, // 1.77778
    DEVICE_1920_1152, // 1.66667 MX4
    DEVICE_1920_1200, // 1.6
    DEVICE_2560_1440, // 1.77778
    DEVICE_2560_1600  // 1.6
} DeviceType;

// 设备宽高比
typedef enum {
    D_WTH_133 = 133, // ipad
    D_WTH_150 = 150, // iphone4 4s 魅族mx2
    D_WTH_178 = 178, // iphone5，新安卓手机，iphone6
    D_WTH_167 = 167, // 一般是老安卓手机，老安卓平板，魅族mx3
    D_WTH_160 = 160, // 一般是新安卓平板
} DeviceWidthToHeight;

typedef enum {
    DeviceOrientationUnkown = 0,
    DeviceOrientationPortrait = 1,           // 竖向，home键向下
    DeviceOrientationPortraitUpsideDown = 2, // 竖向，home键向上
    DeviceOrientationLandscapeLeft = 3,      // 横向，home键向右
    DeviceOrientationLandscapeRight = 4,     // 横向，home键向左
} DeviceOrientation;


// 服务器数据源
class ServerCellData
{
public:
    short id;       //服务器id
    string name;    //服务器name
    bool role;      //该服是否已创建角色
    short status;   //服务器状态：四种状态 1空闲；2正常；3爆满；4维护
    bool is_new;    // 是否为新服
    bool is_update; // 改服是否处于维护状态
    string url;
    
    ServerCellData() {
        id = 0;
        name = "";
        role = false;
        is_new = false;
        is_update = false;
        status = 2;
    }
};

#pragma mark --------英雄相关枚举---------
// 作操作状态枚举
typedef enum {
    AT_STAND = 0,   // 待机
    AT_MOVE = 1,    // 移动
    AT_ATTACK = 2,  // 攻击
    AT_SKILL = 3,   // 技能
    AT_MOVE_STAND = 4, // 移动后待机
} ActionType;

typedef enum {
    BHS_STAND = 0,      // 原始待机
    BHS_MOVE_END = 1,   // 移动结束
    BHS_ACTION_END,     // 释放技能或普攻
    BHS_STANDBY,        // 手动待机
} BattleHeroStatue;


enum HeroAttackType {
    HAT_NULL = 0,           // default
    HAT_ATTACK      = 1,    // 自动攻击
};


enum HeroClassType {
    HCT_SOLDIER         = 1,    // 战士
    HCT_MAGE            = 2,    // 法师
    HCT_SUPPORT         = 3,    // 辅助
};


// 能力数据
enum AbilityType {
    AT_INVALID                     = 0,         // 初始值
    
    // 基础数值
    AT_REPLENISH_BASE              = 100,       // 基础治疗效果。100%。治疗数值就是攻击力数值
    AT_SPEED_BASE                  = 101,       // 速度固定数值
    AT_HP_MAX_BASE                 = 102,       // 提升最大生命值
    AT_SKILL_DAMAGE                = 110,       // 技能基本伤害
    
    // 技能相关属性
    AT_SKILL_UP                    = 200,       // 技能伤害提升
    AT_ATTACK_UP                   = 201,       // 攻击提升%
    AT_DEFENSE_UP                  = 202,       // 防御提升%
    AT_DEFENSE_IGNORE_UP           = 203,       // 无视防御
    AT_SPEED_UP                    = 204,       // 速度提升()
    AT_REPLENISH_UP                = 205,       // 治疗效果提升
    AT_BEREPLENISH_UP              = 206,       // 被治疗效果提升
    AT_CRITICAL_UP                 = 207,       // 暴击提升
    AT_BECRITICAL_UP               = 208,       // 被暴击提升
    AT_DODGE                       = 210,       // 格挡几率提升
    AT_HIT_RATE                    = 211,       // 精准提升
    AT_EXEMPTION_CONFINED          = 212,       // 免除控制的几率
    AT_EXEMPTION_SILENCE           = 213,       // 沉默抵抗
    AT_EXEMPTION_DISARM            = 214,       // 缴械抵抗
    AT_EXEMPTION_IMMOBILIZ         = 215,       // 定身抵抗
    AT_EXEMPTION_FROZEN            = 216,       // 冰冻抵抗
    AT_EXEMPTION_DIZZY             = 217,       // 眩晕抵抗
    AT_EXEMPTION_PETRIFY           = 218,       // 石化抵抗
    AT_EXEMPTION_IGNORE            = 219,       // 无视控制抵抗
    
    AT_ATTACK_ADD                  = 220,       // 攻击增加固定
    AT_DAMAGE_UP                   = 221,       // 伤害提升
    AT_DAMAGE_CRITICAL_UP          = 222,       // 暴击伤害提升
    AT_HP_ADD                      = 223,       // 血量固定数值增加
    AT_DEFENSE_ADD                 = 224,       // 护甲固定数值增加
    AT_DAMAGE_HOLY                 = 225,       // 神圣伤害增加
    AT_SKILL_ADD                   = 226,       // 技能固定伤害增加
    AT_DEFENSE_IGNORE              = 227,       // 无视所有防御


    AT_DAMAGE_WEAK                 = 230,       // 虚弱提升

    AT_DAMAGE_FIRE                 = 251,       // 火的伤害提升
    AT_DAMAGE_FOREST               = 252,       // 森林的伤害提升
    AT_DAMAGE_WATER                = 253,       // 水的伤害提升
    AT_DAMAGE_LIGHT                = 254,       // 光的伤害提升
    AT_DAMAGE_SHADOW               = 255,       // 暗的伤害提升
    
    AT_DAMAGE_SILENCE              = 260,       // 对沉默目标伤害加成
    AT_DAMAGE_DISARM               = 261,       // 对缴械目标伤害加成
    AT_DAMAGE_IMMOBILIZ            = 262,       // 对定身目标伤害加成
    AT_DAMAGE_FROZEN               = 263,       // 对冰冻目标伤害加成
    AT_DAMAGE_DIZZY                = 264,       // 对眩晕目标伤害加成
    AT_DAMAGE_PETRIFY              = 265,       // 对石化目标伤害加成
    AT_DAMAGE_FEAR                 = 266,       // 对恐惧目标伤害加成
    
    
    AT_DAMAGE_RESULT_UP            = 270,       // 最终伤害结果增加
    
    // 未添加
    AT_DAMAGE_FIGHTER              = 281,       // 对战士伤害加成
    AT_DAMAGE_MAGE                 = 282,       // 对法师伤害加成
    AT_DAMAGE_PRISET               = 283,       // 对牧师伤害加成
    AT_DAMAGE_ASSASSIN             = 284,       // 对刺客伤害加成
    AT_DAMAGE_RANGER               = 285,       // 对游侠伤害加成
    
    AT_DAMAGE_REDUCTION            = 291,       // 伤害减免

    
    AT_DAMAGE_BURN                 = 301,       // 对灼烧目标伤害增加
    AT_DAMAGE_FROST                = 302,       // 对霜冻目标伤害增加
    AT_DAMAGE_POISONE              = 303,       // 对中毒目标伤害增加
    AT_DAMAGE_ELECTRICITY          = 304,       // 对感电目标伤害增加
    AT_DAMAGE_BLEED                = 305,       // 对流血目标伤害增加
    
    AT_EXEMPTION_BURN              = 321,       // 灼烧抵抗
    AT_EXEMPTION_FROST             = 322,       // 霜冻抵抗
    AT_EXEMPTION_POISONE           = 323,       // 中毒抵抗
    AT_EXEMPTION_ELECTRICITY       = 324,       // 感电抵抗
    AT_EXEMPTION_BLEED             = 325,       // 流血抵抗
    
};

// 英雄元素类型
enum HeroElemType {
    FIRE                = 1,    // 火
    WATER               = 2,    // 水
    FOREST              = 3,    // 木
    LIGHT               = 4,    // 光
    SHADOW              = 5,    // 暗
};

// 英雄职业类型
enum HeroOccupationType {
    HOT_FIGHTER = 1,            // 战士
    HOT_MAGE    = 2,            // 法师
    HOT_PRISET  = 3,            // 牧师
    HOT_ASSASSIN= 4,            // 刺客
    HOT_RANGER  = 5,            // 游侠
};

enum BuffType {
    BT_INVALID               = 0,    // 初始值
    /*
     *  技能动画
     *  如果当前buff_type < 100 的动画还在执行的话，则一直等待动画执行完毕
     *  技能从左往右  flipped_x = false
     *  锚点左下角为0，0
     */
    BT_AMIN                  = 1,    // 动画，单纯的一个动画
    BT_ATTACK_NEAR           = 2,    // 近身攻击
    BT_ATTACK_RANGE          = 3,    // 远程攻击
    BT_SITU                  = 4,    // 原地动画
    BT_THREW                 = 5,    // 投掷动画
    BT_ATTACK_EFFECT1        = 6,    // 在英雄位置播放特效
    BT_ATTACK_EFFECT2        = 7,    // 在目标位置播放特效
    BT_ATTACK_EFFECT3        = 8,    // 移动到地图任意位置停留一段时间并执行攻击动作
    BT_ATTACK_EFFECT4        = 9,    // 在指定位置释放特效
    BT_ATTACK_EFFECT5        = 10,   // 投掷到指定位置
    BT_ATTACK_EFFECT6        = 11,   // 移动到目标前面。执行多次攻击动画

    BT_DAMAGE                = 100,  // 造成自身攻击力的伤害
    BT_DAMAGE_TARGET         = 101,  // 造成目标攻击力的伤害
    BT_DAMAGE_HP_MAX         = 102,  // 造成目标血量最大值的伤害
    BT_DAMAGE_ATTACH         = 103,  // 造成自身攻击力的伤害，并对指定类目标造成特殊伤害
    BT_DAMAGE_IGNORE         = 104,  // 造成无视防御的攻击
    
    BT_REPLENISH_HP          = 130,  // 恢复生命值
    BT_REPLENISH_HP_MAXIMUM  = 131,  // 恢复最大生命值
    BT_REPLENISH_HP_DAMAGE   = 132,  // 恢复伤害值的百分比

    BT_REBORN                = 150,  // 重生
    BT_ABILITY_ADD           = 160,  // 修改玩家属性值,增加数值
    BT_ABILITY_SET           = 161,  // 修改玩家属性值,修改数值
    BT_COMMON_CHANGE         = 162,  // 修改普通技能类型
    BT_HP_MAX_CHANGE         = 163,  // 更新角色的最大生命值
    BT_ANGER_ADD             = 164,  // 增加攻击能量
    BT_ATTACK_STEAL          = 166,  // 攻击力偷取
    
    
    BT_BEATTACK              = 170,  // 被攻击时触发art
    BT_BEATTACK_BACK         = 171,  // 被攻击时触发art,目标为攻击者
    BT_USE_ATTACK            = 172,  // 使用普通攻击时触发art
    BT_USE_SKILL             = 173,  // 使用技能时触发art
    BT_CRITICAL              = 174,  // 暴击时触发
    BT_BECRITICAL            = 175,  // 被暴击时触发
    BT_BEDAMAGE_HP_STAGE     = 176,  // 按照伤害百分比触发多少层buff
    BT_BEDAMAGE_HP_MAXIMUM   = 177,  // 被攻击时。生命值低于%时触发
    BT_BEATTACK_ATTACK       = 178,  // 被普通攻击了
    BT_BEATTACK_SKILL        = 179,  // 被技能攻击了
    BT_DEATH                 = 180,  // 死亡时触发
    BT_ATTACK_SELF           = 181,  // 普通攻击造成伤害了
    BT_ATTACK_SKILL_SELF     = 182,  // 技能攻击造成伤害了
    
    BT_ROUND                 = 200,  // 回合buff
    BT_ROUND_START           = 201,  // 目标回合开始的时候触发
    BT_ROUND_END             = 202,  // 目标回合结束的时候触发
    
    BT_USE_LIMIT             = 210,  // 限定使用次数buff
    BT_TARGET_SELECT         = 211,  // 目标选择buff，简化buff逻辑
    BT_CLASS_SELECT          = 212,  // 指定职业才会生效的buff
    BT_POS_SELECT            = 213,  // 指定位置才会生效的buff
    
    BT_SELECT_HP_COMP        = 220,  // 根据血量附加buff，血量大于自身，血量小于自身
    
    BT_POLL                  = 300,   // 对逐个目标释放技能
    BT_LOOP                  = 301,   // 对指定目标执行多次技能
    
    BT_INDEPENDENT           = 1000,  // 独立概率，每个目标都独立计算触发概率
    BT_SILENCE               = 1001,  // 沉默，无法使用技能
    BT_DISARM                = 1002,  // 缴械，无法普通攻击
    BT_IMMOBILIZ             = 1003,  // 定身，无法使用攻击和技能
    BT_FROZEN                = 1004,  // 冰冻，无法使用攻击和技能
    BT_DIZZY                 = 1005,  // 眩晕，无法使用攻击和技能
    BT_PETRIFY               = 1006,  // 石化，无法使用攻击和技能
    BT_FEAR                  = 1007,  // 恐惧，无法使用攻击

    BT_REMOVE_ALL            = 1100,  // 移除所有对目标生效的buff
    BT_REMOVE_CONTROL        = 1101,  // 移除所有控制技能
    BT_REMOVE_BUFF           = 1102,  // 移除debug
    
    // 特殊标记
    BT_BURN                  = 1201,  // 灼烧
    BT_FROST                 = 1202,  // 霜冻
    BT_POISONE               = 1203,  // 中毒
    BT_ELECTRICITY           = 1204,  // 感电
    BT_BLEED                 = 1205,  // 流血
    
    // 反击之类的东西
    BT_ACTION_ATTACK         = 1301,  // 使用一次普通攻击
    BT_ACTION_SKILL          = 1302,  // 使用一次技能攻击
    
//    frost
    BT_MUSIC                 = 2000,  // 播放一个音效
    
    // 暂时废弃
//    BT_AMIN_FROZEN           = 2001,  // 冰冻动画
//    BT_AMIN_DIZZY            = 2002,  // 眩晕动画
//    BT_AMIN_PETRIFY          = 2003,  // 石化
    
    // 目标选择buff，value0: target生效的buff  value1: caster生效的buff
    // 职业筛选buff，value0：target为指定职业时才会触发buff
    // 位置筛选buff，value[] 中包含指定位置时才会触发buff
    // buff筛选buff，value0: 暂时无法实现
};

enum BuffDamageType {
    BDT_NORMAL      = 0,         // 普通伤害
    BDT_DEBUFF      = 10,        // debuf造成的伤害
};

enum BuffEffectType {
    BET_NORMAL      = 0,        // 普通buff
    BET_DEBUFF      = 100,      // 负面buff
    BET_CONTROL     = 200,      // 控制技能
};

//BT_AMIN_CONFLICT_BEGIN   = 2000,  // 人物冲突动画开始（只是标记冲突）
//BT_AMIN_CONFLICT_END =   = 2099,  // 人物冲突动画结束（只是标记冲突）

enum SkillTargetType {
    STT_INVALID              = -1,   // 初始值
    STT_REMOVE_SELF          = 0,    // 移除自己（筛选）
    STT_SELF                 = 1,    // 自己（筛选）
    STT_FRIEND               = 2,    // 友方（加法）
    STT_ENEMY                = 3,    // 敌人（加法）
    STT_ALIVE                = 4,    // 存活（筛选）
    STT_DEAD                 = 5,    // 死亡（筛选）
    STT_FRONT                = 6,    // 前排（筛选）（只选择存活目标）
    STT_REAR                 = 7,    // 后排（筛选）（只选择存活目标）
    STT_RAND                 = 8,    // 随机（筛选）(target_num)
    STT_HP_POSITIVE          = 9,    // 血量正序（多）(target_num)
    STT_POS                  = 10,   // 位置（筛选）(target_num)
    STT_HP_REVERSE           = 11,   // 血量倒序（少）(target_num)
    STT_TEAM                 = 12,   // 队友
};

enum DamageType {
    
};


enum MSLBattleType {
    MSLBT_MAIN_BATTLE = 0,      // 主场景挂机
    MSLBT_MAIN_MISSION_BATTLE,  // 挑战主线
};

enum BattleStatuType {
    BST_READY = 0,              // 准备战斗
    BST_READYING = 1,               // 准备战斗中
    BST_BATTLE = 2,                 // 战斗中
    BST_END = 3,                    // 战斗结束
    BST_REMOVE = 4,                 // 移除。战斗场景的定时器有时会移除不了
};

#pragma mark --------资源相关枚举---------
// 资源类型的名称ID
typedef enum {
    RESOURCE_INVALID    = 0,
    RESOURCE_GOLD       = 1,    // 金币
    RESOURCE_GEM        = 2,    // 钻石
    RESOURCE_ENERGY     = 3,    // 体力
    RESOURCE_FRIEND_SHIP= 4,    // 友情点
    RESOURCE_EXPERIENCE = 5,    // 角色经验
} ResourceType;


// 物品定义。
enum ItemType {
//    IT_GOLD                 =  900001,      // 金币
//    IT_GEM                  =  900002,      // 钻石
    IT_ROLE_EXP             =  900003,      // 角色经验
    
    IT_HERO_EXP             =  900101,      // 英雄经验
    IT_HERO_UP_STONE        =  900102,      // 英雄进阶石
};

#pragma mark --------sdk枚举---------
//#define ALAHAIMU_SDK
//#define OKGAME_SDK
#define FEIFAN_SDK
//#define FUSION_SDK



#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #define PACKAGE_VERSION "20210309"
#else
    // 安卓不再维护这个版本号
    #define PACKAGE_VERSION "20200525"
#endif


template<typename T, typename F>
void sortMapToVector(map<T, F>& m1, vector< pair<T, F> >& vec, int cmp(const pair<T, F> &x, const pair<T, F> &y)) {
    for(typename map<T, F>::iterator iter = m1.begin(); iter != m1.end(); iter++) {
        vec.push_back(make_pair(iter->first, iter->second));
    }
    sort(vec.begin(), vec.end(), cmp);
}

#endif
