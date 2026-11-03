//
//  OkGamePlatform.h
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#ifndef __cleck__OkGamePlatform__
#define __cleck__OkGamePlatform__

#include "../Common/SingleInstance.h"
#include "PlatformImpl.h"
#include "../Comp/UIModelLayer.h"
#include "SocialPlatform.h"

#include "../Net/PlatformApi.h"

#define OkGamePlatformDebug 1

class OkGamePlatform : public Ref, public SingleInstance<OkGamePlatform>
{
public:
//    static OkGamePlatform* instance(){}
    
    PlatformImpl* okgame_platform_impl;
    
    CC_SYNTHESIZE(string, user_id, UserId);
    CC_SYNTHESIZE(string, order_id, OrderId);
    
    /** 越狱版ios端相关属性 */
    
    OkGamePlatform();
    virtual ~OkGamePlatform();
    
    void init();
    bool isPlatformInstalled(int16_t type);
    
    void login(bool auto_login);  // 登陆
    void loginCallback(bool is_success, string user_id, string user_token, string user_name, string game_id); // 登录成功回调
    void logout();
    
    /**
     * @paragram scene_type
     * 1、选择服务器
     * 2、创建新用户
     * 3、角色进入游戏
     * 4、角色升级
     */
    void submitRoleInfo(const string& type);
    
    // 支付相关
    void payStart();
    void payEnd();
    void pay(string goods_id, string billNo, string extraInfo);
    void payCallback(bool is_success, string billNo, string error_msg);
    
    string getPf();
    string getChannelId();
    string getAgent();

    virtual void updateExtraData(string guide_num,
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
                                 string clan_name);
    
    void checkOpenId();
    void onChangeRole(int button_index);
    
    void httpCharge(HttpClient *sender, HttpResponse *response);
    
    
    void realName(int is_success, string user_id, int adult);
};

#endif /* defined(__MiniEmpire__TencentPlatform__) */
