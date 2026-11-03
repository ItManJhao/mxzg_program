//
//  LuaNodeCtr.cpp
//  cleck
//
//  Created by hua on 2019/3/26.
//

#include "LuaNodeCtr.h"
#include "../Model/LuaManager.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "../Comp/Menu/UIMenuItem.h"
#include "../Comp/UILabel.h"
#include "../Comp/UIRichTextEx.h"

map<LuaNodeCtr*, vector<LuaCallBackData> > LuaNodeCtr::map_variable;

LuaNodeCtr::LuaNodeCtr()
{
    this->setCCBIPath("");
}

LuaNodeCtr::~LuaNodeCtr()
{
    
}

LuaNodeCtr* LuaNodeCtr::create()
{
    auto pRef = new (std::nothrow)LuaNodeCtr();
    return pRef;
}


void LuaNodeCtr::close(Ref* object)
{
    auto iter_layer = map_variable.find(this);
    if (iter_layer != map_variable.end()) {
        map_variable.erase(iter_layer);
    }
    
    WindowCtr::close(object);
}

void LuaNodeCtr::setLayer(Node* layer)
{
    auto tmp_layer = static_cast<LayerBase*>(layer);
    if (tmp_layer) {
        tmp_layer->retain();
        this->layer = (LayerBase*)layer;
        this->layer->controller = this;
    }
}

void LuaNodeCtr::setCCBIPath(std::string file)
{
    file_path = file;
    ccbi_path = file_path.c_str();
}

void LuaNodeCtr::loadLayer()
{
    // CCBLoader::readNodeGraphFromFile(file_path.c_str(), this);
}

void LuaNodeCtr::remove()
{
    auto iter_layer = map_variable.find(this);
    if (iter_layer != map_variable.end()) {
        map_variable.erase(iter_layer);
    }
    
    is_opened = false;
}

SEL_MenuHandler LuaNodeCtr::onResolveCCBCCMenuItemSelector(Ref * pTarget, const char* pSelectorName)
{
    //CCB_SELECTORRESOLVER_CCMENUITEM_GLUE(this, "onConfirm", RenameCtr::onConfirm);
    return NodeCtr::onResolveCCBCCMenuItemSelector(pTarget, pSelectorName);
}

SEL_MenuHandler LuaNodeCtr::onResolveCCBCCMenuItemSelector(cocos2d::Ref * pTarget, cocos2d::Ref* pMenuItem,const char* pSelectorName)
{
    auto iter_layer = map_variable.find(this);
    if (iter_layer == map_variable.end()) {
        vector<LuaCallBackData> vec;
        map_variable.insert(make_pair(this, vec));
        iter_layer = map_variable.find(this);
    }

    auto& iter_vec = iter_layer->second;

    LuaCallBackData data;
    data.retain();
    data.setCaller((Node*)pMenuItem);
    data.setNode((Node*)pMenuItem);
    data.setNodeName(pSelectorName);
    iter_vec.push_back(data);

    return CC_MENU_SELECTOR(LuaNodeCtr::onMenuItemSelector);
}


static string getNodeType(cocos2d::Node *pNode) {
    
    if (dynamic_cast<UIMenuItemTab*>(pNode)) {
        return "UIMenuItemTab";
    } if (dynamic_cast<UIMenuItemLabel*>(pNode)) {
        return "UIMenuItemLabel";
    } else if (dynamic_cast<UIMenuItemImage*>(pNode)) {
        return "UIMenuItemImage";
    } else if (dynamic_cast<UILabelTTF*>(pNode)) {
        return "UILabelTTF";
    } else if (dynamic_cast<RichTextEx*>(pNode)) {
        return "RichTextEx";
    } else if (dynamic_cast<Label*>(pNode)) {
        return "cc.Label";
    } else if (dynamic_cast<cocos2d::ui::Scale9Sprite*>(pNode)) {
        return "ccui.Scale9Sprite";
    } else if (dynamic_cast<Sprite*>(pNode)) {
        return "cc.Sprite";
    }  else if (dynamic_cast<Layer*>(pNode)) {
        return "cc.Layer";
    }
    return "cc.Node";
}

void LuaNodeCtr::resolveCCBCCMenuItemSelector()
{
    auto iter_layer = map_variable.find(this);
    if (iter_layer == map_variable.end()) {
        return;
    }
    
    auto& iter_vec = iter_layer->second;
    
    for (auto iter_data = iter_vec.begin(); iter_data != iter_vec.end();)
    {
        auto data = *iter_data;
        if (data.getCaller() != NULL)
        {
            LuaManager::instance()->handleEvent(this, "onResolveCCBCCMenuItemSelector", [&](LuaStack* ls) {
                ls->pushObject((Ref*)data.getNode(), getNodeType(data.getNode()).c_str());
                ls->pushString(data.getNodeName().c_str());
                return 2;
            });
            data.release();
            iter_data = iter_vec.erase(iter_data);
        }
        else
        {
            ++iter_data;
        }
    }
    
    map_variable.erase(iter_layer);
}

