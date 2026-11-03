//
//  SocialPlatform.cpp
//  AVT
//
//  Created by Conix on 15-06-28.
//
//



#include "SocialPlatform.h"
#include "../Net/PlatformApi.h"
#include "../Net/HttpCallback.h"
#include "../Data/Player.h"
#include "../Model/Game.h"
#include "../Model/UserSetting.h"
#include "../Config/VersionTable.h"
#include "../Config/SystemTable.h"
#include "../Comp/MessageView.h"
#include "../Data/RoleData.h"
#include "../Model/LuaManager.h"

#include "../Common/CommonDefine.h"

PlatformImpl* SocialPlatform::platform_impl = NULL;


#ifdef OKGAME_SDK
    // 包含对应的头文件
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #include "OkGamePlatformIOS.h"
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
//        #include "OkGamePlatformMac.h"
    #endif
#endif

#ifdef ALAHAIMU_SDK
    // 包含对应的头文件
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #include "AlahaimuPlatformIOS.h"
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        #include "AlahaimuPlatformMac.h"
    #endif
#endif


#ifdef FEIFAN_SDK
    // 包含对应的头文件
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #include "FeiFanPlatformIOS.h"
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        #include "OkGamePlatformMac.h"
    #endif
#endif


SocialPlatform::SocialPlatform()
{
    platform_impl = createPlatformImpl();
    
    is_charge = false;
//    CCLOG("%d", COCOS2D_DEBUG);
#if COCOS2D_DEBUG > 0
     channel_id = platform_impl->getChannelId() ;
     pf_id = platform_impl->getPf();
     agent = platform_impl->getAgent();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    platform = "1";
#else
    platform = "2";
#endif
#endif
}

void SocialPlatform::appDidFinishLaunchingWithOptions(void* application, void* launchOptions, void* appController)
{
    platform_impl->appDidFinishLaunchingWithOptions(application, launchOptions, appController);
}

void SocialPlatform::didRegisterForRemoteNotificationsWithDeviceToken(void* application, void* deviceToken)
{
    platform_impl->didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken);
}

void SocialPlatform::didFailToRegisterForRemoteNotificationsWithError(void* application, void* error)
{
    platform_impl->didFailToRegisterForRemoteNotificationsWithError(application, error);
}

void SocialPlatform::applicationWillResignActive(void* application)
{
    platform_impl->applicationWillResignActive(application);
}

void SocialPlatform::applicationDidEnterBackground(void* application)
{
    platform_impl->applicationDidEnterBackground(application);
}

void SocialPlatform::applicationWillEnterForeground(void* application)
{
    platform_impl->applicationWillEnterForeground(application);
}

void SocialPlatform::applicationDidBecomeActive(void* application)
{
    platform_impl->applicationDidBecomeActive(application);
}

void SocialPlatform::applicationWillTerminate(void* application)
{
    platform_impl->applicationWillTerminate(application);
}

bool SocialPlatform::applicationOpenURL(void* application, void* url, void* options)
{
    platform_impl->applicationOpenURL(application, url, options);
}

void SocialPlatform::initSDK()
{
    platform_impl->initSDK();
}

// 初始化平台
void SocialPlatform::initPlatform()
{
    
}

void SocialPlatform::login(bool auto_login, int8_t product_type) {
//    OkGamePlatform::instance()->init();
    
    platform_impl->init();
    /*
     UserSettingManager* us_manager = UserSettingManager::instance();
     
     if (strcmp(us_manager->user_setting.user_id, "") == 0) {
        OkGamePlatform::instance()->login(false);
     } else {
        OkGamePlatform::instance()->login(true);
     }
     */
}

