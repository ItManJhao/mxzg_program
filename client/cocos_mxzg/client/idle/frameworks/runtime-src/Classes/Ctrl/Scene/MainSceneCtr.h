//
//  MainSceneCtr.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __MainSceneCtr_H__
#define __MainSceneCtr_H__

#include "SceneCtr.h"
#include "../../Common/SingleInstance.h"
#include "TownSceneCtr.h"

#include "../../Comp/Menu/UIMenuItemScale.h"
#include "../../Comp/Menu/UIMenuScene.h"
#include "../../Comp/UILabel.h"
#include "../../Comp/Menu/UIMenuRotate.h"
#include "../../Comp/Menu/UIMenuBattle.h"

#include "../../Comp/UIComboBox.h"

#include "../../Comp/UIRichTextEx.h"

/**
 * 主场景类型
 *
 */

enum MainLayerType {
    MLT_INVALID                     = 0,
    MLT_MAIN_CITY                   = 100000,
    MLT_HERO_TRAIN                  = 110000,  // 英雄培养界面
    MLT_ROLE                        = 200000,
    MLT_ROLE_HERO_UPGRADE           = 210000,
    MLT_ROLE_HERO_UPSTAR            = 220000,
    MLT_ROLE_SKILL_UPGRADE          = 230000,
    MLT_ROLE_HERO_LIMIT_UP          = 240000,
    MLT_ROLE_HERO_ILLUSTRAT         = 250000,
    MLT_ROLE_HERO_HAVE              = 260000,
    MLT_ROLE_HERO_SELL              = 270000,
    MLT_ROLE_CATALOG                = 280000,   // 英雄图鉴界面
    MLT_MAIN_PAGE                   = 300000,
    MLT_BACKPACK                    = 310000,   // 背包界面
    MLT_BATTLE                      = 400000,
    MLT_BATTLE_MAINLINE             = 410000,
    MLT_BATTLE_BEFALL               = 440000,   // 单人多人选项模式
    MLT_BATTLE_MISSION_LIST         = 441000,
    MLT_BATTLE_BEFALL_ROOM_LIST     = 442000,
    MLT_BATTLE_BEFALL_ROOM_INFO     = 443000,
    MLT_CLAN_SYNTHESIS              = 500000,   // 军团综合
    MLT_CLAN_SEARCH                 = 510000,
    MLT_DRAGON                      = 600000,
    MLT_FRIENDS_LIST                = 610000,
    MLT_FRIENDS_ADD                 = 620000,
    MLT_SHOP_GEM                    = 630000,
    MLT_SHOP_HONOR                  = 650000,
    MLT_SHOP_KEY                    = 660000,
    MLT_SHOP_CAPACITY               = 670000,
    MLT_OTHER_CUE                   = 680000,
    MLT_SKIN                        = 700000,
};

// 英雄图鉴类的层类型
enum MLRHIType {
    MLRHIT_CARD = 1,    // 英雄图鉴
    MLRHIT_HAVE = 2,    // 英雄库
    MLRHIT_SELL = 3,    // 英雄出售
};

enum ClanSynLayerType {
    CSLT_INVALID = -1,
    CSLT_NONE = 0,
    CSLT_CLAN,
    CSLT_FRIENDS_LIST,
    CSLT_FRIENDS_ADD,
};

#pragma mark-
class MSLayerBase : public UIWindowLayer {
public:
    MSLayerBase();
    virtual void initDone();
    virtual void remove();
};

#pragma mark- 战斗UI

class MainScene : public TownScene {
public:
    int32_t interval;
    Node* cur_main_layer;    // 当前主层
    Node* tmp_main_layer;    // 缓存主层
    
    UIMenu* menu_scale;
    UIMenuItemScale* btn_main_city; // 主城
    UIMenuItemScale* btn_hero;      // 英雄
    UIMenuItemScale* btn_backpack;  // 背包
    UIMenuItemScale* btn_battle;    // 战斗
    UIMenuItemScale* btn_clan;      // 军团
    UIMenuItemScale* btn_dragon;    // 魔兽
    UIMenuItemScale* btn_skin;      // 皮肤
    
    Layer* main_layer;              // 主控制层
    
    Label* lbl_role_nick;
    
    Label* lbl_level;
    
    Label* lbl_attack;
//    UILabel* lbl_energy_time;
    Label* lbl_gold;
    Label* lbl_gem;
//    Label* lbl_exp;
    
    Sprite* spr_head;
    
    ProgressTimer* progress_exp;
    
    MainScene();
    static MainScene* create();
    void onNodeCreated();
    virtual void onExit();
    
    void update(float dt);
};


#pragma mark-
class ResHeroSummonList;
class MainSceneCtr : public TownSceneCtr,
                     public SingleInstance<MainSceneCtr>
{
public:
//    static MainSceneCtr* instance(){}
    
    
    MainSceneCtr();
    virtual ~MainSceneCtr();
    virtual void enter();
    virtual void didEnter();
    virtual SceneCtrType getSceneCtrType();
    virtual void onExit();

    MainScene* getMainScene();
    MainLayerType getCurLayerType();
    Node* getCurLayer();
    
    float getMenuScaleHeight();     // 获取下方切换按钮的高度
    float getBottomHeight();
    void visibleMenuScale(bool b);  // 显示或隐藏最下面的按钮
    void relogin();
    
    // 界面切换逻辑
    void addKeepLayer(MainLayerType type);
    void removeKeepLayer(MainLayerType type);
    bool isKeepLayer(MainLayerType type);
    void clearKeepLayer();
    void addKeepBuffer(MainLayerType type, Node* node);
    Node* getKeepBuffer(MainLayerType type);
    MainLayerType getKeepNodeType(Node* node);
    void removeActionEnd(Node* node);
    
    // 界面设置体力 金币 钻石 经验
    void setBattle(int32_t from, int32_t to);
    void setGold(int64_t form, int64_t to);
    void setGem(int32_t from, int32_t to);
    void setLevel(int32_t level);
    void setExp(int32_t level, int32_t exp);
    void setNick(string nick);
    
    // 主界面按钮响应
    void addEnergy(Ref* pSender);   // 买体力
    void addGold(Ref* pSender);     // 买金币
    void addGem(Ref* pSender);      // 买宝石
    void onRoleInfo(Ref* pSender);  // 个人简介
    
    void onPub(Ref* pSender);       // 切换到酒馆
    void onRole(Ref* pSender);      // 切换到角色信息
    void onMainPage(Ref* pSender);  // 切换到主页界面
    void onBattle(Ref* pSender);    // 切换到战斗界面
    void onClan(Ref* pSender);      // 切换到军团界面
    void onOther(Ref* pSender);     // 切换到魔兽界面
    void onSkin(Ref* pSender);      // 切换到皮肤界面
    
    // 主界面战斗模块按钮响应
    void onBattleMission(Ref* pSender); // 点击选关
    
    void onMissionBattle(Ref* pSender); // 点击战斗按钮
    void onBattleMissionDone(vector<int64_t> vec_hero);
    
    void onIdleTeam(Ref* pSender);      // 点击队伍按钮
    void onIdleTeamSave(vector<int64_t> vec_hero);
    
    void onIldeItemReward(Ref* pSender);
    void onChapterWorld(Ref* pSender);
    
    // 综合模块
    void onChangeLayer(MainLayerType layer_type);
    
    void onChat(Ref *pSender);
    void onFriend(Ref *pSender);
    void setFriendShip(int32_t num);
    
    void onBuyGemLua(Ref* pSender);        // 购买钻石
    void onBuyGoldLua(Ref* pSender);       // 购买金币
    void onRoleLua(Ref* pSender);
    
    void onFriendChat(int64_t player_id);
    
    static void createTouch(Vec2 tp);
    void resetScaleBtn();
    
    void resetChangeAct(float dt);
    bool isChaning();
    
    void reloadConfig();
    void reloadConfigOne(int32_t type);

    void renameDone();
public:
    bool is_changing;
    int64_t player_id;
    int32_t buy_item_type;
    vector<int64_t> vec_hero_sell;      // 英雄出售id记录
    
    int32_t mission_type;               // 扫荡的关卡
    int32_t mission_degree;
    
    int64_t battle_match_start_time;            // 战斗匹配开始时间
    
    vector<MainLayerType> vec_keep_layer;       // 需要保存的类型
    map<MainLayerType, Node*> map_keep_buffer;  // 图层缓存
protected:
    MainLayerType cur_layer_type;
    MainLayerType tmp_layer_type;
    MainLayerType last_layer_type;

    
    int32_t cur_selected_lineup_idx;            // MSLRole里当前选中的角色idx
    
    virtual void loadScene();
    void changeLayer(MainLayerType layer_type); // 切换层
};

#endif /* defined(__MainSceneCtr_H__) */
