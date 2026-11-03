//
//  UIMenuBattle.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMenuBattle.h"

//#include "UIMenuItemBar.h"

#include "../../Data/RoleData.h"

#include "../../Person/Hero.h"

#include "../../Common/CommonDefine.h"

//#include "../../Model/MapManager.h"
#include "../MessageView.h"

UIMenuBattle::UIMenuBattle() {
    is_show_tool_bar = true;
    is_moving_hero = false;
   // schedule(schedule_selector(UIMenuBattle::update), 0.01);
}

UIMenuBattle* UIMenuBattle::create() {
    UIMenuBattle *pRet = new UIMenuBattle();
    if (pRet && pRet->initWithArray(Vector<MenuItem*>())) {
        pRet->autorelease();
    } else {
        delete pRet;
        pRet = NULL;
    }
    return pRet;
}

bool UIMenuBattle::initWithArray(const Vector<MenuItem*>& arrayOfItems) {
    if (Layer::init()) {
        _enabled = true;
        // menu in the center of the screen
        Size s = Director::getInstance()->getWinSize();
        
        this->setIgnoreAnchorPointForPosition(true);
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
        
        auto touchListener = EventListenerTouchOneByOne::create();
        
        touchListener->onTouchBegan = CC_CALLBACK_2(UIMenuBattle::onTouchBegan, this);
        touchListener->onTouchMoved = CC_CALLBACK_2(UIMenuBattle::onTouchMoved, this);
        touchListener->onTouchEnded = CC_CALLBACK_2(UIMenuBattle::onTouchEnded, this);
        touchListener->onTouchCancelled = CC_CALLBACK_2(UIMenuBattle::onTouchCancelled, this);
//        touchListener->onTouchesBegan = CC_CALLBACK_2(UIMenuBattle::onTouchesBegan, this);
//        touchListener->onTouchesMoved = CC_CALLBACK_2(UIMenuBattle::onTouchesMoved, this);
//        touchListener->onTouchesEnded = CC_CALLBACK_2(UIMenuBattle::onTouchesEnded, this);
//        touchListener->onTouchesCancelled = CC_CALLBACK_2(UIMenuBattle::onTouchesCancelled, this);
        
        _eventDispatcher->addEventListenerWithSceneGraphPriority(touchListener, this);
        
        return true;
    }
    return false;
}

bool UIMenuBattle::onTouchBegan(Touch* touch, Event* event) {
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
    
    Unit* unit = dynamic_cast<Unit*>(_selectedItem);
    
    p_began = convertToNodeSpace(touch_began);

    if (enable_long_press) {
        long_pressed = false;
        this->schedule(schedule_selector(UIMenu::longPress), 0, 0, 0.3);
    }
    
    is_scroll_view_can_move = isScrollViewCanMove();
    if (_selectedItem) {
        if (!unit && !hero_selected) {
            return false;
        }
        
        _selectedWithCamera = camera;
        _selectedItem->selected();
        
//        BattleSceneCtr* battle_ctr = BattleSceneCtr::instance();
//        Hero* hero = (Hero*)_selectedItem;
//        if ( isUnitMoveEnabled() ) {
//            p_distance = Point(p_began.x - _selectedItem->getPosition().x,
//                               p_began.y - _selectedItem->getPosition().y);
//            is_scroll_view_can_move = false;
//
//            Vec2 pos = p_began - p_distance;
//            battle_ctr->heroMove(hero, pos, ! is_moving_hero);
//            is_moving_hero = true;
//        }
//        battle_ctr->pos_move = Point(hero->battle_hero->x, hero->battle_hero->y);
    }
    
    enableScrollView(is_scroll_view_can_move);
    
    _state = Menu::State::TRACKING_TOUCH;
    return true;
}

void UIMenuBattle::onTouchEnded(Touch* touch, Event* event) {
    CCAssert(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchEnded] -- invalid state");
    this->retain();
    
//    BattleSceneCtr* battle_ctr = BattleSceneCtr::instance();
    
//    this->unschedule(schedule_selector(UIMenu::longPress));
//
//    if (long_press_target != NULL && end_long_press_selector != NULL) {
//        (long_press_target->*end_long_press_selector)(NULL);
//    }
//
//    if (enable_double_click) {
//        if (_clickedItem == _selectedItem) {
//            if (double_click_target && double_click_selector) {
//                (double_click_target->*double_click_selector)(_selectedItem);
//            }
//        } else {
//            _clickedItem = _selectedItem;
//        }
//        this->unschedule(schedule_selector(UIMenu::doubleClickTimeOut));
//        this->schedule(schedule_selector(UIMenu::doubleClickTimeOut), 0, 0,0.2);
//    }
//
//    if ( isUnitMoveEnabled() ) {
//        Hero* hero = dynamic_cast<Hero*>(_selectedItem);
//        if ( hero ) {
//            Point now = convertToNodeSpace(touch->getLocation());
//            now.x -= p_distance.x;
//            now.y -= p_distance.y;
//
//            battle_ctr->heroPutDown(hero, now, false);
//        }
//    }
//
//    is_moved = false;
//
//    _state = Menu::State::WAITING;
//    _selectedWithCamera = nullptr;
//    is_moving_hero = false;
//    this->release();
}

void UIMenuBattle::onTouchCancelled(Touch* touch, Event* event) {
    onTouchEnded(touch, event);
//    CCASSERT(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchCancelled] -- invalid state");
//    this->retain();
//
//    this->unschedule(schedule_selector(UIMenu::longPress));
//
//    if (_selectedItem) {
//        _selectedItem->unselected();
//    }
//
//    _state = Menu::State::WAITING;
//    this->release();
}

