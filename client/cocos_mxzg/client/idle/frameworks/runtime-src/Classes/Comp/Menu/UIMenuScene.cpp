//
//  UIMenuScene.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMenuScene.h"

#include "../../Ctrl/Scene/MainSceneCtr.h"


#include "../../Model/Utils.h"
#include "../MessageView.h"

UIMenuScene::UIMenuScene() {
    hero_selected = NULL;
    enable_long_press = true;
    p_began = Point::ZERO;
    player_owner = NULL;
    
    last_operate_time = 0;
    
    battle_statue = AT_STAND;
    
    scroll_view = NULL;
}

void UIMenuScene::addHero(Hero* hero) {
    
}

Hero* UIMenuScene::getHeroById(int64_t hero_id) {
    Vector<Node*>& vec_children = getChildren();
    
    for (int i = 0; i < vec_children.size(); i++) {
        Hero* hero = dynamic_cast<Hero*>(vec_children.at(i));
        if (!hero) {
            continue;
        }
        
        if (hero->item_id == hero_id) {
            return hero;
        }
    }
    
    return NULL;
}

Hero* UIMenuScene::getHeroByPos(int x, int y) {
    Vector<Node*>& vec_children = getChildren();
    
    for (int i = 0; i < vec_children.size(); i++) {
        Hero* hero = dynamic_cast<Hero*>(vec_children.at(i));
        if (!hero || hero->isDie()) {
            continue;
        }
        
        if (hero->x == x && hero->y == y) {
            return hero;
        }
    }
    
    return NULL;
}

void UIMenuScene::enableScrollView(bool b) {
    if (scroll_view) {
        scroll_view->setCanHandle(b);
    }
}

void UIMenuScene::initMenu() {
    scroll_view = dynamic_cast<UIScrollViewZoom*>(getParent()->getParent());
}

bool UIMenuScene::onTouchBegan(Touch* touch, Event* event) {
    auto camera = Camera::getVisitingCamera();
    if (_state != Menu::State::WAITING || ! _visible || !_enabled || !camera) {
        return false;
    }
    
    for (Node *c = this->_parent; c != nullptr; c = c->getParent()) {
        if (c->isVisible() == false) {
            return false;
        }
    }
    
    is_moved = false;
    
    touch_began = touch->getLocation();
    
    _selectedItem = this->getItemForTouch(touch, camera);
    if (_selectedItem) {
        _state = Menu::State::TRACKING_TOUCH;
        _selectedWithCamera = camera;
        _selectedItem->selected();
        
        p_began = convertToNodeSpace(touch_began);
        
        return true;
    }
    
    onPutDown();
    
    return false;
}

void UIMenuScene::onTouchEnded(Touch* touch, Event* event) {
    CCAssert(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchEnded] -- invalid state");
    this->retain();
    if (_selectedItem) {
        if (_selectedItem != hero_selected) {
            if (!is_moved) {
                _selectedItem->activate();
                if (_selectedItem) {
                    hero_selected = (Hero*)_selectedItem;
                    onPickedUp();
                }
            }
        }
        
    } else {
        onPutDown();
    }
    
    is_moved = false;
    
    _state = Menu::State::WAITING;
    _selectedWithCamera = nullptr;
    this->release();
}

void UIMenuScene::onTouchMoved(Touch* touch, Event* event) {
    Menu::onTouchMoved(touch, event);
}

void UIMenuScene::onTouchCancelled(Touch *touch, Event* event) {
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);
    CCAssert(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchCancelled] -- invalid state");
    if (_selectedItem) {
        _selectedItem->unselected();
    }
    _state = Menu::State::WAITING;
    
//    if (scroll_view->touch_count > 0) {
//        scroll_view->touch_count -= 1;
//    }
}

void UIMenuScene::addChild(Node * child) {
    Layer::addChild(child);
}

void UIMenuScene::addChild(Node * child, int zOrder) {
    Layer::addChild(child, zOrder);
}

void UIMenuScene::addChild(Node * child, int zOrder, int tag) {
    Layer::addChild(child, zOrder, tag);
}

void UIMenuScene::removeChild(Node* child, bool cleanup) {
    if (_selectedItem == child) {
        _selectedItem = NULL;
    }
    
    Node::removeChild(child, cleanup);
}

t_int32 UIMenuScene::countBuildingZOrder(Point p) {
//    return MapManager::countZOrder(p);
}

void UIMenuScene::reorderChild(cocos2d::Node *child, int zOrder) {
    UIMenu::reorderChild(child, zOrder);
}

MenuItem* UIMenuScene::getItemForTouch(Touch * touch, const Camera *camera) {
    if (_children.size() == 0) {
        return NULL;
    }
    
    Point touchLocation = touch->getLocation();
    
    float min_distance = -1;
    
    MenuItem* nearest_item = NULL;
    // 建筑NormalImage、网格区域，找与手点坐标最近的出来
    for (int i = 0; i < _children.size(); i++) {
        Hero* hero = dynamic_cast<Hero*>(_children.at(i));
        if (hero && hero->isVisible() && hero->isEnabled())
        {
            Point local = hero->convertToNodeSpace(touchLocation);
            
            Rect item_rect = hero->rect();
            item_rect.origin = Point::ZERO;
            
            if (item_rect.containsPoint(local)) {
                float distance = local.distance(Point(item_rect.getMidX(), item_rect.getMidY()));
                if (min_distance == -1 || min_distance > distance) {
                    min_distance = distance;
                    nearest_item = hero;
                }
            }
        }
    }
    
    return nearest_item;
}

// 当建筑被中时
void UIMenuScene::onPickedUp() {
//    unit_selected->onPicked();
}

void UIMenuScene::onPutDown() {
    if (hero_selected) {
        hero_selected->setSelected(false);
        hero_selected = NULL;
    }
}

void UIMenuScene::removeNode(Node *node) {
    node->removeFromParentAndCleanup(true);
}
