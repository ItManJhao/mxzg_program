//
//  UIMenu.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMenu.h"
#include "UIMenuItem.h"
#include "../../Ctrl/Scene/MainSceneCtr.h"
#include "../../Model/LuaManager.h"

UIMenu::UIMenu() {
    lua_model = false;
    enable_when_moving = false;
    enable_long_press = false;
    enable_long_press_repeat = false;
    long_pressed = false;
    is_moved = false;
    touch_began = Point::ZERO;
    
    is_touch_inside_node = NULL;
    
    long_press_target = NULL;
    begin_long_press_selector = NULL;
    end_long_press_selector = NULL;
    
    enable_double_click = false;
    double_click_target = NULL;
    double_click_selector = NULL;
    
    long_press_static_target = NULL;
    begin_long_press_static_selector = NULL;
    end_long_press_static_selector = NULL;
    
    _clickedItem = NULL;
    //setGlobalZOrder(-9999);
}

UIMenu* UIMenu::create() {
    return create(NULL, NULL);
}

UIMenu * UIMenu::create(MenuItem* item, ...) {
    va_list args;
    va_start(args,item);
    
    UIMenu *pRet = UIMenu::createWithItems(item, args);
    
    va_end(args);
    
    return pRet;
}

UIMenu* UIMenu::createWithArray(const Vector<MenuItem*>& arrayOfItems) {
    UIMenu *pRet = new UIMenu();
    if (pRet && pRet->initWithArray(arrayOfItems)) {
        pRet->autorelease();
    } else {
        CC_SAFE_DELETE(pRet);
    }
    
    return pRet;
}

UIMenu* UIMenu::createWithItems(MenuItem* item, va_list args) {
    Vector<MenuItem*> pArray;
    if( item ) {
        pArray.pushBack(item);
        MenuItem *i = va_arg(args, MenuItem*);
        while(i) {
            pArray.pushBack(i);
            i = va_arg(args, MenuItem*);
        }
    }
    
    return UIMenu::createWithArray(pArray);
}

bool UIMenu::initWithArray(const Vector<MenuItem*>& arrayOfItems) {
    if (Layer::init()) {
        _enabled = true;
        // menu in the center of the screen
        Size s = Director::getInstance()->getWinSize();
        
        this->ignoreAnchorPointForPosition(true);
        this->setAnchorPoint(Vec2(0.5f, 0.5f));
        this->setContentSize(s);
        
        this->setPosition(s.width/2, s.height/2);
        
        int z=0;
        
        for (auto& item : arrayOfItems) {
            this->addChild(item, z);
            z++;
        }
        
        _selectedItem = nullptr;
        _state = Menu::State::WAITING;
        
        // enable cascade color and opacity on menus
        setCascadeColorEnabled(true);
        
        _touchListener = EventListenerTouchOneByOne::create();
        _touchListener->setSwallowTouches(true);
        _touchListener->onTouchBegan = CC_CALLBACK_2(UIMenu::onTouchBegan, this);
        _touchListener->onTouchMoved = CC_CALLBACK_2(UIMenu::onTouchMoved, this);
        _touchListener->onTouchEnded = CC_CALLBACK_2(UIMenu::onTouchEnded, this);
        _touchListener->onTouchCancelled = CC_CALLBACK_2(UIMenu::onTouchCancelled, this);
        _eventDispatcher->addEventListenerWithSceneGraphPriority(_touchListener, this);
        return true;
    }
    return false;
}

void UIMenu::onExit()
{
    if (lua_model && enable_long_press) {
        LuaManager::instance()->handleEvent(this, "onExit", [&](LuaStack * ls) {
            ls->pushObject((Ref*)this, "UIMenu");
            return 1;
        });
    }
    Menu::onExit();
}


// 判断子节点是否移除了
bool UIMenu::checkChild(Node* child) {
    bool is_has_children = false;
    auto children = this->getChildren();
    for (int i = 0; i < children.size(); i++)
    {
        if (children.at(i) == _selectedItem) {
            is_has_children = true;
        }
    }
    return is_has_children;
}

