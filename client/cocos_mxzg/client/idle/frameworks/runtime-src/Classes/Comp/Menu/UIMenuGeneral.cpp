//
//  UIMenuGeneral.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMenuGeneral.h"

#include "../../Ctrl/Scene/MainSceneCtr.h"


#include "../../Model/Utils.h"
#include "../MessageView.h"
#include "../../Model/LuaManager.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

UIMenuGeneral::UIMenuGeneral() {
    p_began = Point::ZERO;
    _selectedNode = NULL;
    is_moved = false;
    enable_when_moving = false;
}

bool UIMenuGeneral::init() {
    Vector<MenuItem*> pArray;
    return initWithArray(pArray);
}

bool UIMenuGeneral::onTouchBegan(Touch* touch, Event* event) {
    is_moved = false;
    if (!isTouchInside(touch)) {
        return false;
    }
    
    auto camera = Camera::getVisitingCamera();
    if (_state != Menu::State::WAITING || ! _visible || !_enabled || !camera)
    {
        return false;
    }
    
    for (Node *c = this->_parent; c != nullptr; c = c->getParent())
    {
        if (c->isVisible() == false)
        {
            return false;
        }
    }
    
    touch_began = touch->getLocation();
    
    _selectedNode = this->getNodeForTouch(touch, camera);
    
    if (_selectedNode)
    {
        _state = Menu::State::TRACKING_TOUCH;
        _selectedWithCamera = camera;
//        _selectedItem->selected();
        LuaManager::instance()->handleEvent(this, "itmeTouchBegan", [&](LuaStack* ls) {
            ls->pushObject(_selectedNode, "cc.Node");
            return 1;
        });
        return true;
    }
    
    return false;
}

void UIMenuGeneral::onTouchEnded(Touch* touch, Event* event) {
    CCASSERT(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchEnded] -- invalid state");
    this->retain();
//    if (_selectedItem)
//    {
//        _selectedItem->unselected();
//        _selectedItem->activate();
//    }
//    log("is_moved = %d", is_moved);
    if (!is_moved && _selectedNode)
    {
        LuaManager::instance()->handleEvent(this, "itmeTouchEnded", [&](LuaStack* ls) {
            ls->pushObject(_selectedNode, "cc.Node");
            return 1;
        });
    }
    
    is_moved = false;
    _state = Menu::State::WAITING;
    _selectedWithCamera = nullptr;
    this->release();
}


void UIMenuGeneral::onTouchMoved(Touch* touch, Event* event) {
    CCASSERT(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchMoved] -- invalid state");
    
    if (abs((int)(touch_began.x - touch->getLocation().x)) > UI_ENABLE_MOVE_DISTANCE ||
        abs((int)(touch_began.y - touch->getLocation().y)) > UI_ENABLE_MOVE_DISTANCE) {
        is_moved = !enable_when_moving;
    }
    
    Node*currentItem = this->getNodeForTouch(touch, _selectedWithCamera);
    if (currentItem != _selectedNode)
    {
//        if (_selectedItem)
//        {
//            _selectedItem->unselected();
//        }
        _selectedNode = currentItem;
        if (_selectedNode)
        {
            LuaManager::instance()->handleEvent(this, "itmeTouchMoved", [&](LuaStack* ls) {
                ls->pushObject(_selectedNode, "cc.Node");
                return 1;
            });
        }
//        if (_selectedItem)
//        {
//            _selectedItem->selected();
//        }
    }
}

void UIMenuGeneral::onTouchCancelled(Touch *touch, Event* event) {
    CCASSERT(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchCancelled] -- invalid state");
    this->retain();
    if (_selectedNode)
    {
        LuaManager::instance()->handleEvent(this, "itmeTouchCancelled", [&](LuaStack* ls) {
            ls->pushObject(_selectedNode, "cc.Node");
            return 1;
        });
    }
//    if (_selectedItem)
//    {
//        _selectedItem->unselected();
//    }
    _state = Menu::State::WAITING;
    this->release();
}

void UIMenuGeneral::addChild(Node * child)
{
    Layer::addChild(child);
}

void UIMenuGeneral::addChild(Node * child, int zOrder)
{
    Layer::addChild(child, zOrder);
}

void UIMenuGeneral::addChild(Node * child, int zOrder, int tag)
{
    Layer::addChild(child, zOrder, tag);
}

void UIMenuGeneral::addChild(Node * child, int zOrder, const std::string &name)
{
    Layer::addChild(child, zOrder, name);
}

void UIMenuGeneral::removeChild(Node* child, bool cleanup) {
    if (_selectedNode == child) {
        _selectedNode = NULL;
    }
    
    Node::removeChild(child, cleanup);
}

void UIMenuGeneral::reorderChild(cocos2d::Node *child, int zOrder) {
    UIMenu::reorderChild(child, zOrder);
}

Node* UIMenuGeneral::getNodeForTouch(Touch * touch, const Camera *camera) {
    Vec2 touchLocation = touch->getLocation();
    for (const auto &item: _children)
    {
        Node* child = dynamic_cast<Node*>(item);
        if (nullptr == child || false == child->isVisible())
        {
            continue;
        }
        Rect rect;
        rect.size = child->getContentSize();
        if (isScreenPointInRect(touchLocation, camera, child->getWorldToNodeTransform(), rect, nullptr))
        {
            return child;
        }
    }
    return nullptr;
}

void UIMenuGeneral::removeNode(Node *node) {
    node->removeFromParentAndCleanup(true);
}


void UIMenuGeneral::setWhenMoving(bool b) {
    enable_when_moving = b;
}

bool UIMenuGeneral::getWhenMoving() {
    return enable_when_moving;
}

#pragma mark -

void UIMenuGeneralLoader::onHandlePropTypeCheck(Node * pNode, Node * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, "swallowsTouches") == 0) {
        ((UIMenu*)pNode)->setSwallowsTouches(pCheck);
    } else {
        LayerLoader::onHandlePropTypeCheck(pNode, pParent, pPropertyName, pCheck, pCCBReader);
    }
}


