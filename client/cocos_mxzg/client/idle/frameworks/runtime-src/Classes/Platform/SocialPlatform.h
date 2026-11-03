//
//  SocialPlatform.h
//  AVT
//
//  Created by Conix on 15-06-28.
//
//

#ifndef __AVT__SocialPlatform__
#define __AVT__SocialPlatform__


#include "../Common/SingleInstance.h"

#include "PlatformImpl.h"

class BillData
{
public:
    string bill_no;
    string product_id;
};


// 社交平台，适配器角色，内部融合调用
class SocialPlatform : public Ref, public SingleInstance<SocialPlatform>
{
public:
//    static SocialPlatform* instance(){};
    
    // 以前的平台单例放弃，以SocialPlatform的PlatformImpl作为以前的单例
    static PlatformImpl* platform_impl;
    
    SocialPlatform();
    
    // IOS SDK 需要接入
    void appDidFinishLaunchingWithOptions(void* application, void* launchOptions, void* appController);
    void didRegisterForRemoteNotificationsWithDeviceToken(void* application, void* deviceToken);
    void didFailToRegisterForRemoteNotificationsWithError(void* application, void* error);
    void applicationWillResignActive(void* application);
    void applicationDidEnterBackground(void* application);
    void applicationWillEnterForeground(void* application);
    void applicationDidBecomeActive(void* application);
    void applicationWillTerminate(void* application);
    bool applicationOpenURL(void* application, void* url, void* options);
    
    string getDeviceToken();
    void setDeviceToken(string token);
    
    // 初始化SDK
    void initSDK();
    
    // 初始化平台
    void initPlatform();
    
    // 登录逻辑
    void login(bool auto_login, int8_t product_type = 0);
    void loginCallback(bool is_success, string user_id, string user_token = "", string user_name = "", string game_id = "");
    void logOutCallback();
    void logout();
    
    string getUserCode();
    int32_t getServerId();
    
    string getPfId();
    string getChannelId();
    
    void getServerList();
    void receiveServerList(CSJson::Value json);
    
    string getPlatformStr();
    
    // 支付逻辑
    void pay(string product_id, string amount, string gem);
    void payConfirm(string product_id, string billNo, string extraInfo);
    void payCallback(bool is_success, string billNo, string error_msg);
    void payDone(string billNo);
    
    /*
     * type:[create_role,enter_game,level_up,guide_num,select_server,loading_finish]
     */
    void submitRoleInfo(const string& type);
    void updateExtraData(string guide_num,
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
                         string clan_name);
    
    BillData* getBillNoData(string bill_no);
    void removeBillNoData(string bill_no);
    
    
    void setChannelId(string channel_id);
    void setPfId(string pf_id);
    void setPlatform(string platform);
    void setPlatformUrl(int32_t index, string url);
    string getPlatformUrl(int32_t index, string url);
    
    void setAgent(string platform);
    string getAgent();
    
    bool isDebug();
    
    void realName(int is_success, string user_id, int adult);
    
    
    
    // 添加时间 2020-04-15 21:20:43, 需要判断是否存在再调用
    // 第三方平台标识符"":通用， tw：贪玩， ky：可以
    virtual string getPlatformId();
    
    string getAppId();
    
    // 用户中心
    void showUserCenter();
    void showCustomerService();
    
    // 分享链接
    void shareLink();
    void shareLinkCallback(bool is_success, string msg);
    
    // 点赞
    void dz();
    void dzCallback(bool is_success, string msg);

    void zhuXiao();
    void discuss();
    
    // 领取礼包
    void giftBag();
    void giftBagCallback(bool is_success, string msg);
    
    void showAd(string type);
    void showAdCallback(string type);
    
    string getPackageVersion();
    
public:
    bool is_charge;     // 是否充值
    vector<BillData> vec_bill;
    string push_token;

#if COCOS2D_DEBUG > 0
    string channel_id; // 大渠道 1
    string pf_id;      // 小渠道 100001
    string platform;   // 平台   1
    string agent;      // 渠道号 mxzgAND
#endif
};

#endif /* defined(__AVT__SocialPlatform__) */
