//
//  UIWindowLayer.h
//  RongYaoZhiCheng
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __RongYaoZhiCheng__UIWindowLayer__
#define __RongYaoZhiCheng__UIWindowLayer__

#include "UIModelLayer.h"

#include "editor-support/cocosbuilder/CocosBuilder.h"


#include "Menu/UIMenuIntercept.h"

class UIWindowLayer : public UIModelLayer
{
public:
    UIWindowLayer();
    virtual ~UIWindowLayer();
    virtual void onNodeLoaded(Node *pNode, NodeLoader *pNodeLoader);
    
    virtual bool onTouchBegan(Touch *touch, Event *event);
    virtual void onTouchMoved(Touch *touch, Event *event);
    virtual void onTouchEnded(Touch *touch, Event *event);
    
    virtual void setSwallowTouches(bool is_swallow_touches);
    virtual void setAutoClose(bool is_auto);
    EventListenerTouchOneByOne* listener;
public:
    bool is_auto_close;
};
#endif /* defined(__RongYaoZhiCheng__UIWindowLayer__) */
