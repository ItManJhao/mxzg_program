//
//  OkGamePlatformIOS.mm
//  cleck
//
//  Created by conix on 3/24/14.
//
//




#include "OkGamePlatformIOS.h"
#include "OkGamePlatform.h"
#include "../../../Classes/Model/Game.h"
#include "SocialPlatform.h"

#ifdef OKGAME_SDK

#import <MLZHSDK/KYGAMESDKAPI.h>

//#import <KYSDK/KYSDKAPI.h>

#define APP_ID "177"
#define APP_KEY "7c9a1c54bb3583bb7af9054efbd9ba3c"
#define SDK_AGENT "mlzhIOS"

#pragma mark okgame接口模块
PlatformImpl* createPlatformImpl() {
    return new OkGamePlatformIOS();
}

OkGamePlatformIOS::OkGamePlatformIOS() {
    
}

OkGamePlatformIOS::~OkGamePlatformIOS() {
    
}

void OkGamePlatformIOS::initSDK() {
    [[KYGAMESDKAPI shareInstance]initSDKWithAppId:@APP_ID
                                              appKey:@APP_KEY
                                               agent:@SDK_AGENT success:^{
                                                   NSLog(@"Demo SDK初始化成功");
                                               } failure:^(NSString *message) {
//                                                   NSLog(@"Demo SDK初始化失败：%@",message);
                                                   this->initSDK();
                                               }];
}

void OkGamePlatformIOS::init() {
    [[KYGAMESDKAPI shareInstance]loginSuccess:^(NSString *loginToken, NSString *userId, NSString *userName) {
//        self.userId = userId;
//        NSLog(@"Demo SDK登录成功 loginToken = %@，userId = %@，userName = %@",loginToken,userId,userName);
        //游戏二登验证...
        this->user_id = [userId UTF8String];
        SocialPlatform::instance()->loginCallback(true,  [userId UTF8String]);
    } failed:^(NSString *message) {
//        NSLog(@"Demo SDK登录失败：%@",message);
        SocialPlatform::instance()->loginCallback(false, "");
    }];
}

void OkGamePlatformIOS::initPlatform(int flag) {
//    SocialPlatform::instance()->loginCallback(1, Game::instance()->deviceUUID());
}

void OkGamePlatformIOS::login(bool auto_login) {
//    [KYSDKAPI loginSuccess:^(NSString *userId, NSString *userName, NSString *token) {
//        NSLog(@"登录成功，userId = %@，userName = %@，token = %@",userId,userName,token);
//        user_id = [userId UTF8String];
//        //此处二登验证：
//        OkGamePlatform::instance()->loginCallback(true, [userId UTF8String]);
//    } failure:^(NSString *errorStr) {
//        NSLog(@"登录失败：%@",errorStr);
//        OkGamePlatform::instance()->loginCallback(false, [errorStr UTF8String]);
//    }];
}

void OkGamePlatformIOS::logout() {
//    [KYSDKAPI logout];
    this->user_id = "";
    [[KYGAMESDKAPI shareInstance]logoutSuccess:^{
        NSLog(@"Demo SDK 退出登录成功");
    } failed:^(NSString *message) {
        NSLog(@"Demo SDK 退出登录失败：%@",message);
    }];
}

void OkGamePlatformIOS::submitRoleInfo(const string& type) {
    KYGAMERoleModel *model = [[KYGAMERoleModel alloc]init];
    model.roleId = [NSString stringWithUTF8String:this->role_id.c_str()];
    model.roleName =[NSString stringWithUTF8String:this->role_name.c_str()];
    model.level = [NSString stringWithUTF8String:this->role_level.c_str()];
    model.serverId = [NSString stringWithUTF8String:this->server_id.c_str()];
    model.serverName = [NSString stringWithUTF8String:this->server_name.c_str()];
    model.balance = [NSString stringWithUTF8String:this->balance.c_str()];
    model.vip = [NSString stringWithUTF8String:this->vip_level.c_str()];
    model.currency = [NSString stringWithUTF8String:this->gem_num.c_str()];
    model.power = [NSString stringWithUTF8String:this->attack_num.c_str()];
    
    if (type == "select_server") {
        model.sceneId = ky_selectServer;
    } else if (type == "level_up") {
        model.sceneId = ky_levelUp;
    } else if (type == "enter_game") {
        model.sceneId = ky_enterServer;
    } else if (type == "create_role") {
        model.sceneId = ky_createRole;
    } else {
        return;
    }
    
    [[KYGAMESDKAPI shareInstance]submitRoleInfoWithLoginUserId:[NSString stringWithUTF8String:this->user_id.c_str()] roleModel:model success:^{
        NSLog(@"Demo SDK角色信息提交成功");
    } failed:^(NSString *message) {
        NSLog(@"Demo SDK角色信息提交失败：%@",message);
    }];
}

void OkGamePlatformIOS::updateExtraData(const string& guide_num,
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



string OkGamePlatformIOS::getChannelId() {
    return "100";
}

string OkGamePlatformIOS::getPf() {
    return "100001";
}

string OkGamePlatformIOS::getAgent() {
    return SDK_AGENT;
}

void OkGamePlatformIOS::pay(const string& productId, const string& billNo, const string& extraInfo) {
    
    KYGAMEPaymentInfo *model = [[KYGAMEPaymentInfo alloc]init];
    model.productId = [NSString stringWithUTF8String:productId.c_str()];
//    model.productId = [NSString stringWithUTF8String:"com.gzbl.mlzh.zc6"];
    model.orderId = [NSString stringWithUTF8String:billNo.c_str()];
    model.extraInfo = [NSString stringWithUTF8String:extraInfo.c_str()];
    model.roleId = [NSString stringWithUTF8String:this->role_id.c_str()];
    model.roleName = [NSString stringWithUTF8String:this->role_name.c_str()];
    model.level = [NSString stringWithUTF8String:this->role_level.c_str()];
    model.serverId = [NSString stringWithUTF8String:this->server_id.c_str()];
    model.serverName = [NSString stringWithUTF8String:this->server_name.c_str()];
    model.balance = [NSString stringWithUTF8String:this->balance.c_str()];
    model.vip = [NSString stringWithUTF8String:this->vip_level.c_str()];
    model.currency = [NSString stringWithUTF8String:this->gem_num.c_str()];
    model.power = [NSString stringWithUTF8String:this->attack_num.c_str()];
    
    [[KYGAMESDKAPI shareInstance] paymentWithLoginUserId:[NSString stringWithUTF8String:this->user_id.c_str()] roleModel:model success:^{
        NSLog(@"Demo SDK支付失败");
    } failed:^(NSString *message) {
        NSLog(@"Demo SDK支付失败：%@",message);
    }];
}


#endif
