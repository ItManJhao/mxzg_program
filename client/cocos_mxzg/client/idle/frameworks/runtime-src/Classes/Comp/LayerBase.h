//
//  LayerBase.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__LayerBase__
#define __AVT__LayerBase__

#include "../Common/CommonDefine.h"

#include "editor-support/cocosbuilder/CocosBuilder.h"

using namespace cocosbuilder;

class NodeCtr;

class LayerBase : public Layer,
                  public CCBMemberVariableAssigner,
                  public NodeLoaderListener  //层上只进行成员属性关联
{
public:
    LayerBase();
    ~LayerBase();
    
//    CREATE_FUNC(LayerBase);
    static LayerBase* create();

    virtual bool onAssignCCBMemberVariable(cocos2d::Ref* target, const char* memberVariableName, cocos2d::Node* node) { return false; };
    virtual void onNodeLoaded(cocos2d::Node * pNode, NodeLoader * pNodeLoader);
    
    //重写注册和事件响应函数
    virtual bool onTouchBegan(Touch *pTouch, Event *pEvent);
    
    void shake(float range, int times, float slow_down);
    
    NodeCtr* controller;
    
    virtual bool isTouchInside(Touch* touch);
    
    
    void setLoadedPlist(std::vector<std::string> vec_plist);
    std::vector<std::string> getLoadedPlist();
    void clearLoadedPlist();
protected:
    FiniteTimeAction* shake_action;
    void shakeActionEnd();
    
    std::vector<std::string> vec_plist;
};

class LayerBaseLoader : public LayerLoader {
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(LayerBaseLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(LayerBase);
};
#endif /* defined(__AVT__LayerBase__) */
