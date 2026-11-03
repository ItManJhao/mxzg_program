//
//  LuaNodeLoder.cpp
//  idle
//
//  Created by hua on 2019/8/13.
//

#include "LuaNodeLoader.h"
#include "../Model/LuaManager.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

LuaNodeLoader* LuaNodeLoader::create(std::string node_name)
{
    auto pRef = new (std::nothrow) LuaNodeLoader();
    if (pRef) {
        pRef->setNodeName(node_name);
        pRef->autorelease();
        return pRef;
    }
    CC_SAFE_DELETE(pRef);
    return NULL;
}

void LuaNodeLoader::setNodeName(const std::string& name)
{
    this->node_name = name;

}

cocos2d::Node* LuaNodeLoader::createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader)
{
    CSJson::Value json;
    json["node_name"] = this->node_name;
    return LuaManager::instance()->executeGlobalNodeFunctionReturn("createLuaNode", json);
}

void LuaNodeLoader::onHandlePropTypeInteger(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, int pInteger, cocosbuilder::CCBReader * pCCBReader)
{
//    LuaManager::instance()->executeGlobalAutoFunction("luaNodeOnHandlePropTypeInteger", CSJson::Value json);
    cocosbuilder::NodeLoader::onHandlePropTypeInteger(pNode, pParent, pPropertyName, pInteger, pCCBReader);
}

void LuaNodeLoader::onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, cocosbuilder::CCBReader * ccbReader)
{
    LuaManager::instance()->executeGlobalAutoFunction("luaNodeOnHandlePropTypeString", [&](LuaStack * ls) {
        ls->pushString(this->node_name.c_str());
        ls->pushObject(pNode, "cc.Node");
        ls->pushObject(pParent, "cc.Node");
        ls->pushString(pString);
        return 4;
    });
    cocosbuilder::NodeLoader::onHandlePropTypeString(pNode, pParent, pPropertyName, pString, ccbReader);
}
