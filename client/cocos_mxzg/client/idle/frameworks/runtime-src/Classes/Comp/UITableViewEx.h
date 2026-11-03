#ifndef __UITableViewEx_H__
#define __UITableViewEx_H__

#include "cocos-ext.h"
#include "cocos2d.h"
#include "../Model/Game.h"
#include "editor-support/cocosbuilder/CocosBuilder.h"

USING_NS_CC;
USING_NS_CC_EXT;

using namespace cocosbuilder;

class UITableViewEx : public cocos2d::extension::TableView
{
public:
    UITableViewEx();
    static UITableViewEx* create(Size view_size);
    
    virtual void onTouchEnded(Touch *pTouch, Event *pEvent) override;
    
    virtual void onScrollViewTouchEnded(Touch* touch, Event* event);
    
    void deaccelerateScrolling(float dt);
    
    
    void setMoveSpeed(float speed);
    float getMoveSpeed();
public:
    float move_speed;
};

#endif
