//
//  UIMenuGeneral.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UIMenuGeneral__
#define __AVT__UIMenuGeneral__

#include "UIMenu.h"
#include "../UIScrollViewZoom.h"

class UIMenuGeneral : public UIMenu {
public:
    
    
    UIMenuGeneral();
    CREATE_FUNC(UIMenuGeneral);
    
    virtual bool init() override;
    virtual bool onTouchBegan(Touch* touch, Event* event) override;
    virtual void onTouchEnded(Touch* touch, Event* event) override;
    virtual void onTouchMoved(Touch* touch, Event* event) override;
    virtual void onTouchCancelled(Touch *touch, Event* event) override;
    
    virtual void addChild(Node * child) override;
    virtual void addChild(Node * child, int zOrder) override;
    virtual void addChild(Node * child, int zOrder, int tag) override;
    virtual void addChild(Node * child, int zOrder, const std::string &name) override;
	virtual void removeChild(Node* child, bool cleanup) override;
    
    virtual void reorderChild(Node* child, int zOrder) override;
    virtual void setWhenMoving(bool b);
    virtual bool getWhenMoving();

protected:
    
    Node* _selectedNode;
    Point p_began;
    Point p_distance;
    
    // 重写itemForTouch
    virtual Node* getNodeForTouch(Touch * touch, const Camera *camera);
    void removeNode(Node* node); // 移除节点
};


#pragma mark -

class UIMenuGeneralLoader : public LayerLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuGeneralLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuGeneral);
    
    virtual void onHandlePropTypeCheck(Node * pNode,
                                       Node * pParent,
                                       const char* pPropertyName,
                                       bool pCheck,
                                       CCBReader * pCCBReader);
};

#endif /* defined(__AVT__UIMenuGeneral__) */
