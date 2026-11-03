//
//  UIMenuItemBattle.cpp
//  AVT
//
//  Created by conix on 4/1/16.
//
//

#include "UIMenuItemBattle.h"

#include "../../Animation/ActionFactory.h"
#include "../../Config/LanguageTable.h"


UIMenuItemBattle::UIMenuItemBattle() {
    x = 0;
    y = 0;
}

UIMenuItemBattle::UIMenuItemBattle(int x, int y) {
    this->x = x;
    this->y = y;
}

UIMenuItemBattle* UIMenuItemBattle::createWithSpriteFrameName(const char *normalImage, ccMenuCallback callback, int x, int y) {
    UIMenuItemBattle *pRet = new UIMenuItemBattle(x, y);
    if (pRet && pRet->initWithSpriteFrameName(normalImage, normalImage, NULL, callback))
    {
        pRet->autorelease();
        pRet->initDone();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

void UIMenuItemBattle::initDone() {
    
}

