//
//  NodeCtr.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__WindowCtr__
#define __ClickerHeroes__WindowCtr__

#include "../NodeCtr.h"

extern const float window_action_duration;

/**
 所有带有放大特效的窗口(CCNode)的Controller的父类
 */
class WindowCtr : public NodeCtr
{
public:
    WindowCtr();
    ~WindowCtr();
    virtual void open();
    virtual void close(Ref* object);
    
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* pSelectorName);
    
    virtual void runAction(bool flag);
    
    virtual void closeActionEnd();
    virtual void openActionEnd();
protected:
    virtual void runAction(Node *executor, int8_t type, bool open, const std::function<void()>& call_func = NULL);
};

#endif /* defined(__ClickerHeroes__EffectNodeCtr__) */
