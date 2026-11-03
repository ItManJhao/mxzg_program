//
//  UIMessageBoxIOS.h
//  conix
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __conix__UIMessageBoxIOS__
#define __conix__UIMessageBoxIOS__

#if (CC_TARGET_OS_MAC)

#import <Foundation/Foundation.h>
#include "UIMessageBoxImpl.h"


#pragma mark -
class UIMessageBoxMAC : public UIMessageBoxImpl {
public:
    UIMessageBoxMAC();
    virtual ~UIMessageBoxMAC();
    
    virtual void show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1);
    virtual void callback(int button_index);
};

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */

#endif /* defined(__conix__UIMessageBoxIOS__) */
