//
//  CommonRunner.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "CommonRunner.h"

//#include "../Data/RoleData.h"
#include "../Model/Game.h"

void CommonRunner::init() {
    interval = delay = 0.3333;
}

void CommonRunner::run(float delay) {
    Game* game = Game::instance();
    
    // 半夜0点的时候做一些操作
    if ((game->getServerTime() + game->zone) % 86400 == 0) {
        // 每日匹配次数清零
//        RoleData* role_data = RoleData::instance();
//        if (role_data->pvp_match_time_used > 0) {
//            role_data->pvp_match_time_used = 0;
//        }
    }
}
