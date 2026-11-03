//
//  OkGamePlatformMac.mm
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#include "OkGamePlatformMac.h"
#include "OkGamePlatform.h"
#include "../../../Classes/Model/Game.h"

#define PLATFOTM_ID "tw_trad"

//#import <KYSDK/KYSDKAPI.h>

#pragma mark okgame接口模块

PlatformImpl* createPlatformImpl() {
    return new OkGamePlatformMac();
}

OkGamePlatformMac::OkGamePlatformMac() {
    
}

OkGamePlatformMac::~OkGamePlatformMac() {
    
}

void OkGamePlatformMac::init() {
    // TEST
    //    Game::instance()->updateDeviceUUID();
    SocialPlatform::instance()->loginCallback(1, Game::instance()->deviceUUID());
}

void OkGamePlatformMac::initPlatform(int flag) {
    // TEST
    //    Game::instance()->updateDeviceUUID();
//    SocialPlatform::instance()->loginCallback(1, Game::instance()->deviceUUID());
}

void OkGamePlatformMac::login(bool auto_login) {
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

void OkGamePlatformMac::logout() {
//    [KYSDKAPI logout];
    
}

void OkGamePlatformMac::submitRoleInfo(const string& userId,
                                       const int32_t& sceneId,
                                       const string& roldId,
                                       const string& roleName,
                                       const string& serverId,
                                       const string& serverName,
                                       const string& gemNum,
                                       const string& vipLevel) {
//    ApiRoleInfoModel *role = [[ApiRoleInfoModel alloc]init];
//    role.userId = [NSString stringWithUTF8String:userId.c_str()];
//    if (sceneId == 1) {
//        role.sceneId = ky_selectServer;
//    } else if (sceneId == 2) {
//        role.sceneId = ky_createRole;
//    } else if (sceneId == 3) {
//        role.sceneId = ky_enterServer;
//    } else if (sceneId == 4) {
//        role.sceneId = ky_levelUp;
//    } else {
//        role.sceneId = ky_enterServer;
//    }
//    role.roleId = [NSString stringWithUTF8String:roldId.c_str()];
//    role.roleName = [NSString stringWithUTF8String:roleName.c_str()];
//    role.level = @"1";
//    role.serverId = [NSString stringWithUTF8String:serverId.c_str()];
//    role.serverName = [NSString stringWithUTF8String:serverName.c_str()];
//    role.currency = [NSString stringWithUTF8String:gemNum.c_str()];
//    role.balance = @"0";
//    role.vip =[NSString stringWithUTF8String:vipLevel.c_str()];
//    role.power = @"0";
//    [KYSDKAPI submitRoleInfoWithRole:role];
}

string OkGamePlatformMac::getPf() {
    return "100001"; // 内网
//    return "400002";  // 外网
}

string OkGamePlatformMac::getChannelId() {
    return "100";       // 内网
//    return "400";         // 外网
}

string OkGamePlatformMac::getAgent() {
    return "mxzgAND";
}

void OkGamePlatformMac::pay(const string& userId,
                            const string& productId,
                            const string& roldId,
                            const string& roleName,
                            const string& serverId,
                            const string& serverName,
                            const string& gemNum,
                            const string& vipLevel) {
//    if (!self.currentUserId) {
//        NSLog(@"请先调用登录接口");
//        return;
//    }
    //模拟订单号
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *timeStamp = [NSString stringWithFormat:@"%.0f", a];
//    //调起支付
//    [KYSDKAPI requestOrderWithUserId:[NSString stringWithUTF8String:userId.c_str()] //此处为SDK登录获取userId
//                           productId:@"sgqjz.dass.6c"
//                             orderId:timeStamp
//                           extraInfo:@"测试订单额外信息"
//                              roleId:[NSString stringWithUTF8String:roldId.c_str()]
//                            roleName:[NSString stringWithUTF8String:roleName.c_str()]
//                            serverId:[NSString stringWithUTF8String:serverId.c_str()]
//                          serverName:[NSString stringWithUTF8String:serverName.c_str()]
//                           roleLevel:@"0"
//                            currency:[NSString stringWithUTF8String:gemNum.c_str()]
//                                 vip:[NSString stringWithUTF8String:vipLevel.c_str()]
//                             balance:@"0"
//                               power:@"0"
//                             success:^(NSString *cpOrderId) {
//                                 NSLog(@"内购支付成功，游戏订单号：%@",cpOrderId);
//                                 OkGamePlatform::instance()->payCallback(true, [cpOrderId UTF8String], "");
//                             } failure:^(NSString *cpOrderId, NSString *errorMsg) {
//                                 NSLog(@"内购支付失败：%@，游戏订单号：%@",errorMsg,cpOrderId);
//                                 OkGamePlatform::instance()->payCallback(true, [cpOrderId UTF8String], [errorMsg UTF8String]);
//                             }];
}

void OkGamePlatformMac::showPrivacyPolicyContentView() {
//    [KYSDKAPI showPrivacyPolicyContentView];
}

string OkGamePlatformMac::getPlatformId() {
    return PLATFOTM_ID;
}

