//
//  UIMessageBoxImpl.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UIMessageBoxImpl__
#define __AVT__UIMessageBoxImpl__

#include "../Common/CommonDefine.h"

class UIMessageBoxImpl {
protected:
    void* message_box;
    
public:
    UIMessageBoxImpl() {
        message_box = NULL;
    }
    virtual ~UIMessageBoxImpl() {};
    
    virtual void show(void* message_box, const char* title, const char* content, const char* button_str0, const char* button_str1) = 0;
    virtual void callback(int button_index) = 0;
};

extern UIMessageBoxImpl* createUIMessageBoxImpl();

#endif /* defined(__AVT__UIMessageBoxImpl__) */
