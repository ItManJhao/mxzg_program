//
//  Unit.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "Unit.h"
#include "../Ctrl/Scene/TownSceneCtr.h"

int WAR_KEY_HP_MAX = 0;
int WAR_KEY_HP = 0;
int WAR_KEY_ATTACK = 0;
int WAR_KEY_ATTACK_RANGE = 0;
int WAR_KEY_MOVE_RANGE = 0;
int WAR_KEY_ANGER = 0;

Unit::Unit() {
    setHpMax(1);
    setHp(1);
    setAttack(0);
    
    setHpO(1);
    setAttackO(0);
    
    unit_type = UNIT_TYPE_VALID;
    battle_type = UNIT_FRIEND;
    
    item_id = 0;
    type = 0;
    level = 0;
    
    x = 0;
    y = 0;
    
    is_die = false;
}

Unit::~Unit() {
    
}

#pragma mark 获取当前属性值
int Unit::getHpMax() {
    return hp_max1 ^ WAR_KEY_HP_MAX;
}

void Unit::setHpMax(int hp_max) {
    this->hp_max1 = hp_max ^ WAR_KEY_HP_MAX;
}

int Unit::getHp() {
    return hp1 ^ WAR_KEY_HP;
}

void Unit::setHp(int hp) {
    this->hp1 = hp ^ WAR_KEY_HP;
}

int Unit::getAttack() {
    return attack1 ^ WAR_KEY_ATTACK;
}

void Unit::setAttack(int attack) {
    this->attack1 = attack ^ WAR_KEY_ATTACK;
}

int Unit::getAnger() {
    return anger ^ WAR_KEY_ANGER;
}

void Unit::setAnger(int anger) {
    this->anger = anger ^ WAR_KEY_ANGER;
}

#pragma mark 获取原始属性值
int Unit::getHpO() {
    return hp_o ^ WAR_KEY_HP;
}

void Unit::setHpO(int hp) {
    this->hp_o = hp ^ WAR_KEY_HP;
}

int Unit::getAttackO() {
    return attack_o ^ WAR_KEY_ATTACK;
}

void Unit::setAttackO(int attack) {
    this->attack_o = attack ^ WAR_KEY_ATTACK;
}

#pragma mark 基础操作
void Unit::selected() {
    
}

void Unit::unselected() {
    
}

void Unit::activate() {
    MenuItemImage::activate();
}

void Unit::setSelected(bool b) {
    if (!isEnabled() || isSelected() == b) {
        return;
    }
    
    _selected = b;
}

void Unit::stand(int32_t round) {
    
}

void Unit::moveTo(Point pos, int32_t round, ActionType type) {
    
}

void Unit::attack(Point pos, int32_t round) {
    
}

void Unit::skill(Point pos, int32_t round) {
    
}

bool Unit::isDie() {
    return is_die;
}

void Unit::die(Unit* killer) {
    is_die = true;
}

void Unit::showHP() {
    
}

void Unit::hideHP() {
    
}


void Unit::reborn() {
    is_die = false;
}

void Unit::beattack(int hp_old, int hp_new, int elem_type, bool is_critical, float delay) {
    if (getHp() > 0) {
        showHP();
    }
}

int32_t Unit::getUnuseSkillTag(int32_t tag) {
    while(true) {
        if (getChildByTag(tag)) {
            tag++;
        } else {
            break;
        }
    }
    return tag;
}

Node* Unit::getSkillNode(const int32_t& tag) {
    return getChildByTag(tag);
}

TownScene* Unit::getSceneLayer() {
    Node* n = getParent();
    while (n) {
        TownScene* l = dynamic_cast<TownScene*>(n);
        if (l) {
            return l;
        }
        n = n->getParent();
    }
    return NULL;
}

NodeCtr* Unit::getWarSceneCtr() {
    Layer* scene_layer = getSceneLayer();
    
    for (list<NodeCtr*>::iterator i = list_ctrs.begin(); i != list_ctrs.end(); i++) {
        NodeCtr* controller = (*i);
        if (controller->getLayer() == scene_layer) {
            // 找到controller了
            return controller;
        }
    }
    return NULL;
}


