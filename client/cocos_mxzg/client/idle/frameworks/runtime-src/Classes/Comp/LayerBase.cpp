//
//  LayerBase.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "LayerBase.h"
#include "../Ctrl/NodeCtr.h"


LayerBase::LayerBase() {
    controller = NULL;
    shake_action = NULL;
}

LayerBase::~LayerBase() {
}

LayerBase* LayerBase::create() {
    LayerBase *pRet = new LayerBase();
    if (pRet && pRet->init()) {
        pRet->autorelease();
        return pRet;
    } else {
        delete pRet;
        pRet = NULL;
        return NULL;
    }
}

void LayerBase::onNodeLoaded(Node * pNode, NodeLoader * pNodeLoader)
{
    //CCLOG("%d", m_bIsTouchEnabled ? 1 : 0);
    //    遍历其下label节点，设置string
    /*Vector<Node*>& children = this->getChildren();
    LanguageConfigTable* lct = LanguageConfigTable::instance();
    for (int i = 0; i < this->children.size(); ++i) {
        CCNode* node = (CCNode*)children.at(i);
        if (node->getTag() > 1000000) {
//            tag超过1000000的部分就是在xml中的key值
            ((CCLabelTTF*)node)->setString(lct->getLanguage(node->getTag()%1000000));
        }
    }*/
}

bool LayerBase::onTouchBegan(Touch *pTouch, Event *pEvent)
{
    /**
     * 针对于layerBase或者重写laybase但没有重写注册事件响应和ccTouchBegan的类而言,独占消息处理
     */
    
//    NodeCtr* node_ctr = (NodeCtr*)this->controller;
//    if (node_ctr) {
//        CCLOG("%s", node_ctr->getCCBIPath());
//    }
    return true;
}

void LayerBase::shake(float range, int times, float slow_down) {
    if (shake_action || times < 1) {
        return;
    }
    
    int r = rand() % 2 == 0 ? 1 : -1;
    
//    Array* arr = Array::create();
    Vector<cocos2d::FiniteTimeAction *> arr;
    for (int i = 0; i < times; i++) {
        MoveBy* add = MoveBy::create(0.016, Vec2(range, r * range));
        MoveBy* sub = MoveBy::create(0.032, Vec2(-range * 2, r * -range * 2));
        arr.pushBack(add);
        arr.pushBack(sub);
        arr.pushBack(add);
        range -= slow_down;
        if (range < 1) {
            range = 1;
        }
    }
    arr.pushBack(CallFunc::create(CC_CALLBACK_0(LayerBase::shakeActionEnd, this)));
    
    shake_action = Sequence::create(arr);
    runAction(shake_action);
}

void LayerBase::shakeActionEnd() {
    shake_action = NULL;
}

bool LayerBase::isTouchInside(Touch *touch) {
    if (!touch) {
        return false;
    }
    
    Node* parent = getParent();
    if (!parent) {
        return false;
    }
    Point touchLocation = touch->getLocation(); // Get the touch position
    touchLocation = parent->convertToNodeSpace(touchLocation);
    Rect bBox = getBoundingBox();
    return bBox.containsPoint(touchLocation);
}

void LayerBase::setLoadedPlist(std::vector<std::string> vec_plist) {
    this->vec_plist = vec_plist;
}

std::vector<std::string> LayerBase::getLoadedPlist() {
    return vec_plist;
}

void LayerBase::clearLoadedPlist() {
    vec_plist.clear();
}
