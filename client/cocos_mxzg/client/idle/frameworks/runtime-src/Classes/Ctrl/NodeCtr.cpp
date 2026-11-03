//
//  NodeCtr.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "NodeCtr.h"
//#include "Layer/GuideCtr.h"
#include "../Model/LuaManager.h"
#include "Scene/SceneCtr.h"

list<NodeCtr*> list_ctrs;

NodeCtr::NodeCtr() {
    layer = NULL;
    ccbi_path = NULL;
    is_opened = false;
    is_new = true;
    is_single = true;
    is_always = false;
    action_running = false;
    
    is_scroll_view_can_move = false;
    
    list_ctrs.push_back(this);
}

NodeCtr::~NodeCtr() {
    releaseLayer();
    //CC_SAFE_RELEASE_NULL(layer);
    
    for (list<NodeCtr*>::iterator i = list_ctrs.begin(); i != list_ctrs.end(); i++) {
        if ((*i) == this) {
            list_ctrs.erase(i);
            break;
        }
    }
}

SEL_MenuHandler NodeCtr::onResolveCCBCCMenuItemSelector(cocos2d::Ref * pTarget, const char* pSelectorName) {
    return NULL;
}

bool NodeCtr::onAssignCCBMemberVariable(cocos2d::Ref* pTarget, const char* pMemberVariableName, cocos2d::Node* pNode) {
    CCB_MEMBERVARIABLEASSIGNER_GLUE(this, "layer", LayerBase*, layer);
    
    return false;
}

void NodeCtr::onNodeLoaded(cocos2d::Node * pNode, NodeLoader * pNodeLoader) {
    
}


LayerBase* NodeCtr::getLayer()
{
    return layer;
}

void NodeCtr::open() {
    if (is_opened) {
        return;
    }
    is_opened = true;
    
    if (!layer) {
    	loadLayer();
        is_new = true;
    } else {
        is_new = false;
    }
    
    Scene* scene = Director::getInstance()->getRunningScene();
    if (is_single) {
        // close other window
        Vector<Node*>& nodes = scene->getChildren();
        for (int i = 0; i < nodes.size(); i++) {
            LayerBase* layer_tmp = dynamic_cast<LayerBase*>(nodes.at(i));
            if (!layer_tmp) {
                continue;
            }
            NodeCtr* controller = layer_tmp->controller;
            if (controller == NULL || controller == this || controller->isAlways()) {
                continue;
            }
            controller->close(NULL);
        }
    }
    scene->addChild(layer);
    
    LuaManager::instance()->executeGlobalAutoFunction("windowsOpen", [&](LuaStack * ls) {
        ls->pushObject(this, "NodeCtr");
        ls->pushString(getCCBIPath());
        return 2;
    });
    
//    GuideCtr::windowsOpen(this, getCCBIPath());
}

void NodeCtr::loadLayer() {
	CCBLoader::readNodeGraphFromFile(ccbi_path, this);
}

void NodeCtr::close(Ref* object) {
    if (!is_opened) {
        return;
    }
    is_opened = false;
    releaseLayer(); // 释放layer，下次将重新读取CCBI文件
    
    LuaManager::instance()->executeGlobalAutoFunction("windowsClose", [&](LuaStack * ls) {
        ls->pushObject(this, "NodeCtr");
        ls->pushString(getCCBIPath());
        return 2;
    });
    
//    GuideCtr::windowsClose(this, getCCBIPath());
}

void NodeCtr::fastClose() {
    if (!is_opened) {
        return;
    }
    is_opened = false;
    releaseLayer(); // 释放layer，下次将重新读取CCBI文件
    
    LuaManager::instance()->executeGlobalAutoFunction("windowsClose", [&](LuaStack * ls) {
        ls->pushObject(this, "NodeCtr");
        ls->pushString(getCCBIPath());
        return 2;
    });
//    GuideCtr::windowsClose(this, getCCBIPath());
}


bool NodeCtr::isSingle()
{
    return is_single;
}

bool NodeCtr::isAlways()
{
    return is_always;
}

bool NodeCtr::isOpened()
{
    return is_opened;
}

void NodeCtr::onExit() {
    
}

void NodeCtr::remove() {
    release();
}