void SocialPlatform::loginCallback(bool is_success, string user_id, string user_token, string user_name, string game_id) {
    CCLOG("loginCallback is_success %s user_id %s", is_success ? "true" : "false", user_id.c_str());
    
    UserSettingManager* usm = UserSettingManager::instance();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    usm->user_setting.setUserId(user_id.c_str());
#else
    usm->user_setting.setUserId(Game::instance()->deviceUUID().c_str());
#endif
    usm->save();
    
    CSJson::Value json;
    json["is_success"] = is_success;
    json["user_id"] = user_id;
    json["user_token"] = user_token;
    json["user_name"] = user_name;
    json["game_id"] = game_id;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("loginCallback", json);
    
//    CSJson::Value json;
//    json["status"] = 20;
//    json["is_success"] = is_success;
//    auto is_change = LuaManager::instance()->executeGlobalBoolFunctionReturn("changeToLogoSceneCtr", json);
//    if (is_change) {
//        if (!Game::is_login) {
//            LogoSceneCtr::instance()->loginCallback(is_success);
//        } else {
//            Game::is_login = false;
//            LogoSceneCtr::instance()->enterWithAnimation();
//        }
//    }
}


void SocialPlatform::logout()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    platform_impl->logout();
    return;
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    platform_impl->logout();
    return;
#endif
    
    Game::instance()->stopTheGame();
    Game::instance()->updateDeviceUUID();
//    SocialPlatform::instance()->loginCallback(is_success, user_id);
//    platform_impl->loginCallback(false, "");
    SocialPlatform::instance()->loginCallback(false, "");

}


void SocialPlatform::logOutCallback() {
    CCLOG("loginOutCallback");
    
    CSJson::Value json;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("logOutCallback", json);
    
//    Game::instance()->stopTheGame();
//
//    Game::is_login = false;
//
//    CSJson::Value json;
//    json["status"] = 20;
//    auto is_change = LuaManager::instance()->executeGlobalBoolFunctionReturn("changeToLogoSceneCtr", json);
//    if (is_change) {
//        LogoSceneCtr::instance()->enterWithAnimation();
//    }
}


string SocialPlatform::getUserCode() {
    UserSettingManager* us_manager = UserSettingManager::instance();
    return us_manager->user_setting.user_id;
}

int32_t SocialPlatform::getServerId() {
    UserSettingManager* us_manager = UserSettingManager::instance();
    return us_manager->user_setting.server_id;
}

void SocialPlatform::getServerList()
{
    // 请求服务器列表
    map<string, string> params;
    params["action"] = "Platform.httpHosts";
    params["platform"] = getPlatformStr();
    params["pf_id"] = getPfId();
    params["channel_id"] = getChannelId();
    
    PlatformApi* api = PlatformApi::create();
    api->setCallback(CC_CALLBACK_1(SocialPlatform::receiveServerList, this));
    api->sendGet(params);
}

void SocialPlatform::receiveServerList(CSJson::Value json) {
//    LogoSceneCtr::instance()->receiveServerList(json);
//    ChooseServerCtr::instance()->receiveServerList(json);
}


void SocialPlatform::realName(int is_success, string user_id, int adult) {
    CSJson::Value json;
    json["is_success"] = is_success;
    json["user_id"] = user_id;
    json["adult"] = adult;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("realName", json);
}



string SocialPlatform::getPfId() {
#if COCOS2D_DEBUG > 0
    return pf_id;
#endif
    
    return platform_impl->getPf();
}

string SocialPlatform::getChannelId() {
#if COCOS2D_DEBUG > 0
    return channel_id;
#endif
    
    return platform_impl->getChannelId();
}

string SocialPlatform::getPlatformStr() {
#if COCOS2D_DEBUG > 0
    return platform;
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return "1";
#else
    return "2";
#endif
}


