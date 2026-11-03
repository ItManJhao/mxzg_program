//
//  FeiFanPlatformIOS.mm
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#include "FeiFanPlatformIOS.h"
#include "OkGamePlatform.h"
#include "../../../Classes/Model/Game.h"
#include "SocialPlatform.h"
#include "FeiFanDefine.h"

#ifdef FEIFAN_SDK
#import <Innovate/Innovate.h>
#import <UserNotifications/UserNotifications.h>

#import <FeiFanShare.h>




#define PLATFOTM_ID "tw_trad"
#define CHANNEL_ID "400"
#define PF_ID "400001"


#define KY_APP_ID "101"
#define KY_APP_KEY "7c9a1c54bb3583bb7af9054efbd9ba3c"
#define KY_SDK_AGENT "mjyssIOS"



#pragma mark okgame接口模块
PlatformImpl* createPlatformImpl() {
    return new FeiFanPlatformIOS();
}

FeiFanPlatformIOS::FeiFanPlatformIOS() {
    
}

FeiFanPlatformIOS::~FeiFanPlatformIOS() {
    
}

void FeiFanPlatformIOS::appDidFinishLaunchingWithOptions(void* application, void* launchOptions, void* appController)
{
    MajorProject_applicationdidFinishLaunchingWithOptions((UIApplication*)application, (NSDictionary *)launchOptions);
    [[FeiFanShare sharedInstance] registerAPNS:(NSObject*)appController];
    [[FeiFanShare sharedInstance] addNSNotificationCenter];
    
}

void FeiFanPlatformIOS::didRegisterForRemoteNotificationsWithDeviceToken(void* application, void* deviceToken)
{
    MajorProject_applicationDidRegisterForRemoteNotificationsWithDeviceToken((UIApplication *)application, (NSData *)deviceToken);
}

void FeiFanPlatformIOS::didFailToRegisterForRemoteNotificationsWithError(void* application, void* error)
{
    MajorProject_applicationDidFailToRegisterForRemoteNotificationsWithError((UIApplication *)application, (NSError *)error);
}

void FeiFanPlatformIOS::applicationWillResignActive(void* application)
{
    MajorProject_applicationWillResignActive((UIApplication *)application);
}

void FeiFanPlatformIOS::applicationDidEnterBackground(void* application)
{
    MajorProject_applicationDidEnterBackground((UIApplication *)application);
}

void FeiFanPlatformIOS::applicationWillEnterForeground(void* application)
{
    MajorProject_applicationWillEnterForeground((UIApplication *)application);
}

void FeiFanPlatformIOS::applicationDidBecomeActive(void* application)
{
    MajorProject_applicationDidBecomeActive((UIApplication *)application);
}

void FeiFanPlatformIOS::applicationWillTerminate(void* application)
{
    MajorProject_applicationWillTerminate((UIApplication *)application);
}

//bool applicationOpenURL(void* application, void* url, void* options)
//{
//    NSDictionary<UIApplicationOpenURLOptionsKey,id>* aoptions = (NSDictionary<UIApplicationOpenURLOptionsKey,id>*)options;
//    auto result = MajorProject_applicationOpenURLWithOptions((UIApplication *)application, (NSURL *)url, aoptions);
//    return result == TRUE ? true : false;
//}

void FeiFanPlatformIOS::initSDK() {
    MajorProject_performInit(@APP_ID, @APP_KEY, SPInterfaceOrientationUnlimited);
//    [FeiFanShare sharedInstance].is_initing = YES;
}

void FeiFanPlatformIOS::init() {
    
    [FeiFanShare sharedInstance].is_logining = YES;
    if ([FeiFanShare sharedInstance].is_init_finish) {
        [[FeiFanShare sharedInstance] startLogin];
    }
//    MajorProject_performInit(@APP_ID, @APP_KEY, SPInterfaceOrientationUnlimited);
    
//    [[FeiFanShare sharedInstance] startLogin];
}

void FeiFanPlatformIOS::initPlatform(int flag) {
//    SocialPlatform::instance()->loginCallback(1, Game::instance()->deviceUUID());
}

void FeiFanPlatformIOS::login(bool auto_login) {
//    OKSDKLogout;
    
}

void FeiFanPlatformIOS::logout() {
    MajorProject_performLogout();
}

