//
//  MessageView.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__MessageView__
#define __ClickerHeroes__MessageView__

#include "../Common/CommonDefine.h"
#include "../Common/SingleInstance.h"

class TextElem {
public:
    TextElem(const string& t, t_byte e) {
        text = t;
        err = e;
    }
    
    string text;
    t_byte err;

};

class LabelElem {
public:
    
    LabelElem() {
        lbl_message = NULL;
        spr_bg = NULL;
    }
    cocos2d::Node* lbl_message;
    cocos2d::ui::Scale9Sprite* spr_bg;
    

};

class MessageView : public Ref, public SingleInstance<MessageView> {
public:
    //static MessageView* instance(){}
    
    MessageView();
    // 保存节点及其创建时间
    
    // 添加一条消息
    void add(const string& text, t_byte err = 1);
    void clear();
    
    void addNotice(const string& text);
    
private:
    bool is_molding;
    vector<LabelElem> vec_label;
    vector<TextElem> vec_text_elem;
    
    bool is_noticing;       // 是否正在公告
    cocos2d::ui::Scale9Sprite* spr_notice_bg;   // 公告背景
    cocos2d::extension::ScrollView* scroll_view;    // 公告滚动范围
    vector<string> vec_notice;  // 公告
    int32_t last_show_time;     // 防止动画卡住
    
    void showNextMessage();
    void showMessageActionEnd(Node* node);
    void showMessageEnd(Node* node);
    
    void showNextNotice();
    void showNoticeActionEnd(Node* node);
    void removeNoticeBg(Node* node);
    
    LabelElem* getLabelElemByLabel(Node* node);
    void removeLabelElem(Node* node);
};

#endif /* defined(__ClickerHeroes__MessageView__) */
