//
//  ProtocolRequest.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef AVT_ProtocolRequest_h
#define AVT_ProtocolRequest_h

#include "NetProtocol.h"

using namespace std;
USING_NS_CC;

#pragma pack(1)

class ProtocolRequest : public ProtocolBase
{
    
};

#pragma mark ------心跳-----------

class ReqHeartbeat : public ProtocolRequest {
public:
    ReqHeartbeat() {
        protocol = 1004;
    }
};

#pragma mark -
#pragma mark 登陆模块 BEGIN
class ReqLogin : public ProtocolRequest
{
public:
    int64_t uid;
    int time;
    int server_id;
    int platform;   // 0，IOS，1，安卓
    char sign[33];
    
    ReqLogin() {
        protocol = 1001;
        uid = 0;
        time = 0;
        platform = 0;
        server_id = 0;
        
        memset(sign, 0, sizeof(sign));
    }
};

class ReqInit : public ProtocolRequest
{
public:
    char nick[NAME_LENGTH];
    int8_t lang;
    int platform;   // 0，IOS，1，安卓
    ReqInit() {
        protocol = 1101002;
        memset(nick, 0, sizeof(nick));
        lang = 0;
    }
};

class ReqOffline : public ProtocolRequest {
public:
    
    ReqOffline() {
        protocol = 1101003;
    }
};

class ReqError : public ProtocolRequest {
public:
    int32_t length;
    char error[10000];
    ReqError() {
        protocol = 1101010;
    }
};


#pragma mark 登陆模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 角色模块 BEGIN
class ReqRoleInfo : public ProtocolRequest
{
public:
    ReqRoleInfo()
    {
        protocol = 1102001;
    }
};

class ReqRoleDelete : public ProtocolRequest
{
public:
    ReqRoleDelete()
    {
        protocol = 1102002;
    }
};

class ReqRoleEditNick : public ProtocolRequest
{
public:
    char nick[NAME_LENGTH];
    
    ReqRoleEditNick()
    {
        protocol = 1102003;
        
        memset(nick, 0, sizeof(nick));
    }
};

// 获取某个玩家的详细信息
class ReqPlayerInfo : public ProtocolRequest {
public:
    int64_t player_id;
    ReqPlayerInfo() {
        protocol = 1102004;
        player_id = 0;
    }
};

// 保存新手指引序号
class ReqGuideSerial : public ProtocolRequest {
public:
    int serial;    // 新手指引序号
    ReqGuideSerial() {
        protocol = 1102005;
        serial = 0;
    }
};

// 新手指引召唤初始角色
class ReqGuideSummon : public ProtocolRequest {
public:
    int32_t index;
    ReqGuideSummon() {
        protocol = 1102006;
        index = 0;
    }
};

// 新手指引领取指引关卡的奖励
class ReqGuideFirstPveReward : public ProtocolRequest {
public:
    ReqGuideFirstPveReward() {
        protocol = 1102007;
    }
};


// GM命令
class ReqGMCommand : public ProtocolRequest {
public:
    int32_t gem;                 // 需要多少钻石
    int64_t gold;                // 需要多少金币
    int32_t backpack_count;      // 背包物品数量
    PSBackpackData item_list[30];// 需要什么物品（变长）
    
    int32_t hero_count;
    PSHeroData hero_list[30]; // （变长）
    
    ReqGMCommand() {
        protocol = 1102008;
        gem = 0;
        gold = 0;
        backpack_count = 0;
        memset(item_list, 0, sizeof(item_list));
//
//        hero_count = 0;
//        memset(hero_list, 0, sizeof(hero_list));
    }
};

// GM命令  删除背包
class ReqGMRemovebackpack : public ProtocolRequest {
public:
    int32_t type;                 // 0 英雄背包 ，1 物品背包

    ReqGMRemovebackpack() {
        protocol = 1102009;
        type = 0;
    }
};

// 修改角色 头像 形象
class ReqRoleChangeHead : public ProtocolRequest
{
public:
    int32_t head_id;    // 头像
    int32_t image_id;   // 形象
    
    ReqRoleChangeHead()
    {
        protocol = 1102011;
        head_id = 0;
        image_id = 0;
    }
};

#pragma mark 角色模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 聊天模块 BEGIN

class ReqChatContentSend : public ProtocolRequest {
public:
    int8_t chat_type;   // 聊天类型 2:世界 3:军团 4:喇叭 5:私聊
    int64_t player_id;  // 消息接受者
    char chat_content[CHAT_LENGTH];
    ReqChatContentSend(){
        protocol = 1106001;
        chat_type = 0;
        player_id = 0;
        memset(chat_content, 0, sizeof(chat_content));
    }
};

#pragma mark 聊天模块 END


///////////////////////////////////
#pragma mark-
#pragma mark 军团模块 START

class ReqClanInfo : public ProtocolRequest {
public:
    int64_t clan_id;    // 军团ID
    ReqClanInfo() {
        protocol = 1107001;
        
        clan_id = 0;
    }
};

//创建军团
class ReqClanCreate : public ProtocolRequest {
public:
    char clan_name[25];
    int32_t clan_photo;
    char clan_notice[301];  // 公会公告
    
    ReqClanCreate() {
        protocol = 1107002;
        memset(clan_name, 0, sizeof(clan_name));
        clan_photo = 0;
        memset(clan_notice, 0, sizeof(clan_notice));
    }
};


// 搜索军团
class ReqClanSearch : public ProtocolRequest {
public:
    char clan_name[NAME_LENGTH];    // 军团名称
    ReqClanSearch() {
        protocol = 1107003;
        memset(clan_name, 0, sizeof(clan_name));
    }
};

// 加入军团
class ReqClanJoin : public ProtocolRequest {
public:
    int64_t clan_id;    //军团ID
    ReqClanJoin() {
        
        protocol = 1107004;
        clan_id = 0;
        
    }
};

// 退出军团
class ReqClanQuit : public ProtocolRequest {
public:
    ReqClanQuit() {
        protocol = 1107005;
        
    }
};

//请求 处理消息同意 or 忽略
class ReqClanReqAgree : public ProtocolRequest {
public:
    int64_t member_id;      // 玩家ID
    int8_t agree_status;    // 同意状态  1：同意  0:忽略
    ReqClanReqAgree() {
        protocol = 1107008;
        agree_status = 0;
        member_id =0;
    }
};


// 修改军团操作.长老以上职位才有权限修改..
class ReqClanChangeInfo : public ProtocolRequest {
public:
    int64_t clan_id;        // 自身军团ID
    char clan_notice[CLAN_DESC_LENGTH];// 军团公告
    ReqClanChangeInfo() {
        protocol = 1107010;
        clan_id = 0;
        memset(clan_notice, 0, sizeof(clan_notice));
    }
};

// 操作军团消息提示
class ReqClanMsgInfo : public ProtocolRequest {
public:
    
    ReqClanMsgInfo() {
        protocol = 1107006;
    }
};

// 军团成员请求信息
class ReqClanReqMsgInfo : public ProtocolRequest {
public:
    ReqClanReqMsgInfo() {
        protocol = 1107007;
    }
};

// 升职或降职操作
class ReqClanChangePos : public ProtocolRequest {
public:
    int64_t member_id;      // 玩家ID
    int8_t  status;         // 升职状态  1：升职  0:降职. 2:踢出
    ReqClanChangePos() {
        protocol = 1107011;
        member_id = 0;
        status = 0;
    }
};

// 请求军团聊天列表
class ReqClanChatList : public ProtocolRequest{
public:
    ReqClanChatList() {
        protocol = 1107020;
    }
};


// 军团战斗结束
class ReqClanMissionEnd : public ProtocolRequest{
public:
    int32_t hp;
    ReqClanMissionEnd() {
        protocol = 1107052;
        hp = 0;
    }
};


// 军团商店 列表
class ReqClanShopList : public ProtocolRequest
{
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqClanShopList()
    {
        protocol = 1107061;
        index = 0;
    }
};
// 军团商店 购买
class ReqClanShopBuy : public ProtocolRequest
{
public:
    int32_t index; //购买物品序号
    ReqClanShopBuy()
    {
        protocol = 1107062;
    }
};
#pragma mark 军团模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 副本数据模块 BEGIN
//  主线已通关数据列表请求
class ReqMainLineAdventureData : public ProtocolRequest {
public:
    ReqMainLineAdventureData() {
        protocol = 1108001;
    }
};

//  日常通关数据列表请求
class ReqDailyAdventureList : public ProtocolRequest {
public:
    ReqDailyAdventureList() {
        protocol = 1108002;
    }
};

// 请求副本 房间列表
class ReqDungeonRoomList : public ProtocolRequest {
public:
    int32_t dungeon_type;       // 1.探险  2.大降临(小降临)
    ReqDungeonRoomList() {
        protocol = 1108100;
        dungeon_type = 0;
    }
};

// 请求创建一个副本房间
class ReqDungeonCreateRoom : public ProtocolRequest {
public:
    int32_t dungeon_type; // 1.探险  2.大降临(小降临)
    int32_t type;
    int8_t  degree;
    int32_t level_limit;
    char    passcode[PASSCODE_LENGTH];   // PASSCODE_LENGTH = 7
    ReqDungeonCreateRoom() {
        protocol = 1108101;
        dungeon_type = 0;
        type = 0;
        degree = 0;
        level_limit = 0;
        memset(passcode, '\0', sizeof(passcode));
    }
};

// 请求加入一个房间...
class ReqDungeonJoinRoom : public ProtocolRequest {
public:
    int64_t room_id;                // 对应房间的id
    char passcode[PASSCODE_LENGTH]; // PASSCODE_LENGTH = 7
    ReqDungeonJoinRoom() {
        protocol = 1108102;
        room_id = 0;
        memset(passcode, '\0', sizeof(passcode));
    }
};

class ReqDungeonPlayerList : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id
    ReqDungeonPlayerList() {
        protocol = 1108103;
        room_id = 0;
    }
};

// 修改房间设置..
class ReqDungeonSetting : public ProtocolRequest {
public:
    int64_t room_id;         // 房间id.(可能会被外挂利用.需要验证玩家是否是房主)
    int32_t dungeon_type;    // 1.探险. 2.大降临(小降临)
    int32_t type;            // 副本类型.刷新界面用的
    int8_t  degree;          // 副本难度
    int32_t level_limit;     // 等级限制
    char    passcode[PASSCODE_LENGTH];  // PASSCODE_LENGTH = 7
    ReqDungeonSetting() {
        protocol = 1108104;
        room_id = 0;
        dungeon_type = 0;
        type = 0;
        degree = 0;
        level_limit = 0;
        memset(passcode, '\0', sizeof(passcode));
    }
};


// 邀请好友进房间
class ReqDungeonInvite : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id (需要验证玩家是否是房主)
    int64_t friend_id;      // 好友的id
    ReqDungeonInvite() {
        protocol = 1108105;
        room_id = 0;
        friend_id = 0;
    }
};

// 接受好友邀请
class ReqDungeonReplyInvite : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id
    ReqDungeonReplyInvite() {
        protocol = 1108106;
        room_id = 0;
    }
};

// 退出房间
class ReqDungeonExitRoom : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id
    ReqDungeonExitRoom() {
        protocol = 1108107;
        room_id = 0;
    }
};

// 选择英雄.和准备
class ReqDungeonReady : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id
    int64_t hero_id;        // 英雄id
    bool    is_ready;       // 是否准备
    ReqDungeonReady() {
        protocol = 1108108;
        room_id = 0;
        hero_id = 0;
        is_ready = false;
    }
};

// 位置操作
class ReqDungeonSeatChange : public ProtocolRequest {
public:
    int64_t room_id;        // 房间id(需要验证玩家是否是房主)
    int8_t  seat_num;       // 被操作的位置
    int8_t  status;         // 0 : 委任为房主. 1 : 踢出房间  2 : 锁住   3 : 解锁
    ReqDungeonSeatChange() {
        protocol = 1108109;
        room_id = 0;
        seat_num = 0;
        status = 1;
    }
};

// 聊天
class ReqDungeonChat : public ProtocolRequest {
public:
    int64_t room_id;
    char chat_content[CHAT_LENGTH];
    ReqDungeonChat() {
        protocol = 1108110;
        room_id = 0;
        memset(chat_content, '\0', sizeof(chat_content));
    }
};

// 战斗开始
class ReqDungeonBattle : public ProtocolRequest {
public:
    int64_t room_id;
    ReqDungeonBattle() {
        protocol = 1108111;
        room_id = 0;
    }
};

