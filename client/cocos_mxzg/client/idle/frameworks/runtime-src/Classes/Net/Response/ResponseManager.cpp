//
//  ResponseManager.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "ResponseManager.h"

#include "ErrorResponse.h"
#include "HeartbeatResponse.h"
#include "LuaResponse.h"

//#include "../../Ctrl/Layer/GuideCtr.h"
#include "../../Model/LuaManager.h"

int64_t ResponseManager::getResponse(int key)
{
    return response_map[key];
}

ResponseManager::ResponseManager()
{
    init();
}

void ResponseManager::init()
{
#pragma mark 心跳包 & 全服广播
    // ResHeartbeat
    response_map[2201001] = (int64_t)&HeartbeatResponse::heartbeat; // 心跳包
    
#pragma mark 错误码
    // 错误码回调函数  ResError
    response_map[1200000] = (int64_t)&ErrorResponse::getError;
    

    


//#pragma mark 军团信息
//    // ResClanInfo
//    response_map[1207001] = (int64_t)&ClanResponse::clanInfo;
//
//    // ResClanCreate
//    response_map[1207002] = (int64_t)&ClanResponse::clanCreate;
//
//    // ResClanSearch
//    response_map[1207003] = (int64_t)&ClanResponse::clanSearch;
//
//    // ResClanJoin
//    response_map[1207004] = (int64_t)&ClanResponse::clanJoin;
//
//    // ResClanMsgInfo
//    response_map[1207006] = (int64_t)&ClanResponse::clanMsgInfo;    // 操作战盟记录
//
//    // ResClanReqMsgInfo
//    response_map[1207007] = (int64_t)&ClanResponse::clanReqInfo;    // 非战盟成员加入战盟请求
//
//    // ResClanReqAgree
//    response_map[1207008] = (int64_t)&ClanResponse::clanReqAgree;   // 玩家接受到处理过的战盟请求
//
//    // ResUpdateAllClanInfo
//    response_map[1207009] = (int64_t)&ClanResponse::clanUpdateInfo; // 刷新军团界面
//
//    // ResClanChangePos
//    response_map[1207011] = (int64_t)&ClanResponse::clanChangePos;
//
//    // ResClanChatList
//    response_map[1207020] = (int64_t)&ClanResponse::clanChatList;

}

int64_t ResponseManager::getLuaResponse(int key)
{
    auto iter_call_fun = lua_response_map.find(key);
    if (iter_call_fun == lua_response_map.end()) {
        return NULL;
    }
    
    return (int64_t)lua_response_map[key];
}

void ResponseManager::addLuaResponse(int key)
{
    lua_response_map[key] = (int64_t)&LuaResponse::luaResponse;                  // LUA
}

void ResponseManager::response(ByteArray* data)
{
    if (!data) {
        return;
    }
    
    auto res = (ProtocolBase*)data->getData();
    if (res->protocol == 1207001) {
        auto tmp_res = (ResClanInfo*)res;
        tmp_res = NULL;
    }
    
    data->resetPos();
    auto protocol = data->readInt();
    auto function = getResponse(protocol);
    if (!function) {
        return;
    }
    
    void (*pf)(void* , int32_t) = (void (*)(void* , int32_t))function;
    (*pf)(data->getData(), data->getLength());
    
    LuaManager::instance()->executeGlobalAutoFunction("waitRecvProtocol", [&](LuaStack * ls) {
        ls->pushInt(protocol);
        return 1;
    });
    
//    GuideCtr::waitRecvProtocol(protocol);
}

void ResponseManager::luaResponse(ByteArray* data)
{
    auto length = data->getLength();
    auto byte_data = data->getData();
    auto protocol = data->readInt();
    int64_t function = getLuaResponse(protocol);
    if (function) {
        void (*pf)(void* , int32_t) = (void (*)(void* , int32_t))function;
        (*pf)(byte_data, length);
    }
}

void ResponseManager::clearLuaResponse()
{
    lua_response_map.clear();
}
