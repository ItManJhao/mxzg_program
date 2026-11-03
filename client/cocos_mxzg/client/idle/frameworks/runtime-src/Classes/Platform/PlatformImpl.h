//
//  OkGamePlatformImpl.h
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#ifndef __cleck__OkGamePlatformImpl__
#define __cleck__OkGamePlatformImpl__

#include "../Common/CommonDefine.h"
/*OkGame平台*/

class PlatformImpl {  
    
public:
	PlatformImpl() {}
    ~PlatformImpl() {}
    
    
    virtual void initSDK(){};
    
    virtual void appDidFinishLaunchingWithOptions(void* application, void* launchOptions, void* appController){};
    virtual void didRegisterForRemoteNotificationsWithDeviceToken(void* application, void* deviceToken){};
    virtual void didFailToRegisterForRemoteNotificationsWithError(void* application, void* error){};
    virtual void applicationWillResignActive(void* application){};
    virtual void applicationDidEnterBackground(void* application){};
    virtual void applicationWillEnterForeground(void* application){};
    virtual void applicationDidBecomeActive(void* application){};
    virtual void applicationWillTerminate(void* application){};
    virtual void applicationOpenURL(void* application, void* url, void* options){};
    
    
    virtual void init(){};
    
    /*初始化平台*/
    // flag 0：开发环境；1：现网环境
    virtual void initPlatform(int flag) {}
    virtual void login(bool auto_login) {}  // 登陆
    virtual void logout() {}
    
    virtual void submitRoleInfo(const string& type) {}
    
    virtual void updateExtraData(const string& guide_num,
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
                                 const string& clan_name) {}
    
    virtual string getPf() { return ""; }
    virtual string getChannelId() { return ""; }
    virtual string getAgent() { return ""; }

    virtual void pay(const string& productId, const string& billNo, const string& extraInfo) {}
    
    virtual void showPrivacyPolicyContentView() {}
    
    virtual string getAppId() {return "";};
    virtual void showUserCenter(){};
    virtual void showCustomerService(){};
    virtual void shareLink(){};
    virtual void dz(){};
    virtual void zhuXiao(){};
    virtual void discuss(){};
    virtual void giftBag(){};
    virtual void showAd(string type){};
    virtual string getPlatformId() {return "";};
};

extern PlatformImpl* createPlatformImpl();

#endif /* defined(__cleck__OkGamePlatformImpl__) */
