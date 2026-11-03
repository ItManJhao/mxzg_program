//
//  AchievementResponse.cpp
//  AVT
//
//  Created by windy on 2017/11/15.
//

#include "LuaResponse.h"
#include "../../Data/RoleData.h"
#include "../../Model/LuaManager.h"

void LuaResponse::luaResponse(void *buffer , int32_t size)
{
    ByteArray* data = ByteArray::create();
    data->pushData(buffer, size);
    
//    auto protocol_base = (ProtocolBase*)buffer;
//    if (protocol_base->protocol == 1218004) {
//        auto req = (ResPvpBattleHistory*)buffer;
//        req = NULL;
//    }
//    log("LuaResponse::luaResponse = %d", protocol_base->protocol);
    LuaManager::instance()->executeGlobalByteArrayFunction("response", data, "ByteArray");
}
