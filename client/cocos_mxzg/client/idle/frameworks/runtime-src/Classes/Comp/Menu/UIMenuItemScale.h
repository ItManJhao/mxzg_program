//
//  UIMenuItemScale.h
//  AVT
//
//  Created by conix on 6/29/16.
//
//

#ifndef UIMenuItemScale_h
#define UIMenuItemScale_h

#include "UIMenuItem.h"

class UIMenuItemScale : public UIMenuItemTab {
public:
    float des_scale;        // 选中后的缩放
    Point pos_init;         // 初始位置
    
    UIMenuItemScale();
    ~UIMenuItemScale();
    
    CREATE_FUNC(UIMenuItemScale);
    static UIMenuItemScale* create(const string& normal, const string& selected, float scale, ccMenuCallback callback);
    virtual void initDone(float scale);
    
    virtual void setChecked(bool checked);
    
    void setInitPos(const Vec2 &position);
    void setOScale(float scale);
    float getOScale();
    
    virtual void update(float delay);
    
    CC_SYNTHESIZE(float, scale_step, ScaleStep);
private:
    // 当这个item缩小到原来尺寸大小时 记录使他发生缩小的那个item的tag值
    int32_t before_scale_item_tag;
};

#endif /* UIMenuItemScale_h */
