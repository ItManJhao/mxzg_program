//
//  UIMessageBoxIOS.mm
//  conix
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMessageBoxIOS.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#include "UIMessageBox.h"
#import <UIKit/UIAlert.h>

@implementation UIMessageBoxIOSDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_messageBox) {
        _messageBox->callback((int)buttonIndex);
    }
    [self release];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    return true;
}

@end

#pragma mark -

UIMessageBoxIOS::UIMessageBoxIOS() {
    
}

UIMessageBoxIOS::~UIMessageBoxIOS() {
    
}

void UIMessageBoxIOS::show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1) {
    this->message_box = message_box;
    
    UIMessageBoxIOSDelegate* delegate = [[UIMessageBoxIOSDelegate alloc] init];
    delegate.messageBox = this;
    
    NSString* str_title = title ? [NSString stringWithUTF8String : title] : nil;
    NSString* str_content = content ? [NSString stringWithUTF8String : content] : nil;
    NSString* str_button_str0 = button_str0 ? [NSString stringWithUTF8String : button_str0] : nil;
    NSString* str_button_str1 = button_str1 ? [NSString stringWithUTF8String : button_str1] : nil;
    UIAlertView* messageBox = [[UIAlertView alloc] initWithTitle: str_title
                                                         message: str_content
                                                        delegate: delegate
                                               cancelButtonTitle: str_button_str0
                                               otherButtonTitles: str_button_str1, nil];
    [messageBox autorelease];
    [messageBox show];
}

void UIMessageBoxIOS::callback(int button_index) {
    UIMessageBox* mb = static_cast<UIMessageBox*>(message_box);
    if (mb) {
        mb->callback(button_index);
    }
}

#pragma mark -

UIMessageBoxImpl* createUIMessageBoxImpl() {
    return new UIMessageBoxIOS();
}

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */
