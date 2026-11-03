//
//  UIUIMenuRotate.h
//  AVT
//
//  Created by conix on 9/15/16.
//
//

#ifndef UIUIMenuRotate_h
#define UIUIMenuRotate_h

#include "../../Common/CommonDefine.h"

#include "UIMenu.h"
#include "UIMenuItem.h"

class UIMenuItemRotate : public UIMenuItemImage {
public:
    /**
     * 原始序号，用来记录该item的初始顺序，防止几个item顺序出现混乱
     * 最上面的为1，靠左的为2，旋转顺序依次增加
     */
    int8_t init_rotate_index;
    
    /**
     * 当前序号，根据menu计算记录当前item的序号，用来改变item的最终pos和当前order值及scale大小
     */
    int8_t now_rotate_index;
    
    float o_scale;  // 记录初始缩放
    
    UIMenuItemRotate();
    
    static UIMenuItemRotate* createWithSpriteFrameName(const std::string& spriteFrameName, float scale);
    void initDone(float scale);
    
    void setInitIndex(int8_t index);
};

class UIMenuRotate : public UIMenu {
public:
    static UIMenuRotate* create();
    UIMenuRotate();
    
    virtual bool onTouchBegan(Touch *touch, Event *unused_event);
    virtual void onTouchMoved(Touch *touch, Event *unused_event);
    virtual void onTouchEnded(Touch *touch, Event *unused_event);
    
    void setCardInitPos(map<int8_t, Point> init_pos);
    void setCardResponseSize(Size response_size);
    
    void updateCardPos(float offset_x, bool is_action = false);
    
    void actionEnd();
    void stopAction();
    
    void removeSelfFromParent();
    
protected:
    Size response_size;     // menu响应范围，超出区域外的不响应
    map<int8_t, Point> init_pos;    // key为序号，value为序号对应的初始位置
    float distance_between_card;    // 相邻两张卡之间的间距
    int32_t round_rotate;           // 已旋转圈数，正负代表旋转方向
};

#endif /* UIMenuRotate_h */
