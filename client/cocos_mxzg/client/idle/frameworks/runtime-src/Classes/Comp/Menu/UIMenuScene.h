//
//  UIMenuScene.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UIMenuScene__
#define __AVT__UIMenuScene__

#include "UIMenu.h"
#include "../UIScrollViewZoom.h"

#include "../../Person/Hero.h"

#include "../../Data/Player.h"

class UIMenuScene : public UIMenu {
public:
    
    Hero* hero_selected;
    
    int64_t last_operate_time;      // 上次操作时间
    
    Player* player_owner;
    
    ActionType battle_statue;
    
    UIMenuScene();
    CREATE_FUNC(UIMenuScene);
    void initMenu();
    
    virtual bool onTouchBegan(Touch* touch, Event* event);
    virtual void onTouchEnded(Touch* touch, Event* event);
    virtual void onTouchMoved(Touch* touch, Event* event);
    virtual void onTouchCancelled(Touch *touch, Event* event);
    
    virtual void addChild(Node * child);
	virtual void addChild(Node * child, int zOrder);
	virtual void addChild(Node * child, int zOrder, int tag);
	virtual void removeChild(Node* child, bool cleanup);

    virtual void addHero(Hero* hero);
    virtual Hero* getHeroById(int64_t hero_id);
    virtual Hero* getHeroByPos(int x, int y);
    
    virtual void reorderChild(Node* child, int zOrder);
    void reorderUnit(Hero* b);
    
    void onPutDown();
    
protected:
    UIScrollViewZoom* scroll_view;
    Point p_began;
    Point p_distance;
    
    // 重写itemForTouch
    virtual MenuItem* getItemForTouch(Touch * touch, const Camera *camera);
    
    t_int32 countBuildingZOrder(Point p);
    void enableScrollView(bool b);
    void onPickedUp();
    
    void removeNode(Node* node); // 移除节点
};

#endif /* defined(__AVT__UIMenuScene__) */