void SocialPlatform::pay(string product_id, string amount, string gem)
{
//    CCLOG("SocialPlatform::pay product_id = %s, amount = %s, gem = %s",
//          product_id.c_str(),
//          amount.c_str(),
//          gem.c_str());
//    
//    auto player = Player::instance();
//    //    auto role_data = RoleData::instance();
//    UserSettingManager* us_manager = UserSettingManager::instance();
//    SocialPlatform* social_platform = SocialPlatform::instance();
//
//
//    map<string, string> params;
//    params["action"] = "Recharge.recharge";
//
//    // 沙箱状态的订单会有该参数且值为1，正式订单无该参数
//    params["X-Order-Sandbox"] = "1";
//
//    // 订单号。前端生成
//    params["BillNo"] = StringUtils::format("%lld", Game::instance()->makeId());
//
//    // 用户唯一标识符
//    params["UserCode"] = us_manager->user_setting.user_id;
//
//    // 充值金额
//    params["Amount"] = amount;
//
//    // 接入游戏时分配的商品ID
//    params["ProductId"] = product_id;
//
//    // 角色ID
//    params["RoleId"] = StringUtils::format("%lld", player->role_id);
//
//    // 服务器ID
//    params["ServerId"] = StringUtils::format("%d", us_manager->user_setting.server_id);
//
//    // 渠道ID
//    params["channel_id"] = social_platform->getChannelId();
//
//    // 子包ID
//    params["pf_id"] = social_platform->getPfId();
//
//    // 平台标识符
//    params["platform"] = social_platform->getPlatformStr();
//
//    // 宝石数量
//    params["gem"] = gem;
//
//
//    PlatformApi* api = PlatformApi::create();
//    api->setCallback(CC_CALLBACK_1(SocialPlatform::payConfirm, this));
//    api->sendGet(params, 5);
//
//    
//    BillData data;
//    data.bill_no = params["BillNo"];
//    data.product_id = params["ProductId"];
//    vec_bill.push_back(data);
//    
    // test
    //    payDone(data.bill_no);
}

void SocialPlatform::payConfirm(string product_id, string billNo, string extraInfo)
{
//    CSJson::StyledWriter writer;
//    auto string = writer.write(json);
//    CCLOG("string = %s", string.c_str());
//    if (!json.isObject()  ||
//        !json.isMember("productId") ||
//        !json.isMember("billNo")) {
//        return;
//    }
//
//    Game::is_in_pay = true;
//
//    // goods_id
//    OkGamePlatform::instance()->payStart();
    platform_impl->pay(product_id, billNo, extraInfo);
}


void SocialPlatform::payCallback(bool is_success, string billNo, string error_msg)
{
    
    CSJson::Value json;
    json["is_success"] = is_success;
    json["billNo"] = billNo;
    json["msg"] = error_msg;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("payCallback", json);
    
    
//    Game::is_in_pay = false;
//
//    OkGamePlatform::instance()->payEnd();
}

