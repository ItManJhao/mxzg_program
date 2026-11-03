//
//  UIMenuItemScale.cpp
//  AVT
//
//  Created by conix on 6/29/16.
//
//

#include "UIMenuItemScale.h"
#include "UIMenu.h"
//int32_t UIMenuItemScale::flag_lock = 0;

UIMenuItemScale::UIMenuItemScale()
{
    o_scale = 1.0;
    des_scale = 1.3;
    scale_step = 0.1;
    
    pos_init = Point::ZERO;
    
    before_scale_item_tag = 0;
}

UIMenuItemScale::~UIMenuItemScale() {
    
}

UIMenuItemScale* UIMenuItemScale::create(const string& normal, const string& selected, float scale, ccMenuCallback callback) {
    UIMenuItemScale *pRet = new UIMenuItemScale();
    if (pRet && pRet->initWithSpriteFrameName(normal.c_str(), selected.c_str(), "", callback)) {
        pRet->initDone(scale);
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

void UIMenuItemScale::initDone(float scale) {
    o_scale *= scale;
    setContentSize(Size(getContentSize().width - 2 / scale, getContentSize().height));
    setAnchorPoint(Vec2(0.5, 0));
    
    schedule(schedule_selector(UIMenuItemScale::update), 0.01);
}

void UIMenuItemScale::setChecked(t_bool checked) {
    UIMenuItemTab::setChecked(checked);
}

void UIMenuItemScale::setInitPos(const cocos2d::Vec2 &position) {
    setPosition(position);
    
    pos_init = position;
}

void UIMenuItemScale::setOScale(float scale) {
    setScale(scale);
    
    o_scale = scale;
}

float UIMenuItemScale::getOScale() {
    return o_scale;
}

void UIMenuItemScale::update(float delay) {
    
    if (!isSelected()) {
        return;
    }

    float target_scale = o_scale * des_scale;

    if (getScale() == target_scale) {
        return;
    }

    Size size_item = Size(getContentSize().width * o_scale, getContentSize().height * o_scale);
    int tag_check = getTag();
    int tag_uncheck = 999;
    
    // 设置缩放
    float left_scale = abs(getScale() - target_scale);
    float init_scale = getScale();
    if (left_scale <= scale_step) {
        setScale(target_scale);
    
        before_scale_item_tag = 0;
    } else {
        if (init_scale < target_scale) {
            setScale(init_scale + left_scale * scale_step);
        } else {
            setScale(target_scale);
        }
    }
    
    UIMenuItemScale* item_uncheck = NULL;  // 放弃选中的item
    Vector<Node*>& vec_children = getParent()->getChildren();
    
    // 拿到这个放弃的item
    for (auto child : vec_children) {
        UIMenuItemScale* item = dynamic_cast<UIMenuItemScale*>(child);
        if (!item || item == this || item->getScale() == o_scale) {
            continue;
        }
        
        if (item->before_scale_item_tag != getTag() && item->before_scale_item_tag != 0) {
            item->setScale(o_scale);
            item->before_scale_item_tag = 0;
            continue;
        }
        item_uncheck = item;
        item_uncheck->before_scale_item_tag = getTag();
        break;
      
    }
    
    // 设置放弃选中的item缩放
    if (item_uncheck) {
        tag_uncheck = item_uncheck->getTag();
        item_uncheck->setScale(target_scale - getScale() + o_scale);
     
        if (item_uncheck->getScale() == o_scale) {
            item_uncheck->before_scale_item_tag = 0;
        }
    }
    
    // 设置各按钮位置
    float max_scale = 0;
    for (auto child : vec_children) {
        UIMenuItemScale* item = dynamic_cast<UIMenuItemScale*>(child);
        if (!item) {
            continue;
        }
        
        int item_tag = item->getTag();
        
        float pos_x = item->pos_init.x;
        if (item_tag > tag_uncheck) {
            pos_x += item->getContentSize().width * (item_uncheck->getScale() - o_scale);
        } else if (item_tag == tag_uncheck) {
            pos_x += item->getContentSize().width * (item_uncheck->getScale() - o_scale) / 2;
        }
        if (item_tag > tag_check) {
            pos_x += size_item.width / o_scale * (getScale() - o_scale);
        } else if (item_tag == tag_check) {
            pos_x += item->getContentSize().width * (getScale() - o_scale) / 2;
        }
        
        item->setPositionX(pos_x);
        
        if (pos_x > max_scale) {
            max_scale = pos_x;
        }
    }
    
    bool is_enabled = max_scale + 0.05 > des_scale;
    for (auto child : vec_children) {
        UIMenuItemScale* item = dynamic_cast<UIMenuItemScale*>(child);
        if (!item) {
            continue;
        }
        item->setEnabled(is_enabled);
    }
}
