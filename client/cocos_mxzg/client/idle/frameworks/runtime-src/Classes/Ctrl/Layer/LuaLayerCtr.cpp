//
//  LuaLayerCtr.cpp
//  cleck
//
//  Created by hua on 2019/3/26.
//

#include "LuaLayerCtr.h"
#include "../../Model/LuaManager.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "../../Comp/Menu/UIMenuItem.h"
#include "../../Comp/UILabel.h"
#include "../../Comp/UIRichTextEx.h"
#include "../../Common/CCBLoader.h"

//map<LuaLayer*, vector<LuaCallBackData> > LuaLayer::map_variable;

//LayerBuffer* LayerBuffer::_instance = NULL;
//
//LayerBuffer* LayerBuffer::instance()
//{
//    if (_instance == NULL) {
//        _instance = new LayerBuffer();
//    }
//    return _instance;
//}

LuaLayer* LuaLayerLoader::createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader) {
//    std::string className = ccbReader->readCachedString();
    auto node = LuaLayer::create();
    return node;
}

//Node * LuaCCBFileLoader::parsePropTypeCCBFile(Node * pNode, Node * pParent, CCBReader * pCCBReader) {
//    std::string layerFile = pCCBReader->readCachedString();
//    std::string ccbFileName = "ccbi/" + layerFile;
//
//    CCBLoader::addLuaLoaderLibrary(CCBReader::deletePathExtension(layerFile.c_str()).c_str());
//
//    /* Change path extension to .ccbi. */
//    std::string ccbFileWithoutPathExtension = CCBReader::deletePathExtension(ccbFileName.c_str());
//    ccbFileName = ccbFileWithoutPathExtension + ".ccbi";
//
//    // Load sub file
//    std::string path = FileUtils::getInstance()->fullPathForFilename(ccbFileName);
//
//    auto dataPtr = std::make_shared<Data>(FileUtils::getInstance()->getDataFromFile(path));
//
//    CCBReader * reader = new (std::nothrow) CCBReader(pCCBReader);
//    reader->autorelease();
//    reader->getAnimationManager()->setRootContainerSize(pParent->getContentSize());
//
//
//    reader->_data = dataPtr;
//    reader->_bytes = dataPtr->getBytes();
//    reader->_currentByte = 0;
//    reader->_currentBit = 0;
//    CC_SAFE_RETAIN(pCCBReader->_owner);
//    reader->_owner = pCCBReader->_owner;
//
//    reader->getAnimationManager()->_owner = reader->_owner;
//
//    // The assignments below are done in the CCBReader constructor.
//    //     reader->_ownerOutletNames = pCCBReader->_ownerOutletNames;
//    //     reader->_ownerOutletNodes = pCCBReader->_ownerOutletNodes;
//    //     reader->_ownerOutletNodes->retain();
//    //     reader->_ownerCallbackNames = pCCBReader->_ownerCallbackNames;
//    //     reader->_ownerCallbackNodes = pCCBReader->_ownerCallbackNodes;
//    //     reader->_ownerCallbackNodes->retain();
//
//
//    Node * ccbFileNode = reader->readFileWithCleanUp(false, pCCBReader->getAnimationManagers());
//
//    if (ccbFileNode && reader->getAnimationManager()->getAutoPlaySequenceId() != -1)
//    {
//        // Auto play animations
//        reader->getAnimationManager()->runAnimationsForSequenceIdTweenDuration(reader->getAnimationManager()->getAutoPlaySequenceId(), 0);
//    }
//
//    if (reader->isJSControlled() && pCCBReader->isJSControlled() && nullptr == reader->_owner)
//    {
//        //set variables and callback to owner
//        //set callback
//        auto ownerCallbackNames = reader->getOwnerCallbackNames();
//        auto& ownerCallbackNodes = reader->getOwnerCallbackNodes();
//        if (!ownerCallbackNames.empty() && !ownerCallbackNodes.empty())
//        {
//            CCASSERT(ownerCallbackNames.size() == ownerCallbackNodes.size(),
//                     "ownerCallbackNames size should equal to ownerCallbackNodes size.");
//            ssize_t nCount = ownerCallbackNames.size();
//
//            for (ssize_t i = 0 ; i < nCount; i++)
//            {
//                pCCBReader->addOwnerCallbackName(ownerCallbackNames[i].asString());
//                pCCBReader->addOwnerCallbackNode(ownerCallbackNodes.at(i));
//            }
//        }
//        //set variables
//        auto ownerOutletNames = reader->getOwnerOutletNames();
//        auto ownerOutletNodes = reader->getOwnerOutletNodes();
//        if (!ownerOutletNames.empty() && !ownerOutletNodes.empty())
//        {
//            CCASSERT(ownerOutletNames.size() == ownerOutletNodes.size(),
//                     "ownerOutletNames size should be equal to ownerOutletNodes's size.");
//            ssize_t nCount = ownerOutletNames.size();
//
//            for (ssize_t i = 0 ; i < nCount; i++)
//            {
//                pCCBReader->addOwnerOutletName(ownerOutletNames.at(i).asString());
//                pCCBReader->addOwnerOutletNode(ownerOutletNodes.at(i));
//            }
//        }
//    }
//    return ccbFileNode;
//}




LuaLayer::LuaLayer()
{
    
}

LuaLayer::~LuaLayer()
{
//    auto iter_layer = map_variable.find(this);
//    if (iter_layer == map_variable.end()) {
//        return;
//    }
//
//    auto& iter_vec = iter_layer->second;
//    for (auto iter_data = iter_vec.begin(); iter_data != iter_vec.end(); ++iter_data)
//    {
//        auto data = *iter_data;
//        data.release();
//    }
//    map_variable.erase(iter_layer);
}


