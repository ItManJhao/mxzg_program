//
//  OkGamePlatform.cpp
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#include "OkGamePlatform.h"
#include "../Model/UserSetting.h"
#include "../Model/Utils.h"
#include "../Model/Game.h"
#include "../Data/Player.h"
#include "../Data/RoleData.h"
#include "../Animation/ActionFactory.h"
#include "../AppDelegate.h"
#include "../Model/UserSetting.h"
#include "../Config/VersionTable.h"
#include "../Comp/UIMessageBox.h"
#include "../Comp/MessageView.h"

OkGamePlatform::OkGamePlatform() {
    user_id = "";
    okgame_platform_impl = createPlatformImpl();
    order_id = "";
}

OkGamePlatform::~OkGamePlatform() {
    CC_SAFE_DELETE(okgame_platform_impl);
}

void OkGamePlatform::init() {
    
#if (OkGamePlatformDebug == 0)
    return;
#endif
    
    
#if defined(COCOS2D_DEBUG) && (COCOS2D_DEBUG > 0)
    okgame_platform_impl->initPlatform(0);
#else
    okgame_platform_impl->initPlatform(1);
#endif
    CCLOG("OkGamePlatform::init()");
}

void OkGamePlatform::login(bool auto_login) {
#if (OkGamePlatformDebug == 0)
    return;
#endif
    okgame_platform_impl->login(auto_login);
}

void OkGamePlatform::logout() {
#if (OkGamePlatformDebug == 0)
    return;
#endif
    okgame_platform_impl->logout();
}

void OkGamePlatform::loginCallback(bool is_success, string user_id, string user_token, string user_name, string game_id) {
#if (OkGamePlatformDebug == 0)
    return;
#endif
    
    SocialPlatform::instance()->loginCallback(is_success, user_id, user_token, user_name, game_id);
}

void OkGamePlatform::submitRoleInfo(const string& type) {
    //    UserSettingManager* usm = UserSettingManager::instance();
    //    RoleData* role_data = RoleData::instance();
    //    Player* player = Player::instance();
    okgame_platform_impl->submitRoleInfo(type);
}

void OkGamePlatform::updateExtraData(string guide_num,
                                     string role_id,
                                     string role_create_time,
                                     string role_name,
                                     string role_level,
                                     string server_id,
                                     string server_name,
                                     string balance,
                                     string vip_level,
                                     string gem_num,
                                     string attack_num,
                                     string extra_info,
                                     string clan_name) {
    okgame_platform_impl->updateExtraData(guide_num,
                                          role_id,
                                          role_create_time,
                                          role_name,
                                          role_level,
                                          server_id,
                                          server_name,
                                          balance,
                                          vip_level,
                                          gem_num,
                                          attack_num,
                                          extra_info,
                                          clan_name);
}

void OkGamePlatform::pay(string goods_id, string billNo, string extraInfo) {
#if (OkGamePlatformDebug == 0)
    return;
#endif
    okgame_platform_impl->pay(goods_id, billNo, extraInfo);
}

void OkGamePlatform::payStart() {
    //    // 加一个最高优先级的事件响应，以使在动画过程中，其他事件被屏蔽掉，在动画结束后恢复
    //    top_layer = LayerBase::create();
    //    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(top_layer, -10, true);
    //    CCDirector::sharedDirector()->getRunningScene()->addChild(top_layer, 10000);
    //    CCSize win_size = CCDirector::sharedDirector()->getWinSize();
    //    CCRepeatForever* act = ActionFactory::createRepeatForever("ccbi-res/scene-loading.plist", "scene-loading/%02d.png", 0.075);
    //    CCSprite* search = CCSprite::createWithSpriteFrameName("scene-loading/00.png");
    //    search->setPosition(ccp(win_size.width - search->getContentSize().width / 2 - 20, search->getContentSize().height / 2 + 20));
    //    search->setOpacity(0);
    //    search->runAction(act);
    //    search->runAction(CCFadeIn::create(0.3));
    //    top_layer->addChild(search, 3);
}

void OkGamePlatform::payEnd() {
    //    // 移除当前占用所有点击事件的layer
    //    if (!top_layer) {
    //        return;
    //    }
    ////    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(top_layer);
    //    top_layer->removeFromParentAndCleanup(true);
    //    top_layer = NULL;
}

void OkGamePlatform::payCallback(bool is_success, string billNo, string error_msg) {
    SocialPlatform::instance()->payCallback(is_success, billNo, error_msg);
}

void OkGamePlatform::realName(int is_success, string user_id, int adult) {
    SocialPlatform::instance()->realName(is_success, user_id, adult);
}



void OkGamePlatform::checkOpenId() {
    //    LanguageConfigTable* language = LanguageConfigTable::instance();
    //    UIMessageBox::create(language->getLanguage(7001278),
    //                         language->getLanguage(7001279),
    //                         language->getLanguage(351),
    //                         language->getLanguage(352),
    //                         this,
    //                         callfuncI_selector(TencentPlatform::onChangeRole))->show();
    //stopTheGame();
}

string OkGamePlatform::getPf() {
    return okgame_platform_impl->getPf();
}

string OkGamePlatform::getAgent() {
    return okgame_platform_impl->getAgent();
}


string OkGamePlatform::getChannelId() {
    string channel_id = okgame_platform_impl->getChannelId();
    CCLOG("okgame platform channel id = :%s", channel_id.c_str());
    return channel_id;
}

void OkGamePlatform::httpCharge(HttpClient *sender, HttpResponse *response)
{
//    if (response == NULL) {r
//        return;
//    }
//    
//    if (!response->isSucceed()) {
//        return;
//    }
//    
//    string html = "";
//    vector<char> vdata = *response->getResponseData();
//    for (int i = 0; i < vdata.size(); i++) {
//        html += vdata[i];
//    }
//    
//    if (html.compare("") == 0) {
//        return;
//    }
//    
//    CCLOG("charge http: %s", html.c_str());
//    
//    CSJson::Reader reader;
//    CSJson::Value json;
//    if (!reader.parse(html, json)) {
//        return;
//    }
//    
//    if (!json.isMember("error")) {
//        return;
//    }
//    
//    if (json["error"].asInt() != 0) {
//        return;
//    }
//    
//    if (!json.isMember("order_id") ||
//        !json.isMember("goods_id")) {
//        return;
//    }
//    
//    BuyGemConfig* config = BuyGemTable::instance()->getConfig(atoi(json["goods_id"].asCString()));
//    if (config == NULL) {
//        return;
//    }
//    
//    payStart();
//    
//    //    AppDelegate::platform_login = true;
//    SocialPlatform::instance()->is_charge = false;
//    
//    order_id = json["order_id"].asCString();
//    string zone_id = StringUtil::itoa(UserSettingManager::instance()->user_setting.server_id);
//    string str_num = StringUtil::itoa(config->gem);
    
    //    okgame_platform_impl->pay(open_id,
    //                               getPayToken(),
    //                               getSessionId(),
    //                               getSessionType(),
    //                               zone_id,
    //                               getPf(),
    //                               getPfKey(),
    //                               str_num);
}