void SocialPlatform::payDone(string billNo)
{
//    Game::is_in_pay = false;
//
//    // 执行某些操作
//    auto bill_data = getBillNoData(billNo);
//
//    if (!bill_data) {
//        return;
//    }
//
//    auto buy_config = BuyGemTable::instance()->getConfigByServerId(bill_data->product_id);
//    if (!buy_config) {
//        return;
//    }
//
//    removeBillNoData(billNo);
//
//    RoleData* role_data = RoleData::instance();
//    Player* player = Player::instance();
//    role_data->total_charge += (int32_t)buy_config->money;
//
//    // 邮件的刷新，直至收到响应为止
//    role_data->mail_data.is_need_refresh = true;
//
//    ReqMailList req_mail_list;
//    NetManager::instance()->send(&req_mail_list, sizeof(req_mail_list));
//
//    // 背包的刷新，直至收到响应为止
//    player->backpack_data.is_need_refresh = true;
//
//    ReqBackpackList req_backpack_list;
//    NetManager::instance()->send(&req_backpack_list, sizeof(req_backpack_list));
//
//    if (buy_config->kind == 1) {
//        // 购买钻石
//        MessageView::instance()->add(StringUtils::format("您购买了%d个钻石 . . .", buy_config->gem).c_str(), 0);
//
//        role_data->resourceAdd(RESOURCE_GEM, buy_config->gem + buy_config->gift);
//
//        // 更新商城显示
//        ShopLayer* layer_shop = ShopCtr::instance()->getShopLayer();
//        if (!layer_shop) {
//            return;
//        }
//
//        layer_shop->setGemNum(RoleData::instance()->gem);
//    } else if (buy_config->kind == 2) {
//        // 购买成长基金
//        role_data->promotion_data.buyFoundation();
//
//        CheckInCtr::instance()->onBuyFoundationDone();
//    } else if (buy_config->kind == 3) {
//        // 购买月卡
//        for (auto iter_reward = buy_config->vec_shop_item.begin(); iter_reward != buy_config->vec_shop_item.end(); ++iter_reward) {
//            role_data->itemAdd((*iter_reward).type, (*iter_reward).num);
//        }
//        MessageView::instance()->add("获得月卡x1", 0);
//
//        ShopCtr::instance()->buyMonthlyDone();
//    } else if (buy_config->kind == 4) {
//        // 购买年卡
//        for (auto iter_reward = buy_config->vec_shop_item.begin(); iter_reward != buy_config->vec_shop_item.end(); ++iter_reward) {
//            role_data->itemAdd((*iter_reward).type, (*iter_reward).num);
//        }
//        MessageView::instance()->add("获得终身卡x1", 0);
//
//        ShopCtr::instance()->buyMonthlyDone();
//    } else if (buy_config->kind == 5 ||     // 新手礼包
//               buy_config->kind == 6 ||     // 每日礼包
//               buy_config->kind == 7 ||     // 月度礼包
//               buy_config->kind == 8 ||     // 首充礼包
//               buy_config->kind == 9) {     // 限时礼包
//
//        CCLOG("购买礼包成功, 礼包已发送邮箱.");
//        // 购买礼包
//        MessageView::instance()->add("购买礼包成功, 礼包已发送邮箱.", 0);
//
//        role_data->total_present_num += 1;
//        role_data->shop_data.addNumByIndex(buy_config->idx);
//
//        if (buy_config->kind == 5 ||
//            buy_config->kind == 8) {
//            FirstChargeCtr::instance()->buySetDone();
//        } else if (buy_config->kind == 6 ||
//                   buy_config->kind == 7) {
//            ShopCtr::instance()->buySetDone();
//        } else if (buy_config->kind == 9) {
//            ShopGiftDuringCtr::instance()->buySetDone();
//        }
//    }
//
//    auto red_dot_manager = RedDotManager::instance();
//    red_dot_manager->setRedNodeVisible(RDT_MS_PROMOTION_TASK, role_data->promotion_data.hasTaskReward());
//    //    red_dot_manager->setRedNodeVisible(RDT_MS_ACTIVITY_DAY7, role_data->promotion_data.hasLogin7Reward());
//    red_dot_manager->setRedNodeVisible(RDT_MS_ACTIVITY_PAY_REWARD, role_data->promotion_data.hasRechargeReward());
//    red_dot_manager->setRedNodeVisible(RDT_MS_ACTIVITY_GROW_UP, role_data->promotion_data.hasFoundationReward());
//    red_dot_manager->setRedNodeVisible(RDT_MS_ACTIVITY_ACTIVE, role_data->daily_task_data.hasBoxReward());
}


void SocialPlatform::submitRoleInfo(const string& type)
{
    // updateExtraData();
    platform_impl->submitRoleInfo(type);
}

