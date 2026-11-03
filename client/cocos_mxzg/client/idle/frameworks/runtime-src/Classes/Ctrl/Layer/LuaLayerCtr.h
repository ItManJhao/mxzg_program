//
//  LuaLayerCtr.h
//  cleck
//
//  Created by hua on 2019/3/26.
//

#ifndef LuaLayerCtr_h
#define LuaLayerCtr_h

#include "WindowCtr.h"
#include "../../Comp/UIWindowLayer.h"
#include "../../Common/SingleInstance.h"
#include "../LuaNodeCtr.h"
#include "../../Model/ByteArray.h"
#include "editor-support/cocosbuilder/CCBSelectorResolver.h"

//class LayerBuffer : public cocos2d::Ref, public SingleInstance<LayerBuffer>
//{
//public:
//    static LayerBuffer* instance();
//
//private:
//    static LayerBuffer* _instance;
//};

class LuaLayer : public UIWindowLayer, public CCBSelectorResolver
{
public:
    LuaLayer();
    ~LuaLayer();
    CREATE_FUNC(LuaLayer);
    
    static LuaLayer* createWithCCBIFile(const std::string& ccbi_file);
    static LuaLayer* createWithCCBIFile(const std::string& ccbi_file, NodeCtr* node_ctr);
    virtual void onExit();
    
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char* pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(cocos2d::Ref* pTarget, const char* pSelectorName);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelectorEx(cocos2d::Ref * pTarget, cocos2d::Ref* pMenuItem,const char* pSelectorName);
    virtual Control::Handler onResolveCCBCCControlSelector(cocos2d::Ref* pTarget, const char* pSelectorName) {return NULL;}
    
    virtual void onNodeLoaded(Node *pNode, NodeLoader *pNodeLoader);
    virtual void assignCCBMemberVariable();
    
    virtual void onMenuItemSelector(Ref* pSender);
    
    vector<string> getFunctionList() { return vec_function;};
    void clearFunctionList() { vec_function.clear(); };
    
    cocos2d::Vector<Node*> getItemList() { return vec_item;};
    void clearItemList() { vec_item.clear(); };
    
    
    cocos2d::Vector<Node*> getMemberList() { return vec_member;};
    void clearMemberList() { vec_member.clear(); };
protected:
    vector<string> vec_function;
    cocos2d::Vector<Node*> vec_item;
    cocos2d::Vector<Node*> vec_member;
    
// protected:
//    static map<LuaLayer*, vector<LuaCallBackData> > map_variable;
};

//
class LuaLayerLoader : public LayerLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(LuaLayerLoader, loader);
protected:
    virtual LuaLayer* createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader);
};

//class LuaCCBFileLoader : public CCBFileLoader
//{
//public:
//    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(LuaCCBFileLoader, loader);
//protected:
//    virtual cocos2d::Node * parsePropTypeCCBFile(cocos2d::Node * pNode, cocos2d::Node * pParent, CCBReader * ccbReader);
//};

#endif /* LuaLayerCtr_h */
