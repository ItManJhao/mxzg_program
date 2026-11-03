//
//  MasterCenter.h

//


//

#import <Foundation/Foundation.h>
#import "MainConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface MasterCenter : NSObject

+ (instancetype)defaultInstance;


- (void)startInitBandAppid:(NSString *)appId appkey:(NSString *)appkey screenDirection:(SPInterfaceOrientationType)screenDirection;


- (void)startAutomaticLogin;


- (void)prepareLogout;


-(void)startBuyProductWithInfo:(NSDictionary *)payInfoDict;

/**
 上报角色信息
 @param roleDict 角色信息
 @param reprotType 上报时机
 */
- (void)report_updateRoleInfomationWithParameters:(NSDictionary *)roleDict reportType:(NSString *)reprotType;

/**
 Firebase统计埋点事件
 */
- (void)reprot_createFirebaseDotEvents;


/**
 显示悬浮窗
 */
- (void)start_presentFloatWindow;

/**
 隐藏悬浮窗
 */
- (void)start_dissmissFloatWindow;



- (NSString *)got_currentVersion;

/**
 显示个人中心
 */
- (void)start_showUserCenter;


- (void)start_showCustomerService;

/**
 显示fs ye
 */
- (void)start_PrepareFunPopupViewController;


- (void)pi_showAppCommentViewController:(CompleteCallBack)complete;


- (void)pi_shareFacebookCompelete:(CompleteCallBack)complete;

- (void)pi_thumbUpFacebookComplete:(CompleteCallBack)complete;


- (void)pi_bindThirdAccount;

/**
领取礼包
*/
- (void)pi_gotRewardType:(RewardType)type compelete:(CompleteCallBack)complete;


/**
 展示激励视频广告
 */
- (void)pi_showRewardVideoAdWithAdScene:(NSString *)adScene;


- (void)pi_setGameLanguageType:(GameLanguageType)languageType;

//设置与获取游戏头像
- (void)pi_setHeadImageComplete:(CompleteCallBack)complete;
- (void)pi_getHeadImageComplete:(CompleteCallBack)complete;


- (void)pi_tutorial_completion;
//游戏内事件上报
- (void)pi_reportInGameEventName:(NSString *)eventName withValues:(NSDictionary * _Nullable)values;


//获取当前手机系统时区和ip
- (void)pi_getTimeZoneComplete:(CompleteCallBack)complete;

- (void)pi_getIPAddressComplete:(CompleteCallBack)complete;



@end

NS_ASSUME_NONNULL_END
