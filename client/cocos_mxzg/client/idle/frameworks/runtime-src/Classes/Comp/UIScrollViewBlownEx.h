//
//  UIScrollViewBlownEx.h
//  Editorer
//
//  Created by windy on 2017/9/30.
//

#ifndef UIScrollViewBlownEx_h
#define UIScrollViewBlownEx_h

#include "cocos2d.h"
#include "UIWindowLayer.h"
#include "Menu/UIMenuItem.h"
#include "Menu/UIMenu.h"

USING_NS_CC;
using namespace std;

class UIScrollViewBlownEx : public cocos2d::extension::ScrollView,
                            public cocos2d::extension::ScrollViewDelegate
{
public:
    UIScrollViewBlownEx();
    ~UIScrollViewBlownEx(){};
    static UIScrollViewBlownEx* create(Size view_size);
    virtual bool initWithSize(Size view_size);
    
    void stopScrollAnimation();     // 停止滚动动画
    void stopSomewhere(Vec2 offset);// 惯性滚动到某个位置停下来.
    
    void setItemScale(float min_scale, float max_scale);
    void setItemOffset(float offset);
    void setScaleDistance(float distance);
    void setDidStopSpeed(float speed_y, float offset_max);
    void setSelect(int index, bool animation);
    void setMinSelect(int32_t index);
    
    void setSelectCallBack(const std::function<void (UIScrollViewBlownEx*, int)> &func);     // 最终选定目标.有bug.选中第一个或最后一个时不执行回调.不建议使用
    void setAutoSelectCallBack(const std::function<void (UIScrollViewBlownEx*, int)> &func); // 滑动时选中的目标
    void setDelegateA(cocos2d::extension::ScrollViewDelegate* pDelegate) { delegate = pDelegate;}
    
    void updateView();
    void addItem(MenuItem* item);
    int  getSelect();
    int  getItemCount();
protected:
    void updateTweenAction(float value, const std::string& key) override;
    virtual void onTouchEnded(Touch *touch, Event *event) override;
    void deaccelerateScrolling(float dt);
    void scrollToPoint(float dt);
    int getSelectIndex(Node* node);
    
    virtual void scrollViewDidScroll(ScrollView* view) override;
    virtual void scrollViewDidZoom(ScrollView* view) override;
    virtual void scrollViewWillStop(Vec2 speed);
protected:
    float min_scale;
    float max_scale;
    float distance_scale;
    float m_speed_y;
    float m_speed_offset;
    float action_time;
    float begin_y;
    float distance_offset;
    float item_offset;
    float min_offset;
    bool is_touch_item;
    int32_t select_index;
    UIMenu* menu; // 不能滑动..请修改menu..menu的点击事件会吞噬滑动事件
    Node* select_item;
    vector<MenuItem*> vec_item;
    std::function<void (UIScrollViewBlownEx*, int)> select_func;
    std::function<void (UIScrollViewBlownEx*, int)> auto_select_func;
    cocos2d::extension::ScrollViewDelegate* delegate;
};

#endif /* UIScrollViewBlownEx_h */
