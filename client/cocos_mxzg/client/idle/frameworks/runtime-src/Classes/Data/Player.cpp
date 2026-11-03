//
//  Player.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "Player.h"
#include "../Ctrl/Scene/MainSceneCtr.h"

#include "../Comp/MessageView.h"
#include "../Config/RoleTable.h"
#include "RoleData.h"

Player::Player()
: user_id(0)
, role_id(0)
, clan_id(0)
, level(0)
, exp(0)
, energy(0)
, gold(0)
, gem(0)
, friend_ship(0)
, crown(0)
, is_vip(0)
, guide_num(0)
, honor(0)
, last_week_rank(0)
, now_week_honor(0)
{
//    heros.init();
}

Player::~Player()
{
    
}


void Player::resourceAdd(ResourceType type, int64_t num) {
    if (num <= 0) {
        return;
    }
    
    MainSceneCtr* main_scene_ctr = MainSceneCtr::instance();
    
    switch (type) {
        case RESOURCE_GOLD:
        {
            int64_t temp = gold;
            gold += num;

            if (main_scene_ctr) {
                main_scene_ctr->setGold(temp, gold);
            }
            break;
        }
        case RESOURCE_GEM:
        {
            int32_t tmp = gem;
            if (gem + num > 0x7fffffff) {
                gem = 0x7fffffff;
            } else {
                gem += num;
            }
            
            if (main_scene_ctr) {
                main_scene_ctr->setGem(tmp, gem);
            }
            
            break;
        }
        case RESOURCE_EXPERIENCE:
        {
            while (true)
            {
                auto level_config = MainLevelTable::instance()->getConfig(level);
                if ( ! level_config || level_config->exp == 0)
                {
                    break;
                }
                
                if ( level_config->exp - (exp + num) > 0 )
                {
                    exp += num;
                    break;
                }
                else
                {
                    num = (num - (level_config->exp - exp));
                    exp = 0;
                    level++;

//                    RoleData::instance()->activity_task_data.updateProgress(ATID_PLAYER_UPDRAGE);
                }
            }
            
            if (main_scene_ctr) {
                main_scene_ctr->setLevel(level);
                main_scene_ctr->setExp(level, exp);
            }
            break;
        }
        case RESOURCE_FRIEND_SHIP:
        {
            friend_ship += num;
            break;
        }
        default:
            break;
    }
}

void Player::resourceSub(ResourceType type, int64_t num) {
    if (num <= 0) {
        return;
    }
    
    MainSceneCtr* main_scene_ctr = MainSceneCtr::instance();
    
    switch (type) {
        case RESOURCE_GOLD:
        {
            int64_t temp = gold;
            gold = (gold - num) > 0 ? (gold - num) : 0;

            if (main_scene_ctr) {
                main_scene_ctr->setGold(temp, gold);
            }
//            RoleData::instance()->achievement_data.updateProgress(AID_COST_GOLD, num);
            break;
        }
        case RESOURCE_GEM:
        {
            int32_t tmp = gem;
            gem = (gem - (int32_t)num) > 0 ? (gem - (int32_t)num) : 0;
            
            if (main_scene_ctr) {
                main_scene_ctr->setGem(tmp, gem);
            }
            
            break;
        }
        case RESOURCE_ENERGY:
        {
            int32_t tmp = energy;
            energy = (energy - (int32_t)num) > 0 ? (energy - (int32_t)num) : 0;
            
            if (main_scene_ctr) {
//                main_scene_ctr->setEnergy(tmp, energy);
            }
            
//            RoleData::instance()->achievement_data.updateProgress(AID_COST_ENERGY, num);
            break;
        }
        case RESOURCE_FRIEND_SHIP:
        {
            friend_ship = (friend_ship - (int32_t)num) > 0 ? (friend_ship - (int32_t)num) : 0;
            break;
        }
        default:
            break;
    }
}

