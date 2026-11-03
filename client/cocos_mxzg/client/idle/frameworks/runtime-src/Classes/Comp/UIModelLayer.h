//
//  UIModelLayer.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__UIModelLayer__
#define __ClickerHeroes__UIModelLayer__

#include "LayerBase.h"

class UIModelLayer : public LayerBase
{
public:
    UIModelLayer();
    virtual void close();
    virtual bool onTouchBegan(Touch *touch, Event *unused_event);
    virtual void onTouchEnded(Touch *touch, Event *unused_event);
    
protected:
    bool touch_began_inside;
};


#endif /* defined(__ClickerHeroes__UIModelLayer__) */
