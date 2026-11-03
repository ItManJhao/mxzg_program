//
//  SceneCtr.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "SceneCtr.h"
#include "../../Comp/MessageView.h"
#include "MainSceneCtr.h"
#include "../../Animation/CCActionExt.h"
#include "../../AutoRun/NetManager.h"
#include "../../Person/Unit.h"
#include "../../Animation/ActionFactory.h"
#include "../../Config/LanguageTable.h"
#include "../../Model/LuaManager.h"

bool scene_entering = false;
ProtectedNodeEx* SceneCtr::node_protected = NULL;

SceneCtr::SceneCtr() {
    is_single = true;
    is_always = true;
    is_scroll_view_can_move = true;
    scene = NULL;
    tip_label = NULL;
    show_flag = 0;
    is_transitioning = false;
    is_didenter = false;
}

SceneCtr::~SceneCtr() {
   // CCLOG("~SceneCtr");
}


ProtectedNodeEx* SceneCtr::getEnterAnimationNode(float opacity) {
//    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
//    sfc->addSpriteFramesWithFile("ccbi-base/loading.plist");

    Size win_size = Director::getInstance()->getWinSize();

    auto node = ProtectedNodeEx::create();
    
    // 嵌套一层node.方便遍历
    Node* node_parent = Node::create();
    node_parent->setTag(1000);
    node->addProtectedChild(node_parent);
    
    return node;
    
//    auto language_table = LanguageTable::instance();
//    int r = 1;
//    Sprite* logo = Sprite::create(StringUtils::format("ccbi-base/map-bg-loading-%d.jpg", r));
//    float scale_x = win_size.width / logo->getContentSize().width;
//    float scale_y = win_size.height / logo->getContentSize().height;
//    logo->setScaleX(scale_x);
//    logo->setScaleY(scale_y);
//    logo->setOpacity(opacity);
//    logo->setScale(scale_x > scale_y ? scale_x : scale_y);
//    logo->setPosition(Vec2(win_size.width / 2, win_size.height / 2));
//    node_parent->addChild(logo);
//
////    auto loading_bg = cocos2d::ui::Scale9Sprite::createWithSpriteFrameName("loading/bg-white.png", cocos2d::Rect(2, 2, 2, 2));
////    loading_bg->setOpacity(opacity);
////    loading_bg->setContentSize(win_size);
////    loading_bg->setPosition(win_size.width * 0.5, win_size.height * 0.5);
////    node_parent->addChild(loading_bg);
//
//    string str_msg = language_table->getLanguage(9000001 + rand() % 27);
//    auto lbl_msg = Label::createWithTTF(str_msg, FONT_DEFAULT_NAME, 40);
//    if (lbl_msg)
//    {
//        lbl_msg->setColor(Color3B::WHITE);
//        lbl_msg->setAlignment(cocos2d::TextHAlignment::LEFT, cocos2d::TextVAlignment::CENTER);
//        lbl_msg->setAnchorPoint(Vec2(0.0f, 0.5f));
//        lbl_msg->setPosition(170, 130);
//        lbl_msg->setDimensions(800, 600);
//        lbl_msg->setOpacity(opacity);
//        lbl_msg->enableShadow();
//        lbl_msg->setScale(0.5);
//        lbl_msg->setTag(101);
//        node_parent->addChild(lbl_msg);
//    }
//
//    float repeat_time = 4;
//    string str_tmp = "......";
//    for (int i = 0; i < str_tmp.length(); i++) {
//        Label* lbl_tmp = Label::createWithTTF(str_tmp.substr(i, 1), FONT_DEFAULT_NAME, 40);
//        if (lbl_tmp)
//        {
//            lbl_tmp->setPosition(win_size.width / 2 + 100 + 15 * i, 60);
//            lbl_tmp->setColor(Color3B::WHITE);
//            lbl_tmp->enableShadow();
//            lbl_tmp->setOpacity(opacity);
//            lbl_tmp->setScale(0.5);
//            node_parent->addChild(lbl_tmp);
//
//            auto act_move = Sequence::create(DelayTime::create(0.2 * i),
//                                             MoveTo::create(0.2, lbl_tmp->getPosition() + Vec2(0, 10)),
//                                             MoveTo::create(0.2, lbl_tmp->getPosition()),
//                                             DelayTime::create(repeat_time - 0.2 * i),
//                                             NULL);
//            lbl_tmp->runAction(RepeatForever::create(act_move));
//        }
//    }
//
//    //     版本号
//    string str_version = StringUtils::format("version:%s.%lld",
//                                             Game::instance()->getVersion().c_str(),
//                                             Game::client_version % 10000000);
//    auto lbl_version = Label::createWithTTF(str_version, FONT_DEFAULT_NAME, 28);
//    if (lbl_version)
//    {
//        lbl_version->setAnchorPoint(Vec2(0.0f, 0.5f));
//        lbl_version->setPosition(Vec2(10.0, 10.0));
//        lbl_version->setColor(Color3B::WHITE);
//        lbl_version->setOpacity(opacity);
//        lbl_version->enableShadow();
//        lbl_version->setScale(0.5);
//        lbl_version->setTag(102);
//        node_parent->addChild(lbl_version);
//    }
//    return node;
}

