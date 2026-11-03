//
//  UIMenuItemBattle.h
//  AVT
//
//  Created by conix on 4/1/16.
//
//

#ifndef UIMenuItemBattle_h
#define UIMenuItemBattle_h

#include "UIMenuItem.h"

class UIMenuItemBattle : public UIMenuItemImage {
public:
    int x;  // 格子坐标
    int y;
    
    UIMenuItemBattle();
    UIMenuItemBattle(int x, int y);
    
    static UIMenuItemBattle* createWithSpriteFrameName(const char *normalImage, ccMenuCallback callback, int x, int y);
    
    virtual void initDone();
};

#endif /* UIMenuItemBattle_h */
