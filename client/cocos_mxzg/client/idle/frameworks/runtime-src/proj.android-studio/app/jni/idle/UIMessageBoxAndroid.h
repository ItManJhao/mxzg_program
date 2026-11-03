/*
 * UIMessageBoxAndroid.h
 *
 *  Created on: 2016-12-16
 *      Author: conix
 */

#ifndef UIMESSAGEBOXANDROID_H_
#define UIMESSAGEBOXANDROID_H_

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "../../../Classes/Comp/UIMessageBoxImpl.h"

class UIMessageBoxAndroid : public UIMessageBoxImpl {
public:
	UIMessageBoxAndroid();
	virtual ~UIMessageBoxAndroid();
    
    virtual void show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1);
    virtual void callback(int button_index);
};

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) */

#endif /* UIMESSAGEBOXANDROID_H_ */