float SceneCtr::runOutAnimation(ProtectedNodeEx *node) {
    CCLOG("runOutAnimation");
//    allChildrenFade(node->getProtectedChildByTag(1000), 1, true);
    return 0.1 + 0.1;
}

float SceneCtr::runEnterAnimation(ProtectedNodeEx *node) {
    CCLOG("runEnterAnimation");
//    allChildrenFade(node->getProtectedChildByTag(1000), 1, false);
    return 0.1;
}

void SceneCtr::enter() {
    scene_entering = false;
    
    Director *pDirector = Director::getInstance();
    Scene* running_scene = pDirector->getRunningScene();
    is_new = true;
    is_opened = true;
    //  控制器虽然是个单例 但在这里控制器如果不用会被释放掉
    if (running_scene) {
        MessageView::instance()->clear();
        
        list<NodeCtr*> tmp_list = list_ctrs;
        for (list<NodeCtr*>::iterator i = tmp_list.begin(); i != tmp_list.end(); i++) {
            NodeCtr* controller = (*i);
            pDirector->getScheduler()->unscheduleAllForTarget(controller);
            if (controller == this) {
                // 同一个SceneCtr，只释放layer
                releaseLayer();
            } else {
                releaseLayer();
                controller->onExit();
                controller->remove();
            }
        }
        
        loadScene();
        pDirector->replaceScene(scene);
    } else {
        loadScene();
        pDirector->runWithScene(scene);
    }

    if (node_protected) {
        node_protected->removeFromParent();
        scene->addChild(node_protected);
    }

//    WAR_KEY_HP_MAX = rand() % 20000;
//    WAR_KEY_HP = rand() % 20000;
//    WAR_KEY_DAMAGE = rand() % 20000;
//    WAR_KEY_FIRING_RANGE_NEAR = rand() % 20000;
//    WAR_KEY_FIRING_RANGE_FAR = rand() % 20000;
//    WAR_KEY_ATTACK_SPEED = rand() % 20000;
//    WAR_KEY_MOVE_SPEED = rand() % 20000;
//    WAR_KEY_SPUTTERING_RANGE = rand() % 20000;
//    
//    WAR_KEY_GOLD = rand() % 90000000;
//    WAR_KEY_ELIXIR = rand() % 90000000;
    
    pDirector->getScheduler()->schedule(schedule_selector(SceneCtr::checkEnter), this, 0.25, CC_REPEAT_FOREVER, 0.25, false);
    
    LuaManager::instance()->handleEvent(this, "sceneCtrEnter", [&](LuaStack * ls) {
        ls->pushObject((Ref*)this, "SceneCtr");
        ls->pushInt((int32_t)getSceneCtrType());
        return 2;
    });
    
    LuaManager::instance()->executeGlobalAutoFunction("sceneCtrEnter", [&](LuaStack * ls) {
        ls->pushObject((Ref*)this, "SceneCtr");
        ls->pushInt((int32_t)getSceneCtrType());
        return 2;
    });
    
#if COCOS2D_DEBUG > 0
//    if (NetManager::instance()->hosts.size() > 0) {
//		vector< pair<string, unsigned short> >& hosts = NetManager::instance()->hosts;
//		string host = hosts[0].first;
//		host.append(CCString::createWithFormat(":%d", hosts[0].second)->getCString());
//
//		CCLabelBMFont* label_host = CCLabelBMFont::create(host.c_str(), "font/28.fnt");
//		label_host->setAnchorPoint(CCPointZero);
//		label_host->setPosition(ccp(230, 25));
//		label_host->setScale(Game::getReverseScale());
//		scene->addChild(label_host, 100);
//	}
#endif
}

