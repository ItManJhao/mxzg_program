//
//  UIScrollViewZoom.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __UISCROLLVIEWZOOM_H__
#define __UISCROLLVIEWZOOM_H__

#include "cocos-ext.h"
#include "cocos2d.h"
#include "../Model/Game.h"
#include "editor-support/cocosbuilder/CocosBuilder.h"


USING_NS_CC;
USING_NS_CC_EXT;

using namespace cocosbuilder;

class UIScrollViewZoom : public ScrollView
{
public:
    UIScrollViewZoom();
    virtual ~UIScrollViewZoom();

    /**
     * 构建一个UIScrollViewZoom对象函数
     * @return : 返回一个自动释放的UIScrollViewZoom*对象
     */
    CREATE_FUNC(UIScrollViewZoom);
    static UIScrollViewZoom * create(Size size);
    
    /**
     * 对外提供的最小/最大缩放值的公有接口函数
     * @param minScale :设定的地图最小缩放值
     * @param maxScale :设定的地图最大缩放值
     * @return         :返回设定好的最小和最大缩放值
     */
    void setMinScale(float minScale);
    float getMinScale();
    
    void setMaxScale(float maxScale);
    float getMaxScale();
    
    void setMoveSpeed(float speed);
    float getMoveSpeed();
    
    Rect getZoomViewRect();
    
    /**
     * 对外提供地图能够显示的最小和最大缩放值
     * @param:   showMaxScale:设置地图最大能够显示的缩放值
     * @param:   showMinScale:设置地图最小能够显示的缩放值
     */
    CC_SYNTHESIZE(float,showMaxScale,ShowMaxScale);
    CC_SYNTHESIZE(float,showMinScale,ShowMinScale);
    
    /**
     * 重载的函数,默认我们让UIScrollViewZoom可以进行触摸响应操作
     * @return :一直返回true
     */
    virtual bool onTouchBegan(Touch *pTouch, Event *pEvent);
    
    /**
     * 重载的函数,只有在前端建筑允许进行移动操作时,对应的UIScrollViewZoom才可以进行移动操作,否则就不能进行移动UIScrollViewZoom的操作
     * @warning: isCanHandle成员变量的真假来进行决定是否可以进行ccTouchMoved操作
     */
    virtual void onTouchMoved(Touch *pTouch, Event *pEvent);
    
    /**
     * 重载的函数,用来设定缩放率在最小/最大 与 显示最小/显示最大  之间
     */
    virtual void onTouchEnded(Touch* touch, Event* event);

    virtual void onTouchCancelled(Touch *touch, Event *event);

    /**
     * 设置ccTouchBegan中返回true或者false的bool判定变量
     * @warning : can_handle为true时,ccTouchBegan中可以加载CCScrollView中ccTouchBegan进行处理,并返回true,否则返回false
     */
    CC_SYNTHESIZE(bool, can_handle, CanHandle);

    virtual void setContentOffsetInDuration(Point offset, float dt);
    virtual void setSwallowsTouches(bool b);
protected:
    bool scrolling;
    int64_t last_touch;
    float move_speed;
    
    bool isDoubleTouch();
    
    virtual void stoppedAnimatedScroll(Node* node);
    void deaccelerateScrolling(float dt);
};

class UIScrollViewZoomLoader : public ScrollViewLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIScrollViewZoomLoader,loader);
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIScrollViewZoom);
};


class UIScrollViewBackpackLoader : public UIScrollViewZoomLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIScrollViewBackpackLoader,loader);
//    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIScrollViewZoom);
    virtual UIScrollViewZoom* createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader);
};

#endif  /* defined(__UISCROLLVIEWZOOM_H__) */
