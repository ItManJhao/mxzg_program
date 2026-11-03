//
//  OkGamePlatformIOS.h
//  cleck
//
//  Created by conix on 3/24/14.
//
//

#include "../../../Classes/Common/CommonDefine.h"


#ifdef FEIFAN_SDK

@class FeiFanShare;

@interface FeiFanShare : NSObject
{

    NSTimer* timer_login;
}

@property(nonatomic)BOOL is_logining;
@property(nonatomic)BOOL is_init_finish;

+(FeiFanShare*)sharedInstance;

- (void)addNSNotificationCenter;
- (void)registerAPNS:(NSObject *)appController;
- (void)initSuccess:(NSNotification *)notification;
- (void)initFailed:(NSNotification *)notification;
- (void)startLogin;
@end

#endif