// 房间战斗结束
class ReqDungeonBattleEnd : public ProtocolRequest {
public:
    int64_t room_id;
    int8_t is_win;
    ReqDungeonBattleEnd() {
        protocol = 1108112;
        room_id = 0;
        is_win = 0;
    }
};

#pragma mark 冒险模式数据模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 战斗模块 BEGIN

// 请求战斗，demo期，起到等待对方登陆，服务器接到双方包时开始战斗
class ReqBattleMatch : public ProtocolRequest {
public:
    ReqBattleMatch() {
        protocol = 1103001;
    }
};

// 关卡
class ReqChapterEnd : public ProtocolRequest {
public:
    int32_t idx;
    int8_t is_win;          // 胜利则保存idx,  0:输  1:赢
    ReqChapterEnd() {
        protocol = 1103002;
        idx = 0;
        is_win = 0;
    }
};

// 更改挂机关卡
class ReqChapterChangeMission : public ProtocolRequest {
public:
    int32_t idx;
    ReqChapterChangeMission() {
        protocol = 1103003;
        idx = 0;
    }
};

// 获取挂机奖励列表
class ReqChapterItemList : public ProtocolRequest {
public:
    int32_t max_fighting;       // 主阵营最高战斗力
    ReqChapterItemList() {
        protocol = 1103004;
    }
};

// 领取挂机物品
class ReqChapterItemReward : public ProtocolRequest {
public:
    ReqChapterItemReward() {
        protocol = 1103005;
    }
};

// 获取关卡数据。登录时前端会请求关卡数据
class ReqChapterData : public ProtocolRequest {
public:
    ReqChapterData() {
        protocol = 1103007;
    }
};


// 保存挂机队伍
class ReqChapterIdleLineup : public ProtocolRequest {
public:
    int32_t list_count;
    int64_t list[20];       // 英雄id
    ReqChapterIdleLineup() {
        protocol = 1103008;
        list_count = 0;
    }
};

// 保存战斗队伍
class ReqChapterBattleLineup : public ProtocolRequest {
public:
    int32_t list_count;
    int64_t list[6];       // 英雄id
    ReqChapterBattleLineup() {
        protocol = 1103009;
        list_count = 0;
    }
};


// 获取关卡首通奖励列表
class ReqChapterRewardList : public ProtocolRequest {
public:
    ReqChapterRewardList() {
        protocol = 1103010;
    }
};

// 领取关卡首通奖励 回复1205003
class ReqChapterFirstReward : public ProtocolRequest {
public:
    int32_t idx;    // firstrewardchapter.csv的idx
    ReqChapterFirstReward() {
        protocol = 1103011;
    }
};



// 获取布阵列表
class ReqLineUp : public ProtocolRequest {
public:
    ReqLineUp() {
        protocol = 1103101;
    }
};

// 保存战斗队列
class ReqLineUpSave : public ProtocolRequest {
public:
    PSLineUpData data;   // 英雄属性
    ReqLineUpSave() {
        protocol = 1103100;
    }
};


// 幻境之塔数据
class ReqTowerData : public ProtocolRequest {
public:
    ReqTowerData() {
        protocol = 1103200;
    }
};

// 幻境之塔战斗结束
class ReqTowerBattleEnd : public ProtocolRequest {
public:
    int8_t is_win;      // 0：失败  1:胜利
    ReqTowerBattleEnd() {
        protocol = 1103201;
    }
};


// 幻境之塔体力购买
class ReqTowerEnergyBuy : public ProtocolRequest {
public:
    int32_t num;         // 购买的数量
    ReqTowerEnergyBuy() {
        protocol = 1103202;
        num = 0;
    }
};


// 获取幻境之塔首通奖励列表
class ReqTowerRewardList : public ProtocolRequest {
public:
    ReqTowerRewardList() {
        protocol = 1103203;
    }
};

// 领取幻境之塔首通奖励 回复1205003
class ReqTowerFirstReward : public ProtocolRequest {
public:
    int32_t idx;    // firstrewardtower.csv的idx
    ReqTowerFirstReward() {
        protocol = 1103204;
    }
};

// 领取快速战斗奖励
class ReqQuickBattleReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqQuickBattleReward() {
        protocol = 1103208;
        idx = 0;
    }
};

#pragma mark 战斗模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 英雄模块 BEGIN
//获取英雄列表
class ReqHeroList : public ProtocolRequest {
public:
    ReqHeroList() {
        protocol = 1104001;
    }
};


// 获取召唤进度
class ReqHeroSummonCount : public ProtocolRequest {
public:
    ReqHeroSummonCount() {
        protocol = 1104004;
    }
};

// 请求召唤进度奖励
class ReqHeroSummonAward : public ProtocolRequest {
public:
    ReqHeroSummonAward() {
        protocol = 1104005;
    }
};

// 请求召唤
class ReqHeroSummon : public ProtocolRequest {
public:
    int8_t summon_type;  //召唤类型  1:友情召唤  2:友情召唤十次召唤   3:高级一次召唤   4:高级十次召唤
    
    ReqHeroSummon() {
        protocol = 1104002;
        summon_type = 0;
    }
};

class ReqHeroUpgradeStar : public ProtocolRequest {
public:
    int64_t hero_id;
    int32_t list_hero_count;
    // int64_t material_hero_id[5]; // 变长
    ReqHeroUpgradeStar() {
        protocol = 1104007;
        hero_id = 0;
        list_hero_count = 0;
        // material_hero_id = 0;
    }
};

class ReqHeroUpgradeLevel : public ProtocolRequest {
public:
    int64_t hero_id;
    int32_t item_type; // 材料类型
    int32_t item_num;  // 材料数量
    
    ReqHeroUpgradeLevel() {
        protocol = 1104008;
        hero_id = 0;
        item_type = 0;
        item_num = 0;
    }
};

// 技能升级
class ReqHeroSkillUpgrade : public ProtocolRequest {
public:
    int64_t hero_id;
    int32_t skill_type;
    
    ReqHeroSkillUpgrade() {
        protocol = 1104010;
        hero_id = 0;
        skill_type = 0;
    }
};

class ReqFightHeroInitPos : public ProtocolRequest{
public:
    int8_t group_id;           // 单个上阵英雄组合列表id
    char line_up_name[NAME_LENGTH];
    int32_t list_count;         // 单个布阵列表长
    // PSHeroInitPos list[4]    // 单个布阵列表
    ReqFightHeroInitPos() {
        protocol = 1104011;
        group_id = 0;
        list_count = 0;
        memset(line_up_name, 0, sizeof(line_up_name));
    }
};

