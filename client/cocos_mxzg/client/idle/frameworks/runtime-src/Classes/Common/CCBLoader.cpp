//
//  CCBLoader.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "CCBLoader.h"

// 导入自己的控件Loader类
#include "../Comp/UIScrollViewZoom.h"
#include "../Comp/Menu/UIMenu.h"
#include "../Comp/Menu/UIMenuItem.h"
#include "../Comp/UILabel.h"


// layer
// 导入自己的控件Loader类
#include "../Comp/UIScrollViewZoom.h"
#include "../Comp/Menu/UIMenu.h"
#include "../Comp/Menu/UIMenuGeneral.h"
#include "../Comp/Menu/UIMenuItem.h"
#include "../Comp/LuaNodeLoader.h"

#include "../Ctrl/Layer/LuaLayerCtr.h"

// layer
#include "../Ctrl/Scene/MainSceneCtr.h"

#include "../Model/LuaManager.h"

// 需要修改源码
/*
 // client/idle/frameworks/runtime-src/Classes/cocosbuilder/CCLabelBMFontLoader.cpp
 
 
 #include "platform/CCFileUtils.h"
 
 void LabelBMFontLoader::onHandlePropTypeFntFile(Node * pNode, Node * pParent, const char * pPropertyName, const char* pFntFile, CCBReader * ccbReader) {
 if(strcmp(pPropertyName, PROPERTY_FNTFILE) == 0) {
 
 // FIX
 std::string file_name = ccbReader->getCCBRootPath();
 std::string fix_file_name = pFntFile;
 fix_file_name = fix_file_name.substr(file_name.length());
 if (FileUtils::getInstance()->isFileExist(fix_file_name)) {
 ((Label *)pNode)->setBMFontFilePath(fix_file_name);
 } else {
 ((Label *)pNode)->setBMFontFilePath(pFntFile);
 }
 
 
 } else {
 NodeLoader::onHandlePropTypeFntFile(pNode, pParent, pPropertyName, pFntFile, ccbReader);
 }
 }
 
 
 --
 // client/idle/frameworks/runtime-src/Classes/cocosbuilder/NodeLoader.cpp
 Node * NodeLoader::parsePropTypeCCBFile(Node * pNode, Node * pParent, CCBReader * pCCBReader)
 std::string layerFile = pCCBReader->readCachedString();
 std::string ccbFileName = "ccbi/" + layerFile;
 
 CCBLoader::addLuaLoaderLibrary(CCBReader::deletePathExtension(layerFile.c_str()).c_str());
 
std::string ccbFileWithoutPathExtension = CCBReader::deletePathExtension(ccbFileName.c_str());
ccbFileName = ccbFileWithoutPathExtension + ".ccbi";
 
 
 BlockData * NodeLoader::parsePropTypeBlock(Node * pNode, Node * pParent, CCBReader * ccbReader)
 //                    if(selMenuHandler == 0)
 //                    {
 //                        CCBSelectorResolver * ccbSelectorResolver = ccbReader->getCCBSelectorResolver();
 //                        if(ccbSelectorResolver != nullptr)
 //                        {
 //                            selMenuHandler = ccbSelectorResolver->onResolveCCBCCMenuItemSelector(target, selectorName.c_str());
 //                        }
 //                    }
 
 // FIX
 if(selMenuHandler == 0)
 {
 selMenuHandler = targetAsCCBSelectorResolver->onResolveCCBCCMenuItemSelector(target, pNode, selectorName.c_str());
 }
 
 
 
 
 
 
 */


NodeLoaderLibrary* CCBLoader::loaderLibrary = NULL;

NodeLoaderLibrary* CCBLoader::getLoaderLibrary()
{
    if (loaderLibrary) {
        return loaderLibrary;
    }
    
    loaderLibrary = NodeLoaderLibrary::newDefaultNodeLoaderLibrary();
    loaderLibrary->retain();
    
    //注册节点加载库
    
//    loaderLibrary->unregisterNodeLoader("CCBFile");
//    loaderLibrary->registerNodeLoader("CCBFile", LuaCCBFileLoader::loader());

    // UI
    loaderLibrary->registerNodeLoader("UILabelTTF", UILabelTTFLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenu", UIMenuLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuGeneral", UIMenuGeneralLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemCheckBox", UIMenuItemCheckBoxLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemIcon", UIMenuItemIconLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemImage", UIMenuItemImageLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemLabel", UIMenuItemLabelLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemRadio", UIMenuItemRadioLoader::loader());
    loaderLibrary->registerNodeLoader("UIMenuItemTab", UIMenuItemTabLoader::loader());
    loaderLibrary->registerNodeLoader("UIScrollViewZoom", UIScrollViewZoomLoader::loader());
    loaderLibrary->registerNodeLoader("UIScrollViewBackpack", UIScrollViewBackpackLoader::loader());

    
    // layer    
    return loaderLibrary;
}


// 加载层
Node* CCBLoader::readNodeGraphFromFile(const char* pCCBFileName)
{
    return readNodeGraphFromFile(pCCBFileName, NULL, false);
}

// 加载层
Node* CCBLoader::readNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController)
{
    return readNodeGraphFromFile(pCCBFileName, pController, true);
}

// 加载层
Node* CCBLoader::readNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController, bool flag)
{
    CCBReader* reader = new CCBReader(CCBLoader::getLoaderLibrary());
    reader->setCCBRootPath("ccbi-res/");
//    reader->setCCBIRootPath("ccbi/");
    Node* node = reader->readNodeGraphFromFile(pCCBFileName, pController);
    auto layer_base = dynamic_cast<LayerBase*>(node);
    if (layer_base) {
        auto& set_list = reader->getLoadedSpriteSheet();
        std::vector<std::string> vec_plist;
        
        for (auto iter = set_list.begin(); iter != set_list.end(); ++iter)
        {
            vec_plist.push_back(*iter);
        }
        
        layer_base->setLoadedPlist(vec_plist);
    }
    
//    reader->getLoadedSpriteSheet();
    
    CC_SAFE_RELEASE_NULL(reader);
    
    if (pController && flag) {
        pController->getLayer()->controller = pController;
    }
    
    return node;
}

/**加载场景*/
Scene* CCBLoader::createSceneWithNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController)
{
    CCBReader* reader = new CCBReader(CCBLoader::getLoaderLibrary());
    Scene* scene = reader->createSceneWithNodeGraphFromFile(pCCBFileName, pController);
    CC_SAFE_RELEASE_NULL(reader);
    
    pController->getLayer()->controller = pController;
    
    return scene;
}

void CCBLoader::addLuaLoaderLibrary(const char* pCCBFileLayerName)
{
    auto loader = getLoaderLibrary();
    loader->unregisterNodeLoader(pCCBFileLayerName);
    loader->registerNodeLoader(pCCBFileLayerName, LuaLayerLoader::loader());
}

void CCBLoader::addNodeLoaderLibrary(const char* nodeName)
{
    auto loader = getLoaderLibrary();
    loader->registerNodeLoader(nodeName, LuaNodeLoader::create(nodeName));
}


void CCBLoader::onHandlePropTypeStringCustom(Node * pNode, Node * /*pParent*/, const char* pPropertyName, const char * pString, CCBReader * /*ccbReader*/) {
    
    if (pPropertyName != NULL && strcmp(pPropertyName, "customs") == 0) {
        LuaManager::instance()->executeGlobalAutoFunction("nodeCustoms", [&](LuaStack * ls) {
            ls->pushObject(pNode, "cc.Node");
            ls->pushString(pString);
            return 2;
        });
    }
}

