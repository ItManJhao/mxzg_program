//

//  PursueIdeal
//

//  Copyright © 2019 曾春军. All rights reserved.
//

#import <Foundation/Foundation.h>


/** SDK旋转方向 */
typedef NS_ENUM (NSInteger, SPInterfaceOrientationType)
{
    SPInterfaceOrientationUnlimited = -1,
    SPInterfaceOrientationPortrait = 0,
    SPInterfaceOrientationLandscape = 1,
};

typedef NS_ENUM(NSInteger,SPAnalysisType)
{
    SPAnalysisTypeSelectService,
    SPAnalysisTypeCreateRole,
    SPAnalysisTypeEnterGame,
    SPAnalysisTypeUpdateLevel,
    SPAnalysisTypeExitGame
};


typedef NS_ENUM (NSInteger, SPAdEventType)
{
    SPAdEventTypeLoad,//请求广告
    SPAdEventTypeShow //展示广告
};


typedef NS_ENUM(NSInteger,RewardType)
{
    RewardTypeShare,
    RewardTypeLike,
    RewardTypeBind
};

typedef NS_ENUM(NSInteger,GameLanguageType)
{
    GameLanguageTypeEN,   //英文
    GameLanguageTypeTH,   
    GameLanguageTypeVI,   //越南语
    GameLanguageTypeHans, //简体中文
    GameLanguageTypeHant, 
    GameLanguageTypeOther //其他
};

typedef NS_ENUM(NSInteger,ATTrackAuthorizationType)
{
    ATTrackAuthorizationTypeNotDetermined,   
    ATTrackAuthorizationTypeRestricted,   
    ATTrackAuthorizationTypeDenied,  //用户拒绝授权
    ATTrackAuthorizationTypeAuthorized  //用户同意授权
    
};

//对外接口的回调类型
typedef void(^CompleteCallBack)(BOOL result,NSString *msg);


#pragma mark:数据上报
extern NSString * const PC_ROLE_ID;
extern NSString * const PC_ROLE_NAME;
extern NSString * const PC_ROLE_LEVEL;
extern NSString * const PC_SERVER_ID;
extern NSString * const PC_SERVER_NAME;
extern NSString * const PC_REMAIN_COIN;


#pragma mark:支付
extern NSString * const PC_CP_ORDER_ID;
extern NSString * const PC_APPLE_PRODUCT_ID;
extern NSString * const PC_PRODUCT_PRICE;
extern NSString * const PC_EXTRA_INFO;
extern NSString * const PC_EXTRA_INFO1;
extern NSString * const PC_EXTRA_INFO2;

extern NSString * const PC_PRODUCT_COUNT;
extern NSString * const PC_PRODUCT_ID;
extern NSString * const PC_PRODUCT_NAME;
extern NSString * const PC_CURRENCY;


#pragma mark:通知名

extern NSString * const PConInitSuccess;
extern NSString * const PConInitFailed;

//登录成功，失败
extern NSString * const PConLoginSuccess;
extern NSString * const PConLoginFailed;


extern NSString * const PConLogoutSuccess;

//支付成功，失败，取消
extern NSString * const PConBuySuccess;
extern NSString * const PConBuyFailed;
extern NSString * const PConBuyCancel;

//绑定账号的通知
extern NSString * const PConBindThirdSuccess;
//获取绑定账号的状态
extern NSString * const PConGotThirdBindSuccState;

#pragma mark:二次验证取值的key
extern NSString * const PC_SESSION_ID;
extern NSString * const PC_UID;

#pragma mark:广告填充成功，失败
extern NSString * const PC_CompleteImpressionAds;
extern NSString * const PC_FillAdsFailed;

#pragma mark:广告场景
extern NSString * const PC_AD_SCENE;

