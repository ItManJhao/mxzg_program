/*
 * GameAndroid.cpp
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "OkGamePlatformAndroid.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include <android/log.h>
#include "../../../Classes/Data/Player.h"
#include "../../../Classes/Model/Utils.h"
#include "../../../Classes/Net/PlatformApi.h"
#include "../../../Classes/Comp/UIMessageBox.h"
#include "../../../Classes/Common/CommonDefine.h"

#include "../../../Classes/Model/Game.h"
#include "../../../Classes/Platform/OkGamePlatform.h"
#include "../../../Classes/Platform/SocialPlatform.h"


string OkGamePlatformAndroid::main_class_name_for_jni = "";

const string& OkGamePlatformAndroid::getMainClassNameForJNI() {
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
        
        CCLOG("%s", main_class_name_for_jni.c_str());
        
    } else {
        CCLOG("common game system main class null !!!");
    }
    return main_class_name_for_jni;
}


PlatformImpl* createPlatformImpl() {
    return new OkGamePlatformAndroid();
}


void OkGamePlatformAndroid::init() {
    this->initPlatform(true);
}

void OkGamePlatformAndroid::initPlatform(int flag) {
    CCLOG("jni: initPlatform.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "initPlatform",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: initPlatform did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


void OkGamePlatformAndroid::logout() {
    CCLOG("jni: logout.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "logout",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: initPlatform did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}

string OkGamePlatformAndroid::getPf() {
    CCLOG("jni: getPf start.");

	string str_pf;

	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			                                     OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
			                                     "getFuseAgent",
			                                     "(Ljava/lang/String;)Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: getPf did not exist.");
	} else {
		jstring param1 = minfo.env->NewStringUTF("pf_id");
		jstring pf_str = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, param1);

		const char* str = minfo.env->GetStringUTFChars(pf_str, 0);
		str_pf = str;
		
		const char* str_param1 = minfo.env->GetStringUTFChars(param1, 0);

		minfo.env->ReleaseStringUTFChars(param1, str_param1);
		minfo.env->ReleaseStringUTFChars(pf_str, str);
		minfo.env->DeleteLocalRef(param1);
		minfo.env->DeleteLocalRef(pf_str);
	}

	return str_pf;
}

string OkGamePlatformAndroid::getChannelId() {
	CCLOG("jni: getChannelId start.");

	string str_channel;
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			                                     OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
			                                     "getFuseAgent",
			                                     "(Ljava/lang/String;)Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: getChannelId did not exist.");
	} else {
		jstring param1 = minfo.env->NewStringUTF("channel_id");
		jstring channel_str = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, param1);

		const char* str = minfo.env->GetStringUTFChars(channel_str, 0);
		str_channel = str;

		const char* str_param1 = minfo.env->GetStringUTFChars(param1, 0);

		minfo.env->ReleaseStringUTFChars(param1, str_param1);
		minfo.env->ReleaseStringUTFChars(channel_str, str);
		minfo.env->DeleteLocalRef(param1);
		minfo.env->DeleteLocalRef(channel_str);
	}

	return str_channel;
}


void OkGamePlatformAndroid::submitRoleInfo(const string& type) {
    CCLOG("jni: submitRoleInfo start.");
    
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
                                                 "submitRoleInfo",
                                                 "(Ljava/lang/String;)V");
    if (!isHave) {
        CCLOG("jni: submitRoleInfo did not exist.");
    } else {
        jstring param1 = minfo.env->NewStringUTF(type.c_str());
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, param1);
        
        minfo.env->DeleteLocalRef(param1);
    }
}

void OkGamePlatformAndroid::updateExtraData(const string& guide_num,
                                 const string& role_id,
                                 const string& role_create_time,
                                 const string& role_name,
                                 const string& role_level,
                                 const string& server_id,
                                 const string& server_name,
                                 const string& balance,
                                 const string& vip_level,
                                 const string& gem_num,
                                 const string& attack_num,
                                 const string& extra_info,
                                 const string& clan_name) {
    CCLOG("jni: updateExtraData start.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
                                                 "updateExtraData",
                                                 "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isHave) {
        CCLOG("jni: updateExtraData did not exist.");
    } else {
        jstring param1  = minfo.env->NewStringUTF(guide_num.c_str());
        jstring param2  = minfo.env->NewStringUTF(role_id.c_str());
        jstring param3  = minfo.env->NewStringUTF(role_create_time.c_str());
        jstring param4  = minfo.env->NewStringUTF(role_name.c_str());
        jstring param5  = minfo.env->NewStringUTF(role_level.c_str());
        jstring param6  = minfo.env->NewStringUTF(server_id.c_str());
        jstring param7  = minfo.env->NewStringUTF(server_name.c_str());
        jstring param8  = minfo.env->NewStringUTF(balance.c_str());
        jstring param9  = minfo.env->NewStringUTF(vip_level.c_str());
        jstring param10 = minfo.env->NewStringUTF(gem_num.c_str());
        jstring param11 = minfo.env->NewStringUTF(attack_num.c_str());
        jstring param12 = minfo.env->NewStringUTF(extra_info.c_str());
        jstring param13 = minfo.env->NewStringUTF(clan_name.c_str());
        
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        param1,
                                        param2,
                                        param3,
                                        param4,
                                        param5,
                                        param6,
                                        param7,
                                        param8,
                                        param9,
                                        param10,
                                        param11,
                                        param12,
                                        param13);
        
        minfo.env->DeleteLocalRef(param1);
        minfo.env->DeleteLocalRef(param2);
        minfo.env->DeleteLocalRef(param3);
        minfo.env->DeleteLocalRef(param4);
        minfo.env->DeleteLocalRef(param5);
        minfo.env->DeleteLocalRef(param6);
        minfo.env->DeleteLocalRef(param7);
        minfo.env->DeleteLocalRef(param8);
        minfo.env->DeleteLocalRef(param9);
        minfo.env->DeleteLocalRef(param10);
        minfo.env->DeleteLocalRef(param11);
        minfo.env->DeleteLocalRef(param12);
        minfo.env->DeleteLocalRef(param13);
    }
}

void OkGamePlatformAndroid::pay(const string& productId, const string& billNo, const string& extraInfo) {
	CCLOG("jni: pay start.");
	JniMethodInfo minfo;
	int is_success = 0;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			                                     OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
			                                     "pay",
			                                     "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	if (!isHave) {
		CCLOG("jni: pay did not exist.");
	} else {
		//调用此函数
		jstring product_str = minfo.env->NewStringUTF(productId.c_str());
        jstring bill_str = minfo.env->NewStringUTF(billNo.c_str());
        jstring extra_str = minfo.env->NewStringUTF(extraInfo.c_str());

		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, product_str, bill_str, extra_str);
        
		minfo.env->DeleteLocalRef(product_str);
        minfo.env->DeleteLocalRef(bill_str);
        minfo.env->DeleteLocalRef(extra_str);
	}
}

string OkGamePlatformAndroid::getAgent()
{
	CCLOG("jni: getAgent start.");

	string str_agent;

	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo,
			                                     OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
			                                     "getFuseAgent",
			                                     "(Ljava/lang/String;)Ljava/lang/String;");
	if (!isHave) {
		CCLOG("jni: getPf did not exist.");
	} else {
		jstring param1 = minfo.env->NewStringUTF("okAgent");
		jstring agent_str = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, param1);

		const char* str = minfo.env->GetStringUTFChars(agent_str, 0);
		str_agent = str;
		
		const char* str_param1 = minfo.env->GetStringUTFChars(param1, 0);

		minfo.env->ReleaseStringUTFChars(param1, str_param1);
		minfo.env->ReleaseStringUTFChars(agent_str, str);
		minfo.env->DeleteLocalRef(param1);
		minfo.env->DeleteLocalRef(agent_str);
	}

	return str_agent;
}

void OkGamePlatformAndroid::showUserCenter() {
    CCLOG("jni: showUserCenter.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "showUserCenter",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: showUserCenter did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


void OkGamePlatformAndroid::showCustomerService() {
    CCLOG("jni: showCustomerService.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "showCustomerService",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: showCustomerService did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


void OkGamePlatformAndroid::shareLink() {
    CCLOG("jni: shareLink.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "shareLink",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: shareLink did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


void OkGamePlatformAndroid::dz() {
    CCLOG("jni: dz.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "dz",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: dz did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


void OkGamePlatformAndroid::zhuXiao() {
    CCLOG("jni: zhuXiao.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "zhuXiao",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: zhuXiao did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}

void OkGamePlatformAndroid::discuss() {
    CCLOG("jni: discuss.");
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(), "discuss",
                                                 "()V");
    if (!isHave) {
        CCLOG("jni: discuss did not exist.");
    } else {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


string OkGamePlatformAndroid::getPlatformId() {
    CCLOG("jni: getPlatformId start.");

    string str_pf;

    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,
                                                 OkGamePlatformAndroid::getMainClassNameForJNI().c_str(),
                                                 "getFuseAgent",
                                                 "(Ljava/lang/String;)Ljava/lang/String;");
    if (!isHave) {
        CCLOG("jni: getPlatformId did not exist.");
    } else {
        jstring param1 = minfo.env->NewStringUTF("soc_platform_id");
        jstring pf_str = (jstring) minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, param1);

        const char* str = minfo.env->GetStringUTFChars(pf_str, 0);
        str_pf = str;
        
        const char* str_param1 = minfo.env->GetStringUTFChars(param1, 0);

        minfo.env->ReleaseStringUTFChars(param1, str_param1);
        minfo.env->ReleaseStringUTFChars(pf_str, str);
        minfo.env->DeleteLocalRef(param1);
        minfo.env->DeleteLocalRef(pf_str);
    }

    return str_pf;
}

// JAVA回调
extern "C"
{
    void Java_common_GameSystem_loginCallback(JNIEnv *env, jobject thiz, jint success, jstring user_code, jstring user_token, jstring user_name, jstring game_id) {
		CCLOG("Java_common_GameSystem_loginCallback");

        const char* str_user_code = env->GetStringUTFChars(user_code, 0);
        std::string cxx_user_code = str_user_code;

        const char* str_user_token = env->GetStringUTFChars(user_token, 0);
        std::string cxx_user_token = str_user_token;

        const char* str_user_name = env->GetStringUTFChars(user_name, 0);
        std::string cxx_user_name = str_user_name;

        const char* str_game_id = env->GetStringUTFChars(game_id, 0);
        std::string cxx_game_id = str_game_id;

        OkGamePlatform::instance()->loginCallback(success, cxx_user_code, cxx_user_token, cxx_user_name, cxx_game_id);

		env->ReleaseStringUTFChars(user_code, str_user_code);
		env->ReleaseStringUTFChars(user_token, str_user_token);
		env->ReleaseStringUTFChars(user_name, str_user_name);
		env->ReleaseStringUTFChars(game_id, str_game_id);

		CCLOG("Java_common_GameSystem_loginCallback");
    }
    
    void Java_common_GameSystem_payCallback(JNIEnv *env, jobject thiz, jint success, jstring billNo, jstring error_msg) {
    	CCLOG("Java_common_GameSystem_payCallback");
    	
        const char* str_order_id = env->GetStringUTFChars(billNo, 0);
        std::string str_bill = str_order_id;

        const char* str_error_msg = env->GetStringUTFChars(error_msg, 0);
        std::string str_error = str_error_msg;
        
        OkGamePlatform::instance()->payCallback(success, str_bill, str_error);

		env->ReleaseStringUTFChars(billNo,  str_order_id);

		env->ReleaseStringUTFChars(error_msg, str_error_msg);

		CCLOG("Java_common_GameSystem_payCallback");
    }

    void Java_common_GameSystem_realName(JNIEnv *env, jobject thiz, jint success, jstring user_id, jint adult) {
        CCLOG("Java_common_GameSystem_realName");

        const char* str_user_id = env->GetStringUTFChars(user_id, 0);
        std::string str_id = str_user_id;

        OkGamePlatform::instance()->realName(success, str_id, adult);

    	env->ReleaseStringUTFChars(user_id,  str_user_id);

    	CCLOG("Java_common_GameSystem_realName");
    }

    void Java_common_GameSystem_shareLinkCallback(JNIEnv *env, jobject thiz, jint success, jstring msg) {
        CCLOG("Java_common_GameSystem_shareLinkCallback");

        const char* str_msg = env->GetStringUTFChars(msg, 0);
        std::string str_id = str_msg;

        SocialPlatform::instance()->shareLinkCallback(success == 1, str_id);

    	env->ReleaseStringUTFChars(msg,  str_msg);

    	CCLOG("Java_common_GameSystem_shareLinkCallback");
    }

    void Java_common_GameSystem_dzCallback(JNIEnv *env, jobject thiz, jint success, jstring msg) {
        CCLOG("Java_common_GameSystem_dzCallback");

        const char* str_msg = env->GetStringUTFChars(msg, 0);
        std::string str_id = str_msg;

        SocialPlatform::instance()->dzCallback(success == 1, str_id);

    	env->ReleaseStringUTFChars(msg,  str_msg);

    	CCLOG("Java_common_GameSystem_dzCallback");
    }

    void Java_common_GameSystem_giftBagCallback(JNIEnv *env, jobject thiz, jint success, jstring msg) {
        CCLOG("Java_common_GameSystem_giftBagCallback");

        const char* str_msg = env->GetStringUTFChars(msg, 0);
        std::string str_id = str_msg;

        SocialPlatform::instance()->giftBagCallback(success == 1, str_id);

    	env->ReleaseStringUTFChars(msg,  str_msg);

    	CCLOG("Java_common_GameSystem_giftBagCallback");
    }

    void Java_common_GameSystem_showAdCallback(JNIEnv *env, jobject thiz, jstring type) {
        CCLOG("Java_common_GameSystem_showAdCallback");

        const char* str_type = env->GetStringUTFChars(type, 0);
        std::string str_id = str_type;

        SocialPlatform::instance()->showAdCallback(str_id);

    	env->ReleaseStringUTFChars(type,  str_type);

    	CCLOG("Java_common_GameSystem_showAdCallback");
    }
}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */
