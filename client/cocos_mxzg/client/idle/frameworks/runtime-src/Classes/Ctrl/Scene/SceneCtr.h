//
//  SceneCtr.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__SceneCtr__
#define __ClickerHeroes__SceneCtr__

#include "../NodeCtr.h"
#include "../../Comp/Menu/UIMenuItem.h"
#include "../../Comp/ProtectedNodeEx.h"

enum SceneCtrType {
    SCT_VALID = -1,
    SCT_LOADING_SCENE = 0,
    SCT_MAIN_SCENE,
    SCT_BATTLE_SCENE,
    SCT_LOGO_SCENE
};

class ProtectedNodeEx;

class SceneCtr : public NodeCtr {
public:
    Scene* scene;
    static ProtectedNodeEx* node_protected;
    bool is_transitioning;                      // 是否正在切换场景

    SceneCtr();
    virtual ~SceneCtr();

    virtual ProtectedNodeEx* getEnterAnimationNode(float opacity = 0);
    virtual float runOutAnimation(ProtectedNodeEx* node);
    virtual float runEnterAnimation(ProtectedNodeEx* node);

    virtual void enter();
    virtual void enterWithAnimation(t_byte show_flag = 0);
    virtual void waitOutAndEnter(float delay = 0);
    virtual bool isDidEnter();
    virtual bool isLoadingFinish();             // 加载资源需要.预留
    virtual SceneCtrType getSceneCtrType();


    void addProtocolWaiting(int net_protocol);  // 增加需要等待的网络协议
    void receivedProtocol(int net_protocol);    // 已经收到网络协议

    static SceneCtr* getRunningSceneCtr();
    int isWaitingByProtocol(int protocol);      // 是否在等待指定协议包 0:等待这个协议 1: 已经等待到这个协议 2:没有等待这个协议
protected:
    map<int, bool> net_protocol_waiting;        // 需要等待的网络包
    bool is_didenter;

    t_byte show_flag;
    Label* tip_label;
    
    virtual void checkEnter(float delay = 0);
    void startWaiting(float delay = 0);
    void waiting(float delay = 0);
    virtual void releaseOldScene();
    virtual void clearData();

    virtual void loadScene();
    virtual void didEnter();
};

#endif /* defined(__ClickerHeroes__SceneCtr__) */