void NodeCtr::releaseLayer() {
    if (layer) {
        layer->setVisible(false);
        
        auto tmp_layer = layer;
        CC_SAFE_RELEASE_NULL(layer);
//        layer = NULL;
        
        tmp_layer->controller = NULL;
        while (true) {
            auto count = tmp_layer->getReferenceCount();
            if (count > 2) {
                tmp_layer->release();
            } else {
                break;
            }
        }
        tmp_layer->removeFromParentAndCleanup(true);
        
//        layer->removeFromParentAndCleanup(true);
//        auto count = layer->getReferenceCount();
//        CCLOG("releaseLayer = %d", count);
//        layer = NULL;
        
//        auto count = tmp_layer->getReferenceCount();
//        CCLOG("releaseLayer = %d", count);
    }
//    this->retain()
}

void NodeCtr::allChildrenFade(Node* node, float duration, bool flag) {
    Vector<Node*>& children = node->getChildren();
    if (children.size() <= 0) {
        return;
    }
    
    Node* obj;
    for (int i = 0; i < children.size(); i++) {
        obj = children.at(i);
        if (!obj || !obj->isVisible()) {
            continue;
        }
        
        allChildrenFade(obj, duration, flag);
        
        if (flag) {
            float opacity = obj->getOpacity();
            obj->setOpacity(0);
//            float opacity = 255;
            obj->runAction(EaseExponentialOut::create(FadeTo::create(duration, opacity)));
        } else {
            obj->runAction(EaseExponentialOut::create(FadeOut::create(duration * 0.3)));
        }
    }
}



void NodeCtr::open(Node *parent)
{
    if (parent == NULL || is_opened || action_running) {
        return;
    }
    
    is_opened = true;
    
    if (!layer) {
    	loadLayer();
        is_new = true;
    } else {
        is_new = false;
    }
    
    Scene* scene = Director::getInstance()->getRunningScene();
    if (is_single) {
        // close other window
        Vector<Node*>& nodes = scene->getChildren();
        LayerBase* layer_tmp = NULL;
        for (int i = 0; i < nodes.size(); i++) {
            layer_tmp = dynamic_cast<LayerBase*>(nodes.at(i));
            if (!layer_tmp) {
                continue;
            }
            NodeCtr* controller = layer_tmp->controller;
            if (controller == NULL || controller == this || controller->isAlways()) {
                continue;
            }
            controller->close(NULL);
        }
    }
    parent->addChild(layer);
}

bool NodeCtr::isOpenWindow(const char* ccbi) {
    Scene* scene = Director::getInstance()->getRunningScene();
    Vector<Node*>& nodes = scene->getChildren();
    LayerBase* layer_tmp = NULL;
    for (int i = 0; i < nodes.size(); i++) {
        layer_tmp = dynamic_cast<LayerBase*>(nodes.at(i));
        if (!layer_tmp) {
            continue;
        }
        NodeCtr* controller = layer_tmp->controller;
        if (controller != NULL && controller->getCCBIPath() != NULL && strcmp(ccbi, controller->getCCBIPath()) == 0) {
            return true;
        }
    }
    return false;
}

const char* NodeCtr::getCCBIPath() {
    return ccbi_path;
}

void NodeCtr::asynUserData(void* data)
{
    
}

list<NodeCtr*> NodeCtr::getCtrList() {
    return list_ctrs;
}

void NodeCtr::setIsSingle(bool b) {
    is_single = b;
}

void NodeCtr::setIsAlways(bool b) {
    is_always = b;
}

bool NodeCtr::closeOtherWindow() {
    bool is_close = false;
    auto list_ctr = NodeCtr::getCtrList();
    for (auto iter = list_ctr.begin(); iter != list_ctr.end(); ++iter)
    {
        auto ctr = *iter;
        auto scene_ctr = dynamic_cast<SceneCtr*>(ctr);
        if (ctr->isOpened() && !scene_ctr) {
            string ccbi_file = ctr->getCCBIPath();
            CSJson::Value json;
            json["ccbi_file"] = ccbi_file;
            auto is_close = LuaManager::instance()->executeGlobalBoolFunctionReturn("closeOtherWindow", json);
            if (is_close) {
                is_close = true;
                ctr->fastClose();
            }
        }
    }
    return is_close;
}
