//
//  Player.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__Player__
#define __AVT__Player__

#include "../Common/CommonDefine.h"
#include "../Common/SingleInstance.h"

//#include "HeroData.h"
//#include "ClanData.h"


using namespace std;

class Player : public Ref,
               public SingleInstance<Player>
{
public:
//    CC_SYNTHESIZE(int64_t, user_id, UserID);            // 账号ID
//    CC_SYNTHESIZE(int64_t, role_id, RoleID);            // 角色ID
//    CC_SYNTHESIZE(int64_t, clan_id, ClanID);            // 军团ID
//    CC_SYNTHESIZE(string, nick, Nick);                  // 昵称
//    CC_SYNTHESIZE(short, level, Level);                 // 等级
//    CC_SYNTHESIZE(int, exp, Exp);                       // 经验
//    CC_SYNTHESIZE(bool, is_vip, Vip);                   // VIP
//    CC_SYNTHESIZE(int8_t, sex_id, SexID);               // 性别
//    CC_SYNTHESIZE(int8_t, head_id, HeadID);             // 头像
//    CC_SYNTHESIZE(int32_t, energy, Energy);             // 体力值
//
//    CC_SYNTHESIZE(int64_t, gold, Gold);                 // 金币
//    CC_SYNTHESIZE(int32_t, gem, Gem);                   // 钻石
//
//    CC_SYNTHESIZE(int32_t, honor, Honor);               // 荣耀点
//    CC_SYNTHESIZE(int32_t, crown, Crown);               // 皇冠数
//    CC_SYNTHESIZE(int32_t, friend_ship, FriendShip);    // 友情点
//    CC_SYNTHESIZE(int32_t, last_week_rank, LastWeekRank);// 上周天梯分数
//    CC_SYNTHESIZE(int32_t, now_week_honor, NowWeekHonor);// 这周获得的荣耀点
//    CC_SYNTHESIZE(int32_t, guide_num, GuideNum);        // 新手指引序号
//
//    CC_SYNTHESIZE(Heros, heros, Heros);
//    CC_SYNTHESIZE(ClanData, clan, Clan);

    int64_t user_id;        // 账号ID
    int64_t role_id;        // 角色ID
    int64_t clan_id;        // 军团ID
    string nick;            // 昵称
    short level;            // 等级
    int exp;                // 经验
    bool is_vip;

    int8_t sex_id;          // 头像
    int8_t head_id;

    int32_t energy;
    int64_t gold;
    int32_t gem;
    int32_t honor;

    int32_t crown;            // 这周天梯积分

    int32_t friend_ship;      // 友情点

    int32_t last_week_rank;  // 上周天梯分数
    int32_t now_week_honor;   // 这周获得的荣耀点

    int32_t guide_num;

//    Heros heros;

//    ClanData clan;
public:
    Player();
    ~Player();
    
public:
    void resourceAdd(ResourceType type, int64_t num);  // 加资源
    void resourceSub(ResourceType type, int64_t num);  // 减资源
};

#endif /* defined(__AVT__Player__) */
