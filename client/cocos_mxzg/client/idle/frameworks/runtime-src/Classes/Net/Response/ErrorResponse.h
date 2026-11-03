//
//  ErrorResponse.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__ErrorResponse__
#define __AVT__ErrorResponse__

#include "../Protocol/ProtocolResponse.h"

class ErrorResponse
{
public:
    // 获取错误信息回调函数
    static void getError(void *buffer , int32_t size);
};

#endif /* defined(__AVT__ErrorResponse__) */
