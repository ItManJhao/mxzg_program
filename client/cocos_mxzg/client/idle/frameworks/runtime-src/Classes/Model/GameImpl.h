//
//  GameImpl.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__GameImpl__
#define __ClickerHeroes__GameImpl__

#include "../Common/CommonDefine.h"

class GameImpl {
public:
    GameImpl() {};
    virtual ~GameImpl() {};
    
    virtual string getDeviceString() = 0;
    virtual bool isRetina() = 0;
    virtual cocos2d::Rect getEGLViewRect() = 0;
    virtual float getNotchHeight() {return 0;};
    virtual int getDeviceOrientation() {return 0;};

    virtual void addNotification(const char* msg, unsigned int time, const char* name) = 0;
    virtual void removeNotification(const char* name) = 0;
    
    virtual string deviceUUID() = 0;
    virtual string updateDeviceUUID() = 0;
    virtual string getCurrentLanguageCodeFull() = 0;
    
    virtual string getVersion() = 0;
    virtual string getBundleId() = 0;

    virtual void setClipboard(string str) {};

    virtual void openUrl(const char* url) = 0;
    

    // 0:无网络 1:wifi 2:手机网络
    virtual int getNetworkState() = 0;
    
    virtual string getExternalStorageDirectory() = 0;
    virtual bool updateApk(const char* apk_name, const char* diff_path) = 0;
    virtual void deleteFileWithPath(const char* file_path) = 0;
    virtual void deleteFileInStorageDirectory(const char* file_name) = 0;

    virtual int isQQInstalled() {return 1;}
    virtual int isWXInstalled() {return 1;}
    virtual void exitTheGame() {}
    
};

extern GameImpl* createGameImpl();

#endif /* defined(__ClickerHeroes__GameImpl__) */
