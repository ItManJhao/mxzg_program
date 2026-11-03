//
//  ResponseManager.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__ResponseManager__
#define __ClickerHeroes__ResponseManager__

#include <iostream>
#include <map>
#include "../../Common/SingleInstance.h"
#include "../Protocol/ProtocolResponse.h"
#include "../../Model/ByteArray.h"

class ResponseManager : public SingleInstance<ResponseManager> {
public:
//    static ResponseManager* instance();
    ResponseManager();
    int64_t getResponse(int key);
    int64_t getLuaResponse(int key);
    void addLuaResponse(int key);
    void luaResponse(ByteArray* data);
    
    // LUA回调CPP接口
    void response(ByteArray* data);
    
    void clearLuaResponse();
protected:
    map<int, int64_t> response_map;
    map<int, int64_t> lua_response_map;
    void init();
};

#endif /* defined(__ClickerHeroes__ResponseManager__) */