void UIMenuBattle::onTouchMoved(Touch* touch, Event* event) {
    CCAssert(_state == Menu::State::TRACKING_TOUCH, "[Menu ccTouchMoved] -- invalid state");
    if (abs((int)(touch_began.x - touch->getLocation().x)) > 5 ||
        abs((int)(touch_began.y - touch->getLocation().y)) > 5) {
        is_moved = !enable_when_moving;
    }
    
//    BattleSceneCtr* battle_scene_ctr = BattleSceneCtr::instance();
//
//    if (is_moved) {
//        this->unschedule(schedule_selector(UIMenu::longPress));
//        // battle_scene_ctr->hideGridInfo();
//    }
//
//    if ( isUnitMoveEnabled()) {
//        Point now = convertToNodeSpace(touch->getLocation());
//        now.x -= p_distance.x;
//        now.y -= p_distance.y;
//
//        Hero* hero = (Hero*)_selectedItem;
//        battle_scene_ctr->heroMove(hero, now, ! is_moving_hero );
//        is_moving_hero = true;
//    }
}

void UIMenuBattle::onTouchesBegan(const std::vector<Touch *> &touch, cocos2d::Event *event) {
    onTouchBegan(touch.at(0), event);
    
//    if (touch.size() > 1 && scroll_view && is_scroll_view_can_move) {
//        for (int i = 1; i < touch.size(); i++) {
//            scroll_view->onTouchBegan(touch.at(i), event);
//        }
//    }
}

void UIMenuBattle::onTouchesEnded(const std::vector<Touch *> &touch, cocos2d::Event *event) {
    onTouchEnded(touch.at(0), event);
    
//    if (touch.size() > 1 && scroll_view && is_scroll_view_can_move) {
//        for (int i = 1; i < touch.size(); i++) {
//            scroll_view->onTouchEnded(touch.at(i), event);
//        }
//    }
}

void UIMenuBattle::onTouchesCancelled(const std::vector<Touch *> &touch, cocos2d::Event *event) {
    onTouchCancelled(touch.at(0), event);
    
//    if (touch.size() > 1 && scroll_view && is_scroll_view_can_move) {
//        for (int i = 1; i < touch.size(); i++) {
//            scroll_view->onTouchCancelled(touch.at(i), event);
//        }
//    }
}

void UIMenuBattle::onTouchesMoved(const std::vector<Touch *> &touch, cocos2d::Event *event) {
    onTouchMoved(touch.at(0), event);
    
//    if (touch.size() > 1 && scroll_view && is_scroll_view_can_move) {
//        for (int i = 1; i < touch.size(); i++) {
//            scroll_view->onTouchMoved(touch.at(i), event);
//        }
//    }
}

bool UIMenuBattle::isScrollViewCanMove() {
    for (list<NodeCtr*>::iterator iter = list_ctrs.begin(); iter != list_ctrs.end(); iter++) {
        if ((*iter)->isOpened() && !(*iter)->is_scroll_view_can_move) {
            return false;
        }
    }
    
    return true;
}

void UIMenuBattle::update(float delta) {
    UIMenuScene::update(delta);
    
}

void UIMenuBattle::longPress(float delay) {
    long_pressed = true;
    
    if (long_press_target != NULL && begin_long_press_selector != NULL) {
        (long_press_target->*begin_long_press_selector)(_selectedItem);
    }
}

void UIMenuBattle::setShowToolBar(bool visible) {
    is_show_tool_bar = visible;
    
    if (!visible && hero_selected) {
        onPutDown();
    }
}

MenuItem* UIMenuBattle::getItemForTouch(cocos2d::Touch *touch, const Camera *camera) {
    return UIMenuScene::getItemForTouch(touch, camera);
}

MenuItem* UIMenuBattle::getItemForTouch(cocos2d::Touch *touch, const Camera *camera, bool is_ignor_enemy) {
    Point touchLocation = touch->getLocation();
    
    Player* player = Player::instance();
    RoleData* role_data = RoleData::instance();
    
    MenuItem* item_selected = NULL;
    // 按照渲染顺序 _children里的node 会重新排序 即地图格子会排在前面 如果英雄和地图格子重叠 ，先判断是否点击到格子再判断是否点击到英雄
    if (_children.size() > 0) {
        for (int i = 0; i < _children.size(); i++) {
            Hero* hero = dynamic_cast<Hero*>(_children.at(i));
            
            if (hero && hero->isVisible() && hero->isEnabled() ) {
                //CCLOG("判断英雄");
                if (is_ignor_enemy) {
                    if (hero->role_id != player->role_id) {
                        continue;
                    }
                }
                // 获取到这个格子上的自己的英雄 hero_tmp
//                Point local_point = role_data->map_manager.pointFromScreenToMap(touchLocation, (UIScrollViewZoom*)getParent()->getParent());
//                Point local_grid = role_data->map_manager.pointToGrid(local_point);
//                Hero *hero_tmp = BattleSceneCtr::instance()->getHeroItemByGrid(player->role_id , local_grid);
//                
//                // 判断是否触摸到精灵 通过点击到的格子判断 不是纹理大小
//
//                if (hero_tmp != nullptr && (hero_tmp->battle_hero->hero_id == hero->battle_hero->hero_id)) {
//                    if (hero == hero_selected) {
//                        return hero;
//                    } else {
//                        item_selected = hero;
//                    }
//                }
            }
        }
    }
    
    return item_selected;
}

bool UIMenuBattle::isUnitMoveEnabled() {
   
    return true;
}




