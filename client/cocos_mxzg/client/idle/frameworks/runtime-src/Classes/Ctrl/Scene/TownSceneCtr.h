//
//  TownSceneCtr.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__TownSceneCtr__
#define __AVT__TownSceneCtr__


#include "SceneCtr.h"

#include "../../Data/Player.h"

#include "../../Comp/LayerBase.h"
#include "../../Comp/UIScrollViewZoom.h"
#include "../../Comp/Menu/UIMenuScene.h"

class TownScene : public LayerBase
{
public:
    UIMenuScene* menu_scene;

    TownScene();
    
    virtual void onNodeLoaded(Node *pNode, NodeLoader *pNodeLoader);
    
    void initForMainScene();
    void initForBattleScene();
    
    /**
     * @param pos 相对于屏幕的一个坐标，此坐标将移动到屏幕正中央
     */
    void setViewToCenterWithPos(Point pos);
    
    Point checkScrollViewOffset(Point pos);
    
protected:
    float space;  // 上下左右边界之间的间距值
    
    void initMenuScene(UIMenuScene* ms);
};

#pragma mark --------------------

class TownSceneCtr : public SceneCtr {
public:
    TownSceneCtr();
    virtual ~TownSceneCtr();
    
    TownScene* getTownScene();
    
protected:
    virtual void enter();
    virtual void didEnter();
};

#endif /* defined(__AVT__TownSceneCtr__) */
