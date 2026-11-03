//
//  SpiderKit.h
//  SpiderKit
//
//  Created by 曾春军 on 2019/8/6.
//  Copyright © 2019 曾春军. All rights reserved.
//

#import <UIKit/UIKit.h>


FOUNDATION_EXPORT double InnovateVersionNumber;

//! Project version string for Innovate.
FOUNDATION_EXPORT const unsigned char InnovateVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Innovate/PublicHeader.h>
#import <Innovate/MasterCenter.h>
#import <Innovate/MainConstant.h>
#import <Innovate/MasterCenterAppDelegate.h>




//对外宏接口
/**
 * 初始化接口
 **/
#define MajorProject_performInit(appId,appKey,direction) \
[[MasterCenter defaultInstance] startInitBandAppid:appId appkey:appKey screenDirection:direction]


#define MajorProject_performLogin() \
[[MasterCenter defaultInstance] startAutomaticLogin]


/**
 * 登出接口
 **/
#define MajorProject_performLogout(...) \
[[MasterCenter defaultInstance] prepareLogout]



#define MajorProject_performPurchase(payInfoDict) \
[[MasterCenter defaultInstance] startBuyProductWithInfo:payInfoDict]


/**
 *  角色信息上报接口
 *
 * @param    roleInfoDict    角色信息，请务必传入真实信息，具体内容
 *                           PC_ROLE_ID        PC_SERVER_ID      PC_SERVER_NAME
 *                           PC_ROLE_NAME      PC_ROLE_LEVEL     PC_REMAIN_COIN
 **/
#define MajorProject_performReportRoleInfo(roleInfoDict,type) \
[[MasterCenter defaultInstance] report_updateRoleInfomationWithParameters:roleInfoDict reportType:type]

/**
 * 游戏进度条加载完成 事件接口
 **/

#define MajorProject_performGameLoadingCompleteEvent(...) \
[[MasterCenter defaultInstance] reprot_createFirebaseDotEvents]


/**
 * 获取版本号
 **/
#define MajorProject_getSdkVersion(...) \
[[MasterCenter defaultInstance] got_currentVersion]


#define MajorProject_showUserCenter(...) \
[[MasterCenter defaultInstance] start_showUserCenter]


#define MajorProject_showCustomerService(...) \
[[MasterCenter defaultInstance] start_showCustomerService]

/**
 *  显示fsy
 **/
#define MajorProject_showFanViewController(...) \
[[MasterCenter defaultInstance] start_PrepareFunPopupViewController]

/**
 *  显示App Comment
 **/
#define MajorProject_showAppCommentController(callback) \
[[MasterCenter defaultInstance] pi_showAppCommentViewController:callback]


/**
 *   FB分享
 **/
#define MajorProject_onFacebookShare(callback) \
[[MasterCenter defaultInstance] pi_shareFacebookCompelete:callback]



#define MajorProject_onFacebookLike(callback) \
[[MasterCenter defaultInstance] pi_thumbUpFacebookComplete:callback]


#define MajorProject_onGotReward(type,callback) \
[[MasterCenter defaultInstance] pi_gotRewardType:type compelete:callback]


/**
 *  展示激励视频广告
 **/

#define MajorProject_showRewardVideoAdWithAdScene(adScene) \
[[MasterCenter defaultInstance] pi_showRewardVideoAdWithAdScene:adScene]


#define MajorProject_setGameLanguage(langType) \
[[MasterCenter defaultInstance] pi_setGameLanguageType:langType]

/**
 *   设置头像
 **/
#define MajorProject_setHeadImage(callback) \
[[MasterCenter defaultInstance] pi_setHeadImageComplete:callback]



#define MajorProject_getHeadImage(callback) \
[[MasterCenter defaultInstance] pi_getHeadImageComplete:callback]


/**
 *   获取当前设备系统时区
 **/
#define MajorProject_getTimeZone(callback) \
[[MasterCenter defaultInstance] pi_getTimeZoneComplete:callback]


/**
 *   获取当前设备的ip地址
 **/
#define MajorProject_getIPAddress(callback) \
[[MasterCenter defaultInstance] pi_getIPAddressComplete:callback]



#define MajorProject_tutorialCompletion(...) \
[[MasterCenter defaultInstance] pi_tutorial_completion]


/**
 *   上报游戏内事件
 **/
#define MajorProject_reportInGameEventName(eventName,values) \
[[MasterCenter defaultInstance] pi_reportInGameEventName:eventName withValues:values]



#define MajorProject_applicationdidFinishLaunchingWithOptions(application, launchOptions) \
[MasterCenter innovateApplacationDeleage:application didFinishLaunchingWithOptions:launchOptions]

#define MajorProject_applicationWillResignActive(application) \
[MasterCenter innovateApplacationDeleageWillResignActive:application]

#define MajorProject_applicationDidEnterBackground(application) \
[MasterCenter innovateApplacationDeleageDidEnterBackground:application]

#define MajorProject_applicationWillEnterForeground(application) \
[MasterCenter innovateApplacationDeleageWillEnterForeground:application]

#define MajorProject_applicationDidBecomeActive(application) \
[MasterCenter innovateApplacationDeleageDidBecomeActive:application]

#define MajorProject_applicationWillTerminate(application) \
[MasterCenter innovateApplacationDeleageWillTerminate:application]


//应用间跳转
#define MajorProject_applicationOpenURLWithOptions(application,url,options) \
[MasterCenter innovateApplacationDeleage:application openURL:url options:options]


//远程推送
#define MajorProject_applicationDidRegisterForRemoteNotificationsWithDeviceToken(application,deviceToken) \
[MasterCenter innovateApplacationDeleage:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken]

#define MajorProject_applicationDidFailToRegisterForRemoteNotificationsWithError(application,error) \
[MasterCenter innovateApplacationDeleage:application didFailToRegisterForRemoteNotificationsWithError:error]



#define MajorProject_applicationDidReceiveRemoteNotificationWithUserInfo(application,userInfo) \
[MasterCenter innovateApplacationDeleage:application didReceiveRemoteNotification:userInfo]

#define MajorProject_applicationDidReceiveRemoteNotificationWithUserInfoAndCallback(application,userInfo,callback) \
[MasterCenter innovateApplacationDeleage:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:callback]

#define MajorProject_userNotificationCenterWillPresentNotificationWithNotificationAndCallback(center,notification,callback) \
[MasterCenter pi_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:callback]

#define MajorProject_userNotificationCenterDidReceiveNotificationResponseWithResponseAndCallback(center,response,callback) \
[MasterCenter pi_userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:callback]

