//
//  UIMenuRotate.cpp
//  AVT
//
//  Created by conix on 9/15/16.
//
//

#include "UIMenuRotate.h"

UIMenuItemRotate::UIMenuItemRotate() {
    init_rotate_index = 0;
    now_rotate_index = 0;
}

UIMenuItemRotate* UIMenuItemRotate::createWithSpriteFrameName(const std::string &spriteFrameName, float scale) {
    
    UIMenuItemRotate* pRet = new UIMenuItemRotate();
    if (pRet && pRet->initWithSpriteFrameName(spriteFrameName.c_str(), spriteFrameName.c_str(), spriteFrameName.c_str(), NULL)) {
        pRet->initDone(scale);
        pRet->autorelease();
    } else {
        delete pRet;
        pRet = NULL;
    }
    return pRet;
}

void UIMenuItemRotate::initDone(float scale) {
    setEnabled(false);  // 按钮不可点击
    
    o_scale = scale;
}

void UIMenuItemRotate::setInitIndex(int8_t index) {
    this->init_rotate_index = index;
    this->now_rotate_index = index;
}

UIMenuRotate* UIMenuRotate::create() {
    UIMenuRotate* pRet = new UIMenuRotate();
    if (pRet && pRet->init()) {
        pRet->autorelease();
        return pRet;
    } else {
        delete pRet;
        pRet = NULL;
        return  pRet;
    }
}

UIMenuRotate::UIMenuRotate() {
}

bool UIMenuRotate::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *unused_event) {
    log("touch begin");
    
    Point pos_touch = touch->getLocationInView();
    Vec2 pos_menu = getPosition();
    
    if (pos_touch.x > pos_menu.x &&
        pos_touch.y > pos_menu.y &&
        pos_touch.x < pos_menu.x + response_size.width &&
        pos_touch.y < pos_menu.y + response_size.height) {
        touch_began = pos_touch;
        return true;    // Layer::onTouchBegan(touch, unused_event);
    }
    
    return false;
}

void UIMenuRotate::onTouchMoved(Touch *touch, Event *unused_event) {
    // 获取x轴的移动距离
    float offset_x = touch->getLocation().x - touch_began.x;
    if (offset_x == 0) {
        return;
    }
    
    updateCardPos(offset_x);
    log("touch move");
}

void UIMenuRotate::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *unused_event) {
    float offset_x = touch->getLocation().x - touch_began.x;
    if (offset_x == 0) {
        return;
    }
    
    updateCardPos(offset_x, true);
    
    round_rotate = 0;
    do {
        if (abs(offset_x) > distance_between_card) {
            if (offset_x > 0) {
                offset_x -= distance_between_card;
                round_rotate -= 1;
            } else {
                offset_x += distance_between_card;
                round_rotate += 1;
            }
        } else {
            break;
        }
    } while(1);
    float percent_offset = offset_x / distance_between_card;
    Vector<Node*>& children = getChildren();
    for (auto child : children) {
        UIMenuItemRotate* node = dynamic_cast<UIMenuItemRotate*>(child);
        if (node == NULL) {
            break;
        }
        if (init_pos.find(node->now_rotate_index) == init_pos.end()) {
            break;
        }
        int8_t index_target = node->now_rotate_index + round_rotate;
        if (abs(percent_offset) > 0.5f) {
            if (percent_offset < 0) {
                index_target += 1;
            } else {
                index_target -= 1;
            }
        }
        do {
            if (index_target <= 0) {
                index_target += init_pos.size();
            } else if (index_target > init_pos.size()) {
                index_target -= init_pos.size();
            } else {
                break;
            }
        } while(1);
        node->now_rotate_index = index_target;
    }
    
    Layer::onTouchEnded(touch, unused_event);
    log("touch end");
}

void UIMenuRotate::setCardInitPos(map<int8_t, Point> init_pos) {
    this->init_pos = init_pos;
    
    if (init_pos.size() < 2) {
        distance_between_card = 0;
    } else {
        distance_between_card = abs(init_pos.at(1).x - init_pos.at(2).x);
    }
}

void UIMenuRotate::setCardResponseSize(cocos2d::Size response_size) {
    this->response_size = response_size;
}

