//
//  UIMessageBoxIOS.h
//  conix
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __conix__UIMessageBoxIOS__
#define __conix__UIMessageBoxIOS__

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#import <Foundation/Foundation.h>
#include "UIMessageBoxImpl.h"

class UIMessageBoxIOS;
@interface UIMessageBoxIOSDelegate : NSObject <UIAlertViewDelegate>
{
    
}


@property(nonatomic, assign) UIMessageBoxIOS* messageBox;

@end

#pragma mark -

class UIMessageBoxIOS : public UIMessageBoxImpl {
public:
    UIMessageBoxIOS();
    virtual ~UIMessageBoxIOS();
    
    virtual void show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1);
    virtual void callback(int button_index);
};

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */

#endif /* defined(__conix__UIMessageBoxIOS__) */
