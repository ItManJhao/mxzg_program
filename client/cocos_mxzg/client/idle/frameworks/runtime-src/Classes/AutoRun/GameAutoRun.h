//
//  GameAutoRun.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__GameAutoRun__
#define __AVT__GameAutoRun__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "../Common/SingleInstance.h"
#include <map>

using namespace std;
USING_NS_CC;
USING_NS_CC_EXT;

class GameAutoRun : public Ref
{
public:
    void start();
    void stop();
    void stopAndRelease();
public:
    float interval;
    float delay;
    
    virtual void init() = 0;
    virtual void run(float delay) = 0;
    
};

#endif /* defined(__AVT__GameAutoRun__) */