bool UIMenu::onTouchBegan(Touch* touch, Event* event) {
    
//    CCLOG("UIMenu.tag = %d", this->getTag());
    
    if (!isTouchInside(touch)) {
        return false;
    }
    
    t_bool flag = Menu::onTouchBegan(touch, event);
    if (flag) {
        touch_began = touch->getLocation();
        if (enable_long_press) {
            long_pressed = false;
            this->schedule(schedule_selector(UIMenu::longPress), 0.1, CC_REPEAT_FOREVER, 0.3);
        }
        if (enable_long_press) {
            long_pressed = false;
            this->schedule(schedule_selector(UIMenu::longPress), 0.1, CC_REPEAT_FOREVER, 0.3);
        }
    }

    return flag;
}

void UIMenu::onTouchEnded(Touch* touch, Event* event) {
    this->unschedule(schedule_selector(UIMenu::longPress));
    this->unschedule(schedule_selector(UIMenu::longPressSelected));
    
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);

    if ((_selectedItem && this->checkChild(_selectedItem) == false) || this->getParent() == NULL) {
        _selectedItem = NULL;
    }

    this->retain();
    //CCAssert(m_eState == kCCMenuStateTrackingTouch, "[Menu ccTouchEnded] -- invalid state");
    if (_selectedItem)
    {
        _selectedItem->unselected();
        if (!is_moved && !long_pressed) {
            _selectedItem->activate();
        }
        
        if (enable_double_click) {
            if (_clickedItem == _selectedItem) {
                if (double_click_target && double_click_selector) {
                    (double_click_target->*double_click_selector)(_selectedItem);
                }
            } else {
                _clickedItem = _selectedItem;
            }
            this->unschedule(schedule_selector(UIMenu::doubleClickTimeOut));
            this->schedule(schedule_selector(UIMenu::doubleClickTimeOut), 0, 0,0.2);
        }
    }
    
    if (enable_long_press && long_pressed && long_press_target != NULL && end_long_press_selector != NULL) {
        (long_press_target->*end_long_press_selector)(_selectedItem);
    }
    
    if (enable_long_press && long_pressed &&
        long_press_static_target != NULL &&
        end_long_press_static_selector != NULL) {
        (long_press_static_target->*end_long_press_static_selector)(_selectedItem);
    }
    
    if (lua_model && enable_long_press && _selectedItem) {
        LuaManager::instance()->handleEvent(this, "longPressEnd", [&](LuaStack * ls) {
            ls->pushObject((Ref*)this, "UIMenu");
            ls->pushObject((Ref*)_selectedItem, "MenuItem");
            return 2;
        });
    }
    
    is_moved = false;
    _state = Menu::State::WAITING;
    _selectedWithCamera = nullptr;
    this->release();
}

void UIMenu::onTouchMoved(Touch* touch, Event* event) {
    if (abs((int)(touch_began.x - touch->getLocation().x)) > UI_ENABLE_MOVE_DISTANCE ||
        abs((int)(touch_began.y - touch->getLocation().y)) > UI_ENABLE_MOVE_DISTANCE) {
        is_moved = !enable_when_moving;
    }
    
    if ((_selectedItem && this->checkChild(_selectedItem) == false) || this->getParent() == NULL) {
        _selectedItem = NULL;
    }

    if (is_moved) {
        this->unschedule(schedule_selector(UIMenu::longPress));
        
        if (enable_long_press && long_pressed &&
            long_press_static_target != NULL &&
            end_long_press_static_selector != NULL) {
            (long_press_static_target->*end_long_press_static_selector)(_selectedItem);
        }
    }
    
    Menu::onTouchMoved(touch, event);
}

void UIMenu::onTouchCancelled(Touch* touch, Event* event)
{
    this->onTouchEnded(touch, event);
}

void UIMenu::longPress(float delay) {
    long_pressed = true;
    
    if (long_press_target != NULL && begin_long_press_selector != NULL) {
        (long_press_target->*begin_long_press_selector)(_selectedItem);
    }
    
    if (long_press_static_target != NULL && begin_long_press_static_selector != NULL) {
        (long_press_static_target->*begin_long_press_static_selector)(_selectedItem);
    }
    
    if (lua_model && _selectedItem) {
        LuaManager::instance()->handleEvent(this, "longPress", [&](LuaStack * ls) {
            ls->pushObject((Ref*)this, "UIMenu");
            ls->pushObject((Ref*)_selectedItem, "MenuItem");
            return 2;
        });
    }
    
    if (!enable_long_press_repeat) {
        this->unschedule(schedule_selector(UIMenu::longPress));
    }
   // this->schedule(schedule_selector(UIMenu::longPressSelected), 0.1);
}

