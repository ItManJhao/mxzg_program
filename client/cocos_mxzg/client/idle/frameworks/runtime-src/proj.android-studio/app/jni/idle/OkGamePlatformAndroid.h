/*
 * GameAndroid.h
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#ifndef OK_GAME_PLATFORM_ANDROID_H_
#define OK_GAME_PLATFORM_ANDROID_H_

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "../../../Classes/Platform/PlatformImpl.h"

class OkGamePlatformAndroid: public PlatformImpl {
public:
    OkGamePlatformAndroid(){};
    
    static const string& getMainClassNameForJNI();
    virtual void init();

    virtual void initPlatform(int flag);
    virtual void logout();

    virtual void submitRoleInfo(const string& type);
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
                                 const string& clan_name);
    
    virtual void pay(const string& productId, const string& billNo, const string& extraInfo);
    
    virtual string getPf();
    virtual string getChannelId();
    virtual string getAgent();
    
    virtual void showUserCenter();
    virtual void showCustomerService();
    virtual void shareLink();
    virtual void dz();
    virtual void zhuXiao();
    virtual void discuss();

    virtual string getPlatformId();
private:
    static string main_class_name_for_jni;
};


#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */

#endif /* OK_GAME_PLATFORM_ANDROID_H_ */
