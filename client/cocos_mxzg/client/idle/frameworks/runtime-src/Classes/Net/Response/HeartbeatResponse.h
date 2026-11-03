//
//  HeartbeatResponse.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__HeartbeatResponse__
#define __AVT__HeartbeatResponse__

#include "../Protocol/ProtocolResponse.h"

class HeartbeatResponse {
    
public:
    static void heartbeat(void *buffer , int32_t size); // 心跳
    
    static void broadcast(void *buffer,int32_t size);   // 系统公告
};

#endif /* defined(__AVT__HeartbeatResponse__) */
