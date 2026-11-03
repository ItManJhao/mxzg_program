/*
 * GameAndroid.h
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#ifndef GAMEANDROID_H_
#define GAMEANDROID_H_

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "../../../Classes/Model/GameImpl.h"

class GameAndroid: public GameImpl {
public:
	static string getMainClassNameForJNI();

	GameAndroid();
	virtual ~GameAndroid();
    
    virtual string getDeviceString();
    virtual bool isRetina();
    virtual Rect getEGLViewRect();
    virtual float getNotchHeight();
    virtual int getDeviceOrientation();
    
    virtual void addNotification(const char* msg, unsigned int time, const char* name);
    virtual void removeNotification(const char* name);
    
    virtual string deviceUUID();
    virtual string updateDeviceUUID();
    virtual string getCurrentLanguageCodeFull();

    virtual string getVersion();
    virtual string getBundleId();
    virtual void setClipboard(string str);

    virtual void openUrl(const char* url);

    // 0:无网络 1:wifi 2:手机网络
    virtual int getNetworkState();
    virtual long long getFreeDiskSpace();

    virtual void exitTheGame();

    virtual string getExternalStorageDirectory();
    virtual bool updateApk(const char* apk_name, const char* diff_path);
//    virtual int isQQInstalled();
//    virtual int isWXInstalled();
    virtual void deleteFileWithPath(const char* file_path);
    virtual void deleteFileInStorageDirectory(const char* file_name);

private:
    string s_uuid;
	static string main_class_name_for_jni;
};

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */

#endif /* GAMEANDROID_H_ */
