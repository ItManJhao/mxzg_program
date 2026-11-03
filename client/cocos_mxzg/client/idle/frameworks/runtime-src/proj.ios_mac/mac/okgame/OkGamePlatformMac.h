//
//  OkGamePlatformMac.h
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#ifndef __cleck__OkGamePlatformMac__
#define __cleck__OkGamePlatformMac__

#include "PlatformImpl.h"

class OkGamePlatformMac : public PlatformImpl, public Ref
{
public:
    string user_id;
    
    OkGamePlatformMac();
    virtual ~OkGamePlatformMac();
    
    virtual void init();
    virtual void initPlatform(int flag);
    
    // 登录
    virtual void login(bool auto_login);
    virtual void logout();
    
    virtual void submitRoleInfo(const string& userId,
                                const int32_t& sceneId,
                                const string& roldId,
                                const string& roleName,
                                const string& serverId,
                                const string& serverName,
                                const string& gemNum,
                                const string& vipLevel);
    
    virtual string getPf();
    virtual string getChannelId();
    virtual string getAgent();
    
    virtual void pay(const string& userId,
                     const string& productId,
                     const string& roldId,
                     const string& roleName,
                     const string& serverId,
                     const string& serverName,
                     const string& gemNum,
                     const string& vipLevel);
    
    virtual void showPrivacyPolicyContentView();
    
    virtual string getPlatformId();
};

#endif /* defined(__cleck__OkGamePlatformMac__) */
