//
//  UIMenuBattle.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UIMenuBattle__
#define __AVT__UIMenuBattle__

#include "UIMenuScene.h"
#include "../../Data/Player.h"

class UIMenuBattle : public UIMenuScene {
public:
    UIMenuBattle();
    
    static UIMenuBattle* create();
    
    virtual bool initWithArray(const Vector<MenuItem*>& arrayOfItems);
    
    virtual bool onTouchBegan(Touch* touch, Event* event);
    virtual void onTouchEnded(Touch* touch, Event* event);
    virtual void onTouchCancelled(Touch* touch, Event* event);
    virtual void onTouchMoved(Touch* touch, Event* event);
    
    virtual void onTouchesBegan(const std::vector<Touch*>& touch, Event* event);
    virtual void onTouchesEnded(const std::vector<Touch*>& touch, Event* event);
    virtual void onTouchesCancelled(const std::vector<Touch*>& touch, Event* event);
    virtual void onTouchesMoved(const std::vector<Touch*>& touch, Event* event);
    
    
    virtual void update(float delta);
    
    virtual void longPress(float delay);
    
    void setShowToolBar(bool visible);
    
protected:
    
    bool is_show_tool_bar;  // 是否显示tool_bar，战斗时，攻击次序不在自己时，不显示攻击选项
    
    // 在touch_began时记录一下，以免除touch_move时重复调用判断函数
    bool is_scroll_view_can_move;
    
    bool is_moving_hero;
    
    // 重写itemForTouch
    virtual MenuItem* getItemForTouch(Touch * touch, const Camera *camera);
    
    virtual MenuItem* getItemForTouch(Touch* touch, const Camera *camera, bool is_ignor_enemy);
    
    bool isScrollViewCanMove();
    
    bool isUnitMoveEnabled();
    
    bool canMove(Point old_point, Point new_point);
};

#endif /* defined(__AVT__UIMenuBattle__) */
