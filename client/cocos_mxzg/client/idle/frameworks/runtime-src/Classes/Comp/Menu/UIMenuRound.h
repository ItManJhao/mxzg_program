//
//  UIMenuRound.h
//  Editorer
//
//  Created by windy on 2017/9/29.
//

#ifndef UIMenuRound_h
#define UIMenuRound_h

#include <iostream>
#include "cocos2d.h"
#include "UIMenu.h"

USING_NS_CC;
using namespace std;

typedef std::function<void(int32_t)> RoundSelectCallback;


class UIMenuRound : public Layer {
public:
    UIMenuRound();
    CREATE_FUNC(UIMenuRound);
    virtual bool init() override;
    
    virtual bool onTouchBegan(Touch* touch, Event* event) override;
    virtual void onTouchEnded(Touch* touch, Event* event) override;
    virtual void onTouchMoved(Touch* touch, Event* event) override;
    virtual void onTouchCancel(Touch* touch, Event* event);

    void setItem(vector<MenuItem*> vec_item);
    void pushItem(MenuItem* item);
    MenuItem* getItem(int32_t index);
    int32_t getItemSize();

    void setMinScale(float scale);
    void setMaxScale(float scale);
    void setRoundHeight(float height);
    void setRoundLength(float length);
    float getRoundLength();
    int32_t getSelectIndex();
    void setSelected(int32_t index);
    void setSelectCallBack(RoundSelectCallback callback);
    
    void openOpacity();
    void setMinOpacity(float opacity);

    void updateRound(float dt = 0);
    void deaccelerateScrolling(float dt);
    void stopSomewhere(float x);
    void scrollToPoint(float dt);
    float roundLimit(float l, float max);
    float calcMinDistance(float x, float &left_length, float &right_length);
protected:
    UIMenu* menu;
    bool is_appoint;
    int32_t select_index;

    float move_offset_x;
    float round_length;
    float now_place;
    float correct_offset;
    
    float min_scale;
    float max_scale;
    float round_height;
    
    bool is_open_opacity;
    float mim_opacity;
    
    float action_delay;
    float begin_x;
    float action_distance;
    bool dragging;
    Vec2 scroll_distance;
    Vec2 touch_point;
    Vec2 touch_begin_point;
    Touch* _touch;
    vector<MenuItem*> vec_item;
    RoundSelectCallback select_callback;
};



#endif /* UILayerRound_h */
