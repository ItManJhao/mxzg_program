/*
 * GameAndroid.cpp
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "GameAndroid.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include <android/log.h>
#include "../../../Classes/Data/Player.h"
#include "../../../Classes/Model/Utils.h"
#include "../../../Classes/Net/PlatformApi.h"
#include "../../../Classes/Comp/UIMessageBox.h"
#include "../../../Classes/Common/CommonDefine.h"
#include "../../../Classes/Model/Game.h"

static const std::string helperClassName = "org/cocos2dx/lib/Cocos2dxHelper";
string GameAndroid::main_class_name_for_jni = "";

string GameAndroid::getMainClassNameForJNI() {
	if (main_class_name_for_jni.compare("") != 0) {
		return main_class_name_for_jni;
	}

	CCLOG("jni: getMainClassNameForJNI start.");

	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, "common/GameSystem",
			"getMainClassNameForJNI", "()Ljava/lang/String;");
	if (isHave) {
		//调用此函数
		jstring js = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID,
				minfo.methodID);
		const char* str = minfo.env->GetStringUTFChars(js, 0);
		main_class_name_for_jni = str;
		minfo.env->ReleaseStringUTFChars(js, str);
		minfo.env->DeleteLocalRef( js);
		CCLOG("%s", main_class_name_for_jni.c_str());

	} else {
		CCLOG("common game system main class null !!!");
	}
	return main_class_name_for_jni;
}

GameImpl* createGameImpl() {
	return new GameAndroid();
}

GameAndroid::GameAndroid() {
	s_uuid = "";
}

GameAndroid::~GameAndroid() {
}

string GameAndroid::getDeviceString() {
	return "android";
}

bool GameAndroid::isRetina() {
	Size size = Director::getInstance()->getOpenGLView()->getFrameSize();
	return size.height >= 1080;
}

Rect GameAndroid::getEGLViewRect() {
	Rect rect = Rect::ZERO;
	rect.size = Director::getInstance()->getOpenGLView()->getFrameSize();
	return rect;
}

float GameAndroid::getNotchHeight() {
    CCLOG("jni: getNotchHeight");
    float height = 0;
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 GameAndroid::getMainClassNameForJNI().c_str(), "getNotchHeight",
                                                 "()I");

    CCLOG("jni: %s", GameAndroid::getMainClassNameForJNI().c_str());
    if (!isHave) {
        CCLOG("jni: getNotchHeight did not exist.");
    } else {
        //调用此函数
    	height = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID);
    }
    return height;
}

int GameAndroid::getDeviceOrientation() {
    int orientation = -1;
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 GameAndroid::getMainClassNameForJNI().c_str(), "getDeviceOrientation",
                                                 "()I");
    if (!isHave) {
        CCLOG("jni: getFreeDiskSpace did not exist.");
    } else {
        //调用此函数
    	orientation = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID);
    }
    return orientation;
}

void GameAndroid::addNotification(const char* msg, unsigned int time,
		const char* name) {

}

void GameAndroid::removeNotification(const char* name) {

}


string GameAndroid::deviceUUID() {
	CCLOG("jni: getDeviceUUID start.");
	JniMethodInfo minfo; //定义Jni函数信息结构体
	//getStaticMethodInfo 次函数返回一个bool值表示是否找到此函数
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "getDeviceUUID",
			"()Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: Method did not exist.");
		return "";
	} else {
		//调用此函数
		jstring js = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID,
				minfo.methodID);
		const char* str = minfo.env->GetStringUTFChars(js, 0);
		s_uuid = str;
		minfo.env->ReleaseStringUTFChars(js, str);
		minfo.env->DeleteLocalRef(js);
		CCLOG("deviceUUID: %s", s_uuid.c_str());
		return s_uuid.c_str();
	}

	/*
	 * c++方法生成
	 * if (s_uuid.compare("") != 0) {
	 return s_uuid.c_str();
	 }
	 uuid_t uu;
	 uuid_generate(uu);
	 char tmp[37] = {0};
	 sprintf(tmp, "%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X", uu[0], uu[1], uu[2], uu[3], uu[4], uu[5], uu[6], uu[7], uu[8], uu[9], uu[10], uu[11], uu[12], uu[13], uu[14], uu[15]);
	 CCLOG("%s", tmp);
	 s_uuid = tmp;
	 return s_uuid.c_str();*/
}

