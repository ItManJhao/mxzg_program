//
//  MasterCenter+appDelegate.h

//
//  Created by 曾春军 on 2019/3/28.

//

#import "MasterCenter.h"
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface MasterCenter (appDelegate)



//代理方法
+ (void)innovateApplacationDeleage:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)innovateApplacationDeleageWillResignActive:(UIApplication *)application;

+ (void)innovateApplacationDeleageDidEnterBackground:(UIApplication *)application;

+ (void)innovateApplacationDeleageWillEnterForeground:(UIApplication *)application;

+ (void)innovateApplacationDeleageDidBecomeActive:(UIApplication *)application;

+ (void)innovateApplacationDeleageWillTerminate:(UIApplication *)application;


+ (BOOL)innovateApplacationDeleage:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

+ (void)innovateApplacationDeleage:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)innovateApplacationDeleage:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


+ (void)innovateApplacationDeleage:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)innovateApplacationDeleage:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (void)pi_userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0));

+ (void)pi_userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0));


+ (UIInterfaceOrientationMask)innovateApplacationDeleage:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;



@end

NS_ASSUME_NONNULL_END
