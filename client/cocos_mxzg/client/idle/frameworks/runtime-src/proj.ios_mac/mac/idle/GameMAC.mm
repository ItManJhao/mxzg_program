
//
//  Game.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "GameMAC.h"

#if (CC_TARGET_OS_MAC)

#import "sys/utsname.h" // 获取设备字符串用的
#import "platform/ios/CCEAGLView-ios.h"
#import "SSKeychain.h" // IOS保存UUID用的
//#import "Reachability.h"

#include "../../../Classes/Model/Game.h"

GameImpl* createGameImpl() {
    return new GameMAC();
}

GameMAC::GameMAC() {
    
}

GameMAC::~GameMAC() {
    
}

string GameMAC::getDeviceString() {
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

bool GameMAC::isRetina() {
    return true;
}

cocos2d::Rect GameMAC::getEGLViewRect() {
    return Director::getInstance()->getOpenGLView()->getViewPortRect(); 
}

void GameMAC::addNotification(const char* msg, unsigned int time, const char* name) {
    
}

void GameMAC::removeNotification(const char* name) {
    
}

string GameMAC::deviceUUID() {
//    return updateDeviceUUID();
    string device_uuid = UserDefault::getInstance()->getStringForKey("MAC_DEVICE_UUID", "");
    if (device_uuid == "") {
        device_uuid = StringUtils::format("%lld", Game::makeId());
        UserDefault::getInstance()->setStringForKey("MAC_DEVICE_UUID", device_uuid);
    }
    return device_uuid;
}

string GameMAC::updateDeviceUUID() {
    string device_uuid = StringUtils::format("%lld", Game::makeId());
    UserDefault::getInstance()->setStringForKey("MAC_DEVICE_UUID", device_uuid);
    return device_uuid;
}

string GameMAC::getCurrentLanguageCodeFull()
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

string GameMAC::getVersion() {
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//    return [version UTF8String];
    return "";
}

string GameMAC::getBundleId() {
//    NSString *executable_file = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
//    return [executable_file UTF8String];
    return "";
}

void GameMAC::openUrl(const char *url) {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]];
}

bool GameMAC::updateApk(const char *apk_name, const char *diff_path) {
    return false;
}

int GameMAC::getNetworkState() {
//    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
//        return 1; // wifi
//    }
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
//        return 2; // 手机网络
//    }
    return 0;
}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */
