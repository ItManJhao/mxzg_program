//
//  PlatformInit.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__PlatformInit__
#define __AVT__PlatformInit__

#include "../Common/CommonDefine.h"

#ifndef PLATFORM_TYPE
#define PLATFORM_TYPE 0
#endif

class PlatformInit {
public:
    static void init();
};

#endif /* defined(__AVT__PlatformInit__) */
