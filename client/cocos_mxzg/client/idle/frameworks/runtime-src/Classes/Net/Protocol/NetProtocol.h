//
//  NetProtocol.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__NetProtocol_________
#define __AVT__NetProtocol_________

#include "../../Common/CommonDefine.h"

#pragma pack(1)


class ProtocolStruct
{
    
};

class ProtocolBase : public ProtocolStruct
{
public:
    int protocol;
    
    ProtocolBase()
    {
        protocol = 0;
    }
};

#pragma mark -----公共的------
// 技能数据
class PSSkillData : public ProtocolStruct {
public:
    int32_t type;
    int32_t level;  // 等级
//    int8_t is_unLock; // 是否锁住  1:已经解锁  0: 锁住
    PSSkillData() {
        type = 0;
        level = 0;
//        is_unLock = 0;
    }
};

// 战斗英雄数据
class PSBattleHeroData : public ProtocolStruct {
public:
    int64_t role_id;
    
    int64_t hero_id;
    int32_t type;
    int32_t level;
    int32_t star;
    
    int32_t x;      // 英雄开场初始位置
    int32_t y;
    
    PSSkillData skill;
    
    PSBattleHeroData() {
        role_id = 0;
        
        hero_id = 0;
        type = 0;
        level = 0;
        star = 0;
        
        x = 0;
        y = 0;
        
        skill = PSSkillData();
    }
};

class PSEquipData : public ProtocolStruct {
public:
    int64_t equip_id;
    int32_t equip_type;
//    int8_t  place;
    PSEquipData (){
        equip_id = 0;
        equip_type = 0;
//        place = 0;
    }
};

class PSHeroEquipData :public ProtocolStruct{
public:
    int64_t hero_id;
    PSEquipData equip_list[4];
    PSHeroEquipData(){
        hero_id = 0;
        memset(equip_list,0,sizeof(equip_list));
    }
};

class PSHeroData : public ProtocolStruct {
public:
    int64_t hero_id;         // 英雄id
    int32_t type;            // 英雄类型
    int32_t level;           // 等级
    int8_t stage;            // 英雄品阶
    int8_t star;             // 英雄星数
    int8_t elem;             // 元素类型
    int8_t occupation;       // 职业类型
    int8_t is_lock;          // 是否上锁
    int16_t hp_up_level;     // 血量突破等级
    int16_t atk_up_level;    // 攻击突破等级
//    PSEquipData equip[5];    // 英雄装备
    
    PSHeroData() {
        hero_id = 0;
        type = 0;
        level = 0;
        stage = 0;
        star = 0;
        is_lock = 0;
        hp_up_level = 0;
        atk_up_level = 0;
//        memset(equip,0,sizeof(equip));
    }
};

class PSHeroInitPos: public ProtocolStruct {
public:
    int64_t hero_id;        // 英雄类型
    int32_t init_pos_index; // 出阵位置
    PSHeroInitPos() {
        hero_id = 0;
        init_pos_index = 0;
    }
};

// 聊天数据结构...
class PSClanChatData : public ProtocolStruct{
public:
    int64_t member_id;      // 玩家ID
    int32_t time;           // 发送消息时的时间
    char content[200];      // 聊天文本
    PSClanChatData() {
        member_id = 0;
        time = 0;
        memset(content, '\0',sizeof(content));
    }
};

// 上阵英雄阵容数据结构...
class PSFightHeroData : public ProtocolStruct{
public:
    int8_t fight_group_id;              //  单个上阵英雄阵容列表id fight_group_id = 1、2、3、4、5··· 表示第几阵容
    char line_up_name[NAME_LENGTH];     //  阵容名字
    PSHeroInitPos hero_info[4];         //  阵容英雄位置信息
    PSFightHeroData() {
        memset(line_up_name, '\0',sizeof(line_up_name));
        memset(hero_info, 0, sizeof(hero_info));
    }
};


class PSHeroInfoData : public ProtocolStruct {
public:
    int32_t hero_type;
    int32_t hero_star;
    int32_t hero_level;
    int16_t pos;
    PSHeroInfoData() {
        hero_type = 0;
        hero_star = 0;
        hero_level = 0;
        pos = 0;
    };
};

// 副本房间数据
class PSDungeonRoomData : public ProtocolStruct {
public:
    int64_t room_id;                // 房间id
    char    room_name[NAME_LENGTH]; // 房主的名字
    int32_t level;                  // 房主等级
    int32_t type;                   // 副本类型
    int16_t degree;                 // 副本的难度
    int32_t level_limit;            // 等级限制
    bool    is_lock;                // 房间是否有锁
    int8_t  cur_num;                // 房间内有多少人
    int8_t  max_num;                // 房间最大人数
    PSDungeonRoomData() {
        room_id = 0;
        level = 0;
        type = 0;
        degree = 0;
        level_limit = 0;
        is_lock = 0;
        cur_num = 0;
        max_num = 0;
        memset(room_name, '\0', sizeof(room_name));
    }
};