string GameAndroid::updateDeviceUUID() {
	CCLOG("jni: updateDeviceUUID start.");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "updateDeviceUUID",
			"()Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: updateDeviceUUID did not exist.");
		return "";
	} else {
		//调用此函数
		jstring js = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID,
				minfo.methodID);
		jboolean b = true;
		s_uuid = minfo.env->GetStringUTFChars(js, &b);
				
		const char* str_param1 = minfo.env->GetStringUTFChars(js, 0);

		minfo.env->ReleaseStringUTFChars(js, str_param1);;
		minfo.env->DeleteLocalRef(js);
		CCLOG("deviceUUID: %s", s_uuid.c_str());
		return s_uuid.c_str();
	}
}

string GameAndroid::getCurrentLanguageCodeFull() {
    std::string language = JniHelper::callStaticStringMethod(helperClassName, "getCurrentLanguage");
    return language.c_str();
}




string GameAndroid::getVersion() {
	CCLOG("jni: getVersion start.");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "getVersion",
			"()Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: updateDeviceUUID did not exist.");
		return "";
	} else {
		//调用此函数
		jstring js = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID,
				minfo.methodID);
		const char* str = minfo.env->GetStringUTFChars(js, 0);
		string version_id = str;
		minfo.env->ReleaseStringUTFChars(js, str);
		minfo.env->DeleteLocalRef(js);
		CCLOG("program version: %s", version_id.c_str());
		return version_id;
	}
}

string GameAndroid::getBundleId() {
	return "";
}


void GameAndroid::setClipboard(string str) {
    CCLOG("jni: setClipboard start.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 GameAndroid::getMainClassNameForJNI().c_str(), "setClipboard",
                                                 "(Ljava/lang/String;)V");
    if (!isHave) {
        CCLOG("jni: setClipboard did not exist.");
    } else {
        //调用此函数
        jstring tmp = minfo.env->NewStringUTF(str.c_str());
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, tmp);

        const char* str_param1 = minfo.env->GetStringUTFChars(tmp, 0);
        minfo.env->ReleaseStringUTFChars(tmp, str_param1);
        minfo.env->DeleteLocalRef(tmp);
    }
}


void GameAndroid::openUrl(const char* url) {
	CCLOG("jni: openUrl start.");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "openUrl",
			"(Ljava/lang/String;)V");
	if (!isHave) {
		CCLOG("jni: openUrl did not exist.");
	} else {
		//调用此函数
		jstring tmp = minfo.env->NewStringUTF(url);
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, tmp);
		minfo.env->DeleteLocalRef(tmp);
	}
}

int GameAndroid::getNetworkState() {
	//CCLOG("jni: getNetworkState start.");
	//JniHelper::attachCurrentThread();

	int state = 0;
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, "common/GameSystem",
			"getNetworkState", "()I");
	if (!isHave) {
		//CCLOG("download jni: getNetworkState did not exist.");
	} else {
		//CCLOG("download jni: getNetworkState exist.");
		state = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID);
	}

	// 执行这一句会崩溃.原因不明
	//JniHelper::detachCurrentThread();

	return state;
}

long long GameAndroid::getFreeDiskSpace()
{
    double disk_space = -1;
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 GameAndroid::getMainClassNameForJNI().c_str(), "getFreeDiskSpace",
                                                 "()D");
    if (!isHave) {
        CCLOG("jni: getFreeDiskSpace did not exist.");
    } else {
        //调用此函数
    	disk_space = minfo.env->CallStaticDoubleMethod(minfo.classID, minfo.methodID);
    }
    return disk_space;
}

void GameAndroid::exitTheGame() {
	CCLOG("jni: exitTheGame start.");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "exitTheGame",
			"()V");
	if (!isHave) {
		CCLOG("jni: exitTheGame did not exist.");
	} else {
		//调用此函数
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
	}
}