class ReqFightHerolist : public ProtocolRequest {
public:
    ReqFightHerolist() {
        protocol = 1104012;
    }
};


// 英雄图鉴奖励列表
class ReqIllustratReward : public ProtocolRequest {
public:
    ReqIllustratReward() {
        protocol = 1104013;
    }
};

// 英雄图鉴.领取新类型英雄的奖励
class ReqIllustratRecv : public ProtocolRequest {
public:
    int32_t hero_type;
    ReqIllustratRecv() {
        protocol = 1104014;
        hero_type = 0;
    }
};


// 英雄上锁
class ReqHeroLock : public ProtocolRequest {
public:
    int64_t hero_id;        // 突破的英雄id
    int8_t  is_lock;        // 是否上锁 0 : 未锁, 1 : 锁定
    ReqHeroLock() {
        protocol = 1104015;
        hero_id = 0;
        is_lock = false;
    }
};


// 英雄突破
class ReqHeroLimitUp : public ProtocolRequest {
public:
    int64_t hero_id;        // 突破的英雄id
    int8_t  up_type;        // 突破的类型  1 : 血量突破  2 : 攻击突破
    ReqHeroLimitUp() {
        protocol = 1104016;
        hero_id = 0;
        up_type = 0;
    }
};

// 英雄出售
class ReqHeroSell : public ProtocolRequest {
public:
    int32_t hero_num;           // 出售英雄个数
    int64_t list_hero_id[10];   // 出售的英雄id列表
    ReqHeroSell() {
        protocol = 1104017;
        hero_num = 0;
        memset(list_hero_id, 0, sizeof(list_hero_id));
    }
};

// 英雄升级
class ReqHeroUpLevel : public ProtocolRequest {
public:
    int64_t hero_id;        // 升级的英雄id
    ReqHeroUpLevel() {
        protocol = 1104018;
        hero_id = 0;
    }
};

// 英雄升阶
class ReqHeroUpgrade : public ProtocolRequest {
public:
    int64_t hero_id;        // 升阶的英雄id
    ReqHeroUpgrade() {
        protocol = 1104019;
        hero_id = 0;
    }
};

// 英雄升星
class ReqHeroUpStar : public ProtocolRequest {
public:
    int64_t hero_id;        // 升星的英雄id
    int8_t  count;             //列表长度
    int64_t list_hero_id[50];   //消耗英雄id列表
    ReqHeroUpStar() {
        protocol = 1104020;
        hero_id = 0;
        count = 0;
        memset(list_hero_id, 0, sizeof(list_hero_id));
    }
};

// 英雄合成
class ReqHeroCompose : public ProtocolRequest {
public:
    int64_t hero_id;          //主英雄
    int8_t  count;             //列表长度
    int64_t list_hero_id[50];   //消耗英雄id列表
    ReqHeroCompose() {
        protocol = 1104021;
        hero_id = 0;
        count = 0;
        memset(list_hero_id, 0, sizeof(list_hero_id));
    }
};

// 英雄装备
class ReqHeroEquip : public ProtocolRequest {
public:
    ReqHeroEquip(){
        protocol = 1104022;
    }
};

// //装备穿戴，更换
class ReqHeroEquipChange : public ProtocolRequest {
public:
    int64_t hero_id;
    int64_t equip_id;
    int8_t  place;
    ReqHeroEquipChange(){
        protocol = 1104023;
        hero_id = 0;
        equip_id = 0;
        place = 0;
    }
};
// //装备卸下
class ReqHeroEquipDisboard : public ProtocolRequest {
public:
    int64_t hero_id;
    int64_t equip_id;
    int8_t  place;
    ReqHeroEquipDisboard(){
        protocol = 1104024;
        hero_id = 0;
        equip_id = 0;
        place = 0;
    }
};

//装备一键穿戴
class ReqHeroEquipOneKeyWear : public ProtocolRequest {
public:
    int64_t hero_id;
    int8_t count;
    int64_t equip_id[4];
    ReqHeroEquipOneKeyWear(){
        protocol = 1104025;
        hero_id = 0;
        count = 0;
        memset(equip_id, 0, sizeof(equip_id));
    }
};

//装备一键卸下
class ReqHeroEquipOneKeyDisboard : public ProtocolRequest {
public:
    int64_t hero_id;
//    int8_t count;
//    int64_t equip_id[4];
    ReqHeroEquipOneKeyDisboard(){
        protocol = 1104026;
        hero_id = 0;
//        count = 0;
//        memset(equip_id, 0, sizeof(equip_id));
    }
};


#pragma mark 英雄模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 背包模块 BEGIN

class ReqBackpackList : public ProtocolRequest {
public:
    ReqBackpackList() {
        protocol = 1105001;
    }
};

// 物品使用
class ReqBackpackUseItem : public ProtocolRequest {
public:
    int32_t item_type;
    int32_t item_num;
    ReqBackpackUseItem() {
        protocol = 1105002;
        item_type = 0;
        item_num = 0;
    }
};

//装备合成
class ReqMakeEquip : public ProtocolRequest {
public:
    int32_t equip_type;
    int16_t count;
    int64_t equip_id[1000];
    ReqMakeEquip(){
        protocol = 1105004;
        equip_type = 0;
        count = 0;
        memset(equip_id, 0, sizeof(equip_id));
    }
};

//装备一键合成
class ReqOneKeyMakeEquip : public ProtocolRequest {
public:
    int32_t equip_type;
    ReqOneKeyMakeEquip(){
        protocol = 1105005;
        equip_type = 0;
    }
};

//宝箱开启
class ReqOpenBoxReward : public ProtocolRequest {
public:
    int32_t item_type;
    int32_t use_num;
    ReqOpenBoxReward(){
        protocol = 1105006;
        item_type = 0;
        use_num = 0;
    }
};

//碎片合成
class ReqPieceReward : public ProtocolRequest {
public:
    int32_t item_type;
    int32_t use_num;
    ReqPieceReward(){
        protocol = 1105007;
        item_type = 0;
        use_num = 0;
    }
};


#pragma mark 背包模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 市场模块 BEGIN
class ReqMarketList : public ProtocolRequest
{
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqMarketList()
    {
        protocol = 1105101;
        index = 0;
    }
};

class ReqMarketBuy : public ProtocolRequest
{
public:
    int32_t index; //购买物品序号
    ReqMarketBuy()
    {
        protocol = 1105102;
    }
};


// 检查已完成的订单。
class ReqShopRechargeCheck : public ProtocolRequest {
public:
    ReqShopRechargeCheck(){
        protocol = 1120000;
    }
};


// vip奖励购买
class ReqVipRewardBuy : public ProtocolRequest {
public:
    int32_t vip_level;      // 购买哪一个VIP等级奖励
    ReqVipRewardBuy(){
        protocol = 1120004;
        vip_level = 0;
    }
};

// 每日礼包界面领取奖励
class ReqDayLimitReward : public ProtocolRequest {
public:
    ReqDayLimitReward(){
        protocol = 1120007;
    }
};

// 每日首充 进度
class ReqDailyFirstRecharge : public ProtocolRequest
{
public:
    ReqDailyFirstRecharge()
    {
        protocol = 1120008;
    }
};

// 每日首充 奖励
class ReqDailyFirstRechargeReward : public ProtocolRequest
{
public:
    ReqDailyFirstRechargeReward()
    {
        protocol = 1120009;
    }
};

// 超值首充
class ReqRechargeFirst : public ProtocolRequest
{
public:
    ReqRechargeFirst()
    {
        protocol = 1120012;
    }
};

//超值首充 领取
class ReqRechargeFirstReward : public ProtocolRequest
{
public:
    int32_t type;
    ReqRechargeFirstReward()
    {
        protocol = 1120013;
        type = 0;
    }
};


// 特权礼包
class ReqPrivilegeGiftAddOrUpdate : public ProtocolRequest
{
public:
    ReqPrivilegeGiftAddOrUpdate()
    {
        protocol = 1120014;
    }
};

// 每日累充
class ReqDailyTotalRecharge : public ProtocolRequest
{
public:
    ReqDailyTotalRecharge()
    {
        protocol = 1120016;
    }
};

class ReqDailyTotalRechargeGet : public ProtocolRequest
{
public:
    int32_t idx;    // 领取的idx
    
    ReqDailyTotalRechargeGet()
    {
        protocol = 1120017;
        idx = 0;
    }
};

class ReqPrivilegeGiftBuy : public ProtocolRequest
{
public:
    int32_t idx;    // 礼包对应配置表id
    
    ReqPrivilegeGiftBuy()
    {
        protocol = 1120015;
        idx = 0;
    }
};


#pragma mark 市场模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 上阵英雄数据模块 BEGIN



#pragma mark 上阵英雄数据模块 END


///////////////////////////////////////////////
#pragma mark -
#pragma mark 好友模块 BEGIN

// 请求自己的好友列表
class ReqFriendsListInfo : public ProtocolRequest {
public:
    ReqFriendsListInfo() {
        
        protocol = 1109001;
    }
};


//请求 好友请求列表
class ReqFriendsRequestInfo : public ProtocolRequest {
public:
    ReqFriendsRequestInfo() {
        
        protocol = 1109002;
    }
};

//请求 搜索好友关键字
class ReqFriendsSearch : public ProtocolRequest {
public:
    char player_name[NAME_LENGTH];    // 好友名称
    
    ReqFriendsSearch() {
        
        protocol = 1109003;
        memset(player_name, 0, sizeof(player_name));
    }
};

//请求 添加好友
class ReqFriendsAdd : public ProtocolRequest {
public:
    int64_t role_id;    // 好友id
    
    ReqFriendsAdd() {
        
        protocol = 1109004;
        role_id = 0;
    }
};

//请求 同意 or 忽略
class ReqFriendsAgree : public ProtocolRequest {
public:
    int64_t role_id;
    int8_t agree_status;    // 同意状态  1：同意  2:忽略  0:全部忽略
    
    ReqFriendsAgree() {
        
        protocol = 1109005;
        agree_status = 0;
        role_id =0;
    }
};

//请求 删除好友
class ReqFriendsDelete : public ProtocolRequest {
public:
    int64_t role_id;
    
    ReqFriendsDelete() {
        
        protocol = 1109006;
        role_id = 0;
    }
};


//请求 好友消息记录
class ReqFriendsChatList : public ProtocolRequest {
public:
    ReqFriendsChatList() {
        protocol = 1109007;
    }
};


// 给好友赠送友情点
class ReqFriendsGive : public ProtocolRequest {
public:
    int64_t player_id;
    ReqFriendsGive() {
        protocol = 1109008;
        player_id = 0;
    }
};


// 一键好友赠送
class ReqFriendsGiveAll : public ProtocolRequest {
public:
    ReqFriendsGiveAll() {
        protocol = 1109010;
    }
};


// 领取好友的友情点
class ReqFriendsReward : public ProtocolRequest {
public:
    int64_t player_id;
    ReqFriendsReward() {
        protocol = 1109011;
        player_id = 0;
    }
};

// 一键领取好友的友情点
class ReqFriendsRewardAll : public ProtocolRequest {
public:
    ReqFriendsRewardAll() {
        protocol = 1109012;
    }
};

#pragma mark 好友模块 END

///////////////////////////////////////////////
#pragma mark -
#pragma mark 元素石模块 BEGIN

class ReqElemStoneList : public ProtocolRequest {
public:
    
    ReqElemStoneList() {
        protocol = 1110001;
    }
};

#pragma mark 元素石模块 END


#pragma mark-
#pragma mark 排行榜模块 START
class ReqRankClan : public ProtocolRequest {
public:
    
    ReqRankClan() {
        protocol = 1111001;
        
    }
};

class ReqRankPlayer : public ProtocolRequest {
public:
    ReqRankPlayer() {
        protocol = 1111002;
    }
};


// 幻境之塔排行榜
class ReqTowerRank : public ProtocolRequest {
public:
    ReqTowerRank() {
        protocol = 1111003;
    }
};


// PVP排行榜
class ReqPvpRankList : public ProtocolRequest {
public:
    ReqPvpRankList() {
        protocol = 1111004;
    }
};


// 排行榜膜拜
class ReqRankWorshipList : public ProtocolRequest {
public:
    ReqRankWorshipList() {
        protocol = 1111100;
    }
};


// 膜拜了那一个排行榜
class ReqRankWorship : public ProtocolRequest {
public:
    int32_t type;
    int64_t role_id;
    ReqRankWorship() {
        protocol = 1111101;
        type = 0;
        role_id = 0;
    }
};



#pragma mark 排行榜模块 END



////////////////////////////////
#pragma mark-
#pragma mark 成就模块 BEGIN

//请求成就数据
class ReqAchievementData : public ProtocolRequest {
public:
    ReqAchievementData() {
        protocol = 1112000;
    }
};

//请求成就奖励
class ReqAchievementReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqAchievementReward() {
        protocol = 1112002;
        idx = 0;
    }
};

//请求日常数据
class ReqDailyData : public ProtocolRequest {
public:
    ReqDailyData() {
        protocol = 1112003;
    }
};

//请求日常奖励
class ReqDailyReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqDailyReward() {
        protocol = 1112004;
        idx = 0;
    }
};

//请求日常活跃度奖励
class ReqDailyBoxReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqDailyBoxReward() {
        protocol = 1112005;
        idx = 0;
    }
};

////请求成就数据
//class ReqAchievementData : public ProtocolRequest {
//public:
//    ReqAchievementLevel() {
//        protocol = 1112001;
//    }
//};

//class ReqAchievementList : public ProtocolRequest {
//public:
//    ReqAchievementList() {
//        protocol = 1112001;
//    }
//};
//
//class ReqAchievementReward : public ProtocolRequest {
//public:
//    int32_t type_id;
//    ReqAchievementReward() {
//        protocol = 1112002;
//        type_id = 0;
//    }
//};
//
//class ReqAchievementProgress : public ProtocolRequest {
//public:
//    int32_t type_id;
//    int32_t task_progress;
//    ReqAchievementProgress() {
//        protocol = 1112003;
//        type_id = 0;
//        task_progress = 0;
//    }
//};

#pragma mark 成就模块 END


////////////////////////////////
#pragma mark-
#pragma mark 日常任务模块 BEGIN

class ReqDailyTaskList : public ProtocolRequest {
public:
    ReqDailyTaskList() {
        protocol = 1113001;
    }
};

class ReqDailyTaskReward : public ProtocolRequest {
public:
    int32_t type_id;
    ReqDailyTaskReward() {
        protocol = 1113002;
        type_id = 0;
    }
};


class ReqDailyTaskProgress : public ProtocolRequest {
public:
    int32_t type_id;
    int32_t task_progress;
    ReqDailyTaskProgress() {
        protocol = 1113003;
        type_id = 0;
        task_progress = 0;
    }
};

#pragma mark 日常任务模块 END


////////////////////////////////
#pragma mark-
#pragma mark 酒馆任务派遣模块 BEGIN
class ReqPubTaskList : public ProtocolRequest
{
public:
    ReqPubTaskList()
    {
        protocol = 1113021;
    }
};

/*
 ** 任务刷新
 */
class ReqPubTaskRefresh : public ProtocolRequest
{
public:
    int32_t index;   //刷新方式 1钻石 2普通券 3高级券
    ReqPubTaskRefresh()
    {
        protocol = 1113022;
        index = 0;
    }
};

/*
 ** 派遣任务
 */
class ReqPubTaskStart : public ProtocolRequest
{
public:
    int64_t task_id;
    
    int32_t hero_count;
    int64_t hero_id[5]; // 派遣的英雄ID
    
    ReqPubTaskStart()
    {
        protocol = 1113023;
        task_id = 0;
        hero_count = 0;
    }
};

/*
 ** 领取奖励
 */
class ReqPubTaskAward : public ProtocolRequest
{
public:
    int64_t task_id;
    ReqPubTaskAward()
    {
        protocol = 1113024;
        task_id = 0;
    }
};

#pragma mark 酒馆任务派遣模块 END


////////////////////////////////
#pragma mark-
#pragma mark 许愿池模块 BEGIN
class ReqBlessingPoolList : public ProtocolRequest
{
public:
    ReqBlessingPoolList()
    {
        protocol = 1113031;
    }
};

class ReqBlessingPoolRefresh : public ProtocolRequest
{
public:
    int32_t index; // 1普通 2高级
    ReqBlessingPoolRefresh()
    {
        protocol = 1113032; // 返回 1213031
    }
};

class ReqBlessingPoolDone : public ProtocolRequest
{
public:
    int32_t index;  //1普通抽一次 2高级抽一次 10普通抽十次 20高级抽十次
    ReqBlessingPoolDone()
    {
        protocol = 1113033;
        index = 0;
    }
};

/*
 ** 许愿池商店
 */
class ReqBlessingPoolShopList : public ProtocolRequest
{
public:
    int32_t index; // 0 开机请求 1 手动刷新
    ReqBlessingPoolShopList()
    {
        protocol = 1113034;
        index = 0;
    }
};

class ReqBlessingPoolShopBuy : public ProtocolRequest
{
public:
    int32_t index; // 购买物品序号
    ReqBlessingPoolShopBuy()
    {
        protocol = 1113035;
    }
};

#pragma mark 许愿池模块 END


////////////////////////////////
#pragma mark-
#pragma mark 先知之树模块 BEGIN
class ReqProphetSummon : public ProtocolRequest
{
public:
    int32_t index; //1--4抽奖类型
    ReqProphetSummon()
    {
        protocol = 1113041;
        index = 0;
    }
};

// 置换英雄
class ReqProphetChange : public ProtocolRequest
{
public:
    int64_t hero_id; // 被置换的英雄ID 如果是0 发上次置换结果
    
    ReqProphetChange()
    {
        protocol = 1113042;
        hero_id = 0;
    }
};

// 确定置换
class ReqProphetConfirmChange : public ProtocolRequest
{
public:
    int32_t index; //0确认 1取消
    
    ReqProphetConfirmChange()
    {
        protocol = 1113043;
        
        index = 0;
    }
};

/*
 ** 先知商店
 */
class ReqProphetShopList : public ProtocolRequest
{
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqProphetShopList()
    {
        protocol = 1113045;
        index = 0;
    }
};

class ReqProphetShopBuy : public ProtocolRequest
{
public:
    int32_t index; //购买物品序号
    ReqProphetShopBuy()
    {
        protocol = 1113046;
    }
};

#pragma mark 先知之树模块 END

#pragma mark-
#pragma mark 英雄献祭模块 BEGIN
class ReqAltarHero : public ProtocolRequest
{
public:
    int32_t list_count;
    int64_t hero_id[10];
    
    ReqAltarHero()
    {
        protocol = 1113051;
        list_count = 0;
    }
};

/*
 ** 献祭商店
 */
class ReqAltarShopList : public ProtocolRequest
{
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqAltarShopList()
    {
        protocol = 1113054;
        index = 0;
    }
};

class ReqAltarShopBuy : public ProtocolRequest
{
public:
    int32_t index; //购买物品序号
    ReqAltarShopBuy()
    {
        protocol = 1113055;
    }
};

#pragma mark 英雄献祭模块 END

////////////////////////////////
#pragma mark-
#pragma mark 活动任务模块 BEGIN

// 签到列表
class ReqSignInList : public ProtocolRequest
{
public:
    ReqSignInList()
    {
        protocol = 1113010;
    }
};

class ReqSignInAward : public ProtocolRequest
{
public:
    int32_t index;  //签到天数
    ReqSignInAward()
    {
        protocol = 1113011;
        index = 0;
    }
};

// 每周福利
class ReqWeekGiftList : public ProtocolRequest
{
public:
    ReqWeekGiftList()
    {
        protocol = 1113012;
    }
};

// 积天豪礼 累计充值天数
class ReqRechargeDaysList : public ProtocolRequest
{
public:
    ReqRechargeDaysList()
    {
        protocol = 1113013;
    }
};


// 兑换礼包
class ReqGetTimeExchangeGift : public ProtocolRequest
{
public:
    int32_t idx;  // 奖励id
    ReqGetTimeExchangeGift()
    {
        protocol = 1113072;
        idx = 0;
    }
};



// 等级升级礼包
class ReqLevelUpGift : public ProtocolRequest
{
public:
    int32_t gift_id;  // 奖励id
    ReqLevelUpGift()
    {
        protocol = 1113020;
        gift_id = 0;
    }
};



// 积天豪礼 领取奖励
//Req protocol = 1112002; type = 2
//Res protocol = 1213014;

// 周累计充值 统计RMB充值 每周清零
class ReqRechargeWeekList : public ProtocolRequest
{
public:
    ReqRechargeWeekList()
    {
        protocol = 1113015;
    }
};
// 周累计充值 领取奖励
//Req protocol = 1112002; type = 3
//Res protocol = 1213016;


//月卡 至尊月卡
class ReqMonthCardList : public ProtocolRequest
{
public:
    ReqMonthCardList()
    {
        protocol = 1113017;
    }
};

//至尊月卡VIP等级奖励
class ReqMonthVipReward : public ProtocolRequest
{
public:
    ReqMonthVipReward()
    {
        protocol = 1113018;
    }
};

//Req protocol = 1112002; type = 4月卡 5至尊月卡
//Res protocol = 1213018 1月卡 2至尊月卡

#pragma mark 活动任务模块 END


////////////////////////////////
#pragma mark-
#pragma mark 限时礼包模块 BEGIN
class ReqLimitGiftList : public ProtocolRequest
{
public:
    ReqLimitGiftList()
    {
        protocol = 1113060;
    }
};


#pragma mark 限时礼包模块 END

////////////////////////////////
#pragma mark-
#pragma mark 月度回馈模块 BEGIN
class ReqMonthInvestList : public ProtocolRequest
{
public:
    ReqMonthInvestList()
    {
        protocol = 1113062;
    }
};

class ReqMonthInvesGain : public ProtocolRequest
{
public:
    int32_t invest_type; // 活动类型 1 128RMB 2 328RMB
    
    ReqMonthInvesGain()
    {
        protocol = 1113063;
        invest_type = 0;
    }
};

#pragma mark 月度回馈模块 END

#pragma mark -
#pragma mark 新服限购 BEGIN
class ReqNewServerLimitList : public ProtocolRequest
{
public:
    ReqNewServerLimitList()
    {
        protocol = 1113091;
    }
};

#pragma mark 新服限购 END

#pragma mark -q
#pragma mark 中秋特惠 BEGIN
class ReqMidAutumnInfo : public ProtocolRequest
{
public:
    ReqMidAutumnInfo()
    {
        protocol = 1113086;
    }
};
#pragma mark 中秋特惠 END

#pragma mark -q
#pragma mark 召唤水晶 BEGIN
class ReqSummonCrystalInfo : public ProtocolRequest
{
public:
    ReqSummonCrystalInfo()
    {
        protocol = 1113087;
    }
};

class ReqSummonCrystalGet : public ProtocolRequest
{
public:
    int32_t idx;
    
    ReqSummonCrystalGet()
    {
        protocol = 1113088;
        idx = 0;
    }
};
#pragma mark 召唤水晶 END

#pragma mark -q
#pragma mark 占星阵任务 BEGIN
class ReqAstrologyTaskInfo : public ProtocolRequest
{
public:
    ReqAstrologyTaskInfo()
    {
        protocol = 1113100;
    }
};

class ReqAstrologyTaskSubmit : public ProtocolRequest
{
public:
    int32_t idx;    // 任务id
    
    int32_t heros_count;
    PSBackpackData heros[100];  // 英雄
    
    ReqAstrologyTaskSubmit()
    {
        protocol = 1113101;
        
        idx = 0;
    }
};
#pragma mark 占星阵任务 END

#pragma mark -q
#pragma mark 酒馆达标 BEGIN
class ReqPubArriveInfo : public ProtocolRequest
{
public:
    ReqPubArriveInfo()
    {
        protocol = 1113106;
    }
};

class ReqPubArriveGot : public ProtocolRequest
{
public:
    int32_t idx;    // 任务id
    
    ReqPubArriveGot()
    {
        protocol = 1113107;
        
        idx = 0;
    }
};
#pragma mark 酒馆达标 END

#pragma mark 商店模块 BEGIN

// 钻石购买物品
class ReqBuyItem : public ProtocolRequest {
public:
    int32_t item_type;  // 物品类型
    int32_t item_num;   // 购买数量
    
    ReqBuyItem() {
        protocol = 1114000;
        item_type = 0;
        item_num = 0;
    }
};

// 购买角色上限.
class ReqShopBuyHeroCapacity : public ProtocolRequest {
public:
    ReqShopBuyHeroCapacity() {
        protocol = 1114003;
    }
};

// 钻石购买高级召唤卷轴
class ReqShopBuySummonTicket : public ProtocolRequest {
public:
    int32_t ticket_id; //1单张购买 10多张购买
    int32_t buy_num;
    
    ReqShopBuySummonTicket() {
        protocol = 1114010;
        
        ticket_id = 0;
        buy_num = 0;
    }
};

