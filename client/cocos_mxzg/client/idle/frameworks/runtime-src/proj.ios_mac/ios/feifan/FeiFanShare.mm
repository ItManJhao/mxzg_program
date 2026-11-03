//
//  OkGamePlatformIOS.mm
//  cleck
//
//  Created by conix on 3/24/14.
//
//


#import <FeiFanShare.h>
#import <UIKit/UIKit.h>
#ifdef FEIFAN_SDK

#import <Innovate/Innovate.h>
#import <UserNotifications/UserNotifications.h>

#include "../../../Classes/Platform/SocialPlatform.h"

#include "FeiFanDefine.h"


static FeiFanShare *_sharedInstance = nil;

@implementation FeiFanShare

+(FeiFanShare*)sharedInstance
{
    if (_sharedInstance != nil) {
        return _sharedInstance;
    }

    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    
    return _sharedInstance;
}

-(id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    NSAssert(NO, @ "[SDKShare alloc] explicitly called on singleton class.");
    return nil;
}

-(id)copyWithZone:(NSZone*)zone
{
    timer_login = nil;
    _is_logining = NO;
    _is_init_finish = NO;
    return self;
}

-(id)retain
{
    return self;
}

-(oneway void)release
{
}

-(id)autorelease
{
    return self;
}


- (void)loginCallBack:(NSNotification *)sender
{
   
}

- (void)KCregchargCallBack:(NSNotification *)sender
{
}

- (void)addNSNotificationCenter
{
    //监听初始化成功
    
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(initSuccess:) name: PConInitSuccess object:nil];
    //监听初始化失败
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(initFailed:) name: PConInitFailed object:nil];
    
    
#ifdef FUSION_SDK
    
#else
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(loginSuccess:) name:PConLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(loginFailed:) name:PConLoginFailed object:nil];

    //注销
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(loginOutSuccess:) name:PConLogoutSuccess object:nil];
    
    //支付
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(profitSuccess:) name:PConBuySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(profitFailed:) name:PConBuyFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(profitCancel:) name:PConBuyCancel object:nil];
#endif
    

    //第三方绑定账号成功
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(cBindSuccess:) name:PConBindThirdSuccess object:nil];

    //查询第三方账号绑定状态
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(cGetThirdBindSuccState:) name:PConGotThirdBindSuccState object:nil];
//
    //广告观看完毕
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(completeImpressionAds:) name:PC_CompleteImpressionAds object:nil];

    //广告获取失败
    [[NSNotificationCenter defaultCenter] addObserver:[FeiFanShare sharedInstance] selector:@selector(fillAdsFailed:) name:PC_FillAdsFailed object:nil];
}

#pragma mark 初始化
- (void)initSuccess:(NSNotification *)notification
{
    NSLog(@"Game:SDK初始化成功");
    // TODO: 收到此回调后方可进入游戏选区界面并调用登录接口
    [FeiFanShare sharedInstance].is_init_finish = YES;
    if ([FeiFanShare sharedInstance]->_is_logining) {
        [FeiFanShare sharedInstance]->_is_logining = NO;
//        MajorProject_performLogin();
        [[FeiFanShare sharedInstance] startLogin];
    }
}

- (void)initFailed:(NSNotification *)notification
{
    NSLog(@"Game:SDK初始化失败%@", (NSString*)notification.object);
    // TODO: 收到此回调 需重新进行SDK初始化操作
    SocialPlatform::instance()->initSDK();
//    _is_initing = YES;
//    _is_initing = NO;
}


#pragma mark 登录
- (void)startLogin
{
    MajorProject_performLogin();
    
//    if (timer_login != nil) {
//        [timer_login invalidate];
//        timer_login = nil;
//    }
//
//    // 需要判断是否初始化成功
//    timer_login = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[FeiFanShare sharedInstance] selector:@selector(checkLogin:) userInfo:nil repeats:YES];
//    [[FeiFanShare sharedInstance] checkLogin];
}

-(void)checkLogin
{
//    if (_is_init) {
//        MajorProject_performLogin();
//    } else if (_is_initing == NO) {
//        SocialPlatform::instance()->initSDK();
//    }
//
//    if (_is_init && timer_login != nil) {
//        [timer_login invalidate];
//        timer_login = nil;
//    }
}

//登陆成功回调
-(void)loginSuccess:(NSNotification*)notif
{
    //研发服务端使用sessionId去SDK服务端进行登录验证
    NSDictionary *infoDict = notif.object;
    NSString *sessionId = infoDict[PC_SESSION_ID];
    NSString *uid = infoDict[PC_UID];
    NSLog(@"Demo:登录成功 uid:%@ sessionId:%@", uid, sessionId);
    
    SocialPlatform::instance()->loginCallback(true, [uid UTF8String], [sessionId UTF8String], "", APP_ID);
}

//登陆失败回调
-(void)loginFailed:(NSNotification*)notif
{
    NSLog(@"Demo:登录失败");
    SocialPlatform::instance()->loginCallback(false, "");
}

//注销成功的通知
- (void)loginOutSuccess:(NSNotification *)notif {
    //CP返回游戏登录界面并调用登录接口
    SocialPlatform::instance()->logOutCallback();
}


#pragma mark 广告
- (void)completeImpressionAds:(NSNotification*)notif {
    NSDictionary *infoDict = notif.object;
    NSString *adScene = infoDict[PC_AD_SCENE];
    SocialPlatform::instance()->showAdCallback([adScene UTF8String]);
}

- (void)fillAdsFailed:(NSNotification*)notif {
    SocialPlatform::instance()->showAdCallback("");
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除监听
    [super dealloc];
}


- (void) registerAPNS:(NSObject *)appController
{
    if (@available(iOS 10.0,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = appController;
//        [center setDelegate:(UNUserNotificationCenterDelegate*)appController];
        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Demo:request authorization error!");
            }
        }];
    }else{
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


//注册APNS成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    MajorProject_applicationDidRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken);
}

//注册APNS失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    MajorProject_applicationDidFailToRegisterForRemoteNotificationsWithError(application, error);
}


//支付结果的处理
-(void)profitSuccess:(NSNotification*)notif
{
    NSLog(@"Demo:购买成功");
    
    SocialPlatform::instance()->payCallback(true, "", "");
}

-(void)profitFailed:(NSNotification*)notif
{
//    NSLog(@"Demo:购买失败");
    SocialPlatform::instance()->payCallback(false, "", "");

}

-(void)profitCancel:(NSNotification*)notif
{
//    NSLog(@"Demo:购买取消");
//    SocialPlatform::instance()->payCallback(true, "", "");
}



-(void)cGetThirdBindSuccState:(NSNotification*)notif
{
    NSLog(@"第三方绑定状态%@", (NSString*)notif.object);
}

@end


#endif