string GameAndroid::getExternalStorageDirectory() {
	CCLOG("jni: getExternalStorageDirectory start.");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(),
			"getExternalStorageDirectory", "()Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: openUrl did not exist.");
		return "";
	} else {
		//调用此函数
		jstring js = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID,
				minfo.methodID);
		const char* str = minfo.env->GetStringUTFChars(js, 0);
		string path = str;
		minfo.env->ReleaseStringUTFChars(js, str);
		minfo.env->DeleteLocalRef(js);
		CCLOG("get external storage path : %s", path.c_str());
		return path;
	}
}

bool GameAndroid::updateApk(const char* apk_name, const char* diff_path) {
	CCLOG("jni: updateApk start.");
	JniMethodInfo minfo;
	int is_success = 0;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "updateApk",
			"(Ljava/lang/String;Ljava/lang/String;)I");
	if (!isHave) {
		CCLOG("jni: openUrl did not exist.");
	} else {
		//调用此函数
		jstring apk_name_str = minfo.env->NewStringUTF(apk_name);
		jstring diff_path_str = minfo.env->NewStringUTF(diff_path);
		is_success = minfo.env->CallStaticIntMethod(minfo.classID,
				minfo.methodID, apk_name_str, diff_path_str);
		minfo.env->DeleteLocalRef(apk_name_str);
		minfo.env->DeleteLocalRef(diff_path_str);
	}
	return is_success != 0 ? true : false;
}

void GameAndroid::deleteFileWithPath(const char* file_path) {
	CCLOG("jni: deleteFileWithPath start.");
	JniMethodInfo minfo;
	int is_success = 0;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(), "deleteFileWithPath",
			"(Ljava/lang/String;)V");
	if (!isHave) {
		CCLOG("jni: openUrl did not exist.");
	} else {
		//调用此函数
		jstring file_path_str = minfo.env->NewStringUTF(file_path);
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID,
				file_path_str);
		minfo.env->DeleteLocalRef(file_path_str);
	}
}

void GameAndroid::deleteFileInStorageDirectory(const char* file_name) {
	CCLOG("jni: deleteFileInStorageDirectory start.");
	JniMethodInfo minfo;
	int is_success = 0;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			GameAndroid::getMainClassNameForJNI().c_str(),
			"deleteFileInStorageDirectory", "(Ljava/lang/String;)V");
	if (!isHave) {
		CCLOG("jni: openUrl did not exist.");
	} else {
		//调用此函数
		jstring file_name_str = minfo.env->NewStringUTF(file_name);
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID,
				file_name_str);
		minfo.env->DeleteLocalRef(file_name_str);
	}
}


void Java_common_GameSystem_exitGame(JNIEnv* env, jobject jobj) {
	// 有外挂，退出游戏
//	Game::instance()->showExitTheGame();
}


extern "C"
{

void Java_common_GameSystem_orientationChange(JNIEnv *env, jobject thiz, jint orient) {

    if (!cocos2d::Director::getInstance()->getRunningScene()) {
        return;
    }

    int32_t orientation = orient;
    auto eventDispatcher = cocos2d::Director::getInstance()->getEventDispatcher();

    // 游戏运行还在黑屏阶段会崩溃
    if (eventDispatcher)
    {
            CCLOG("orientationChange");
            cocos2d::EventCustom event(DEVICE_ORIENTATION_CHANGE);
            event.setUserData(&orientation);
            eventDispatcher->dispatchEvent(&event);
    }
}
    
void Java_common_GameSystem_xingeCallback(JNIEnv *env, jobject thiz, jstring token) {
    
    if (!cocos2d::Director::getInstance()->getRunningScene()) {
        return;
    }
    
    
    const char* str = env->GetStringUTFChars(token, 0);
    std::string str_token = str;
    CCLOG("xingeCallback %s", str_token.c_str());
//    OkGamePlatform::instance()->loginCallback(success, str_token);
    env->ReleaseStringUTFChars(token, str);
    
    Game::instance()->updateXingeToken(str_token);
}


}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */
