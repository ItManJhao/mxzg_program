//
//  ProtocolResponse.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef AVT_ProtocolResponse_h
#define AVT_ProtocolResponse_h

#include "NetProtocol.h"
#include "../../Common/CommonDefine.h"

#pragma pack(1)

class ProtocolResponse : public ProtocolBase
{
    
};

#pragma mark -------错误模块-------
class ResError : public ProtocolBase
{
public:
    int32_t error; // 错误编码
    bool reload; // 是否需要重新加载游戏
    char msg[1000]; // 服务器端返回错误数据
    
    ResError()
    {
        protocol = 1200000;
        error = 0;
        reload = false;
        memset(msg, 0, sizeof(msg));
    }
};

#pragma mark -----系统模块-----

// 心跳包
class ResHeartbeat : public ProtocolResponse {
public:
    int64_t server_time;
    ResHeartbeat() {
        protocol = 2201001;
        server_time = 0;
    }
};

// 全服公告
class ResBroadcast : public ProtocolResponse {
public:
    int show_time;  // 公告显示时长
    char msg[121];
    ResBroadcast() {
        memset(msg,0,sizeof(msg));
        protocol = 2201002;
    }
};

#pragma mark -------登陆模块-------
class ResLogin : public ProtocolResponse
{
public:
    int64_t rid;
    int64_t server_time;
    int8_t zone;
    int32_t online_time;
    int32_t under_attack_time_left;
    
    ResLogin() {
        protocol = 1201001;
        rid = 0;
        server_time = 0;
        zone = 0;
        online_time = 0;
        under_attack_time_left = 0;
    }
};

class ResInit : public ProtocolResponse
{
public:
    int64_t rid;
    ResInit()
    {
        protocol = 1201002;
    }
};

class ResReLogin : public ProtocolResponse {
public:
    ResReLogin() {
        protocol = 1201004;
    }
};

#pragma mark -------角色模块-------

class ResRoleInfo : public ProtocolResponse
{
public:
    int32_t gem;
    int64_t gold;
    int32_t energy;
    int32_t exp;
    int32_t crown;
    int32_t level;
    int32_t head_id;            // 头像
    int32_t image_id;           // 形象
    char nick[NAME_LENGTH];
    
    int32_t last_request_time;
    int8_t lang;
    int32_t role_create_time;   // 角色创建时间
    int64_t clan_id;            // 军团id
    bool is_rename;             // 是否更改过名字
    int32_t guide_serial;       // 新手指引序号
    int32_t server_create_time; // 开服时间
    
    int32_t vip_level;          // VIP等级
    int32_t vip_exp;            // VIP经验
    
    ResRoleInfo() {
        protocol = 1202001;
        memset(nick, 0, sizeof(nick));
        
        gem = 0;
        gold = 0;
        energy = 0;
        exp = 0;
        crown = 0;
        level = 0;
        head_id = 0;
        image_id = 0;
        last_request_time = 0;
        lang = 0;
        role_create_time = 0;
        clan_id = 0;
        is_rename = false;
        guide_serial = 0;
        
        vip_level = 0;
        vip_exp = 0;
    }
};

// 角色删除，获得相应包，则代表删除成功
class ResRoleDelete : public ProtocolResponse
{
public:
    ResRoleDelete()
    {
        protocol = 1202002;
    }
};

class ResRoleEditNick : public ProtocolResponse
{
public:
    int16_t status;   // 0: 成功, >0: 失败
    
    ResRoleEditNick()
    {
        protocol = 1202003;
        
        status = 0;
    }
};

// 查看玩家信息
class ResPlayerInfo : public ProtocolResponse
{
public:
    int64_t player_id;          // 玩家的rid
    int64_t clan_id;            // 军团id
    char nick[NAME_LENGTH];     // 玩家名字
    int16_t level;              // 等级
    int32_t server_id;          // 玩家区号
    char clan_name[NAME_LENGTH];// 军团名字
    int32_t clan_level;         // 军团等级
    int32_t rank;               // pvp分数
    int32_t battle;             // 战斗力
    int32_t list_count;
    PSHeroData hero_data[1000];    // 上阵英雄的信息
    ResPlayerInfo() {
        protocol = 1202004;
        player_id = 0;
        clan_id = 0;
        memset(nick, 0, sizeof(nick));
        memset(clan_name, 0, sizeof(clan_name));
        memset(hero_data, 0, sizeof(hero_data));
    }
};


class ResGuideSummon : public ProtocolResponse {
public:
    int64_t hero_id;
    ResGuideSummon() {
        protocol = 1202006;
        hero_id = 0;
    }
};

// 角色升级奖励
class ResRoleUpgradeReward : public ProtocolResponse
{
public:
    int32_t level_before;   // 之前的等级
    int32_t level_current;  // 当前等级
    
    int32_t list_count;
    PSBackpackData data[50];
    
    ResRoleUpgradeReward()
    {
        protocol = 1202012;
        level_before = 0;
        level_current = 0;
        list_count = 0;
    }
};


class ResRadio : public ProtocolResponse {
public:
    int64_t rid;                    // 发送者
    int8_t sex;                     // 性别
    int16_t head;                   // 头像
    char nick[NAME_LENGTH];         // 玩家名字长度
    char msg[150];     // 广播信息
    
    ResRadio() {
        protocol = 1232001;
        memset(nick, 0, sizeof(nick));
        memset(msg, 0, sizeof(msg));
    }
};

#pragma mark -------战斗模块-------
// 关卡通关奖励
class ResChapterEnd : public ProtocolResponse {
public:
    int32_t idx;
    int32_t list_count;
    PSBackpackData list[100];
    ResChapterEnd() {
        protocol = 1203002;
        
        idx = 0;
        list_count = 0;
    }
};

// 挂机奖励列表
class ResChapterItemList : public ProtocolResponse {
public:
    int32_t reward_time;    // 上一次领取资源的时间
    int32_t max_reward_time;// 挂机时间上限
    int32_t gold_num;       // 金币数量
    int32_t exp_num;        // 角色经验。
    int32_t hero_exp_num;   // 英魂数量。背包物品
    int32_t max_fighting;   // 最高战斗力
    
    int32_t list_count;
    PSBackpackData list[100];
    ResChapterItemList() {
        protocol = 1203004;
    }
};

// 获取奖励挂机
class ResChapterItemReward : public ProtocolResponse {
public:
    int32_t reward_time;    // 上一次领取资源的时间
    int32_t gold_num;       // 金币数量
    int32_t exp_num;        // 角色经验。
    int32_t hero_exp_num;   // 英魂数量。背包物品

    int32_t list_count;
    PSBackpackData list[100];
    ResChapterItemReward() {
        protocol = 1203005;
    }
};

// 关卡数据
class ResChapterData : public ProtocolResponse {
public:
    int32_t res_reward_time;// 上一次领取资源的时间
    
    int32_t now_idx;
    int32_t max_idx;

//    int32_t idle_list_count; // 挂机队伍
//    int64_t idle_list[20];
    
    int32_t battle_list_count;// 战斗队伍
    int64_t battle_list[10];
    ResChapterData() {
        protocol = 1203007;
        
        res_reward_time = 0;
        
        now_idx = 0;
        max_idx = 0;
                
//        idle_list_count = 0;
        battle_list_count = 0;
    }
};


// 关卡首通奖励列表
class ResChapterRewardList : public ProtocolResponse {
public:
    int32_t list_count;
    int32_t list[200];     // 已经领取的列表
    ResChapterRewardList() {
        protocol = 1203010;
        list_count = 0;
    }
};


// 布阵数据
class ResLineUpData : public ProtocolResponse {
public:
    int32_t list_count;
    PSLineUpData list[100];    // 英雄属性
    ResLineUpData() {
        protocol = 1203101;
        list_count = 0;
    }
};

// 幻境之塔战斗数据
class ResTowerData : public ProtocolResponse {
public:
    int32_t stage;      // 当前处于那一层。配置表相关数据按照stage + 1
    int32_t energy;     // 剩余体力值
    int32_t energy_time;// 上一次恢复体力的时间
    ResTowerData() {
        protocol = 1203200;
        stage = 0;
        energy = 0;
        energy_time = 0;
    }
};

class ResTowerBattleEnd : public ProtocolResponse {
public:
    int32_t stage;              // 通关的层数
    int32_t energy_time;        // 上一次恢复体力的时间
    int32_t energy;             // 剩余的体力值
    int32_t list_count;         // 奖励列表
    PSBackpackData list[100];
    ResTowerBattleEnd() {
        protocol = 1203201;
        stage = 0;
        energy_time = 0;
        list_count = 0;
    }
};

// 体力购买返回结果
class ResTowerEnergyBuy : public ProtocolResponse {
public:
    int32_t status;     // 购买状态 0: 成功  1：钻石不足  2：未知错误
    int32_t energy;     // 购买之后。体力值为多少。无视体力上限
    ResTowerEnergyBuy() {
        protocol = 1203202;
        status = 0;
        energy = 0;
    }
};

// 无限塔首通奖励列表
class ResTowerRewardList : public ProtocolResponse {
public:
    int32_t list_count;
    int32_t list[200];     // 已经领取的列表
    ResTowerRewardList() {
        protocol = 1203203;
        list_count = 0;
    }
};

// 快速战斗初始数据
class ReQuickBattleInitData : public ProtocolResponse {
public:
    int32_t battle_count;   //已快速战斗次数
    ReQuickBattleInitData() {
        protocol = 1203207;
        battle_count = 0;
    }
};

// 快速战斗奖励
class ReQuickBattleReward : public ProtocolResponse {
public:
    int32_t battle_count;   //已快速战斗次数
    int32_t reward_list;
    PSBackpackData list[1000];
    ReQuickBattleReward() {
        protocol = 1203208;
        battle_count = 0;
        reward_list = 0;
    }
};


#pragma mark -------英雄模块-------
// 所有拥有英雄返回列表
class ResHeroList: public ProtocolResponse {
public:
    int32_t hero_capacity;  //  英雄容量
    int32_t list_count;
    PSHeroData list[5000];
    
    ResHeroList(){
        protocol = 1204001;
        list_count = 0;
        hero_capacity = 0;
    }
};


// 获取召唤进度
class ResHeroSummonCount : public ProtocolResponse {
public:
    int32_t next_free_time[3];
    int8_t free[3]; // 0免费 1不免费 2禁用
    ResHeroSummonCount() {
        protocol = 1204004;
    }
};


class ResHeroSummonData : public ProtocolStruct{
public:
    int32_t item_type;  //类型
    
    ResHeroSummonData(){
        item_type = 0;
    }
};

// 招募英雄数据返回列表
class ResHeroSummonList: public ProtocolResponse {
public:
    int32_t list_count;
    ResHeroSummonData list[10];
    
    ResHeroSummonList(){
        protocol = 1204002;
        list_count = 0;
    }
};

// 请求召唤进度奖励
class ResHeroSummonAward : public ProtocolResponse {
public:
    int32_t list_count;
    ResHeroSummonData list[10];
    
    ResHeroSummonAward() {
        protocol = 1204005;
    }
};

// 免费召唤时间数据返回
class ResHeroSummonFreeTime: public ProtocolResponse {
public:
    int32_t free_time;
    
    ResHeroSummonFreeTime(){
        protocol = 1204003;
        free_time = 0;
    }
};

class ResHeroUpgradeLevel : public ProtocolResponse {
public:
    int64_t hero_id;    // 英雄id
    int32_t hero_level; // 英雄升级后的等级
    int32_t hero_exp;   // 英雄升级后的经验
    
    ResHeroUpgradeLevel() {
        protocol = 1204008;
        hero_id = 0;
        hero_level = 0;
        hero_exp = 0;
    }
};

class ResFightHerolist : public ProtocolResponse{
public:
    int32_t list_count;
    PSFightHeroData list[5];              //  最多5个阵容
    ResFightHerolist() {
        protocol = 1204012;
        list_count = 0;
    }
};

// 英雄图鉴已领取奖励列表.(PS: 获取新类型英雄时.玩家可以领取钻石奖励 SystemTable->hero_illustrated_gem)
class ResIllustratReward : public ProtocolResponse {
public:
    int32_t list_count;
    PSIllustratData list[1000];
    ResIllustratReward() {
        protocol = 1204013;
        list_count = 0;
    }
};

//添加新图鉴
class ResIllustratActive : public ProtocolResponse {
public:
    int32_t hero_type;
    int32_t star;
    ResIllustratActive() {
        protocol = 1204014;
        hero_type = 0;
        star = 0;
    }
};


// 英雄突破
class ResHeroLimitUp : public ProtocolResponse {
public:
    int64_t hero_id;
    int16_t up_type;    // 突破的类型
    int16_t level;      // 突破后的等级
    ResHeroLimitUp() {
        protocol = 1204016;
        up_type = 0;
        level = 0;
    }
};

class ResHeroUpLevel : public ProtocolResponse {
public:
    int64_t hero_id;    // 英雄id
    int32_t hero_level; // 英雄升级后的等级
    
    ResHeroUpLevel() {
        protocol = 1204018;
        hero_id = 0;
        hero_level = 0;
    }
};

class ResHeroUpgrade: public ProtocolResponse {
public:
    int64_t hero_id;    // 英雄id
    int32_t hero_stage; // 英雄升阶后的品阶
    
    ResHeroUpgrade() {
        protocol = 1204019;
        hero_id = 0;
        hero_stage = 0;
    }
};

class ResHeroUpStar: public ProtocolResponse {
public:
    int64_t hero_id;    // 英雄id
    int32_t hero_star;  // 英雄升星后的星级
    int32_t item_count; // 返回物品个数
    PSBackpackData item_list[150]; //返回物品
    
    ResHeroUpStar() {
        protocol = 1204020;
        hero_id = 0;
        hero_star = 0;
    }
};


// 合成英雄返回
class ResHeroCompose: public ProtocolResponse {
public:
    PSHeroData hero;                // 合成英雄
    int32_t item_count;             // 返回物品个数
    PSBackpackData item_list[150];  // 返回物品
    
    ResHeroCompose() {
        protocol = 1204021;
        item_count = 0;
    }
};

// 英雄装备
class ResHeroEquip : public ProtocolResponse {
public:
    int32_t count;
    PSHeroEquipData equip_list[500];
    ResHeroEquip(){
        protocol = 1204022;
        count = 0;
    }
};

//装备穿戴，更换
class ResHeroEquipChange : public ProtocolResponse {
public:
    int64_t hero_id;
    int8_t place;
    PSEquipData equip;
    ResHeroEquipChange(){
        protocol = 1204023;
        hero_id = 0;
        place = 0;
    }
};

//装备卸下
class ResHeroEquipDisboard : public ProtocolResponse {
public:
    int64_t hero_id;
    int8_t place;
    PSEquipData equip;
    ResHeroEquipDisboard(){
        protocol = 1204024;
        hero_id = 0;
        place = 0;
    }
};

//装备一键穿戴
class ResHeroEquipOneKeyWear : public ProtocolResponse {
public:
    int64_t hero_id;
    int32_t count;
    PSEquipData equip[4];
    ResHeroEquipOneKeyWear(){
        protocol = 1204025;
        hero_id = 0;
        count = 0;
    }
};

//装备一键卸载
class ResHeroEquipOneKeyDisboard : public ProtocolResponse {
public:
    int64_t hero_id;
    int32_t count;
    PSEquipData equip[4];
    ResHeroEquipOneKeyDisboard(){
        protocol = 1204026;
        hero_id = 0;
        count = 0;
    }
};


#pragma mark -------背包模块-------
class ResBackpackList : public ProtocolResponse {
public:
    int32_t list_count;
    PSBackpackData list[150];
    
    ResBackpackList() {
        protocol = 1205001;
        list_count = 0;
    }
};

class ResBackpackUseItem : public ProtocolResponse {
public:
    int32_t item_type;
    int32_t item_num;
    ResBackpackUseItem() {
        protocol = 1205002;
        item_type = 0;
        item_num = 0;
    }
};

//获得背包物品
class ResBackpackGain : public ProtocolResponse {
public:
    int32_t list_count;
    PSBackpackData list[50];
    
    ResBackpackGain() {
        protocol = 1205003;
        list_count = 0;
    }
};

//装备合成
class ResMakeEquip : public ProtocolResponse {
public:
    int8_t count;
    PSBackpackData equip[100];
    ResMakeEquip(){
        protocol = 1205004;
        count = 0;
    }
};

//装备一键合成
class ResOneKeyMakeEquip : public ProtocolResponse {
public:
    int32_t count;
    PSBackpackData equip[100];
    ResOneKeyMakeEquip(){
        protocol = 1205005;
        count = 0;
    }
};

//宝箱开启
class ResOpenBoxReward : public ProtocolResponse {
public:
    int32_t item_type;
    int32_t use_num;
    int32_t count;
    PSBackpackData list[100];
    ResOpenBoxReward(){
        protocol = 1205006;
        item_type = 0;
        use_num = 0;
        count = 0;
    }
};

//碎片开启
class ResPieceReward : public ProtocolResponse {
public:
    int32_t item_type;
    int32_t count;
    PSHeroData hero;
    ResPieceReward(){
        protocol = 1205007;
        item_type = 0;
        count = 0;
    }
};


#pragma mark -------市场模块-------
class ResMarketList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[6]; //物品
    
    int32_t refresh_num; // 钻石刷新次数
    
    ResMarketList()
    {
        protocol = 1205101;
        freeRefresh = 0;
        list_count = 0;
        refresh_num = 0;
    }
};


// 已完成订单列表
class ResShopRechargeCheck : public ProtocolResponse {
public:
    int32_t list_count;     // 列表长度
    int32_t list_idx[5];    // 商品idx列表
    ResShopRechargeCheck(){
        protocol = 1220000;
    }
};

// vip奖励购买
class ResVipRewardBuy : public ProtocolResponse {
public:
    int32_t list_count;         // 列表长度
    PSBackpackData list[5];     // 背包数据
    ResVipRewardBuy(){
        protocol = 1220004;
        list_count = 0;
    }
};

// 曾经购买了那个vip奖励
class ResVipRewardLog : public ProtocolResponse {
public:
    int8_t is_reward;           // 今天是否已经领取过奖励
    int32_t list_count;         // 列表长度
    int32_t list[5];            // 已经购买过的
    ResVipRewardLog(){
        protocol = 1220005;
        list_count = 0;
    }
};



// 曾经购买的日常礼包
class ResDayLimitLog : public ProtocolResponse {
public:
    int8_t is_reward;           // 今天是否已经领取过奖励
    int32_t list_count;         // 列表长度
    PSDayLimitData list[5];     // 已经购买过的
    ResDayLimitLog(){
        protocol = 1220006;
        list_count = 0;
    }
};


// 每日首充进度
class ResDailyFirstRecharge : public ProtocolResponse
{
public:
    int8_t is_reward;       // 今天是否已领取过奖励 0未领取 1已领取
    int32_t completed;      // 充值进度
    
    ResDailyFirstRecharge()
    {
        protocol = 1220008;
        is_reward = 0;
        completed = 0;
    }
};

// 每日首充奖励
class ResDailyFirstRechargeReward : public ProtocolResponse
{
public:
    int32_t list_count;
    PSBackpackData list[5];
    
    ResDailyFirstRechargeReward()
    {
        protocol = 1220009;
        list_count = 0;
    }
};

// 超值首充
class RechargeFirstData : public ProtocolStruct
{
public:
    int32_t type; //1(6元) 2(100元)
    int32_t idx; // 礼包序号
    int8_t state; //奖品状态 0 不可领 1 未领取 2已领取
    
    RechargeFirstData()
    {
        type = 0;
        idx = 0;
        state = 0;
    }
};
class ResRechargeFirst : public ProtocolResponse
{
public:
    int32_t completed; // 充值进度
    int32_t list_count;
    RechargeFirstData data[2];
    
    ResRechargeFirst()
    {
        protocol = 1220012;
        completed = 0;
        list_count = 0;
    }
};

class ResRechargeFirstReward : public ProtocolResponse
{
public:
    int32_t type; //1(6元) 2(100元)
    int32_t list_count;
    PSBackpackData list[10];
    
    ResRechargeFirstReward()
    {
        protocol = 1220013;
        list_count = 0;
    }
};


// 特权礼包数据
class PrivilegeGiftData : public ProtocolStruct
{
public:
    int32_t idx;        // 对应配置表的id
    int32_t buy_time;   // 可以购买的时间戳
    
    PrivilegeGiftData()
    {
        idx = 0;
        buy_time = 0;
    }
};

// 特权礼包
class ResPrivilegeGiftAddOrUpdate : public ProtocolResponse
{
public:
    int32_t list_count;
    PrivilegeGiftData data[100];
    
    ResPrivilegeGiftAddOrUpdate()
    {
        protocol = 1220014;
        list_count = 0;
    }
};

// 每日累充
class DailyTotalRechargeData : public ProtocolStruct
{
public:
    int32_t idx;        // 对应配置表的id
    int32_t is_got;     // 是否已经领取
    
    DailyTotalRechargeData()
    {
        idx = 0;
        is_got = 0;
    }
};

class ResDailyTotalRecharge : public ProtocolResponse
{
public:
    int32_t list_count;
    DailyTotalRechargeData data[100];
    
    ResDailyTotalRecharge()
    {
        protocol = 1220016;
        list_count = 0;
    }
};


#pragma mark -------聊天模块-------
class ResChatData: public ProtocolResponse {
public:
    int8_t chat_type;               // 1.系统  2.世界  3.军团  4.喇叭  5.私聊  (组队未设置.)
    int64_t player_id;              // 玩家id (0 为系统)
    int64_t friend_id;              // 好友id
    int64_t clan_id;                // 军团id (无 军团为0)
    int32_t send_time;              // 发送时间
    int16_t player_level;           // 玩家等级
    int8_t is_vip;                  // 是否是会员
    int16_t head_id;                // 头像
    char player_name[NAME_LENGTH];  // 玩家昵称 (系统为空)
    char clan_name[NAME_LENGTH];    // 军团名称
    char chat_content[200];         // 聊天内容
    ResChatData() {
        protocol = 1206001;
        chat_type = 0;
        player_id = 0;
        friend_id = 0;
        clan_id = 0;
        send_time = 0;
        player_level = 0;
        is_vip = 0;
        memset(player_name, 0, sizeof(player_name));
        memset(clan_name, 0, sizeof(clan_name));
        memset(chat_content, 0, sizeof(chat_content));
    }
};

#pragma mark -----------军团模块-----------
class ResClanMemberData : public ProtocolStruct {
public:
    int64_t rid;        // 玩家id
    char nick[NAME_LENGTH];
    int32_t rank;       // 玩家排名
    int32_t level;      // 玩家等级
    int8_t position;    // 0：普通成员，1：军团长；2：军团长老
    
    ResClanMemberData() {
        rid = 0;
        memset(nick, 0, sizeof(nick));
        rank = 0;
        level = 0;
        position = 0;
    }
};

class ResClanInfo : public ProtocolResponse {
public:
    int64_t clan_id;              // 军团ID
    int32_t clan_photo;
    int32_t clan_level;
    int32_t clan_exp;
    char clan_notice[CLAN_DESC_LENGTH];// 军团简介
    char clan_name[NAME_LENGTH];  // 军团名称
    int32_t list_count;           // 军团成员长度
    ResClanMemberData list[50];
    
    ResClanInfo() {
        protocol = 1207001;
        clan_id = 0;
        
        memset(clan_notice, 0, sizeof(clan_notice));
        memset(clan_name, 0, sizeof(clan_name));
        
        list_count = 0;
    }
};

class ResClanData : public ProtocolStruct {
public:
    int64_t clan_id;
    char clan_name[NAME_LENGTH];  //军团名称
    char clan_notice[301];
    
    ResClanData() {
        clan_id = 0;
        memset(clan_name, 0, sizeof(clan_name));
    }
};


class ResClanCreate : public ProtocolResponse {
public:
    int32_t error_code; // 0：创建成功，其他则为对应错误码，根据错误码显示对应错误提示
    int64_t clan_id;
    
    ResClanCreate() {
        protocol = 1207002;
        
        error_code = 0;
        clan_id = 0;
    }
};


class ResClanSearchData : public ProtocolStruct {
public:
    int64_t clan_id;
    char clan_name[NAME_LENGTH];  // 军团名称
    int32_t clan_member_num;      // 人员个数
    ResClanSearchData() {
        clan_id = 0;
        memset(clan_name, 0, sizeof(clan_name));
        clan_member_num = 0;
    }
};

class ResClanSearch : public ProtocolResponse {
public:
    int32_t list_count;
    ResClanSearchData list[50];
    
    ResClanSearch() {
        protocol = 1207003;
        
        list_count = 0;
    }
};


class ResClanJoin : public ProtocolResponse {
public :
    int64_t clan_id;    // 军团id
    int8_t join_type;   // 0：审核成功， 1：待审核， 2：申请失败
    ResClanJoin() {
        protocol = 1207004;
        clan_id = 0;
        join_type = 0;
    }
};

// 接收操作军团消息提示响应
class ResClanMsgInfoData : public ProtocolStruct {
public :
    int64_t manager_id;             // 操作人的rid;
    int64_t member_id;              // 被操作人的rid;
    int8_t info_type;               // 1. 同意成员申请 2. 退出军团 3. 管理员踢掉成员 4. 成员被升职  5.降职 6. 加入军团
    char member_name[NAME_LENGTH];  // 被操作人名
    char manager_name[NAME_LENGTH]; // 操作人名
    int8_t position;                // 操作后的职位
    int32_t time;                   // 操作时间
    ResClanMsgInfoData() {
        manager_id = 0;
        member_id = 0;
        info_type = 0;
        memset(member_name, 0, sizeof(member_name));
        memset(manager_name, 0, sizeof(manager_name));
        position = 0;
        time = 0;
    }
};


class ResClanMsgInfo : public ProtocolResponse {
public:
    int32_t list_count;
    ResClanMsgInfoData list[50];
    
    ResClanMsgInfo() {
        protocol = 1207006;
        
        list_count = 0;
    }
    
};


// 存储请求的成员信息
class ResClanReqMsgData : public ProtocolStruct {
public:
    int64_t role_id;   // 玩家id
    char nick[NAME_LENGTH];
    int32_t level;    // 玩家等级
    int32_t crown;   // 玩家皇冠数
    
    ResClanReqMsgData() {
        role_id = 0;
        memset(nick, 0, sizeof(nick));
        level = 0;
        crown = 0;
    }
};

// 响应成员入团请求
class ResClanReqMsgInfo : public ProtocolResponse {
    public :
    int32_t list_count;
    ResClanReqMsgData list[100];
    ResClanReqMsgInfo() {
        protocol = 1207007;
        
        list_count = 0;
    }
};

// 响应 同意成员入团请求
class ResClanReqAgree : public ProtocolResponse {
public:
    int64_t clan_id = 0;
    
    ResClanReqAgree() {
        protocol = 1207008;
        clan_id = 0;
    }
};

// 响应 刷新军团所有信息
class ResUpdateAllClanInfo : public ProtocolResponse {
public:
    ResUpdateAllClanInfo() {
        protocol = 1207009;
    }
};


// 响应升职操作
class ResClanChangePos : public ProtocolResponse {
public:
    int8_t  status; // 升职状态  1：成功  0:失败 2: 自己被提出去了.
    
    ResClanChangePos() {
        protocol = 1207011;
    }
};

// 军团聊天消息
class ResClanChatData : public ProtocolStruct {
public:
    int64_t manager_id;				// 操作人的id.可能玩家会退出军团
    int32_t time;     				// 操作时间
    char manager_name[NAME_LENGTH]; // 操作人名
    char chat_content[CHAT_LENGTH]; // 聊天内容
    ResClanChatData() {
        manager_id = 0;
        time = 0;
        memset(manager_name, 0, sizeof(manager_name));
        memset(chat_content, 0, sizeof(chat_content));
    }
};

// 军团聊天列表
class ResClanChatList : public ProtocolResponse {
public:
    int8_t chat_count;
    // 动态解析
    ResClanChatData       list[100];
    ResClanChatList() {
        protocol = 1207020;
    }
};

// 单条职位变更信息
class ResClanMsgUpdate : public ProtocolResponse {
public:
    ResClanMsgInfoData msg_data;
    ResClanMsgUpdate() {
        protocol = 1207021;
    }
};

// 公会副本结束
class ResClanMissionEnd : public ProtocolResponse {
public:
    int32_t clan_exp;
    int32_t list_count;
    PSBackpackData list[100];
    ResClanMissionEnd() {
        protocol = 1207052;
        clan_exp = 0;
        list_count = 0;
    }
};

// 军团商店 列表
class ResClanShopList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[50]; //物品
    
    ResClanShopList()
    {
        protocol = 1207061;
        freeRefresh = 0;
        list_count = 0;
    }
};
#pragma mark -------副本模块-------
//  主线已通关据
//class ResMainLineChapter: public ProtocolResponse {
//public:
//    int32_t mission_type;   //  这个是返回当前通关的最新的一个关卡
//    ResMainLineChapter() {
//        protocol = 1208001;
//        mission_type = 0;
//    };
//};


class ResMainLineChapter: public ProtocolResponse {
public:
    int32_t mission_id;         // 保存通关关卡最大值
    int32_t list_count;
    PSMainLineData list[100];   // 每天清空
    ResMainLineChapter() {
        protocol = 1208001;
        list_count = 0;
    };
};


// 日常数据列表
class ResDailyAdventureList : public ProtocolResponse {
public:
    int32_t list_count;
    PSDailyAdventureData list[20];
    ResDailyAdventureList() {
        protocol = 1208002;
        list_count = 0;
    };
};

// 副本房间列表
class ResDungeonRoomList : public ProtocolResponse{
public:
    int32_t dungeon_type;       // 1.探险. 2.大降临(小降临)
    int32_t list_count;
    ResDungeonRoomList(){
        protocol = 1208100;
        dungeon_type = 0;
        list_count = 0;
    }
};

// 成功创建或加入房间
class ResDungeonJoinRoom :public ProtocolResponse{
public:
    int64_t room_id;
    int32_t dungeon_type;    // 1.探险. 2.大降临(小降临)
    int32_t type;            // 副本类型.刷新界面用的
    int8_t  degree;          // 副本难度
    int8_t  statu;           // 0:成功加入.1: 已经开始战斗. 2: 密码错误. 3: 人数已满
    ResDungeonJoinRoom(){
        protocol = 1208101;
        room_id = 0;
        dungeon_type = 0;
        type = 0;
        degree = 0;
    }
};

// 房间座位信息
class ResDungeonSeatList : public ProtocolResponse {
public:
    PSSeatData list[4];
    ResDungeonSeatList() {
        protocol = 1208103;
    }
};

// 房主更改了房间设置
class ResDungeonSetting : public ProtocolResponse {
public:
    int64_t room_id;         // 房间id
    int32_t dungeon_type;    // 1.探险. 2.大降临(小降临)
    int32_t type;            // 副本类型.刷新界面用的
    int8_t  degree;          // 副本难度
    int32_t level_limit;     // 等级限制
    ResDungeonSetting() {
        protocol = 1208104;
        room_id = 0;
        dungeon_type = 0;
        type = 0;
        degree = 0;
        level_limit = 0;
    }
};

// 好友邀请.
class ResDungeonFriendsInvite :public ProtocolResponse{
public:
    int64_t room_id;        // 房间ID.用于记录.回复
    int64_t player_id;      // 好友的id
    int32_t dungeon_type;    // 1.探险. 2.大降临(小降临)
    int32_t type;           // 副本类型.
    int8_t  degree;         // 副本的难度
    ResDungeonFriendsInvite(){
        protocol = 1208105;
        player_id = 0;
        dungeon_type = 0;
        type = 0;
        degree = 0;
    }
};

// 被踢出了房间
class ResDungeonBekickedRoom : public ProtocolResponse {
public:
    ResDungeonBekickedRoom() {
        protocol = 1208107;
    }
};

// 副本房间消息.
class ResDungeonChat : public ProtocolResponse{
public:
    int8_t chat_type;   // 1:聊天信息. 2: 成为房主 , 3: 加入了房间 , 4: 离开了房间 , 5: 被踢出了房间
    int64_t player_id;  // 玩家id.点击时需要
    char player_name[NAME_LENGTH];  // 说话的人的名字
    char chat_content[200];         // 说话的内容
    ResDungeonChat(){
        protocol = 1208110;
        chat_type = 0;
        player_id = 0;
        memset(player_name, '\0', sizeof(player_name));
        memset(chat_content, '\0', sizeof(chat_content));
    }
};


class ResDungeonBattle : public ProtocolResponse {
public:
    int64_t room_id;
    int32_t dungeon_type;    // 1.探险. 2.大降临(小降临)
    int32_t type;            // 副本类型.
    int8_t  degree;          // 副本的难度
    ResDungeonBattle() {
        protocol = 1208111;
        room_id = 0;
        dungeon_type = 0;
        type = 0;
        degree = 0;
    }
};



#pragma mark -------好友模块-------
class ResFriendsData : public ProtocolStruct {
public:
    int64_t role_id;                // 角色id
    char player_name[NAME_LENGTH];  // 玩家名称
    int32_t player_level;           // 玩家等级
    int32_t crown;                  // 杯数
    int8_t is_vip;                  // vip标志
    int16_t head_id;                // 头像id
    int32_t battle;                 // 战斗力
    int64_t clan_id;                // 军团id
    int16_t clan_icon_id;           // 军团icon id
    char  clan_name[NAME_LENGTH];   // 军团名称
    int8_t online_status;           // 在线状态
    int32_t offline_time;           // 离线时间
    bool is_gived;                  // 是否给好友赠送过友情点
    bool is_gift;                   // 该好友是否给我赠送了友情点
    bool is_reward;                 // 今天是否已经领取好友赠送的道具
    ResFriendsData() {
        role_id = 0;
        memset(player_name, 0, sizeof(player_name));
        player_level = 0;
        is_vip = 0;
        head_id = 0;
        battle = 0;
        clan_id = 0;
        clan_icon_id = 0;
        memset(clan_name, 0, sizeof(clan_name));
        online_status = 0;
        offline_time = 0;
    }
};

// 响应  自己的好友列表
class ResFriendsListInfo : public ProtocolResponse {
public:
    int32_t list_count;
    ResFriendsData list[56];
    
    ResFriendsListInfo() {
        protocol = 1209001;
        
        list_count = 0;
    }
};

// 响应  好友请求列表
class ResFriendsRequestInfo : public ProtocolResponse {
public:
    int32_t list_count;
    ResFriendsData list[56];
    
    ResFriendsRequestInfo() {
        protocol = 1209002;
        
        list_count = 0;
    }
};

// 响应  好友搜索列表
class ResFriendsSearch : public ProtocolResponse {
public:
    int32_t list_count;
    ResFriendsData list[50];
    
    ResFriendsSearch() {
        protocol = 1209003;
        
        list_count = 0;
    }
};

// 响应 添加好友
class ResFriendsAdd : public ProtocolResponse {
public:
    ResFriendsData friends_data;
    
    ResFriendsAdd() {
        protocol = 1209004;
    }
};

// 响应 好友同意添加
class ResFriendsAgree : public ProtocolResponse {
public:
    ResFriendsData friends_data; // 好友请求的好友信息
    
    ResFriendsAgree() {
        protocol = 1209005;
    }
};

// 响应 删除好友
class ResFriendsDelete : public ProtocolResponse {
public:
    ResFriendsData friends_data; // 删除好友的好友信息
    
    ResFriendsDelete() {
        protocol = 1209006;
    }
};


// 好友消息结构
class ResFriendsChatData : public ProtocolStruct {
public:
    int64_t friend_id;  // 好友id
    int64_t manage_id;  // 消息发送者ID
    int32_t time;       // 消息发送时间
    int16_t head_id;    // 头像
    char chat_content[CHAT_LENGTH]; // 聊天内容
    ResFriendsChatData() {
        friend_id = 0;
        manage_id = 0;
        head_id = 0;
        time = 0;
        memset(chat_content, 0, sizeof(chat_content));
    }
};

// 好友消息记录
class ResFriendsChatList : public ProtocolResponse {
public:
    int32_t list_count;
    ResFriendsChatData list[1000];
    ResFriendsChatList() {
        protocol = 1209007;
        list_count = 0;
    }
};


// 好友给我赠送了友情点
class ResFriendsGive: public ProtocolResponse {
public:
    int64_t player_id;
    ResFriendsGive() {
        protocol = 1209008;
        player_id = 0;
    }
};


// 赠送或被赠送时获得的道具
class ResFriendsGift: public ProtocolResponse {
public:
    int32_t list_count;
    PSBackpackData list[5];
    ResFriendsGift() {
        protocol = 1209013;
        list_count = 0;
    }
};

#pragma mark -------元素石模块-------

class ResElemStoneData : public ProtocolStruct {
public:
//    /**
//     * 元素石类型
//     * 火、水、木、光、暗
//     * 小、中、大
//     */
//    typedef enum {
//        EST_VALID = 0,
//        EST_FIRE_SMALL = 11,
//        EST_FIRE_MID = 12,
//        EST_FIRE_BIG = 13,
//        EST_WATER_SMALL = 21,
//        EST_WATER_MID = 22,
//        EST_WATER_BIG = 23,
//        EST_WOOD_SMALL = 31,
//        EST_WOOD_MID = 32,
//        EST_WOOD_BIG = 33,
//        EST_LIGHT_SMALL = 41,
//        EST_LIGHT_MID = 42,
//        EST_LIGHT_BIG = 43,
//        EST_DARK_SMALL = 51,
//        EST_DARK_MID = 52,
//        EST_DARK_BIG = 53,
//    } ElemStoneType;
    int32_t type;    // 类型
    int32_t num;    // 数量
    ResElemStoneData() {
        type = 0;
        num = 0;
    }
};

class ResElemStoneList : public ProtocolResponse{
public:
    ResElemStoneData list[15];
    int32_t list_count;
    
    ResElemStoneList() {
        list_count = 0;
        
        protocol = 1210001;
    }
};

#pragma mark -------排行榜模块-------
class ResRankClanData : public ProtocolStruct {
public:
    int64_t clan_id;        // 战盟id
    int32_t rank;           // 排名
    int32_t crown;          // 皇冠数
    int32_t member_num;     // 战盟成员数
    int32_t member_max;     // 战盟成员上限
    int8_t  clan_icon_id;   // 战盟图标
    char clan_name[NAME_LENGTH];        // 战盟名
    char clan_head_name[NAME_LENGTH];   // 军团长名
    
    ResRankClanData() {
        clan_id = 0;
        rank = 0;
        clan_icon_id = 1;
        crown = 0;
        member_num = 0;
        member_max = 0;
        memset(clan_name, 0, sizeof(clan_name));
        memset(clan_head_name, 0, sizeof(clan_head_name));
    }
};

class ResRankClan : public ProtocolResponse {
public:
    int32_t list_count;
    ResRankClanData list[56];
    
    ResRankClan() {
        protocol = 1211001;
        list_count = 0;
    }
};

class ResRankPlayerData : public ProtocolStruct {
public:
    int64_t rid;                // 玩家id
    int32_t rank;               // 玩家排名
    int32_t crown;              // 玩家皇冠数
    int32_t level;              // 玩家等级
    int64_t clan_id;            // 玩家军团id
    int8_t  clan_icon_id;       // 战盟图标
    char nick[NAME_LENGTH];     // 玩家名字
    char clan_nick[NAME_LENGTH];// 玩家战盟名
    ResRankPlayerData() {
        rid = 0;
        rank = 0;
        crown = 0;
        level = 0;
        clan_id = 0;
        clan_icon_id = 1;
        memset(nick, 0, sizeof(nick));
        memset(clan_nick, 0, sizeof(clan_nick));
    }
};

class ResRankPlayer : public ProtocolResponse {
public:
    int32_t list_count;
    ResRankPlayerData list[56];
    
    ResRankPlayer() {
        protocol = 1211002;
        list_count = 0;
    }
};

// 地牢排行榜
class ResRankDungeonList : public ProtocolResponse {
public:
    int32_t list_count;
    PSRankPlayerData list[56];
    
    ResRankDungeonList() {
        protocol = 1211002;
        list_count = 0;
    }
};

// 幻境之塔排行榜
class ResRankTowerList : public ProtocolResponse {
public:
    PSRankPlayerData self_data;
    
    int32_t list_count;
    PSRankPlayerData list[50];
    ResRankTowerList() {
        protocol = 1211003;
        list_count = 0;
    }
};


// PVP排行榜
class ResRankPvpList : public ProtocolResponse {
public:
    int32_t season_end_time;    // 赛季结束时间
    
    PSRankPlayerData self_data;
    int32_t list_count;
    PSRankPlayerData list[50];
    ResRankPvpList() {
        protocol = 1211004;
        list_count = 0;
    }
};


// 膜拜数据
class ResRankWorshipData : public ProtocolStruct {
public:
    int32_t type;           // 在那一个排行榜膜拜了你
    char name[NAME_LENGTH]; // 玩家名字
    ResRankWorshipData() {
        
    }
};

// 已经膜拜的列表
class ResRankWorshipList : public ProtocolResponse {
public:
    int32_t list_count;
    int32_t list[10];
    ResRankWorshipList() {
        protocol = 1211100;
        list_count = 0;
    }
};

// 离线被膜拜了
class ResRankWorship : public ProtocolResponse {
public:
    int32_t list_count;
    ResRankWorshipData list[10];
    ResRankWorship() {
        protocol = 1211102;
        list_count = 0;
    }
};

#pragma mark -------成就模块-------

//已领取记录
class ResAchievementData : public ProtocolResponse {
public:
    int32_t count;
    int32_t data_count;
    PSAchievementRecord list[100];
    PSAchievementData data_list[100];
    ResAchievementData() {
        protocol = 1212000;
        count = 0;
        data_count = 0;
        
    }
};

class ResUpdateAchievementData : public ProtocolResponse {
public:
    PSAchievementData data;
    ResUpdateAchievementData() {
        protocol = 1212001;
    }
};

class ResAchievementReward : public ProtocolResponse {
public:
    PSAchievementRecord record;
    int32_t count;
    PSBackpackData list[100];
    ResAchievementReward() {
        protocol = 1212002;
        count = 0;
    }
};

class ResDailyData : public ProtocolResponse {
public:
    int32_t point;
    int32_t count;
    PSAchievementData list[100];
    int32_t record_count;
    PSAchievementRecord record_list[100];  // 0 未领取 1 已领取
    int32_t box_count;
    PSDailyBox box_list[100];  // 0 未领取 1 已领取
    ResDailyData() {
        protocol = 1212003;
        point = 0;
        count = 0;
        record_count = 0;
        box_count = 0;
    }
};

// 日常领取
class ResDailyReward : public ProtocolResponse {
public:
    PSAchievementRecord record;
    int32_t point;
    int32_t count;
    PSBackpackData list[100];
    ResDailyReward() {
        protocol = 1212004;
        point = 0;
        count = 0;
    }
};

// 日常领取
class ResDailyBoxReward : public ProtocolResponse {
public:
    PSDailyBox box;
    int32_t count;
    PSBackpackData list[100];
    ResDailyBoxReward() {
        protocol = 1212005;
        count = 0;
    }
};

class ResUpdateDailyData : public ProtocolResponse {
public:
    PSAchievementData data;
    ResUpdateDailyData() {
        protocol = 1212006;
    }
};


//class ResAchievementData : public ProtocolResponse {
//public:
//    int32_t count;
//    PSAchievementData list[100];
//    ResAchievementData() {
//        protocol = 1212001;
//        count = 0;
//
//    }
//};
//class ResAchievementData : public ProtocolStruct {
//public:
//    int16_t type_id;    // 成就id
//    int32_t progress;   // 成就进度
//    int8_t reward;      // 奖励领取状态
//
//    ResAchievementData() {
//        type_id = 0;
//        progress = 0;
//        reward = 0;
//    }
//};
//
//class ResAchievementList : public ProtocolResponse {
//public:
//    //    成就信息列表
//    int32_t list_count;
//    ResAchievementData list[100];
//
//    ResAchievementList() {
//        protocol = 1212001;
//        list_count = 0;
//        memset(list, 0, sizeof(list));
//    }
//};

#pragma mark -------每日任务模块-------

class ResDailyTaskData : public ProtocolStruct {
public:
    int16_t type_id;    // id
    int32_t progress;   // 进度
    int8_t reward;      // 奖励领取状态
    
    ResDailyTaskData() {
        type_id = 0;
        progress = 0;
        reward = 0;
    }
};

class ResDailyTaskList : public ProtocolResponse {
public:
    //  任务列表
    int32_t list_count;
    ResDailyTaskData list[15];
    
    ResDailyTaskList() {
        protocol = 1213001;
        list_count = 0;
        memset(list, 0, sizeof(list));
    }
};


#pragma mark -------酒馆任务派遣模块-------
class ResPubTaskData : public ProtocolStruct
{
public:
    int64_t task_id;    // id
    int32_t task_type;  // 类型
    int32_t used_time;  // 完成时间 0待派遣
    //int64_t hero_id[5]; // 派遣的英雄ID
    int64_t hero_1;
    int64_t hero_2;
    int64_t hero_3;
    int64_t hero_4;
    int64_t hero_5;
    
    ResPubTaskData()
    {
        task_id = 0;
        task_type = 0;
        used_time = 0;
        //memset(hero_id, 0, sizeof(hero_id));
        hero_1 = 0;
        hero_2 = 0;
        hero_3 = 0;
        hero_4 = 0;
        hero_5 = 0;
    }
};

class ResPubTaskList : public ProtocolResponse
{
public:
    int32_t task_count;  // 任务总数
    int32_t can_do_num;  // 可接取任务个数
    
    int32_t list_count;
    ResPubTaskData list[50];
    
    ResPubTaskList()
    {
        protocol = 1213021;
        
        task_count = 0;
        can_do_num = 0;
    }
};

/*
 ** 使用券 刷新一个任务
 */
class ResPubTaskRereshOne : public ProtocolResponse
{
public:
    ResPubTaskData task;
    
    ResPubTaskRereshOne()
    {
        protocol = 1213022;
    }
};

/*
 ** 派遣任务
 */
class ResPubTaskStart : public ProtocolResponse
{
public:
    int64_t task_id;
    
    ResPubTaskStart()
    {
        protocol = 1213023;
        
        task_id = 0;
    }
};

class ResPubTaskAward : public ProtocolResponse
{
public:
    int64_t task_id;    // 完成任务id
    int32_t used_gem;   // 完成任务消耗的钻石
    
    int32_t list_count;
    PSBackpackData award[5]; //奖励
    
    ResPubTaskAward()
    {
        protocol = 1213024;
        
        task_id = 0;
    }
};



#pragma mark -------许愿池模块-------
class ResBlessingPoolData : public ProtocolStruct
{
public:
    int32_t index;
    PSBackpackData item;
};

class ResBlessingPoolList : public ProtocolResponse
{
public:
    int8_t common_freeRefresh;  // 普通免费刷新 0免费 1不免费
    int8_t senior_freeRefresh;  // 高级免费刷新 0免费 1不免费
    
    ResBlessingPoolData common_type[8]; // 普通奖项类型
    ResBlessingPoolData senior_type[8]; // 高级奖项类型
    
    ResBlessingPoolList()
    {
        protocol = 1213031;
        common_freeRefresh = 0;
        senior_freeRefresh = 0;
    }
};

// 抽奖后返回 标记变灰
class ResBlessingPoolTag : public ProtocolResponse
{
public:
    int32_t type;       // 1普通 2高级
    
    int32_t list_count;
    int32_t index[10];  // 需要变灰的序号
    
    ResBlessingPoolTag()
    {
        protocol = 1213032;
        type = 0;
        list_count = 0;
    }
};

class ResBlessingPoolDone : public ProtocolResponse
{
public:
    int32_t frist_index;   // 首个奖品的位置
    
    int32_t list_count;
    PSBackpackData award[10]; // 奖品
    
    ResBlessingPoolDone()
    {
        protocol = 1213033;
        frist_index = 0;
        list_count = 0;
    }
};

/*
 ** 许愿池商店
 */
class ResBlessingPoolShop : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[6]; //物品
    
    ResBlessingPoolShop()
    {
        protocol = 1213034;
        freeRefresh = 0;
        list_count = 0;
    }
};


#pragma mark -------先知之树模块-------
class ResProphetSummon : public ProtocolResponse
{
public:
    int32_t list_count;
    PSBackpackData award[10];
    
    ResProphetSummon()
    {
        protocol = 1213041;
        list_count = 0;
    }
};

// 召唤结果
class ResProphetChange : public ProtocolResponse
{
public:
    int64_t before_hero_id; //置换前英雄ID
    int32_t after_hero_type; //置换后英雄类型
    
    ResProphetChange()
    {
        protocol = 1213042;
        
        before_hero_id = 0;
        after_hero_type = 0;
    }
};

/*
 ** 先知商店
 */
class ResProphetShopList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[50]; //物品
    
    ResProphetShopList()
    {
        protocol = 1213045;
        freeRefresh = 0;
        list_count = 0;
    }
};

#pragma mark -------英雄献祭模块-------
class ResAltarHero : public ProtocolResponse
{
public:
    int32_t list_count;
    PSBackpackData award[50]; //物品
    
    ResAltarHero()
    {
        protocol = 1213051;
        list_count = 0;
    }
};

/*
 ** 献祭商店
 */
class ResAltarShopList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[50]; //物品
    
    ResAltarShopList()
    {
        protocol = 1213054;
        freeRefresh = 0;
        list_count = 0;
    }
};


#pragma mark -------活动任务模块-------
// 签到
class ResSignInList : public ProtocolResponse
{
public:
    int8_t count_days; //总天数
    int8_t days; //当前签到天数
    int8_t isSignIn; //今天是否已签到 0未签 1已签
    
    ResSignInList()
    {
        protocol = 1213010;
        count_days = 0;
        days = 0;
        isSignIn = 0;
    }
};

class ResSignInAward : public ProtocolResponse
{
public:
    int8_t idx; //天数序号 1-31
    PSBackpackData award; //奖励
    
    ResSignInAward()
    {
        protocol = 1213011;
        idx = 0;
    }
};

// 每周福利
class WeekGiftData : public ProtocolStruct
{
public:
    int32_t idx; // 礼包序号
    int32_t buyCount; // 已购买个数
    
    WeekGiftData()
    {
        idx = 0;
        buyCount = 0;
    }
};

class ResWeekGiftList : public ProtocolResponse
{
public:
    int32_t list_count;
    WeekGiftData data[50];
    
    ResWeekGiftList()
    {
        protocol = 1213012;
        list_count = 0;
    }
};



class ResTimeExchangeGiftList: public ProtocolResponse
{
public:
    int32_t end_time;    //结束时间
    int32_t list_count;
    WeekGiftData data[50];
    
    ResTimeExchangeGiftList()
    {
        protocol = 1213071;
        list_count = 0;
    }
};

class ResGetExchangeGift: public ProtocolResponse
{
public:
    int8_t is_success; // =0 失败  >0 成功
    int32_t list_count;
    PSBackpackData award[10];
    ResGetExchangeGift()
    {
        protocol = 1213072;
        is_success = 0;
        list_count = 0;
    }
};




class LevelUpGiftData : public ProtocolStruct
{
public:
    int32_t idx; // idx
    int32_t buyCount; // 买了
    int8_t is_obtain; // =0 未领  >0 已领取
    
    LevelUpGiftData()
    {
        idx = 0;
        buyCount = 0;
        is_obtain = 0;
    }
};


class ResLevelUpGiftList : public ProtocolResponse
{
public:
    int32_t end_time;    //结束时间
    int32_t count;
    LevelUpGiftData data[50];
    
    ResLevelUpGiftList()
    {
        protocol = 1213019;
        end_time = 0;
        count = 0;
    }
};

class ResLevelUpGift : public ProtocolResponse
{
public:
    int8_t is_success; // <=0 失败  >0 成功
    int32_t idx; // idx
    int32_t list_count;
    PSBackpackData award[10];
    ResLevelUpGift()
    {
        protocol = 1213020;
        is_success = 0;
        idx = 0;
        list_count = 0;
    }
};




// 积天豪礼 列表回复
class ResRechargeDaysList : public ProtocolResponse
{
public:
    int32_t days; // 已领取天数
    int32_t completed; // 当天充值进度
    int8_t is_award; // 是否已领取 0 未领取 1已领取
    
    ResRechargeDaysList()
    {
        protocol = 1213013;
        days = 0;
        completed = 0;
        is_award = 0;
    }
};

// 积天豪礼 领奖回复
class ResRechargeDaysGain : public ProtocolResponse
{
public:
    int32_t days; // 领取
    
    int32_t list_count;
    PSBackpackData award[10];
    
    ResRechargeDaysGain()
    {
        protocol = 1213014;
        days = 0;
        list_count = 0;
    }
};

class RechargeWeekData : public ProtocolStruct
{
public:
    int32_t idx; // 礼包序号
    int8_t is_award; // 0 未领取 1已领取
    RechargeWeekData()
    {
        idx = 0;
        is_award = 0;
    }
};
// 周累计充值 列表回复
class ResRechargeWeekList : public ProtocolResponse
{
public:
    int32_t completed; // 周充值进度
    
    int32_t list_count;
    RechargeWeekData data[10];
    
    ResRechargeWeekList()
    {
        protocol = 1213015;
        completed = 0;
        list_count = 0;
    }
};

// 周累计充值 领奖回复
class ResRechargeWeekGain : public ProtocolResponse
{
public:
    int32_t idx; // 领取序号
    
    int32_t list_count;
    PSBackpackData award[10];
    
    ResRechargeWeekGain()
    {
        protocol = 1213016;
        idx = 0;
        list_count = 0;
    }
};

// 月卡数据
class MonthCardData : public ProtocolStruct
{
public:
    int32_t card_type; // 月卡类型 1 月卡 2 至尊月卡
    int32_t completed; // 当前充值进度
    int32_t gain_days; // 已领取天数
    int32_t over_time; // 结束时间戳
    int8_t is_gain;    // 0 未领取 1 已领取
    int8_t is_gain_vip;// 至尊月卡vip等级奖励
    MonthCardData()
    {
        card_type = 0;
        completed = 0;
        gain_days = 0;
        over_time = 0;
        is_gain = 0;
    }
};
// 月卡 列表回复
class ResMonthCardList : public ProtocolResponse
{
public:
    int32_t list_count;
    MonthCardData data[10];
    
    ResMonthCardList()
    {
        protocol = 1213017;
        list_count = 0;
    }
};

// 月卡 领取回复
class ResMonthCardGain : public ProtocolResponse
{
public:
    int32_t card_type; // 月卡类型 1 月卡 2 至尊月卡
    
    ResMonthCardGain()
    {
        protocol = 1213030;
        card_type = 0;
    }
};

#pragma mark -------限时礼包模块-------
class LimitGiftData : public ProtocolStruct
{
public:
    int64_t gift_id; // 礼包id
    int32_t idx;    // 计费点idx
    int32_t num;    // 数量
    int32_t last_time; //结束时间戳
    
    LimitGiftData()
    {
        gift_id = 0;
        idx = 0;
        last_time = 0;
    }
};

// 限时礼包 列表回复
class ResLimitGiftList : public ProtocolResponse
{
public:
    int32_t list_count;
    LimitGiftData data[10];
    
    ResLimitGiftList()
    {
        protocol = 1213060;
        list_count = 0;
    }
};
// 限时礼包 添加回复
class ResLimitGiftAdd : public ProtocolResponse
{
public:
    LimitGiftData data;
    
    ResLimitGiftAdd()
    {
        protocol = 1213061;
    }
};


#pragma mark -------月度回馈模块-------
// 月度回馈数据
class MonthInvestData : public ProtocolStruct
{
public:
    int32_t invest_type; // 活动类型 1 128RMB 2 328RMB
    int32_t completed; // 当前领取进度
    int8_t is_gain; //0 未领取 1 已领取
    
    MonthInvestData()
    {
        invest_type = 0;
        completed = 0;
        is_gain = 0;
    }
};

// 列表
class ResMonthInvestList : public ProtocolResponse
{
public:
    int32_t list_count;
    MonthInvestData data[10];
    
    ResMonthInvestList()
    {
        protocol = 1213062;
    }
};

//领奖
class ResMonthInvesGain : public ProtocolResponse
{
public:
    int32_t invest_type; // 活动类型 1 128RMB 2 328RMB
    int32_t completed; // 当前领取进度
    
    int32_t list_count;
    PSBackpackData award[10];
    
    ResMonthInvesGain()
    {
        protocol = 1213063;
        
        invest_type = 0;
        completed = 0;
        list_count = 0;
    }
};

#pragma mark -
#pragma mark 新服限购 BEGIN
class NewServerLimitData : public ProtocolStruct
{
public:
    int32_t idx;        // 配置表中礼包idx
    int32_t bought_num; // 已购买数量
    
    NewServerLimitData()
    {
        idx = 0;
        bought_num = 0;
    }
};

class ResNewServerLimitList : public ProtocolResponse
{
public:
    int32_t end_time;   // 终止时间戳
    
    int32_t list_count;
    NewServerLimitData data[100];
    
    ResNewServerLimitList()
    {
        protocol = 1213091;
    }
};

#pragma mark 新服限购 END

#pragma mark -
#pragma mark 中秋特惠 BEGIN
class ResMidAutumnInfo : public ProtocolResponse
{
public:
    int32_t begin_time;     // 开始时间戳
    int32_t end_time;       // 终止时间戳
    int8_t is_bought;       // 是否已经购买   0:未购买   1:已购买
    
    ResMidAutumnInfo()
    {
        protocol = 1213086;
        
        begin_time = 0;
        end_time = 0;
        is_bought = 0;
    }
};
#pragma mark 中秋特惠 END

#pragma mark -q
#pragma mark 召唤水晶 BEGIN
class SummonCrystalData : ProtocolStruct
{
public:
    int32_t idx;        // 配置项idx
    int32_t progress;   // 进度
    int8_t is_bought;   // 是否已经领取   0:未领取   1:已领取
    
    SummonCrystalData()
    {
        idx = 0;
        progress = 0;
        is_bought = 0;
    }
};

class ResSummonCrystalInfo : public ProtocolResponse
{
public:
    int32_t begin_time;
    int32_t end_time;
    
    int32_t list_count;
    SummonCrystalData data[100];
    
    ResSummonCrystalInfo()
    {
        protocol = 1213087;
        
        begin_time = 0;
        end_time = 0;
        list_count = 0;
    }
};
#pragma mark 召唤水晶 END

#pragma mark -q
#pragma mark 占星阵任务 BEGIN
class AstrologyTaskData : ProtocolStruct
{
public:
    int32_t idx;        // 配置项idx
    int8_t is_over;     // 是否已经完成   0:未完成   1:已完成
    
    AstrologyTaskData()
    {
        idx = 0;
        is_over = 0;
    }
};

class ResAstrologyTaskInfo : public ProtocolResponse
{
public:
    int32_t begin_time;
    int32_t end_time;
    
    int32_t list_count;
    AstrologyTaskData data[100];
    
    ResAstrologyTaskInfo()
    {
        protocol = 1213100;
        
        begin_time = 0;
        end_time = 0;
        list_count = 0;
    }
};

class ResAstrologyTaskSubmit : public ProtocolResponse
{
public:
    int32_t idx;
    int8_t is_over;
    
    ResAstrologyTaskSubmit()
    {
        protocol = 1213101;
        
        idx = 0;
        is_over = 0;
    }
};
#pragma mark 占星阵任务 END

#pragma mark -q
#pragma mark 酒馆达标 BEGIN
class PubArriveData : ProtocolStruct
{
public:
    int32_t idx;        // 配置项idx
    int32_t progress;   // 进度
    int8_t is_bought;   // 是否已经领取   0:未领取   1:已领取
    
    PubArriveData()
    {
        idx = 0;
        progress = 0;
        is_bought = 0;
    }
};

class ResPubArriveInfo : public ProtocolResponse
{
public:
    int32_t begin_time;
    int32_t end_time;
    
    int32_t list_count;
    PubArriveData data[100];
    
    ResPubArriveInfo()
    {
        protocol = 1213106;
        
        begin_time = 0;
        end_time = 0;
        list_count = 0;
    }
};
#pragma mark 酒馆达标 END

#pragma mark -------商店模块-------
// 钻石购买物品
class ResBuyItem : public ProtocolResponse {
public:
    PSBackpackData data;
    ResBuyItem() {
        protocol = 1214000;
    }
};

// 扩充角色上限.
class ResShopBuyHeroCapacity : public ProtocolResponse {
public:
    ResShopBuyHeroCapacity() {
        protocol = 1214003;
    }
};

// 钻石购买高级召唤卷轴
class ResShopBuySummonTicket : public ProtocolResponse {
public:
    ResShopBuySummonTicket(){
        protocol = 1214010;
    }
};


#pragma mark -------邮件模块-------
class ResMailList : public ProtocolResponse {
public:
    int32_t list_count;
    PSMailData list[50];

    ResMailList() {
        protocol = 1215000;
        list_count = 0;
    }
};

#pragma mark -------兑换码模块-------
class ResCdk : public ProtocolResponse {
public:
    int8_t is_success; // <=0 失败  >0 成功
    
    ResCdk() {
        protocol = 1215010;
        is_success = 0;
    }
};

#pragma mark -------试炼模块-------

//请求试炼配置
class ResTrialCfg : public ProtocolResponse {
public:
    int32_t begin_mission; //重置关卡
    int32_t misssion_id;  //当前关卡
    int32_t count;        //箱子个数
    PSTrialBox list[100]; //箱子
    ResTrialCfg() {
        protocol = 1216000;
        begin_mission = 0;
        misssion_id = 0;
        count = 0;

    }
};

class ResTrialPass : public ProtocolResponse {
public:
    int32_t misssion_id;  //当前关卡
    int32_t count;
    PSBackpackData items[100];
    ResTrialPass() {
        protocol = 1216001;
        misssion_id = 0;
        count = 0;
        
    }
};

class ResTrialBox : public ProtocolResponse {
public:
    int32_t count;
    PSBackpackData items[100];
    PSTrialBox box;
    ResTrialBox() {
        protocol = 1216002;
        count = 0;
        
    }
};

/*
 ** 勇者试炼商店
 */
class ResTrialShopList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[50]; //物品
    
    ResTrialShopList()
    {
        protocol = 1216005;
        freeRefresh = 0;
        list_count = 0;
    }
};


// 试炼敌人列表
class ResTrialBattleList : public ProtocolResponse
{
public:
    int32_t list_count;
    PSPlayerBattleData list[20];    // 变长
    ResTrialBattleList()
    {
        protocol = 1216007;
        list_count = 0;
    }
};



#pragma mark -------点金模块-------
// 点金数据
class ResBuyaGoldLog : public ProtocolResponse {
public:
    int32_t time;           // 上一次刷新的时间
    int32_t list_count;     // 周期内。购买过的列表
    PSBuyGoldData list[4];  //
    ResBuyaGoldLog() {
        protocol = 1217000;
        time = 0;
        list_count = 0;
    }
};

// 点金购买回调
class ResBuyaGold : public ProtocolResponse {
public:
    int32_t idx;        // 购买的idx
    int32_t gold;       // 获得的金币
    ResBuyaGold() {
        protocol = 1217001;
        idx = 0;
        gold = 0;
    }
};


#pragma mark ------PVP模块-------

class ResPvpData : public ProtocolResponse {
public:
    int32_t score;      // 玩家自身分数
    int32_t free_count; // 免费次数
    int32_t list_count; // 玩家分数
    PSRankPlayerData list[5];   // 对手数据
    ResPvpData() {
        protocol = 1218001;
        free_count = 0;
        score = 0;
        list_count = 0;
    }
};


// 战斗开始
class ResPvpBattle : public ProtocolResponse {
public:
    int64_t battle_id;          // 战斗id
    
    int32_t self_hero_list;     // 自身英雄数据
    PSHeroData self_list[5];    // 自己数据
    
    int32_t enemy_hero_list;    //
    PSHeroData enemy_list[5];   // 对手数据
    
    int32_t equip_count;        // 装备列表
    PSHeroEquipData equip_list[100];
    
    int32_t self_clan_list;
    PSClanSkillData self_clan[100];
    
    int32_t enemy_clan_list;
    PSClanSkillData enemy_clan[100];
    
    ResPvpBattle() {
        protocol = 1218002;
        self_hero_list = 0;
        equip_count = 0;
    }
};

// PVP战斗结束
class ResPvpBattleEnd : public ProtocolResponse {
public:
    int8_t is_win;
    int32_t self_score;         // 自己增加的分数
    int32_t enemy_score;        // 敌人增加的分数
    int32_t list_count;         // 奖励列表
    PSBackpackData list[5];     //
    ResPvpBattleEnd() {
        protocol = 1218003;
        is_win = 0;
        self_score = 0;
        enemy_score = 0;
        list_count = 0;
    }
};


// 战斗历史
class ResPvpBattleHistory : public ProtocolResponse {
public:
    int64_t battle_id;          // 战斗id
    
    int64_t enemy_id;           // 敌人id
    char enemy_name[NAME_LENGTH];// 玩家1名字
    int32_t enemy_head_id;      // 头像id
    int32_t enemy_level;        // 敌人的等级
    int32_t enemy_battle;       // 敌人的战斗力
    
    int8_t status;              // 0:防御 1：挑战别人
    int32_t is_win;             // 自己是否胜利
    int32_t score;              // 胜利的人增加的分数
    
    int32_t self_hero_list;     // 自身英雄数据
    PSHeroData self_list[6];    // 自己数据
    
    int32_t enemy_hero_list;    //
    PSHeroData enemy_list[6];   // 对手数据
    
    int32_t equip_count;        // 装备列表
    PSHeroEquipData equip_list[100];
    
    
    int32_t self_clan_list;
    PSClanSkillData self_clan[100];
    
    int32_t enemy_clan_list;
    PSClanSkillData enemy_clan[100];
    
    ResPvpBattleHistory() {
        protocol = 1218004;
        self_hero_list = 0;
        equip_count = 0;
    }
};


// 战斗历史列表
class ResPvpBattleHistoryList : public ProtocolResponse {
public:
    int32_t list_count;     // 列表长度
    int64_t list[5];        // 战斗id列表
    ResPvpBattleHistoryList() {
        protocol = 1218005;
        list_count = 0;
    }
};

// PVP商店
class ResPvpShopList : public ProtocolResponse
{
public:
    int8_t freeRefresh; // 拥有免费刷新次数
    
    int32_t list_count;
    PSMarketData award[50]; //物品
    
    ResPvpShopList()
    {
        protocol = 1218006;
        freeRefresh = 0;
        list_count = 0;
    }
};

#pragma mark ------七天目标模块-------

class ResSevenDayTargetData : public ProtocolResponse {
public:
    int32_t end_time;
    int32_t cur_day;
    int32_t point;
    int32_t count;                  // 列表长度
    PSSevenDayData list[1000];        // 七天目标数据列表
    int32_t box_count;
    PSSevenDayBox box[100];
    int32_t get_count;
    PSSevenDayStatus status_list[1000];
    
    ResSevenDayTargetData() {
        protocol = 1221000;
        end_time = 0;
        cur_day = 0;
        count = 0;
        box_count = 0;
        point = 0;
        get_count = 0;
    }
};

class ResUpdateSevenDayTargetData : public ProtocolResponse {
public:
    int32_t count;
    PSSevenDayData data[100];        // 七天目标数据列表
    ResUpdateSevenDayTargetData() {
        protocol = 1221001;
        count = 0;
    }
};

class ResSevenDayTargetReward : public ProtocolResponse {
public:
    int32_t point;
    PSSevenDayStatus status;
    int32_t count;
    PSBackpackData data[100];        // 奖励
    ResSevenDayTargetReward() {
        protocol = 1221002;
        count = 0;
        point = 0;
    }
};

class ResSevenDayTargetBoxReward : public ProtocolResponse {
public:
    int32_t count;
    PSBackpackData data[100];        // 奖励
    PSSevenDayBox box;
    ResSevenDayTargetBoxReward() {
        protocol = 1221003;
        count = 0;
    }
};

class ResSevenDayTargetUpdataDay : public ProtocolResponse {
public:
    int32_t cur_day;
    ResSevenDayTargetUpdataDay() {
        protocol = 1221004;
        cur_day= 0;
    }
};

#pragma mark ------七天登录模块-------

class ResSevenDayData : public ProtocolResponse {
public:
    int32_t end_time;
    int32_t cur_day;
    int32_t count;
    PSSevenDayStatus list[1000];
    ResSevenDayData() {
        protocol = 1222000;
        end_time = 0;
        cur_day = 0;
    }
};

class ResUpdateSevenDayReward  : public ProtocolResponse {
public:
    PSSevenDayStatus status;
    int32_t count;
    PSBackpackData data[100];        // 奖励
    ResUpdateSevenDayReward() {
        protocol = 1222001;
        count = 0;
    }
};

class ResSevenDayLoginUpdataDay : public ProtocolResponse {
public:
    int32_t cur_day;
    ResSevenDayLoginUpdataDay() {
        protocol = 1222002;
        cur_day= 0;
    }
};


#pragma mark -------日常模块-------

// 日常副本数据
class ResDailyDungeonData : public ProtocolResponse {
public:
    int32_t gold_count;     // 今天已经攻打多少次日常副本(VIP等级会增加通关次数)
    int32_t exp_count;      // 今天已经攻打多少次经验副本(VIP等级会增加通关次数)
    int32_t hero_count;     // 今天已经攻打多少次英雄副本(VIP等级会增加通关次数)
    
    int32_t gold_mission;   // 当前打到那一关了
    int32_t exp_mission;    // 当前打到那一关了
    int32_t hero_mission;   // 当前打到那一关了
    
    ResDailyDungeonData() {
        protocol = 1219001;
    }
};

// 日常副本结束(获得的奖励)
class ResDailyDungeonEnd : public ProtocolResponse {
public:
    int32_t mission_id;     //
    int32_t mission_type;   // 副本类型1 金币副本， 2经验副本， 3英雄副本
    int32_t list_count;
    PSBackpackData list[5];
    ResDailyDungeonEnd() {
        protocol = 1219002;
        mission_type = 0;
        list_count = 0;
    }
};

#pragma mark -------英雄降临-------
//英雄降临 领取记录和时间
class ResHeroArriveData : public ProtocolResponse {
public:
    int32_t end_time;
    int32_t count;
    PSSevenDayStatus list[100];
    int32_t data_count;
    PSHeroArriveData data_list[100];
    ResHeroArriveData() {
        protocol = 1223000;
        end_time = 0;
        count = 0;
        data_count = 0;
    }
};

class ResHeroArriveReward : public ProtocolResponse {
public:
    PSSevenDayStatus status;
    int32_t count;
    PSBackpackData list[100];
    ResHeroArriveReward() {
        protocol = 1223001;
        count = 0;
    }
};

class ResHeroArriveUpdate : public ProtocolResponse {
public:
    PSHeroArriveData data;
    ResHeroArriveUpdate() {
        protocol = 1223002;
    }
};


#pragma mark -
#pragma mark ----------限时活动模块--------------
// 每月福利
class MouthWelfareData : public ProtocolStruct
{
public:
    int32_t idx; // 礼包序号
    int32_t buyCount; // 已购买个数
    
    MouthWelfareData()
    {
        idx = 0;
        buyCount = 0;
    }
};

class ResMouthWelfareList : public ProtocolResponse
{
public:
    int32_t list_count;
    MouthWelfareData data[50];
    
    ResMouthWelfareList()
    {
        protocol = 1226001;
        list_count = 0;
    }
};

// 每日福利
class DailyWelfareData : public ProtocolStruct
{
public:
    int32_t idx; // 礼包序号
    int32_t buyCount; // 已购买个数
    
    DailyWelfareData()
    {
        idx = 0;
        buyCount = 0;
    }
};

class ResDailyWelfareList : public ProtocolResponse
{
public:
    int32_t list_count;
    DailyWelfareData data[50];
    
    ResDailyWelfareList()
    {
        protocol = 1226002;
        list_count = 0;
    }
};


#pragma pack()
#endif