// 副本房间内部数据
class PSSeatData : public ProtocolStruct {
public:
    int64_t player_id;          // 玩家的id
    int32_t level;              // 玩家的等级
    char    player_name[NAME_LENGTH];// 玩家名字
    bool    is_ready;           // 是否准备, 0:未准备状态.. 1 : 准备状态..
    bool    is_room_owner;      // 是否是房主
    bool    is_lock;            // 是否是锁住状态
    int64_t hero_id;            // 英雄id.
    int32_t hero_type;          // 出战英雄的类型
    int32_t hero_star;          // 出战英雄的星数
    int16_t hero_level;         // 出战英雄的等级
    int32_t hero_exp;           // 出战英雄的经验值
    int16_t hp_up_level;        // 出战英雄的血量等级
    int16_t atk_up_level;       // 出战英雄的攻击等级

    PSSeatData() {
        player_id = 0;
        level = 0;
        is_ready = false;
        is_room_owner = 0;
        is_lock = 0;
        hero_type = 0;
        hero_star = 0;
        hero_level = 0;
        hero_exp = 0;
        hp_up_level = 0;
        atk_up_level = 0;
        memset(player_name,'\0',sizeof(player_name));
    }
};


class PSItemData : public ProtocolStruct {
public:
    int64_t player_id;
    int32_t type;
    int32_t num;
    PSItemData() {
        type = 0;
        num = 0;
    }
    PSItemData (const int32_t& type, const int32_t& num) {
        this->type = type;
        this->num = num;
    }
};

// 日常数据
class PSDailyAdventureData : public ProtocolStruct {
public:
    int32_t mission_type;   //  日常关卡类型;
    int32_t num;            //  当前挑战了多少次
    PSDailyAdventureData() {
        mission_type = 0;
        num = 0;
    }
};

// 英雄图鉴数据
class PSIllustratData : public ProtocolStruct {
public:
    int32_t hero_type;  // 英雄类型
    int32_t star ;      //星级
//    bool  is_recv;      // 是否已经领取奖励
    PSIllustratData() {
        hero_type = 0;
        star = 0;
    }
};


// 主线数据
class PSMainLineData : public ProtocolStruct {
public:
    int32_t mission_id;     // 关卡id
    int32_t raid_num;       // 已经扫荡的次数
    PSMainLineData() {
        mission_id = 0;
        raid_num = 0;
    }
};


// 背包数据
class PSBackpackData : public ProtocolStruct {
public:
    int64_t item_id;         // 物品Id
    int32_t item_type;       // 物品类型
    int32_t item_num;        // 物品数量
    PSBackpackData() {
        item_id = 0;
        item_type = 0;
        item_num = 0;
    }
};

// 市场(商店)数据
class PSMarketData : public ProtocolStruct
{
public:
    int32_t index;          // 序号
    
    PSBackpackData item;    // 物品
    
    int32_t need_type;      // 付费类型
    int32_t need_num;       // 付费数量
    
    int32_t buy_limit;      // 购买限制
    int32_t buy_count;      // 购买次数统计
};

// 邮件数据
class PSMailItemData : public ProtocolStruct {
public:
    int32_t type;       //礼物类型
    int32_t num;
    PSMailItemData() {
        type = 0;
        num = 0;
    }
};


class PSMailData : public ProtocolStruct {
public:
    int64_t mail_id;        //邮件id
    int32_t time;           //时间
    int8_t is_read;         //是否阅读
    int8_t is_receive;      //是否接受
    char str_title[91];     //邮件标题
    char str_content[301];  //邮件内容

    int32_t list_count;
    PSMailItemData list[5];

    PSMailData() {
        mail_id = 0;
        time = 0;
        is_read = 0;
        is_receive = 0;

        list_count = 0;

        memset(str_title, 0, sizeof(str_title));
        memset(str_content, 0, sizeof(str_content));
    }
};

// 玩家排行榜数据
class PSRankPlayerData : public ProtocolStruct {
public:
    int64_t player_id;              // 玩家id
    char name[NAME_LENGTH];         // 玩家名字
    int64_t clan_id;                // 公会id
    char clan_name[NAME_LENGTH];    // 公会名字
    int8_t  clan_icon_id;           // 公会图标
    int32_t level;                  // 玩家等级
    int32_t head_id;                // 玩家头像
    int32_t complete_time;          // 通关时间
    int32_t score;                  // 玩家积分
    int32_t combat_num;             // 战斗力
    int32_t server_id;              // 大区(服务器区号)
    int32_t rank;                   // 玩家排名
    PSRankPlayerData() {
        player_id = 0;
        clan_id = 0;
        clan_icon_id = 0;
        
        level = 0;
        head_id = 0;
        complete_time = 0;
        score = 0;
        combat_num = 0;
        server_id = 0;
        rank = 0;
        
        memset(name, 0, sizeof(name));
        memset(clan_name, 0, sizeof(clan_name));
    }
};