void SceneCtr::loadScene() {
    scene = CCBLoader::createSceneWithNodeGraphFromFile(ccbi_path, this);
}

void SceneCtr::enterWithAnimation(t_byte show_flag) {
    if (scene_entering) {
        return;
    }
    
    
    // 判断是否是当前场景
    auto now_scene_ctr = getRunningSceneCtr();
    if (now_scene_ctr == this) {
        enter();
        return;
    }
    
    scene_entering = true;
    this->show_flag = show_flag;

    is_transitioning = true;
    is_didenter = false;

    Scene* running_scene = Director::getInstance()->getRunningScene();
    if (running_scene) {
        // 执行上一下场景的退出动画
        if (!node_protected) {
            node_protected = getEnterAnimationNode(/*255*/);

            // 吞噬触摸操作
            auto listener = EventListenerTouchOneByOne::create();
            listener->setSwallowTouches(true);
            listener->onTouchBegan = [](Touch *touch, Event *event) {
                return true;
            };
            listener->onTouchMoved = [](Touch *touch, Event *event) {};
            listener->onTouchEnded = [](Touch *touch, Event *event) {};
            Director::getInstance()->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, node_protected);
            running_scene->addChild(node_protected, 99);
        } else {
            node_protected->removeFromParent();
            running_scene->addChild(node_protected, 99);
        }

        float anim_time = runOutAnimation(node_protected);
        Director::getInstance()->getScheduler()->schedule(schedule_selector(SceneCtr::startWaiting), this, 0, 0, anim_time, false);
    } else {
        startWaiting();
    }
}

void SceneCtr::waitOutAndEnter(float delay) {
    net_protocol_waiting.clear();
    
    enter();
}

bool SceneCtr::isDidEnter() {
    return is_didenter;
}

bool SceneCtr::isLoadingFinish() {
    return true;
}

SceneCtrType SceneCtr::getSceneCtrType() {
    return SCT_VALID;
}

void SceneCtr::checkEnter(float delay) {
    if (Director::getInstance()->getRunningScene() != scene) {
        return;
    }
    
    // 计时器有bug
    if (is_didenter) {
        return;
    }
    
    if (node_protected) {
        float time = runEnterAnimation(node_protected);
        auto call_func = CallFuncN::create([](Node* node) {
            auto pro_node = (ProtectedNodeEx*)node;
            pro_node->removeAllChildrenWithCleanup(true);
            pro_node->removeFromParentAndCleanup(true);
            pro_node->destroy(true);
        });
        node_protected->runAction(Sequence::create(DelayTime::create(time), call_func, NULL));
        node_protected = NULL;
    }

    Director::getInstance()->getScheduler()->unschedule(schedule_selector(SceneCtr::checkEnter), this);
    is_transitioning = false;
    didEnter();
}

void SceneCtr::addProtocolWaiting(int net_protocol) {
    net_protocol_waiting[net_protocol] = false;
}

void SceneCtr::receivedProtocol(int net_protocol) {
    net_protocol_waiting[net_protocol] = true;
}