void FeiFanPlatformIOS::submitRoleInfo(const string& type) {
    
    NSString* str_role_name = [NSString stringWithUTF8String:this->role_name.c_str()];
    NSString* str_server_id = [NSString stringWithUTF8String:this->server_id.c_str()];
    NSString* str_server_name = [NSString stringWithUTF8String:this->server_name.c_str()];
    NSString* str_role_level = [NSString stringWithUTF8String:this->role_level.c_str()];
    NSString* str_role_id = [NSString stringWithUTF8String:this->role_id.c_str()];
    NSString* str_gem_num = [NSString stringWithUTF8String:this->gem_num.c_str()];
    
    NSString* str_scene_id = [NSString stringWithUTF8String:this->scene_id.c_str()];
    NSString* str_balance = [NSString stringWithUTF8String:this->balance.c_str()];
    NSString* str_vip_level = [NSString stringWithUTF8String:this->vip_level.c_str()];
    NSString* str_attack_num = [NSString stringWithUTF8String:this->attack_num.c_str()];



    //        create_role,enter_game,level_up,guide_num,select_server
    NSDictionary *roleInfoDict = @{PC_ROLE_NAME   : str_role_name,    // 角色名
                                   PC_SERVER_ID   : str_server_id,    //服务器ID，纯数字字符串
                                   PC_SERVER_NAME : str_server_name,  //服务器名
                                   PC_ROLE_LEVEL  : str_role_level,   //角色等级
                                   PC_ROLE_ID     : str_role_id,      //角色ID
                                   PC_REMAIN_COIN : str_gem_num       //剩余元宝/钻石 数量
                                    };


        if (type == "level_up") {
            MajorProject_performReportRoleInfo(roleInfoDict,@"4");
        } else if (type == "enter_game") {
            MajorProject_performReportRoleInfo(roleInfoDict,@"3");
        } else if (type == "create_role") {
            MajorProject_performReportRoleInfo(roleInfoDict, @"2");
        } else if (type == "loading_finish") {
            MajorProject_performGameLoadingCompleteEvent();
        } else if (type == "select_server") {
            MajorProject_performReportRoleInfo(roleInfoDict, @"1");
        } else if (type == "exit_game") {
            MajorProject_performReportRoleInfo(roleInfoDict, @"5");
        } else if (type == "vip_uplevel") {
            MajorProject_performReportRoleInfo(roleInfoDict, @"6");
        } else if (type == "join_clan") {
            MajorProject_performReportRoleInfo(roleInfoDict, @"7");
        } else {
            MajorProject_performReportRoleInfo(roleInfoDict, [NSString stringWithUTF8String:type.c_str()]);
        }
    
}

void FeiFanPlatformIOS::updateExtraData(const string& guide_num,
                             const string& role_id,
                             const string& role_create_time,
                             const string& role_name,
                             const string& role_level,
                             const string& server_id,
                             const string& server_name,
                             const string& balance,
                             const string& vip_level,
                             const string& gem_num,
                             const string& attack_num,
                             const string& extra_info,
                             const string& clan_name) {
    this->guide_num = guide_num;
    this->role_id = role_id;
    this->role_name = role_name.size() > 0 ? role_name : "0";
    this->role_level = role_level;
    this->server_id = server_id;
    this->server_name = server_name;
    this->balance = balance;
    this->vip_level = vip_level;
    this->gem_num = gem_num;
    this->attack_num = attack_num;
    this->extra_info = extra_info;
    this->clan_name = clan_name;
}


string FeiFanPlatformIOS::getAppId() {
    NSString *appleAppid = [NSBundle mainBundle].infoDictionary[@"AppleAppID"];
    return [appleAppid UTF8String];
}


string FeiFanPlatformIOS::getChannelId() {
    return CHANNEL_ID;
}

string FeiFanPlatformIOS::getPf() {
    return PF_ID;
}

string FeiFanPlatformIOS::getAgent() {
    return KY_SDK_AGENT;
}