void SocialPlatform::updateExtraData(string guide_num,
                                     string role_id,
                                     string role_name,
                                     string role_level,
                                     string server_id,
                                     string server_name,
                                     string balance,
                                     string vip_level,
                                     string gem_num,
                                     string attack_num,
                                     string extra_info,
                                     string clan_name)
{
//    auto player = Player::instance();
    auto role_data = RoleData::instance();
//    UserSettingManager* user_manager = UserSettingManager::instance();
//
//    string guide_num = StringUtils::format("%d", role_data->guide_num);
//    string role_id = StringUtils::format("%lld", player->role_id);
    string role_create_time = StringUtils::format("%d", role_data->role_create_time);
//    string role_name = player->nick;
//    string role_level = StringUtils::format("%d", role_data->checkpoint_max);
//    string server_id = StringUtils::format("%d", user_manager->user_setting.server_id);
//    string server_name = user_manager->user_setting.server_name;
//    string balance = role_data->gold.asString();
//    string vip_level = "0";
//    string gem_num = StringUtils::format("%d", role_data->gem);
//    string attack_num = player->getAttack().asString();
//    string extra_info = "";
//    string clan_name = role_data->clan.clan_name;
    
    platform_impl->updateExtraData(guide_num,
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

BillData* SocialPlatform::getBillNoData(string bill_no)
{
    for (auto iter = vec_bill.begin(); iter != vec_bill.end(); ++iter)
    {
        if (iter->bill_no == bill_no) {
            return &(*iter);
        }
    }
    return NULL;
}

void SocialPlatform::removeBillNoData(string bill_no) {
    for (auto iter = vec_bill.begin(); iter != vec_bill.end();)
    {
        if (iter->bill_no == bill_no) {
            iter = vec_bill.erase(iter);
        } else {
            ++iter;
        }
    }
}

bool SocialPlatform::isDebug() {
    
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
//    return false;
//#endif
    
#if COCOS2D_DEBUG > 0
	return 1;
#else
	return 0;
#endif
}

void SocialPlatform::setPlatformUrl(int32_t index, string url) {
#if COCOS2D_DEBUG > 0
    VersionTable* version_table = VersionTable::instance();
    version_table->config.platform_urls[index] = url;
#endif
}


string SocialPlatform::getPlatformUrl(int32_t index, string url) {
#if COCOS2D_DEBUG > 0
    VersionTable* version_table = VersionTable::instance();
    return version_table->config.platform_urls[index];
#endif
}


void SocialPlatform::setChannelId(string channel_id) {
#if COCOS2D_DEBUG > 0
    this->channel_id =channel_id;
#endif

}

void SocialPlatform::setPfId(string pf_id) {
#if COCOS2D_DEBUG > 0
    this->pf_id = pf_id;
#endif

}

void SocialPlatform::setPlatform(string platform) {
#if COCOS2D_DEBUG > 0
    this->platform = platform;
#endif
}


void SocialPlatform::setAgent(string agent) {
#if COCOS2D_DEBUG > 0
    this->agent = agent;
#endif
}

string SocialPlatform::getAgent() {
#if COCOS2D_DEBUG > 0
    return agent;
#endif
    return platform_impl->getAgent();
}

// 添加时间 2020-04-15 21:20:43, 需要判断是否存在再调用

string SocialPlatform::getAppId() {
    return platform_impl->getAppId();
}

string SocialPlatform::getPlatformId() {
    return platform_impl->getPlatformId();
}


void SocialPlatform::showUserCenter() {
    platform_impl->showUserCenter();
}

void SocialPlatform::showCustomerService() {
    platform_impl->showCustomerService();
}

void SocialPlatform::shareLink() {
    platform_impl->shareLink();
}

void SocialPlatform::shareLinkCallback(bool is_success, string msg) {
    CSJson::Value json;
    json["is_success"] = is_success;
    json["msg"] = msg;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("shareLinkCallback", json);
}


void SocialPlatform::dz() {
    platform_impl->dz();
}

void SocialPlatform::dzCallback(bool is_success, string msg) {
    CSJson::Value json;
    json["is_success"] = is_success;
    json["msg"] = msg;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("dzCallback", json);
}

void SocialPlatform::zhuXiao() {
    platform_impl->zhuXiao();
}

void SocialPlatform::discuss() {
    platform_impl->discuss();
}

void SocialPlatform::giftBag() {
    platform_impl->giftBag();
}

void SocialPlatform::giftBagCallback(bool is_success, string msg) {
    CSJson::Value json;
    json["is_success"] = is_success;
    json["msg"] = msg;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("giftBagCallback", json);
}

void SocialPlatform::showAd(string type) {
    platform_impl->showAd(type);
}

void SocialPlatform::showAdCallback(string type) {
    CSJson::Value json;
    json["type"] = type;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("showAdCallback", json);
}

string SocialPlatform::getPackageVersion() {
    string package_version = PACKAGE_VERSION;
    package_version = package_version + "-" + this->getPlatformStr();
    return package_version;
//    return "20200525-1";
}

string SocialPlatform::getDeviceToken() {
    return this->push_token;
}

void SocialPlatform::setDeviceToken(string token) {
    this->push_token = token;
}
