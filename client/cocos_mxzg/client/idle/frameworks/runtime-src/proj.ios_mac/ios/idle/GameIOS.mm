
//
//  Game.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "GameIOS.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#import "sys/utsname.h" // 获取设备字符串用的
#import "platform/ios/CCEAGLView-ios.h"
#import "SSKeychain.h" // IOS保存UUID用的
//#import "Reachability.h"
#include "Model/LuaManager.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

GameImpl* createGameImpl() {
    return new GameIOS();
}

GameIOS::GameIOS() {
    
}

GameIOS::~GameIOS() {
    
}

string GameIOS::getDeviceString() {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [deviceString UTF8String];
    
    //    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    //    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    //    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    //    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    //    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    //    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    //    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    //    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    //    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    //    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    //    return deviceString;
}

bool GameIOS::isRetina() {
    CCEAGLView* eagl_view = (CCEAGLView*)Director::getInstance()->getOpenGLView()->getEAGLView();
    return [eagl_view contentScaleFactor] == 2.0f ? true : false;
}

cocos2d::Rect GameIOS::getEGLViewRect() {
    CCEAGLView* eagl_view = (CCEAGLView*)Director::getInstance()->getOpenGLView()->getEAGLView();
    CGRect r = [eagl_view bounds];
    return cocos2d::Rect(r.origin.x, r.origin.y, r.size.width, r.size.height);
}

////判断是否是刘海屏
//BOOL isIPhoneNotchScreen(void)
//{
//    if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0) {
//        return NO;
//    }
//
//    /* iPhone8 Plus  UIEdgeInsets: {20, 0, 0, 0}
//     * iPhone8       UIEdgeInsets: {20, 0, 0, 0}
//     * iPhone XR     UIEdgeInsets: {44, 0, 34, 0}
//     * iPhone XS     UIEdgeInsets: {44, 0, 34, 0}
//     * iPhone XS Max UIEdgeInsets: {44, 0, 34, 0}
//     */
//    UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
//
//    CGFloat bottomSpace = 0;
//    switch (UIApplication.sharedApplication.statusBarOrientation) {
//        case UIInterfaceOrientationPortrait:{
//            bottomSpace = safeAreaInsets.bottom;
//        }break;
//        case UIInterfaceOrientationLandscapeLeft:{
//            bottomSpace = safeAreaInsets.right;
//        }break;
//        case UIInterfaceOrientationLandscapeRight:{
//            bottomSpace = safeAreaInsets.left;
//        } break;
//        case UIInterfaceOrientationPortraitUpsideDown:{
//            bottomSpace = safeAreaInsets.top;
//        }break;
//        default:
//            bottomSpace = safeAreaInsets.bottom;
//            break;
//    }
//    return bottomSpace > 0 ? YES : NO;
//}
//
//float getNavigationBarHeight(void)
//{
//    if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0) {
//        return 64.0f;
//    }
//    UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
//    float topSpace = 0;
//    switch (UIApplication.sharedApplication.statusBarOrientation) {
//        case UIInterfaceOrientationPortrait:{
//            topSpace = safeAreaInsets.top;
//        }break;
//        case UIInterfaceOrientationLandscapeLeft:{
//            topSpace = safeAreaInsets.left;
//        }break;
//        case UIInterfaceOrientationLandscapeRight:{
//            topSpace = safeAreaInsets.right;
//        } break;
//        case UIInterfaceOrientationPortraitUpsideDown:{
//            topSpace = safeAreaInsets.bottom;
//        }break;
//        default:
//            topSpace = safeAreaInsets.top;
//            break;
//    }
//    return topSpace + 44.0f;
//}

float GameIOS::getNotchHeight() {
//    log("getNotchHeight = %f",  getNavigationBarHeight());
    CSJson::Value json;
    json["device"] = getDeviceString();
    auto return_json = LuaManager::instance()->executeGlobalJsonFunctionReturn("getNotchHeight", json);
    if (return_json.isObject() && return_json.isMember("height")) {
        float height = atof(return_json["height"].asString().c_str());
        return height;
    }
    return 0;
//    auto str_device = getDeviceString();
//    if (str_device == "iPhone10,3" ||
//        str_device == "iPhone10,6" ||
//        str_device == "iPhone11,2" ||
//        str_device == "iPhone11,4" ||
//        str_device == "iPhone11,6" ||
//        str_device == "iPhone11,8") {
//        return 49;
//    }
//
//    return 0;
}

int GameIOS::getDeviceOrientation()
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 1;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return 2;
            break;
        case UIDeviceOrientationLandscapeLeft:
            return 3;
            break;
        case UIDeviceOrientationLandscapeRight:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

void GameIOS::setClipboard(string str)
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithUTF8String:str.c_str()]];
}

void GameIOS::addNotification(const char* msg, unsigned int time, const char* name) {
    if (msg == NULL) {
        return;
    }
    NSString* body = [NSString stringWithUTF8String:msg];
    
    // 创建一个本地推送
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    if (notification != nil) {
        NSDate *pushDate = [NSDate dateWithTimeIntervalSince1970:time];
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = 0; // kCFCalendarUnitDay
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = body;
        //显示在icon上的红色圈中的数子
        
        //设置userinfo 方便在之后需要撤销的时候使用
        if (name) {
            NSDictionary *info = [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:name] forKey:@"name"];
            notification.userInfo = info;
        }
        //添加推送到UIApplication
        
        UIApplication* app = [UIApplication sharedApplication];
        int num = (int)app.applicationIconBadgeNumber + 1;
        if (num < 1) {
            num = 1;
        }
        
        notification.applicationIconBadgeNumber = num;
        
        [app scheduleLocalNotification:notification];
    }
}

void GameIOS::removeNotification(const char* name) {
    if (!name) {
        return;
    }
    
    NSString* str_name = [NSString stringWithUTF8String:name];
    
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *arr = [app scheduledLocalNotifications];
    if (!arr) {
        return;
    }
    
    for (UILocalNotification* notification in arr) {
        NSDictionary* dict = notification.userInfo;
        if (dict) {
            NSString* value = [dict objectForKey:@"name"];
            if ([str_name isEqualToString:value]) {
                [app cancelLocalNotification:notification];
                break;
            }
        }
    }
}

string GameIOS::deviceUUID() {
    // TEST
//    return "asjdasj128371827313asdh";
//    return updateDeviceUUID();
    NSString* ret = [SSKeychain passwordForService:@"account" account:@"uuid"];
    if (ret == nil) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuid_str = CFUUIDCreateString(NULL, uuid);
        assert(uuid_str != NULL);
        ret = [NSString stringWithFormat:@"%@", uuid_str];
        ret = [ret lowercaseString];
        [SSKeychain setPassword:ret forService:@"account" account:@"uuid"];
    }
    return [ret UTF8String];
}

string GameIOS::updateDeviceUUID() {
    NSString* ret = nil;
    if (ret == nil) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuid_str = CFUUIDCreateString(NULL, uuid);
        assert(uuid_str != NULL);
        ret = [NSString stringWithFormat:@"%@", uuid_str];
        [SSKeychain setPassword:ret forService:@"account" account:@"uuid"];
    }
    return [ret UTF8String];
}

string GameIOS::getCurrentLanguageCodeFull()
{
    static char code[3]={0};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    // get the current language code.(such as English is "en", Chinese is "zh" and so on)
    NSDictionary* temp = [NSLocale componentsFromLocaleIdentifier:currentLanguage];
    NSString * languageCode = [temp objectForKey:NSLocaleLanguageCode];
    [languageCode getCString:code maxLength:3 encoding:NSASCIIStringEncoding];
    code[2]='\0';
    return code;
}


string GameIOS::getVersion() {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return [version UTF8String];
}

string GameIOS::getBundleId() {
    NSString *executable_file = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    return [executable_file UTF8String];
}

void GameIOS::openUrl(const char *url) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]];
}

bool GameIOS::updateApk(const char *apk_name, const char *diff_path) {
    return false;
}

int GameIOS::getNetworkState() {
//    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
//        return 1; // wifi
//    }
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
//        return 2; // 手机网络
//    }
    return 0;
}

void audioRecord() {
    NSDictionary* record_param = [[NSDictionary alloc] initWithObjectsAndKeys:
    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,     // 采样率
    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,  // 音频编码格式
    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,    // 采样位数默认16
    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,      // 通道数目
    [NSNumber numberWithInt:AVAudioQualityMedium], AVEncoderAudioQualityKey,    // 音频编码质量
    nil];
    
    NSArray* path_arr = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* path_doc = [path_arr objectAtIndex:0];
    NSURL* path_url = [NSURL URLWithString:[path_doc stringByAppendingString:@"/battle_talk.wav"]];
    AVAudioRecorder* audio_recorder = [[AVAudioRecorder alloc] initWithURL:path_url settings:record_param error:nil];
    
    [audio_recorder record];
}

void audioPlay() {
    NSArray* path_arr = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* path_doc = [path_arr objectAtIndex:0];
    NSURL* path_file = [NSURL URLWithString:[path_doc stringByAppendingString:@"battle_talk.wav"]];
    AVAudioPlayer* audio_player = [[AVAudioPlayer alloc] initWithContentsOfURL:path_file error:nil];
    
    [audio_player play];
}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */
