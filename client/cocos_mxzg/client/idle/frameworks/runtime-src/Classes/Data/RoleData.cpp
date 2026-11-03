//
//  RoleData.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "RoleData.h"
#include "../Ctrl/Scene/MainSceneCtr.h"

#include "../Comp/MessageView.h"

RoleData::RoleData()
: total_charge(0)   // 充值总数
, is_role_rename(false)
, is_new_player(false)
, login_time(0)
, role_create_time(0)
, inline_time_tip(0)
, adventure_daily_limit(0)
, befall_daily_limit(0)
, restore_energy(0)
{
    first_charge_status = 3;
}

RoleData::~RoleData() {
    
}

bool RoleData::isFirstCharge() {
    return total_charge - 6 <= 0;
}


