//
//  NodeCtr.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__NodeCtr__
#define __ClickerHeroes__NodeCtr__

#include "../Common/SingleInstance.h"
#include "../Comp/LayerBase.h"
#include "../Common/CCBLoader.h"

class NodeCtr : public Ref,
                public CCBSelectorResolver,
                public CCBMemberVariableAssigner,
                public NodeLoaderListener  //container主要进行事件响应和属性关联设置
{
public:
    bool action_running; // 动画是否播放中
    
    bool is_scroll_view_can_move;   // 是否让底层scroll_view可拖动
    
    NodeCtr();
    virtual ~NodeCtr();
    
    //事件响应注册函数
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(cocos2d::Ref* pTarget, const char* pSelectorName);
//    virtual SEL_CallFuncN onResolveCCBCCCallFuncSelector(cocos2d::Ref* pTarget, const char* pSelectorName);
    virtual Control::Handler onResolveCCBCCControlSelector(cocos2d::Ref* pTarget, const char* pSelectorName) {return NULL;}
    
    //属性关联注册函数
    virtual bool onAssignCCBMemberVariable(cocos2d::Ref* target, const char* memberVariableName, cocos2d::Node* node);
    
    //节点加载监听函数
    virtual void onNodeLoaded(cocos2d::Node* pNode, NodeLoader * pNodeLoader);
    
    //用来获取当前container中的layer,用来放在map中建立关联
    virtual LayerBase* getLayer();
    
    virtual void open();
    virtual void close(Ref* object);
    virtual void fastClose();
    virtual bool isSingle();
    virtual bool isAlways();
    virtual bool isOpened();
    virtual void onExit();
    virtual void remove();
    
    virtual void setIsSingle(bool b);
    virtual void setIsAlways(bool b);
    
    static void allChildrenFade(Node* node, float duration, bool flag);
    virtual void open(Node *parent);
    
    static bool isOpenWindow(const char* ccbi);
    const char* getCCBIPath();
    
    virtual void asynUserData(void* data);
    static list<NodeCtr*> getCtrList();
    static bool closeOtherWindow();
protected:
    const char* ccbi_path;
    LayerBase* layer;
    bool is_opened;
    bool is_new;    // layer是不是刚从ccbi里读出来
    bool is_single; // 窗口打开时，是否只留自己
    bool is_always; // 些窗口是否总是显示，不能因其他窗口的打开而被关闭
    
    void releaseLayer();

    virtual void loadLayer();
};

extern list<NodeCtr*> list_ctrs;

#endif /* defined(__ClickerHeroes__NodeCtr__) */
