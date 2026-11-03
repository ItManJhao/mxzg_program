//
//  OkGamePlatformIOS.h
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#ifndef __cleck__OkGamePlatformIOS__
#define __cleck__OkGamePlatformIOS__

#include "PlatformImpl.h"
#include "../../../Classes/Common/CommonDefine.h"


#ifdef OKGAME_SDK

class OkGamePlatformIOS : public PlatformImpl, public Ref
{
public:
    string user_id;
    string guide_num;
    string scene_id;
    string role_id;
    string role_name;
    string role_level;
    string server_id;
    string server_name;
    string balance;
    string vip_level;
    string gem_num;
    string attack_num;
    string extra_info;
    string clan_name;
    
    
    OkGamePlatformIOS();
    virtual ~OkGamePlatformIOS();
    
    virtual void initSDK();
    virtual void init();
    virtual void initPlatform(int flag);
    
    // 登录
    virtual void login(bool auto_login);
    virtual void logout();
    
    
    virtual string getPf();
    virtual string getChannelId();
    virtual string getAgent();

    virtual void pay(const string& productId, const string& billNo, const string& extraInfo);
    
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
    
};


#endif
#endif /* defined(__cleck__OkGamePlatformIOS__) */

