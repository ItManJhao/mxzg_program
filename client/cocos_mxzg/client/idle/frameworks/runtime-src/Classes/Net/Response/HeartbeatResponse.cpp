//
//  HeartbeatResponse.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "HeartbeatResponse.h"
#include "../../Model/Game.h"
#include "../../Comp/MessageView.h"

void HeartbeatResponse::heartbeat(void *buffer , int32_t size) {
    ResHeartbeat* res = reinterpret_cast<ResHeartbeat*>(buffer);
    if (res && res->server_time > 0) {
        Game* game = Game::instance();
        game->setServerTime(res->server_time);
        
        CCLOG("server_time: %lld, %lld", res->server_time, Game::millisecond());
    }
}

void HeartbeatResponse::broadcast(void *buffer,int32_t size) {
    ResBroadcast *res = reinterpret_cast<ResBroadcast*>(buffer);
    int len = (size - sizeof(ProtocolResponse)) / sizeof(char);
    char msg[len];
    memset(msg,0,sizeof(msg));
    strcpy(msg,res->msg);
    MessageView::instance()->add(res->msg, 0);
}
