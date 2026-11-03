//
//  GameMAC.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__GameMAC__
#define __AVT__GameMAC__

#if (CC_TARGET_OS_MAC)

#include "GameImpl.h"

class GameMAC : public GameImpl {
public:
    GameMAC();
    virtual ~GameMAC();
    
    virtual string getDeviceString();
    virtual bool isRetina();
    virtual cocos2d::Rect getEGLViewRect();
    
    virtual void addNotification(const char* msg, unsigned int time, const char* name);
    virtual void removeNotification(const char* name);
    
    virtual string deviceUUID();
    virtual string updateDeviceUUID();
    virtual string getCurrentLanguageCodeFull();

    virtual string getVersion();
    virtual string getBundleId();
    
    virtual void openUrl(const char* url);
    
    virtual int getNetworkState();
    
    virtual string getExternalStorageDirectory(){return FileUtils::getInstance()->getWritablePath();};
    virtual bool updateApk(const char* apk_name, const char* diff_path);
    virtual void deleteFileWithPath(const char* file_path){};
    virtual void deleteFileInStorageDirectory(const char* file_name){};
};

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */

#endif /* defined(__AVT__GameMAC__) */
