//
//  Unit.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__Unit__
#define __AVT__Unit__

#include "../Comp/Menu/UIMenuItemBattle.h"
#include "../Ctrl/NodeCtr.h"

extern int WAR_KEY_HP_MAX;
extern int WAR_KEY_HP;
extern int WAR_KEY_ATTACK;
extern int WAR_KEY_ATTACK_RANGE;
extern int WAR_KEY_MOVE_RANGE;

// 单位类型
enum UnitType {
    UNIT_TYPE_VALID = 0,
    UNIT_TYPE_OBSTACLE = 1, // 障碍
    UNIT_TYPE_HERO = 2,     // 英雄
    UNIT_TYPE_SKILL = 3,    // 技能
};

enum UnitBattleType {
    UNIT_VALID = -1,
    UNIT_FRIEND = 0,
    UNIT_ENEMY = 1,
};


enum UnitAttackType {
    UAT_VALID = 0,
    UAT_ATTACK = 1, // 普通攻击
    UAT_SKILL = 2,  // 技能攻击
};

// 普通攻击属性 1:无 2:火 3:水 4:木 5:光 6:暗
enum UnitDamageType {
    UDT_NOTHING = 1,
    UDT_FIRE,
    UDT_WATER,
    UDT_WOOD,
    UDT_LIGHT,
    UDT_DARK,
};

// 体质 1:无 2:火 3:水 4:木 5:光 6:暗
enum UnitAttributeType {
    UAT_NOTHING = 1,
    UAT_FIRE,
    UAT_WATER,
    UAT_WOOD,
    UAT_LIGHT,
    UAT_DARK,
};

class TownScene;

class Unit : public UIMenuItemBattle {
public:
    UnitType unit_type;
    UnitBattleType battle_type;
    
    int64_t item_id;
    int64_t role_id;
    int type;
    int level;
    
    Unit();
    ~Unit();
    
#pragma mark 获取当前属性值
    int getHpMax();
    void setHpMax(int hp_max);
    
    int getHp();
    void setHp(int hp);
    
    int getAttack();
    void setAttack(int attack);
    
    int getAnger();
    void setAnger(int anger);
    
#pragma mark 获取原始属性值
    int getHpO();
    void setHpO(int hp);
    
    int getAttackO();
    void setAttackO(int attack);
    
#pragma mark 基础操作
    virtual void selected();
    virtual void unselected();
    virtual void activate();
    
    virtual void setSelected(bool b);
    
    virtual void stand(int32_t round);
    virtual void moveTo(Point pos, int32_t round, ActionType type);
    virtual void attack(Point pos, int32_t round);
    virtual void skill(Point pos, int32_t round);
    virtual bool isDie();
    virtual void die(Unit* killer);
    
    virtual void beattack(int hp_old, int hp_new, int elem_type, bool is_critical, float delay);
    
    virtual void showHP();
    virtual void hideHP();
    
    virtual void reborn();

#pragma mark 技能操作
    virtual int32_t getUnuseSkillTag(int32_t tag = 1000000);
    virtual Node* getSkillNode(const int32_t& tag);
    
    
protected:
    string action_plist;
    string action_format;
    
    int hp_max1;
    int hp1;
    int attack1;        // 攻击力
    
    // 原数值
    int hp_o;           // 血量
    int attack_o;       // 攻击力
    
    int32_t anger;      // 怒气值
   
    bool is_die;
protected:
    TownScene* getSceneLayer();
    NodeCtr* getWarSceneCtr();
};

#endif /* defined(__AVT__Unit__) */
