//
//  UIModelLayer.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "UIModelLayer.h"
#include "../Ctrl/NodeCtr.h"

#include "../Model/Game.h"

UIModelLayer::UIModelLayer()
{
    touch_began_inside = false;
}

void UIModelLayer::close() {
    if (controller) {
        controller->close(NULL);
    } else {
        removeFromParentAndCleanup(true);
    }
}

bool UIModelLayer::onTouchBegan(Touch *pTouch, Event *pEvent) {
    touch_began_inside = isTouchInside(pTouch);
    return LayerBase::onTouchBegan(pTouch, pEvent);
}

void UIModelLayer::onTouchEnded(Touch *pTouch, Event *pEvent) {
    LayerBase::onTouchEnded(pTouch, pEvent);
    
    if (!touch_began_inside && this->getParent() && !isTouchInside(pTouch) && Game::instance()->isInVisible(this)) {
        if (Game::instance()->isKeyBoardShown()) {
            // 键盘打开了，关闭键盘
            Game::instance()->shutDownKeyBoard();
        } else {
            // 关闭窗口
            close();
        }
    }
}