void FeiFanPlatformIOS::pay(const string& productId, const string& billNo, const string& extraInfo) {
    CSJson::Reader reader;
    CSJson::Value json;
    string tmp;
    string price = "";
    string server_id = "";
    string role_id = "";
    string role_name = "";
    string role_level = "";
    string ext_info = "";
    string ext_info1 = "";
    string ext_info2 = "";
    string idx = "";
    string product_name = "";
    string product_num = "";

    reader.parse(extraInfo, json);

    if (json.isObject()) {
        if (json.isMember("Price")) price = json["Price"].asString();
        if (json.isMember("ServerId")) server_id = json["ServerId"].asString();
        if (json.isMember("RoleId")) role_id = json["RoleId"].asString();
        if (json.isMember("RoleName")) role_name = json["RoleName"].asString();
        if (json.isMember("RoleLevel")) role_level = json["RoleLevel"].asString();
        if (json.isMember("ExtInfo")) ext_info = json["ExtInfo"].asString();
        if (json.isMember("ExtInfo1")) ext_info1 = json["ExtInfo1"].asString();
        if (json.isMember("ExtInfo2")) ext_info2 = json["ExtInfo2"].asString();
        if (json.isMember("Idx")) idx = json["Idx"].asString();
        if (json.isMember("ProductName")) product_name = json["ProductName"].asString();
        if (json.isMember("ProductNum")) product_num = json["ProductNum"].asString();
    }
    
    //参数由CP提供
    NSMutableDictionary *payInfoDict = [NSMutableDictionary dictionary];
    payInfoDict[PC_CP_ORDER_ID] = [NSString stringWithUTF8String:billNo.c_str()];
    payInfoDict[PC_APPLE_PRODUCT_ID] = [NSString stringWithUTF8String:productId.c_str()];//apple_product_id;
    payInfoDict[PC_PRODUCT_PRICE] = [NSString stringWithUTF8String:price.c_str()];//商品价格
    payInfoDict[PC_REMAIN_COIN] = [NSString stringWithUTF8String:this->gem_num.c_str()]; //剩余金币/元宝/钻石数
    payInfoDict[PC_ROLE_ID] = [NSString stringWithUTF8String:this->role_id.c_str()];
    payInfoDict[PC_ROLE_LEVEL] = [NSString stringWithUTF8String:this->role_level.c_str()];
    payInfoDict[PC_ROLE_NAME] = [NSString stringWithUTF8String:this->role_name.c_str()];
    payInfoDict[PC_SERVER_ID] = [NSString stringWithUTF8String:this->server_id.c_str()]; //需为纯数字字符串
    payInfoDict[PC_SERVER_NAME] = [NSString stringWithUTF8String:this->server_name.c_str()];
    payInfoDict[PC_PRODUCT_ID] = [NSString stringWithUTF8String:idx.c_str()];
    payInfoDict[PC_PRODUCT_COUNT] = [NSString stringWithUTF8String:product_num.c_str()];
    payInfoDict[PC_PRODUCT_NAME] = [NSString stringWithUTF8String:product_name.c_str()];
    payInfoDict[PC_EXTRA_INFO] = [NSString stringWithUTF8String:ext_info.c_str()];
    payInfoDict[PC_EXTRA_INFO1] = [NSString stringWithUTF8String:ext_info1.c_str()];
    payInfoDict[PC_EXTRA_INFO2] = [NSString stringWithUTF8String:ext_info2.c_str()];
    MajorProject_performPurchase(payInfoDict);
}


void FeiFanPlatformIOS::showUserCenter()
{
    MajorProject_showUserCenter();
}

void FeiFanPlatformIOS::showCustomerService()
{
    MajorProject_showCustomerService();
}

void FeiFanPlatformIOS::shareLink()
{
    CompleteCallBack callback = ^(BOOL result,NSString *msg){
        SocialPlatform::instance()->shareLinkCallback(result, [msg UTF8String]);
    };
    MajorProject_onFacebookShare(callback);
}

void FeiFanPlatformIOS::dz()
{
    CompleteCallBack callback = ^(BOOL result,NSString *msg){
        SocialPlatform::instance()->dzCallback(result, [msg UTF8String]);
    };
    MajorProject_onFacebookLike(callback);
}

void FeiFanPlatformIOS::zhuXiao()
{
    MajorProject_performLogout();
}

void FeiFanPlatformIOS::giftBag()
{
    RewardType type = RewardTypeShare;
    CompleteCallBack callback = ^(BOOL result,NSString *msg){
        SocialPlatform::instance()->giftBagCallback(result, [msg UTF8String]);
    };
    MajorProject_onGotReward(type, callback);
}


void FeiFanPlatformIOS::showAd(string type)
{
    //广告使用场景
    MajorProject_showRewardVideoAdWithAdScene([NSString stringWithUTF8String:type.c_str()]);
}

string FeiFanPlatformIOS::getPlatformId()
{
    return PLATFOTM_ID;
}


#endif