#pragma mark 商店模块 END

#pragma mark -
#pragma mark 邮件模块 BEGIN

class ReqMailList : public ProtocolRequest {
public:
    ReqMailList() {
        protocol = 1115000;
    }
};

// 处理邮件请求
class ReqMailDeal : public ProtocolRequest {
public:
    int32_t type;       // 0: 邮件已读  1: 接收邮件礼物   2: 删除邮件
    int64_t mail_id;    // 邮ID

    ReqMailDeal() {
        protocol = 1115001;

        type = 0;
        mail_id = 0;
    }
};

//// 一键领取
//class ReqMailCollectionAll : public ProtocolRequest {
//public:
//    ReqMailCollectionAll() {
//        protocol = 1115002;
//    }
//};

#pragma mark 邮件模块 END

#pragma mark -
#pragma mark 兑换码模块 BEGIN
class ReqCdk : public ProtocolRequest {
public:
    int64_t cdk;
    
    ReqCdk() {
        protocol = 1115010;
        cdk = 0;
    }
};

#pragma mark 兑换码模块 END

#pragma mark -
#pragma mark 试炼模块 BEGIN

//请求试炼配置
class ReqTrialCfg : public ProtocolRequest {
public:
    ReqTrialCfg() {
        protocol = 1116000;
    }
};

//请求试炼通关
class ReqTrialPass : public ProtocolRequest {
public:
    int8_t is_win ; //0试炼失败 1通关
    ReqTrialPass() {
        protocol = 1116001;
        is_win = 0;
    }
};

//请求试炼宝箱
class ReqTrialBox : public ProtocolRequest {
public:
    int8_t idx; //宝箱索引值
    ReqTrialBox() {
        protocol = 1116002;
        idx = 0;
    }
};

//请求试炼重置
class ReqTrialReset : public ProtocolRequest {
public:
    ReqTrialReset() {
        protocol = 1116003;
    }
};


/*
 ** 勇者试炼商店
 */
class ReqTrialShopList : public ProtocolRequest
{
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqTrialShopList()
    {
        protocol = 1116005;
        index = 0;
    }
};

class ReqTrialShopBuy : public ProtocolRequest
{
public:
    int32_t index; //购买物品序号
    ReqTrialShopBuy()
    {
        protocol = 1116006;
    }
};


// 试炼敌人列表
class ReqTrialBattleList : public ProtocolRequest
{
public:
    ReqTrialBattleList()
    {
        protocol = 1116007;
    }
};


#pragma mark 试炼模块 END


#pragma mark -
#pragma mark 点金模块 BEGIN

// 请求点金数据
class ReqBuyGoldLog : public ProtocolRequest {
public:
    ReqBuyGoldLog() {
        protocol = 1117000;
    }
};

// 点金购买.
class ReqBuyGold : public ProtocolRequest {
public:
    int32_t idx;    // 购买了那个金币
    ReqBuyGold() {
        protocol = 1117001;
    }
};



#pragma mark 点金模块 END



#pragma mark -
#pragma mark PVP模块 BEGIN

// PVP数据获取
class ReqPvpData : public ProtocolRequest {
public:
    ReqPvpData() {
        protocol = 1118001;
    }
};


// PVP开始战斗
class ReqPvpBattle : public ProtocolRequest {
public:
    int64_t player_id;  // 选择了那一个玩家
    ReqPvpBattle() {
        protocol = 1118002;
    }
};

// PVP结束战斗
class ReqPvpBattleEnd : public ProtocolRequest {
public:
    int64_t battle_id;  // 战斗id
    int8_t is_win;      // 是否已经胜利
    ReqPvpBattleEnd() {
        protocol = 1118003;
        is_win = false;
    }
};


// 请求回放数据
class ReqPvpBattleHistory : public ProtocolRequest {
public:
    int64_t battle_id;          // 战斗id
    ReqPvpBattleHistory() {
        protocol = 1118004;
        battle_id = 0;
    }
};

// 历史列表
class ReqPvpBattleHistoryList : public ProtocolRequest {
public:
    ReqPvpBattleHistoryList() {
        protocol = 1118005;
    }
};

// 商店刷新
class ReqPvpShopList : public ProtocolRequest {
public:
    int32_t index; //0 开机请求 1 手动刷新
    ReqPvpShopList()
    {
        protocol = 1118006;
        index = 0;
    }
};

// 购买物品序号
class ReqPvpShopBuy : public ProtocolRequest
{
public:
    int32_t index; // 购买物品序号
    ReqPvpShopBuy()
    {
        protocol = 1118007;
        index = 0;
    }
};


#pragma mark PVP模块 END

#pragma mark-
#pragma mark 七天目标 BEGIN

//请求七天目标数据
class ReqSevenDayTargetData : public ProtocolRequest {
public:
    ReqSevenDayTargetData() {
        protocol = 1121000;
    }
};

//请求七天目标奖励领取
class ReqSevenDayTargetReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqSevenDayTargetReward() {
        protocol = 1121002;
        idx = 0;
    }
};

//请求七天目标奖励领取
class ReqSevenDayTargetBoxReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqSevenDayTargetBoxReward() {
        protocol = 1121003;
    }
};

#pragma mark 七天登录 BEGIN

//请求七天目登录
class ReqSevenDayData : public ProtocolRequest {
public:
    ReqSevenDayData() {
        protocol = 1122000;
    }
};

//请求七天登录奖励领取
class ReqSevenDayReward : public ProtocolRequest {
public:
    int32_t day;
    ReqSevenDayReward() {
        protocol = 1122001;
        day = 0;
    }
};


#pragma mark 七天登录 END

#pragma mark -
#pragma mark 英雄降临 BEGIN

class ReqHeroArriveReward : public ProtocolRequest {
public:
    int32_t idx;
    ReqHeroArriveReward() {
        protocol = 1123001;
        idx = 0;
    }
};


#pragma mark 英雄降临 END

#pragma mark -
#pragma mark 限时活动 BEGIN
// 每月福利
class ReqMouthWelfareList : public ProtocolRequest
{
public:
    ReqMouthWelfareList()
    {
        protocol = 1126001;
    }
};

// 每日福利
class ReqDailyWelfareList : public ProtocolRequest
{
public:
    ReqDailyWelfareList()
    {
        protocol = 1126002;
    }
};

#pragma mark 限时活动 END

#pragma pack()

#endif