LuaLayer* LuaLayer::createWithCCBIFile(const std::string& ccbi_file)
{
    LuaLayer* pRef = (LuaLayer*)CCBLoader::readNodeGraphFromFile(ccbi_file.c_str(), NULL, false);
    return pRef;
}

LuaLayer* LuaLayer::createWithCCBIFile(const std::string& ccbi_file, NodeCtr* node_ctr) {
    LuaLayer* pRef = (LuaLayer*)CCBLoader::readNodeGraphFromFile(ccbi_file.c_str(), node_ctr, false);
    return pRef;
}

void LuaLayer::onExit()
{
    LuaManager::instance()->handleEvent(this, "onExit", [&](LuaStack * ls) {
        ls->pushObject((Ref*)this, "LuaLayer");
        return 1;
    });
    UIWindowLayer::onExit();
}

bool LuaLayer::onAssignCCBMemberVariable(Ref *pTarget, const char *pMemberVariableName, cocos2d::Node *pNode) {
//    LuaManager::instance()->executeGlobalAutoFunction("onAssignCCBMemberVariable", [&](LuaStack * ls) {
//        ls->pushObject((Ref*)this, "LuaLayer");
//        ls->pushString(pMemberVariableName);
//        ls->pushObject((Ref*)pNode, getNodeType(pNode).c_str());
////        ls->pushObject((Ref*)pNode, "cc.Node");
//        return 3;
//    });
    
    
//    int32_t data = 0;
//    //auto engine = cocos2d::LuaEngine::getInstance();
//    cocos2d::BasicScriptData scriptdata(this, (void*)&data);
//    LuaManager::instance()->handleEvent(&scriptdata, "onAssignCCBMemberVariable", [&](LuaStack* ls) {
//        ls->pushString(pMemberVariableName);
//        ls->pushObject((Ref*)pNode, getNodeType(pNode).c_str());
//        return 2;
//    });
    
    if (pMemberVariableName != NULL) {
        pNode->setName(pMemberVariableName);
        vec_member.pushBack(pNode);
    }
//    auto iter_layer = map_variable.find(this);
//    if (iter_layer == map_variable.end()) {
//        vector<LuaCallBackData> vec;
//        map_variable.insert(make_pair(this, vec));
//        iter_layer = map_variable.find(this);
//    }
//
//    auto& iter_vec = iter_layer->second;
//
//    LuaCallBackData data;
//    data.retain();
//    data.setCaller(NULL);
//    data.setNode(pNode);
//    data.setNodeName(pMemberVariableName);
//    iter_vec.push_back(data);
    
    return true;
    // return UIWindowLayer::onAssignCCBMemberVariable(pTarget, pMemberVariableName, pNode);
}

SEL_MenuHandler LuaLayer::onResolveCCBCCMenuItemSelector(cocos2d::Ref* pTarget, const char* pSelectorName) {
    return NULL;
}

SEL_MenuHandler LuaLayer::onResolveCCBCCMenuItemSelectorEx(cocos2d::Ref * pTarget, cocos2d::Ref* pMenuItem,const char* pSelectorName) {
    auto node = dynamic_cast<Node*>(pMenuItem);
    if (!node) {
        return NULL;
    }
    
//    auto name = node->getName();
    
//    if (name == "") {
//        name = StringUtils::format("function_unuse%d", (int)vec_function.size());
//        node->setName(name);
//    }
    
    if (pSelectorName != NULL) {
        vec_item.pushBack(node);
        vec_function.push_back(pSelectorName);
    }
    
//
//    auto iter_layer = map_variable.find(this);
//    if (iter_layer == map_variable.end()) {
//        vector<LuaCallBackData> vec;
//        map_variable.insert(make_pair(this, vec));
//        iter_layer = map_variable.find(this);
//    }
//
//    auto& iter_vec = iter_layer->second;
//
//    LuaCallBackData data;
//    data.retain();
//    data.setCaller(node);
//    data.setNode(node);
//    data.setNodeName(pSelectorName);
//    iter_vec.push_back(data);
    
    return CC_MENU_SELECTOR(LuaLayer::onMenuItemSelector);
}

void LuaLayer::onMenuItemSelector(Ref* pSender) {
    
}

void LuaLayer::assignCCBMemberVariable()
{

}



//void LuaLayer::registerAssignCCBMemberVariableLuaHandler(int handler) {
//
////    BasicScriptData data(this,(void*)this);
////    ScriptEvent scriptEvent(kCallFuncEvent, &data);
////    ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&scriptEvent);
//
//    string aa = "registerAssignCCBMemberVariableLuaHandler";
////
//    ByteArray data;
//    data.writeString(aa, 50);
//    LuaCallBackData call_data;
//    call_data.setCaller(this);
//    call_data.setUserData(&data);
//
//    auto engine = cocos2d::LuaEngine::getInstance();
//    cocos2d::BasicScriptData scriptdata(this, &call_data);
//    cocos2d::ScriptEvent eve(cocos2d::ScriptEventType::kCallFuncEvent, &scriptdata);
//    engine->sendEvent(&eve);
//
//    this->handler = handler;
//}

void LuaLayer::onNodeLoaded(Node *pNode, NodeLoader *pNodeLoader)
{
    UIWindowLayer::onNodeLoaded(pNode, pNodeLoader);
    
//    LuaManager::instance()->executeGlobalAutoFunction("onNodeLoaded", [&](LuaStack * ls) {
//        //node, "LuaLayer"
//        ls->pushObject((Ref*)this, "LuaLayer");
//        return 1;
//    });
}
