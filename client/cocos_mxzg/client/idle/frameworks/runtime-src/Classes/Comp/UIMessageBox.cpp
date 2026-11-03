//
//  UIMessageBox.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMessageBox.h"

bool UIMessageBox::opened = false;

UIMessageBox::UIMessageBox(const char* title, const char* content, const char* button_str0, const char* button_str1, ccMessageCallback selector) {
    this->content = content;
    this->title = title;
    this->button_str0 = button_str0;
    this->button_str1 = button_str1;
    this->selector = selector;
    mb_impl = NULL;
    button_index = 0;
}

UIMessageBox::~UIMessageBox() {
    CC_SAFE_DELETE(mb_impl);
}

UIMessageBox* UIMessageBox::create(const char* content, const char* title, const char* button_str0, ccMessageCallback selector) {
    UIMessageBox* p = new UIMessageBox(title, content, button_str0, NULL, selector);
    if (p) {
        p->autorelease();
    } else {
        delete p;
        p = NULL;
    }
    return p;
}

UIMessageBox* UIMessageBox::create(const char* content, const char* title, const char* button_str0, const char* button_str1, ccMessageCallback selector) {
    UIMessageBox* p = new UIMessageBox(title, content, button_str0, button_str1, selector);
    if (p) {
        p->autorelease();
    } else {
        delete p;
        p = NULL;
    }
    return p;
}

void UIMessageBox::show(bool always_show) {
    if (!always_show && opened) {
        return;
    }
    opened = true;
    this->retain();
    
    mb_impl = createUIMessageBoxImpl();
    mb_impl->show(this, title, content, button_str0, button_str1);
}

void UIMessageBox::callback(int button_index) {
	this->button_index = button_index;

	Scheduler* sharedScheduler = Director::getInstance()->getScheduler();
	sharedScheduler->schedule(schedule_selector(UIMessageBox::doCallBack), this, 0, 0, 0.016, false);
}

void UIMessageBox::doCallBack(float delay) {
	if (&selector) {
		(selector)(button_index);
	}

	opened = false;
	release();
}
