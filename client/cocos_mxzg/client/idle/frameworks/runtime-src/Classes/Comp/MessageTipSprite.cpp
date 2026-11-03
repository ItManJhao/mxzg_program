//
//  MessageTipSprite.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "MessageTipSprite.h"
#include "../Common/CommonDefine.h"
#include "../Model/Utils.h"
#include "../Model/Game.h"

MessageTipSprite::MessageTipSprite()
{
    tip_label = NULL;
    tip_number = 0;
}

MessageTipSprite* MessageTipSprite::create(float parent_scale, bool is_numTip) {
    MessageTipSprite *pRet = new MessageTipSprite();
    if (pRet && pRet->init(parent_scale, is_numTip)) {
        pRet->autorelease();
        return pRet;
    } else {
        delete pRet;
        pRet = NULL;
        return NULL;
    }
}

bool MessageTipSprite::init(float parent_scale, bool is_numTip) {
    SpriteFrameCache::getInstance()->addSpriteFramesWithFile("ccbi-res/common-ui.plist");
    // 调用父类init初始化
    bool pRet = false;
    pRet = initWithSpriteFrameName("msg-tip.png");
    
    this->parent_scale = parent_scale;
    
    tip_label = Label::createWithTTF("", FONT_DEFAULT_NAME, 18);
    tip_label->setPosition(Point(this->getContentSize().width/2, this->getContentSize().height/2));
    ADD_NON_NULL_CHILD(tip_label, 0, 1);
    if (is_numTip) {
        setTipNumber(tip_number);
        
    } else {
        tip_label->setScale(1 / parent_scale);
        tip_label->setString("!");
    }
    return pRet;
}

// 设置tip数字
void MessageTipSprite::setTipNumber(uint8_t num) {
    if (this->isVisible() && num <= 0) {
        this->setVisible(false);
        return;
    }
    if (!this->isVisible() && num > 0) {    // 如果当前为显示，并且数量不为0，则显示
        this->setVisible(true);
    }
    
    tip_number = num;
    if (tip_number > 9) {
        tip_label->setString("9+");
        tip_label->setScale(getContentSize().width / tip_label->getContentSize().width / 1.414);
    } else {
        tip_label->setString(StringUtils::format("%d", tip_number));
        tip_label->setScale(1 / parent_scale);
    }
}

// 数量自增1
void MessageTipSprite::autoIncrements() {
    setTipNumber(tip_number + 1);
}







