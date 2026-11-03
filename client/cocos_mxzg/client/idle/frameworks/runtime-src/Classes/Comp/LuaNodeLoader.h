//
//  LuaNodeLoder.h
//  idle
//
//  Created by hua on 2019/8/13.
//

#include "editor-support/cocosbuilder/CocosBuilder.h"


class LuaNodeLoader : public cocosbuilder::NodeLoader {
public:
    static LuaNodeLoader* create(std::string node_name);
//    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(LuaNodeLoader, loader);
    void setNodeName(const std::string& name);
protected:
    std::string node_name;
//    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemLabel);
    virtual cocos2d::Node* createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader);
    virtual void onHandlePropTypeInteger(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, int pInteger, cocosbuilder::CCBReader * pCCBReader);
    virtual void onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, cocosbuilder::CCBReader * ccbReader);
};
