//
//  NodeCtr.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "WindowCtr.h"
#include "../../Comp/UIWindowLayer.h"

const float window_action_duration = 0.16;

WindowCtr::WindowCtr()
{
    action_running = false;
}

WindowCtr::~WindowCtr()
{
    
}

SEL_MenuHandler WindowCtr::onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* pSelectorName) {
    CCB_SELECTORRESOLVER_CCMENUITEM_GLUE(this, "close", WindowCtr::close);
    return NodeCtr::onResolveCCBCCMenuItemSelector(pTarget, pSelectorName);
}

void WindowCtr::open() {
    if (is_opened || action_running) {
        return;
    }
    NodeCtr::open();
    runAction(true);
}

void WindowCtr::close(Ref* object) {
    if (!is_opened) {
        return;
    }
    
    if (layer) {
        auto act_ease = layer->getActionByTag(-999);
        if (act_ease) {
            return;
        }
    }
    
//    if (action_running) {
//        return;
//    }
    
    runAction(false);
}

void WindowCtr::runAction(bool flag) {
    action_running = true;
    
    // 加一个最高优先级的事件响应，以使在动画过程中，其他事件被屏蔽掉，在动画结束后恢复
//    Director::getInstance()->getTouchDispatcher()->addTargetedDelegate(this, -3, true);
    
    ActionInterval* action = NULL;
    if (flag) {
        float scale = layer->getScale();
        layer->setScale(scale * 0.8f);
        action = Sequence::create(ScaleTo::create(window_action_duration * 0.5, scale),
                                  CallFunc::create(CC_CALLBACK_0(WindowCtr::openActionEnd, this)),
                                  NULL);
    } else {
        action = Sequence::create(ScaleTo::create(window_action_duration * 0.5, 0.1),
                                        CallFunc::create(CC_CALLBACK_0(WindowCtr::closeActionEnd, this)),
                                        NULL);
    }
    auto act_ease = EaseExponentialOut::create(action);
    act_ease->setTag(-999);
    layer->runAction(act_ease);
    allChildrenFade(layer, window_action_duration, flag);
}

void WindowCtr::closeActionEnd()
{
//    Director::getInstance()->getTouchDispatcher()->removeDelegate(this);
    NodeCtr::close(NULL);
    action_running = false;
}

void WindowCtr::openActionEnd()
{
//    Director::getInstance()->getTouchDispatcher()->removeDelegate(this);
    action_running = false;
}

void WindowCtr::runAction(Node *executor, int8_t type, bool open, const std::function<void()>& call_func)
{
    action_running = true;
//    Director::getInstance()->getTouchDispatcher()->addTargetedDelegate(this, -3, true);
    
    float duration = 0.0f;
    Point p = Point::ZERO;
    
    FiniteTimeAction* action = NULL;
    if (type == 1) {
        duration = window_action_duration;
        action = Sequence::create(ScaleTo::create(duration / 2, 1.14),
                                  ScaleTo::create(duration / 2, 1.0),
                                  CallFunc::create(call_func),
                                  NULL);
    } else if (type == 2) {
        if (open) {
            duration = 0.05f;
            p = executor->getPosition();
            executor->setPositionX(executor->getPositionX() + 35.0f);
            executor->setVisible(false);
            
            action = Sequence::create(DelayTime::create(0.016f),
                                      Show::create(),
                                      MoveTo::create(duration, p),
                                      CallFunc::create(call_func),
                                      NULL);
            
        } else {
            duration = 0.05f;
            p = Point(executor->getPositionX() - 35.0f, executor->getPositionY());
            
            action = Sequence::create(MoveTo::create(duration, p),
                                      CallFunc::create(call_func),
                                      NULL);
        }
        
        
    } else {
        if (open) {
            duration = 0.05f;
            p = executor->getPosition();
            executor->setPositionX(executor->getPositionX() - 35.0f);
            executor->setVisible(false);
          
            action = Sequence::create(DelayTime::create(0.016f),
                                      Show::create(),
                                      MoveTo::create(duration, p),
                                      CallFunc::create(call_func),
                                      NULL);
        } else {
            duration = 0.05f;
            p = Point(executor->getPositionX() + 35.0f, executor->getPositionY());
            
            action = Sequence::create(MoveTo::create(duration, p),
                                      CallFunc::create(call_func),
                                      NULL);
        }
    }
    
    executor->runAction(action);
    allChildrenFade(executor, duration, open);
}
