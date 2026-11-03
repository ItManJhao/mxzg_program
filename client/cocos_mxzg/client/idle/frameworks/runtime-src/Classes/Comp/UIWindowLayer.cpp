//
//  UIWindowLayer.cpp
//  RongYaoZhiCheng
//
//  Created by Conix on 16-3-2.
//
//

#include "UIWindowLayer.h"

UIWindowLayer::UIWindowLayer()
//: mask(NULL)
//, menu_intercept(NULL)
: listener(NULL)
, is_auto_close(true)
{
    
}

UIWindowLayer::~UIWindowLayer() {
    
}

void UIWindowLayer::onNodeLoaded(Node * pNode, NodeLoader * pNodeLoader) {
    LayerBase::onNodeLoaded(pNode, pNodeLoader);
    
    Size content_size = getContentSize();
    
    Size size = Director::getInstance()->getWinSize();
    this->setPosition(Vec2((size.width - content_size.width) / 2, (size.height - content_size.height) / 2));
    
//    listener = EventListenerTouchOneByOne::create();
//    listener->setSwallowTouches(true);
//    listener->onTouchBegan = CC_CALLBACK_2(UIWindowLayer::onTouchBegan, this);
//    listener->onTouchMoved = CC_CALLBACK_2(UIWindowLayer::onTouchMoved, this);
//    listener->onTouchEnded = CC_CALLBACK_2(UIWindowLayer::onTouchEnded, this);
//    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
//    menu_intercept = UIMenuIntercept::create();
//    menu_intercept->setPosition(Point::ZERO);
//    menu_intercept->setParentLayer(this);
//    addChild(menu_intercept, -9999);
    
//    auto aa = this->getEventDispatcher();
//    aa->removeEventListenersForTarget(<#Node *target#>)
    
    // add mask
//    mask = Sprite::createWithSpriteFrameName("window-mask.png");
//    mask->setScaleX(size.width / (mask->getContentSize().width - 2) * 1.1);
//    mask->setScaleY(size.height / (mask->getContentSize().height - 2) * 1.1);
//    mask->setPosition(Vec2(content_size.width / 2, content_size.height / 2));
//    this->addChild(mask, -200);
}

void UIWindowLayer::setSwallowTouches(bool is_swallow_touches)
{
//    listener->setSwallowTouches(is_swallow_touches);
}

void UIWindowLayer::setAutoClose(bool is_auto) {
//    is_auto_close = is_auto;
}


bool UIWindowLayer::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event) {
    return UIModelLayer::onTouchBegan(touch, event);
}

void UIWindowLayer::onTouchMoved(Touch *touch, Event *event) {
    UIModelLayer::onTouchMoved (touch,event);
}

void UIWindowLayer::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event) {
    if (is_auto_close) {
        UIModelLayer::onTouchEnded (touch,event);
    }
}




