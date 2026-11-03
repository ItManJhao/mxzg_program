/*
 * UIMessageBoxAndroid.cpp
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "UIMessageBoxAndroid.h"
#include "../../../Classes/Comp/UIMessageBox.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include "GameAndroid.h"


UIMessageBoxAndroid* box_instance = NULL;


UIMessageBoxImpl* createUIMessageBoxImpl() {
	box_instance = new UIMessageBoxAndroid();
	return box_instance;
}

UIMessageBoxAndroid::UIMessageBoxAndroid() {
}

UIMessageBoxAndroid::~UIMessageBoxAndroid() {
}

void UIMessageBoxAndroid::show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1) {
	this->message_box = message_box;

	JniMethodInfo minfo; //定义Jni函数信息结构体
	//getStaticMethodInfo 次函数返回一个bool值表示是否找到此函数
	bool isHave = JniHelper::getStaticMethodInfo(minfo, GameAndroid::getMainClassNameForJNI().c_str(), "messageBox", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	if (!isHave) {
		CCLOG("jni: Method did not exist.");
	} else {
		jstring t = minfo.env->NewStringUTF(title);
		jstring c = minfo.env->NewStringUTF(content);
		jstring b0 = minfo.env->NewStringUTF(button_str0);
		jstring b1 = minfo.env->NewStringUTF(button_str1);
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, "", t, c, b0, b1);

		minfo.env->DeleteLocalRef(t);
		minfo.env->DeleteLocalRef(c);
		minfo.env->DeleteLocalRef(b0);
		minfo.env->DeleteLocalRef(b1);
	}
}

void UIMessageBoxAndroid::callback(int button_index) {
    UIMessageBox* mb = static_cast<UIMessageBox*>(message_box);
    if (mb) {
        mb->callback(button_index);
    }
}

extern "C" {

/* 命名规则：Java_Java的包名_类名*/
void Java_common_GameSystem_dialogCallBack(JNIEnv* env, jobject jobj, jint msg_box, jint button_index) {
		CCLOG("Java_common_GameSystem_dialogCallBack");
		box_instance->callback(button_index);
	}

}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */
