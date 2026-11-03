//
//  UIMenu.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__UIMenu__
#define __ClickerHeroes__UIMenu__

#include "../../Common/CommonDefine.h"

#include "editor-support/cocosbuilder/CocosBuilder.h"

using namespace cocosbuilder;

class UIMenu : public Menu {
public:
    bool enable_when_moving;    // 移动的时候按下仍有效
    bool enable_long_press;     // 是否开启长按
    bool enable_long_press_repeat;// 是否开启重复长按
    bool enable_double_click;   // 是否开启双击

    bool long_pressed;
    
    Point touch_began;
    Point p_distance;
    
    UIMenu();
    static UIMenu* create();
    static UIMenu* create(MenuItem* item, ...);
    static UIMenu* createWithArray(const Vector<MenuItem*>& arrayOfItems);
    static UIMenu* createWithItems(MenuItem* item, va_list args);
    virtual void onExit();

    virtual bool initWithArray(const Vector<MenuItem*>& arrayOfItems);
    
    virtual bool onTouchBegan(Touch* touch, Event* event);
    virtual void onTouchEnded(Touch* touch, Event* event);
    virtual void onTouchMoved(Touch* touch, Event* event);
    virtual void onTouchCancelled(Touch* touch, Event* event);

    void cancelLongPressSelected();
    
    void setIsTouchInsideNode(ScrollView* node);
    void setLongPressTarget(Ref *target, SEL_CallFuncO begin_selector, SEL_CallFuncO end_selector);
    virtual void setSwallowsTouches(bool swallowsTouches);
    
    virtual void longPress(float delay);
    virtual void longPressSelected(float delay);
    
    void setDoubleClickTarget(Ref *target, SEL_MenuHandler click_selector);
    
    virtual void setLuaModel(bool b);
    virtual void enableWhenMoving(bool b);
    virtual void enableLongPress(bool b);
    virtual void enableLongPressRepeat(bool b);
    virtual void enableDoubleClick(bool b);

    void setLongPressStaticTarget(Ref *target, SEL_CallFuncO begin_selector, SEL_CallFuncO end_selector);
    virtual void doubleClickTimeOut(float delay);

    bool checkChild(Node* child);
protected:
    bool is_moved;
    bool lua_model;
    
    ScrollView* is_touch_inside_node;

    Ref *long_press_target;
    SEL_CallFuncO begin_long_press_selector;
    SEL_CallFuncO end_long_press_selector;
    
    Ref *double_click_target;
    SEL_MenuHandler double_click_selector;
    MenuItem *_clickedItem;

    //  静止长按按钮响应begin，移动了或者停止点击则响应end
    Ref *long_press_static_target;
    SEL_CallFuncO begin_long_press_static_selector;
    SEL_CallFuncO end_long_press_static_selector;
    
    
    bool isTouchInside(Touch *touch);
    EventListenerTouchOneByOne* _touchListener;
};

#pragma mark -

class UIMenuLoader : public MenuLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenu);
    
    virtual void onHandlePropTypeCheck(Node * pNode, Node * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader);
};

#endif /* defined(__ClickerHeroes__UIMenu__) */
