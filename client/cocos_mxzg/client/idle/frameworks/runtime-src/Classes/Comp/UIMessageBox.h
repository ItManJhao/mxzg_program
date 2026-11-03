//
//  UIMessageBox.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UIMessageBox__
#define __AVT__UIMessageBox__

#include "../Common/CommonDefine.h"
#include "UIMessageBoxImpl.h"

typedef std::function<void(int)> ccMessageCallback;

class UIMessageBox : public Ref {
protected:
    const char* content;
    const char* title;
    const char* button_str0;
    const char* button_str1;
    
    ccMessageCallback selector;
    
    int button_index;

    UIMessageBoxImpl* mb_impl;
    
    UIMessageBox(const char* title, const char* content, const char* button_str0, const char* button_str1, ccMessageCallback selector);
    virtual ~UIMessageBox();

    void doCallBack(float delay);

public:
    static bool opened;
    
    static UIMessageBox* create(const char* content, const char* title, const char* button_str0, ccMessageCallback selector);
    static UIMessageBox* create(const char* content, const char* title, const char* button_str0, const char* button_str1, ccMessageCallback selector);
    void show(bool always_show = false);
    void callback(int button_index);
};

#endif /* defined(__AVT__UIMessageBox__) */
