//
//  AchievementResponse.h
//  AVT
//
//  Created by windy on 2017/11/15.
//

#ifndef LuaResponse_h
#define LuaResponse_h
#include "../Protocol/ProtocolResponse.h"

class LuaResponse {
public:
    static void luaResponse(void *buffer , int32_t size);
};

#endif /* AchievementResponse_h */