void SceneCtr::waiting(float delay) {
    int loaded = 0;
    for (map<int, bool>::iterator i = net_protocol_waiting.begin(); i != net_protocol_waiting.end(); i++) {
        if (i->second) {
            loaded += 1;
        } else {
            CCLOG("waiting protocol %d", i->first);
        }
    }
    
    if (loaded >= net_protocol_waiting.size() && isLoadingFinish()) {
        Director::getInstance()->getScheduler()->unschedule(schedule_selector(SceneCtr::waiting), this);
        
        if ( tip_label) {

            if (tip_label) {
                tip_label->stopAllActions();
                tip_label->runAction(FadeTo::create(0.3, 0));
                tip_label = NULL;
            }
            
            show_flag = 0;
            
            Director::getInstance()->getScheduler()->schedule(schedule_selector(SceneCtr::waitOutAndEnter), this, 0, 0, 0.35, false);
            
        } else {
            waitOutAndEnter();
        }
    }
}

void SceneCtr::startWaiting(float delay) {
    Director::getInstance()->getScheduler()->schedule(schedule_selector(SceneCtr::waiting), this, 0.5, CC_REPEAT_FOREVER, 0.2, false);
    releaseOldScene();

    Scene* running_scene = Director::getInstance()->getRunningScene();
    if (!running_scene) {
        return;
    }

    Size win_size = Director::getInstance()->getWinSize();
    const char* text = NULL;

    /*
     1 匹配玩家
     
     case 2:
     // 拜访玩家
     case 3:
     // 查看战斗回放
     case 4:
     // PVE
     case 5:
     // 反击、反殖民
     case 6:
     // 战后回家
     case 7:
     // 进入大地图
     case 8:
     // 进入领地
     case 9:
     // 进入公会战gve
     case 10:
     // 进入公会战gvg
     case 11:
     // 进入魔晶领地战
     case 12:
     // 进入全服攻击
     */
    
    if (text) {
        tip_label = Label::createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 18);
        tip_label->setColor(Color3B(255, 255, 255));
        tip_label->setPosition(Point(win_size.width / 2, win_size.height / 2));
        tip_label->setOpacity(0);
        tip_label->runAction(FadeIn::create(0.3));
        running_scene->addChild(tip_label, 2);
    }
}

void SceneCtr::releaseOldScene() {
    SceneCtr* scene_ctr = getRunningSceneCtr();
    if (scene_ctr) {
        scene_ctr->scene->removeFromParentAndCleanup(true);
        scene_ctr->scene = NULL;
        scene_ctr->clearData();
    }

    auto scene = Scene::create();
    if (node_protected) {
        node_protected->removeFromParent();
        scene->addChild(node_protected);
    }
    
    if (Director::getInstance()->getRunningScene()) {
        Director::getInstance()->replaceScene(scene);
    } else {
        Director::getInstance()->runWithScene(scene);
    }
}

void SceneCtr::clearData()
{
    SpriteFrameCache::getInstance()->removeUnusedSpriteFrames();
}


void SceneCtr::didEnter() {
    is_didenter = true;
    
    LuaManager::instance()->handleEvent(this, "sceneCtrDidEnter", [&](LuaStack * ls) {
        ls->pushObject((Ref*)this, "SceneCtr");
        ls->pushInt((int32_t)getSceneCtrType());
        return 2;
    });
    
    LuaManager::instance()->executeGlobalAutoFunction("sceneCtrDidEnter", [&](LuaStack * ls) {
        ls->pushObject((Ref*)this, "SceneCtr");
        ls->pushInt(getSceneCtrType());
        return 2;
    });
}

SceneCtr* SceneCtr::getRunningSceneCtr() {
    Scene* running_scene = Director::getInstance()->getRunningScene();
    if (running_scene) {
        for (list<NodeCtr*>::iterator i = list_ctrs.begin(); i != list_ctrs.end(); i++) {
            SceneCtr* controller = dynamic_cast<SceneCtr*>(*i);
            if (controller && controller->scene == running_scene) {
                return controller;
            }
        }
    }
    return NULL;
}


int SceneCtr::isWaitingByProtocol(int protocol) {
    map<int, bool>::iterator iter = net_protocol_waiting.find(protocol);
    if (iter != net_protocol_waiting.end()) {
        return iter->second ? 1 : 0;
    }
    
    return 2;
}

