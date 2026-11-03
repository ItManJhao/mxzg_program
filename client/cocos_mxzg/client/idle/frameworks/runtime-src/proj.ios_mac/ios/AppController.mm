/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"

#import "SocialPlatform.h"
#import <Innovate/Innovate.h>



@implementation AppController

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                     pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                     depthFormat: cocos2d::GLViewImpl::_depthFormat
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];

    [eaglView setMultipleTouchEnabled:YES];
    
    // Use RootViewController manage CCEAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = eaglView;
    viewController.view.backgroundColor = [UIColor clearColor];
    viewController.view.tag = 3;
    
    UIViewController* uiVC = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    uiVC.wantsFullScreenLayout = YES;
    uiVC.view.frame = [UIScreen mainScreen].bounds;
    _videoView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    _videoView.tag = 1;             //设置tag以便之后把Video层取出来~
      
    [uiVC.view addSubview:_videoView];
    [uiVC.view addSubview:viewController.view];
    
    
    
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
//        [window addSubview: viewController.view];
        [window addSubview: uiVC.view];
    }
    else
    {
        // use this method on ios6
//        [window setRootViewController:viewController];
        [window setRootViewController:uiVC];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
//    MajorProject_applicationdidFinishLaunchingWithOptions(application, launchOptions);
//    MajorProject_performInit(@"62", @"6dae9919396d41e933d003d45cc442d4", SPInterfaceOrientationUnlimited);
    
    SocialPlatform::instance()->appDidFinishLaunchingWithOptions(application, launchOptions, self);
    
    SocialPlatform::instance()->initSDK();
    
    app->run();
    return YES;
}

- (UIWindow*)window {
    return window;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::Director::getInstance()->pause();
    
    SocialPlatform::instance()->applicationWillResignActive(application);

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::Director::getInstance()->resume();
    
    SocialPlatform::instance()->applicationDidBecomeActive(application);

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
    
    SocialPlatform::instance()->applicationDidEnterBackground(application);

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
    
    SocialPlatform::instance()->applicationWillEnterForeground(application);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    SocialPlatform::instance()->applicationWillTerminate(application);
}

//注册APNS成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
//    MajorProject_applicationDidRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken);
    SocialPlatform::instance()->didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken);
    NSString *deviceTokenStr = [[[[deviceToken description]
    stringByReplacingOccurrencesOfString:@"<" withString:@""]
    stringByReplacingOccurrencesOfString:@">" withString:@""]
    stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr:\n%@", deviceTokenStr);
    
    SocialPlatform::instance()->setDeviceToken([deviceTokenStr UTF8String]);
}

//注册APNS失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    SocialPlatform::instance()->didFailToRegisterForRemoteNotificationsWithError(application, error);
//    MajorProject_applicationDidFailToRegisterForRemoteNotificationsWithError(application, error);
}

#ifdef FEIFAN_SDK
//应用间跳转
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return MajorProject_applicationOpenURLWithOptions(application, url, options);
//    return SocialPlatform::instance()->applicationOpenURL(application, url, options);
}


//通知栏收到的消息（iOS10之前,应用处于后台）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    
    MajorProject_applicationDidReceiveRemoteNotificationWithUserInfo(application,userInfo);
    
}

//静默远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    
    MajorProject_applicationDidReceiveRemoteNotificationWithUserInfoAndCallback(application,userInfo,completionHandler);
}


//通知栏收到消息（iOS10以后, 应用处于前台时才触发）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)) {
    // Receive displayed notifications for iOS 10 devices.
    // Handle incoming notification messages while app is in the foreground.
    
    MajorProject_userNotificationCenterWillPresentNotificationWithNotificationAndCallback(center,notification,completionHandler);
}


//点击通知栏消息（iOS10以后, 应用处于前台/后台/杀死状态都会来到这个方法）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)) {
    //Handle notification messages after display notification is tapped by the user.
    
    MajorProject_userNotificationCenterDidReceiveNotificationResponseWithResponseAndCallback(center,response,completionHandler);
}

#endif

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
//     cocos2d::Director::getInstance()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}


@end

