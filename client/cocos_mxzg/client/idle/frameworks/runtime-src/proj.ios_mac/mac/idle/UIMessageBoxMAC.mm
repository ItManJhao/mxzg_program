//
//  UIMessageBoxIOS.mm
//  conix
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMessageBoxMAC.h"

#if (CC_TARGET_OS_MAC)

#include "UIMessageBox.h"
#import <Cocoa/Cocoa.h>

#pragma mark -

UIMessageBoxMAC::UIMessageBoxMAC() {
    
}

UIMessageBoxMAC::~UIMessageBoxMAC() {
    
}

void UIMessageBoxMAC::show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1) {
    this->message_box = message_box;
    
    NSString* str_title = title ? [NSString stringWithUTF8String : title] : nil;
    NSString* str_content = content ? [NSString stringWithUTF8String : content] : nil;
//    NSString* str_button_str0 = button_str0 ? [NSString stringWithUTF8String : button_str0] : nil;
//    NSString* str_button_str1 = button_str1 ? [NSString stringWithUTF8String : button_str1] : nil;
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:str_title];
//    [alert addButtonWithTitle:secondname];
    [alert setMessageText:str_content];
//    [alert setInformativeText:informativetext];
    [alert setAlertStyle:NSWarningAlertStyle];
    NSUInteger action = [alert runModal];
    
    // 响应window的按钮事件
    
    if(action == NSAlertFirstButtonReturn)
    {
        callback(1);
    }
//    else if(action == NSAlertSecondButtonReturn)
//    {
//        NSLog(@"alternateButton clicked!");
//    }
//    else if(action == NSAlertThirdButtonReturn)
//    {
//        NSLog(@"otherButton clicked!");
//    }
}

void UIMessageBoxMAC::callback(int button_index) {
    UIMessageBox* mb = static_cast<UIMessageBox*>(message_box);
    if (mb) {
        mb->callback(button_index);
    }
}

#pragma mark -

UIMessageBoxImpl* createUIMessageBoxImpl() {
    return new UIMessageBoxMAC();
}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */
