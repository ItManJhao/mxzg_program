//
//  ActionFactory.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__ActionFactory__
#define __ClickerHeroes__ActionFactory__

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"

using namespace std;
USING_NS_CC;
USING_NS_CC_EXT;

class ActionFactory : public Ref {
public:
    static ActionInterval* createAnimateWithDuration(const char *plist, string format, float duration, CallFunc* callFunc);
    static ActionInterval* createLuaAnimateWithDuration(const char *plist, string format, float duration);

    static Animation* createAnimation(const char *plist, string format, float speed);
    static ActionInterval* createAnimate(const char *plist, string format, float speed, CallFunc* callFunc);
    static ActionInterval* createLuaAnimate(const char *plist, string format, float speed);
    static ActionInterval* createAnimate(string format, float speed, int32_t index);
    static RepeatForever* createRepeatForever(const char *plist, string format, float speed);
    
    static ActionInterval* createAnimateWithRemoveSelf(const char *plist, string format, float speed);
    // 可以指定某一帧的延迟时间  注意frame_index 帧数应该从零开始算
    static ActionInterval* createAnimateWithDelayFrame(const char *plist, string format, float speed,int32_t frame_index, float delay_time);
    
    static ActionInterval* createBeattackAction(Point pos);
    
    static ActionInterval* createShakeAction(float range, int times, float slow_down);
};

#endif /* defined(__ClickerHeroes__ActionFactory__) */
