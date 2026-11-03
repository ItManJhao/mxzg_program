//
//  UIMenuIntercept.hpp
//  AVT
//
//  Created by conix on 7/1/16.
//
//

#ifndef UIMenuIntercept_hpp
#define UIMenuIntercept_hpp

#include "../../Common/CommonDefine.h"

#include "UIMenu.h"
#include "../UIModelLayer.h"

class UIMenuIntercept : public UIMenu {
    
public:
    UIMenuIntercept();
    
    static UIMenuIntercept* create();
    static UIMenuIntercept* create(MenuItem* item, ...);
    static UIMenuIntercept* createWithArray(const Vector<MenuItem*>& arrayOfItems);
    static UIMenuIntercept* createWithItems(MenuItem* item, va_list args);
    
//    virtual bool initWithArray(const Vector<MenuItem*>& arrayOfItems);
    
    virtual bool onTouchBegan(Touch* touch, Event* unused_event);
    virtual void onTouchEnded(Touch *touch, Event *unused_event);
    
    void setParentLayer(UIModelLayer* layer);
    
protected:
    bool touch_began_inside;
    
    UIModelLayer* layer_parent;
};

#endif /* UIMenuIntercept_h */
