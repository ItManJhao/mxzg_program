//
//  Hero.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__Hero__
#define __AVT__Hero__

#include "Unit.h"
#include "../Animation/ActionFactory.h"
#include "../Animation/ShaderFactory.h"

#include "../Data/Player.h"
#include "../Comp/Menu/UIMenu.h"

#include <spine/spine.h>
#include <spine/SkeletonAnimation.h>

using namespace spine;

class DamegeData {
public:
    int64_t attacker;       // 释放者
    bool is_critical;       // 暴击伤害
    int32_t damage;         // 伤害值
    int32_t buff_type;      // buff类型
    int8_t damage_type;     // 伤害类型
    DamegeData() {
        attacker = 0;
        is_critical = 0;
        damage = 0;
        buff_type = 0;
        damage_type = 0;
    }
};


class Hero : public Unit {
public:
    int32_t star;
    int32_t skin;
    
    Label* lbl_level;
    
    Sprite* spr_elem;
    ProgressTimer* hp_progress;
    Sprite* hp_bg_sprite;
    
    ProgressTimer* anger_progress;
    Sprite* anger_bg_sprite;
    
    SkeletonAnimation* spine_hero;  // 英雄原画
    Sprite* spr_shadow;             // 英雄脚底阴影
    Layer* layer_attacked_effect;   // 英雄被攻击特效层
    Node *node_attack_name;         // 英雄攻击在头顶显示攻击或者技能名称
    
    UIMenu* menu_buff_icon;
    
    Hero();
    Hero(int64_t hero_id, int64_t role_id, int32_t type, int32_t level, int32_t star, int32_t skin);
    
    static Hero* create(int64_t hero_id, int64_t role_id, int32_t hero_type, int32_t level, int32_t star, int32_t skin);
    
    virtual void setSelected(bool v);

    void initHero();
    
    virtual void setShadowVisible(bool v);
    
    virtual void update(float delay);
    virtual void setFlippedX(bool flippedX);
    virtual bool isFlippedX();
    
    
    void setHeroAnimationByType(int32_t type);
    void setAnimationNode(SkeletonAnimation* node);
    SkeletonAnimation* getAnimationNode();
    void resetTimeScale();
    
    spTrackEntry* setAnimation (int trackIndex, const std::string& name, bool loop);
    spTrackEntry* addAnimation (int trackIndex, const std::string& name, bool loop, float delay = 0);
    void setShader(ShaderType shader_type, bool loop, const std::string& name = "", bool time_scale = 1);
    
    void updateZOrder(float dt);
    void startUpdateZOrder();
    void stopUpdateZOrder(int32_t z);
    virtual void stand();
    
    virtual void attack();
    virtual void die(Unit* killer);
    
    virtual void beattack(const int64_t& attacker,
                          const int& buff_type,
                          const int& damage,
                          const int32_t& damage_type,
                          const int& hp_new,
                          const int& elem_type,
                          bool is_critical,
                          const float& delay);
    
    virtual void showHP();
    virtual void hideHP();
    
    virtual void showAnger();
    virtual void hideAnger();
    
    virtual Label* showLevel(int32_t level);
    virtual void hideLevel();

    virtual Sprite* showElem(int32_t elem);
    virtual void hideElem();
    
    virtual void reborn();
    

    
    // 普攻或者释放技能时在原画头顶显示普攻或者技能名字
    void showDamage();
    void mergeDamage();
    
    void setShowDamage(bool b);
    bool isShowDamage();
    
    void setRunAction(bool b);
    bool isRunAction();

    void addAbilityTip(int32_t type, int32_t value);
    void addAbilityTextTip(string text);
    void showAbilityTip();
    void updateBuffIcon();
    
protected:
    bool is_show_direction;
    bool is_flipped_x;
    bool is_show_damage;
    bool is_show_damaged;   // 是否在等待下一个伤害的显示
    bool is_run_action;     // 快速战斗模式
    int64_t damage_time;
    int64_t tip_time;
    
    vector<DamegeData> vec_damage;  // 记录伤害值显示队列，正值为治疗值，负值为伤害值
    vector<string> vec_tip;         // 提示队列。用于debug

    int32_t tmp_skill_type;
};

#endif /* defined(__AVT__Hero__) */
