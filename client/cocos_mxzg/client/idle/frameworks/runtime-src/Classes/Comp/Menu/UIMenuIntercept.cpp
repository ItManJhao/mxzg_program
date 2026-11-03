//
//  UIMenuIntercept.cpp
//  AVT
//
//  Created by conix on 7/1/16.
//
//

#include "UIMenuIntercept.h"

#include "../../Model/Game.h"

UIMenuIntercept::UIMenuIntercept()
: layer_parent(NULL)
{
    touch_began_inside = false;
}

UIMenuIntercept* UIMenuIntercept::create() {
    return create(NULL, NULL);
}

UIMenuIntercept * UIMenuIntercept::create(MenuItem* item, ...)
{
    va_list args;
    va_start(args,item);
    
    UIMenuIntercept *pRet = UIMenuIntercept::createWithItems(item, args);
    
    va_end(args);
    
    return pRet;
}

UIMenuIntercept* UIMenuIntercept::createWithArray(const Vector<MenuItem*>& arrayOfItems) {
    UIMenuIntercept *pRet = new UIMenuIntercept();
    if (pRet && pRet->initWithArray(arrayOfItems)) {
        pRet->autorelease();
    } else {
        CC_SAFE_DELETE(pRet);
    }
    
    return pRet;
}

UIMenuIntercept* UIMenuIntercept::createWithItems(MenuItem* item, va_list args) {
    Vector<MenuItem*> pArray;
    if( item ) {
        pArray.pushBack(item);
        MenuItem *i = va_arg(args, MenuItem*);
        while(i) {
            pArray.pushBack(i);
            i = va_arg(args, MenuItem*);
        }
    }
    
    return UIMenuIntercept::createWithArray(pArray);
}

//bool UIMenuIntercept::initWithArray(const Vector<MenuItem*>& arrayOfItems) {
//    if (Menu::init()) {
//        _enabled = true;
//        // menu in the center of the screen
//        Size s = Director::getInstance()->getWinSize();
//        
//        this->setIgnoreAnchorPointForPosition(true);
//        this->setAnchorPoint(Vec2(0.5f, 0.5f));
//        this->setContentSize(s);
//        
//        this->setPosition(s.width/2, s.height/2);
//        
//        int z=0;
//        
//        for (auto& item : arrayOfItems) {
//            this->addChild(item, z);
//            z++;
//        }
//        
//        _selectedItem = nullptr;
//        _state = Menu::State::WAITING;
//        
//        // enable cascade color and opacity on menus
//        setCascadeColorEnabled(true);
//        setCascadeOpacityEnabled(true);
//        
//        auto touchListener = EventListenerTouchOneByOne::create();
//        
//        touchListener->onTouchBegan = CC_CALLBACK_2(UIMenuIntercept::onTouchBegan, this);
//        touchListener->onTouchMoved = CC_CALLBACK_2(UIMenuIntercept::onTouchMoved, this);
//        touchListener->onTouchEnded = CC_CALLBACK_2(UIMenuIntercept::onTouchEnded, this);
//        touchListener->onTouchCancelled = CC_CALLBACK_2(UIMenuIntercept::onTouchCancelled, this);
//        
//        _eventDispatcher->addEventListenerWithSceneGraphPriority(touchListener, this);
//        
//        return true;
//    }
//    return false;
//}

bool UIMenuIntercept::onTouchBegan(Touch *touch, Event *unused_event) {
    touch_began_inside = layer_parent->isTouchInside(touch);
    return true;
}

void UIMenuIntercept::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *unused_event) {
    if (!touch_began_inside && !layer_parent->isTouchInside(touch)) {
        if (Game::instance()->isKeyBoardShown()) {
            // 键盘打开了，关闭键盘
            Game::instance()->shutDownKeyBoard();
        } else {
            // 关闭窗口
            layer_parent->close();
        }
    }
}

void UIMenuIntercept::setParentLayer(UIModelLayer *layer) {
    layer_parent = layer;
}