void UIMenu::longPressSelected(float delay) {
    if (!_selectedItem) {
        return;
    }
    
    UIMenuItemImage* selected_item = dynamic_cast<UIMenuItemImage*>(_selectedItem);
    if (selected_item) {
        selected_item->unselected(true);
    } else {
        _selectedItem->unselected();
    }
    _selectedItem->activate();
}

void UIMenu::cancelLongPressSelected() {
    this->unschedule(schedule_selector(UIMenu::longPressSelected));
    this->_selectedItem = NULL;
    
    if (long_press_target != NULL && end_long_press_selector != NULL) {
        (long_press_target->*end_long_press_selector)(NULL);
    }
    
    if (lua_model) {
        LuaManager::instance()->handleEvent(this, "cancelLongPressSelected", [&](LuaStack * ls) {
            ls->pushObject((Ref*)this, "UIMenu");
            return 1;
        });
    }
}

void UIMenu::doubleClickTimeOut(float delay)
{
    _clickedItem = NULL;
}

bool UIMenu::isTouchInside(Touch *touch) {
    if (!is_touch_inside_node) {
        return true;
    }
    
    if (!touch) {
        return false;
    }
    Node* parent = getParent();
    if (!parent) {
        return false;
    }
    Point touchLocation = touch->getLocation(); // Get the touch position
    touchLocation = is_touch_inside_node->convertToNodeSpace(touchLocation);
    
    Size s = is_touch_inside_node->getViewSize();
    Rect rect;
    rect.setRect(0, 0, s.width, s.height);
    
    return rect.containsPoint(touchLocation);
}



void UIMenu::setIsTouchInsideNode(cocos2d::extension::ScrollView* node) {
    is_touch_inside_node = node;
}

void UIMenu::setLongPressTarget(Ref *target, SEL_CallFuncO begin_selector, SEL_CallFuncO end_selector) {
    long_press_target = target;
    begin_long_press_selector = begin_selector;
    end_long_press_selector = end_selector;
    
    if (long_press_target == NULL) {
        begin_long_press_selector = NULL;
        end_long_press_selector = NULL;
    }
}

void UIMenu::setDoubleClickTarget(Ref *target, SEL_MenuHandler click_selector)
{
    double_click_target = target;
    double_click_selector = click_selector;
    if (double_click_target == NULL) {
        double_click_selector = NULL;
    }
}

void UIMenu::setLongPressStaticTarget(Ref *target, SEL_CallFuncO begin_selector, SEL_CallFuncO end_selector) {
    long_press_static_target = target;
    begin_long_press_static_selector = begin_selector;
    end_long_press_static_selector = end_selector;
    
    if (long_press_static_target == NULL) {
        begin_long_press_static_selector = NULL;
        end_long_press_static_selector = NULL;
    }
}

void UIMenu::setSwallowsTouches(bool swallowsTouches) {
    _touchListener->setSwallowTouches(swallowsTouches);
}

void UIMenu::setLuaModel(bool b) {
    lua_model = b;
}

void UIMenu::enableWhenMoving(bool b) {
    enable_when_moving = b;
}

void UIMenu::enableLongPress(bool b) {
    enable_long_press = b;
}

void UIMenu::enableLongPressRepeat(bool b) {
    enable_long_press_repeat = b;
}

void UIMenu::enableDoubleClick(bool b) {
    enable_double_click = b;
}

#pragma mark -

void UIMenuLoader::onHandlePropTypeCheck(Node * pNode, Node * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, "swallowsTouches") == 0) {
        ((UIMenu*)pNode)->setSwallowsTouches(pCheck);
    } else {
        MenuLoader::onHandlePropTypeCheck(pNode, pParent, pPropertyName, pCheck, pCCBReader);
    }
}