void UIMenuRotate::updateCardPos(float offset_x, bool is_action) {
    round_rotate = 0;
    do {
        if (abs(offset_x) > distance_between_card) {
            if (offset_x > 0) {
                offset_x -= distance_between_card;
                round_rotate -= 1;
            } else {
                offset_x += distance_between_card;
                round_rotate += 1;
            }
        } else {
            break;
        }
    } while(1);
    float percent_offset = offset_x / distance_between_card;
    
    Vector<Node*>& children = getChildren();
    for (auto child : children) {
        UIMenuItemRotate* node = dynamic_cast<UIMenuItemRotate*>(child);
        if (node == NULL) {
            break;
        }
        if (init_pos.find(node->now_rotate_index) == init_pos.end()) {
            break;
        }
        node->stopAllActions();
        
        int8_t last_idx = node->now_rotate_index + round_rotate;
        do {
            if (last_idx <= 0) {
                last_idx += init_pos.size();
            } else if (last_idx > init_pos.size()) {
                last_idx -= init_pos.size();
            } else {
                break;
            }
        } while(1);
        Point pos_init = init_pos.at(last_idx);
        int8_t index_target = last_idx;
        if (percent_offset == 0) {
            node->setPosition(pos_init);
        } else {
            if (percent_offset < 0) {
                index_target += 1;
                if (index_target > init_pos.size()) {
                    index_target -= init_pos.size();
                }
            } else {
                index_target -= 1;
                if (index_target <= 0) {
                    index_target += init_pos.size();
                }
            }
            
            log("target index: %d", index_target);
            Point pos_target = init_pos.at(index_target);
            node->setPositionX(pos_init.x + (pos_target.x - pos_init.x) * abs(percent_offset));
            node->setPositionY(pos_init.y + (pos_target.y - pos_init.y) * abs(percent_offset));
            
            if (is_action) {
                if (abs(offset_x) > distance_between_card / 2) {
                    node->runAction(MoveTo::create(0.3f, pos_target));
                } else {
                    node->runAction(MoveTo::create(0.3f, pos_init));
                }
            }
        }
        
        switch (last_idx) {
            case 1:
                node->setScale(node->o_scale * (1.0f - abs(0.2f * percent_offset)));
                node->getParent()->reorderChild(node, 30);
                if (is_action) {
                    if (abs(offset_x) > distance_between_card / 2) {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 0.8f));
                        node->getParent()->reorderChild(node, 20);
                    } else {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 1.0f));
                    }
                }
                break;
            case 2:
                if (percent_offset > 0) {
                    node->setScale(node->o_scale * (0.8f + abs(0.2f * percent_offset)));
                    node->getParent()->reorderChild(node, 30);
                } else {
                    node->setScale(node->o_scale * 0.8f);
                    node->getParent()->reorderChild(node, 20);
                }
                if (is_action) {
                    if (abs(offset_x) > distance_between_card / 2 && percent_offset > 0) {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 1.0f));
                        node->getParent()->reorderChild(node, 30);
                    } else {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 0.8f));
                        node->getParent()->reorderChild(node, 20);
                    }
                }
                break;
            case 3:
                node->setScale(node->o_scale * 0.8f);
                node->getParent()->reorderChild(node, 10);
                break;
            case 4:
                if (percent_offset < 0) {
                    node->setScale(node->o_scale * (0.8f + abs(0.2f * percent_offset)));
                    node->getParent()->reorderChild(node, 30);
                } else {
                    node->setScale(node->o_scale * 0.8f);
                    node->getParent()->reorderChild(node, 20);
                }
                if (is_action) {
                    if (abs(offset_x) > distance_between_card / 2 && percent_offset < 0) {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 1.0f));
                        node->getParent()->reorderChild(node, 30);
                    } else {
                        node->runAction(ScaleTo::create(0.3f, node->o_scale * 0.8f));
                        node->getParent()->reorderChild(node, 20);
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

void UIMenuRotate::actionEnd() {
    
}

void UIMenuRotate::stopAction() {
    
    Vector<Node*>& children = getChildren();
    for (auto child : children) {
        UIMenuItemRotate* spr_effect_node = dynamic_cast<UIMenuItemRotate*>(child);
        if (spr_effect_node == NULL) {
            break;
        }
        spr_effect_node->stopAllActions();
    }
    
    actionEnd();
}

void UIMenuRotate::removeSelfFromParent() {
    removeFromParentAndCleanup(true);
}