// 公会排行榜数据
class PSRankClanData : public ProtocolStruct {
public:
    int64_t clan_id;                // 公会id
    char clan_name[NAME_LENGTH];    // 公会名字
    char name[NAME_LENGTH];         // 会长名字
    int8_t  clan_icon_id;           // 公会图标
    int32_t level;                  // 玩家等级
    int32_t score;                  // 积分
    int32_t rank;                   // 玩家排名
    PSRankClanData() {
        clan_id = 0;
        clan_icon_id = 0;
        
        level = 0;
        score = 0;
        rank = 0;
        
        memset(name, 0, sizeof(name));
        memset(clan_name, 0, sizeof(clan_name));
    }
};


//// 布阵数据
//class PSLineUpData : public ProtocolStruct {
//public:
//    int32_t type;       // 布阵类型
//    int64_t hero_id;    // 英雄id
//    int32_t hp;         // 剩余血量
//    PSLineUpData() {
//        type = 0;
//        hero_id = 0;
//        hp = 0;
//    }
//};

class PSFetterData : public ProtocolStruct {
public:
    int32_t type;
    int32_t exp;
    int32_t level;
    int32_t skill_level;
    int32_t refine_level;
    int32_t uplimit_level;
    PSFetterData() {
        type = 0;
        exp = 0;
        level = 0;
        skill_level = 0;
        refine_level = 0;
        uplimit_level = 0;
    }
};

class PSLineUpHeroData : public ProtocolStruct {
public:
    int64_t hero_id;    // 英雄id
    int32_t hp;         // 剩余血量
    PSLineUpHeroData() {
        hero_id = 0;
        hp = 0;
    }
};

class PSLineUpData : public ProtocolStruct {
public:
    int32_t type;       // 布阵类型
    int32_t time;       // 布阵的时间
    int32_t goddess_type;// 神器类型
    int32_t list_count; // 英雄列表长
    PSLineUpHeroData hero_list[100]; // 英雄数据
    PSLineUpData() {
        type = 0;
        time = 0;
        list_count = 0;
    }
};

//箱子状态
class PSTrialBox : public ProtocolStruct {
public:
    int8_t pos;       // 位置
    int8_t status;    // 0 可领取 1已领取
};


// 购买次数
class PSDayLimitData : public ProtocolStruct {
public:
    int32_t idx;        // 购买的IDX
    int32_t num;        // 已经购买的次数
    int32_t time;       // 购买时间
    PSDayLimitData() {
        idx = 0;
        num = 0;
        time = 0;
    }
};

//成就已领取等级
class PSAchievementRecord : public ProtocolStruct {
public:
    int32_t type;       // 类型
    int8_t level;       // 已领取等级
};

//成就数据
class PSAchievementData : public ProtocolStruct {
public:
    int32_t type;       // 类型
    int32_t num;         // 次数 or 个数
};

//日常盒子
class PSDailyBox : public ProtocolStruct {
public:
    int32_t idx;       // 类型
    int8_t status;   // 0 未领取 1已领取
};

// 点金数据
class PSBuyGoldData : public ProtocolStruct {
public:
    int32_t idx;        // 购买的IDX
    int32_t num;        // 已经购买的次数
    PSBuyGoldData() {
        idx = 0;
        num = 0;
    }
};

// 七天目标
class PSSevenDayData : public ProtocolStruct {
public:
    int32_t idx;        //
    int32_t num;        // 已经购买的次数
    int32_t day;
    PSSevenDayData() {
        idx = 0;
        num = 0;
        day = 0;
    }
};

// 七天目标领取状态
class PSSevenDayStatus : public ProtocolStruct {
public:
    int32_t idx;       // 类型
    int8_t status;   // 0 未领取 1已领取
    PSSevenDayStatus() {
        idx = 0;
        status = 0;
    }
};


// 七天目标盒子状态
class PSSevenDayBox : public ProtocolStruct {
public:
    int32_t idx;       // 类型
    int8_t status;   // 0 未领取 1已领取
    PSSevenDayBox() {
        idx = 0;
        status = 0;
    }
};


// 公会技能数据
class PSClanSkillData : public ProtocolStruct {
public:
    int32_t profession_type;
    int32_t stage;
    int32_t skill_idx;
    PSClanSkillData() {
        profession_type = 0;
        stage = 0;
        skill_idx = 0;
    }
};

// 英雄降临
class PSHeroArriveData : public ProtocolStruct {
public:
    int32_t idx;        //
    int32_t num;        //
    int32_t type;
    PSHeroArriveData() {
        idx = 0;
        num = 0;
        type = 0;
    }
};


// 玩家战斗数据
class PSPlayerBattleData : public ProtocolStruct {
public:
    int32_t idx;               // 关卡idx
    
    int32_t hero_count;
    PSHeroData hero_list[10];  // 变长
    
    int32_t equip_count;
    PSHeroEquipData equip_list[10];  // 变长
    
    int32_t clan_count;
    PSClanSkillData clan_list[10];  // 变长
    
    PSFetterData fetter_data;
    
    PSPlayerBattleData() {
        
    }
};




#pragma pack()

#endif /* defined(__AVT__NetProtocol__) */
