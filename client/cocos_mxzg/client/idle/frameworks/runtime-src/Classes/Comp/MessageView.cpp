//
//  MessageView.mm
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "MessageView.h"
#include "../Model/Game.h"
#include "UIRichTextEx.h"

MessageView::MessageView()
: spr_notice_bg(NULL)
, scroll_view(NULL)
{
    is_molding = false;
    
    is_noticing = false;
}

void MessageView::add(const string& text, t_byte err) {
    if (text.size() == 0) {
        return;
    }
    
    vec_text_elem.push_back(TextElem(text, err));
    
    if (!is_molding) {
        showNextMessage();
    }
}

void MessageView::addNotice(const string& text) {
    if (text.size() == 0) {
        return;
    }
    
    for (int i = 0; i < vec_notice.size(); i++) {
        if (strcmp(vec_notice.at(i).c_str(), text.c_str()) == 0) {
            return;
        }
    }
    
    vec_notice.push_back(text);
    
    showNextNotice();
}

void MessageView::showNextMessage() {
    if (is_molding ||
        vec_text_elem.size() <= 0) {
        return;
    }
    
    is_molding = true;
    
    auto iter_text_elem = vec_text_elem.begin();
    
    Director* director = Director::getInstance();
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    float reverse_scale = Game::instance()->getReverseScale();
    sfc->addSpriteFramesWithFile("ccbi-res/common-ui.plist");
    sfc->addSpriteFramesWithFile("ccbi-res/common-ui-2.plist");
    
    auto win_size = director->getWinSize();
    
    // 创建UILabelTTF对象，并初始化
    auto label = RichTextEx::createWithXML("");
    label->setScale(0.5);
    label->setFontSize(40);
    label->setXmlText(iter_text_elem->text);
    label->formatText();
    label->setVisible(false);
    director->getRunningScene()->addChild(label, 10001);
    
    if (label->getContentSize().width > 590) {
        label->setAnchorPoint(Vec2::ANCHOR_MIDDLE_LEFT);
        label->ignoreContentAdaptWithSize(false);
        label->setContentSize(Size(350, 55 * 2) / label->getScale());
        label->setWrapMode(RichTextEx::WrapMode::WRAP_PER_CHAR);
        label->formatText();
        label->setPosition(Vec2(win_size.width * 0.5 - label->getContentSize().width * 0.5 * label->getScale(),
                                win_size.height * 0.5));
    } else {
        label->setPosition(Vec2(win_size.width / 2, win_size.height * 0.5));
    }
    
    if (iter_text_elem->err == 1) {
        label->setColor(FONT_LIGHT_YELLOW);
    }
    
    auto bg = cocos2d::ui::Scale9Sprite::createWithSpriteFrameName("win-bg/block-bg-messageview.png");
    bg->ignoreAnchorPointForPosition(false);
    bg->setInsetLeft(35);
    bg->setInsetTop(10);
    bg->setInsetRight(35);
    bg->setInsetBottom(10);
    bg->setAnchorPoint(Vec2(0.5, 0.5));
    bg->setScale(reverse_scale);
    bg->setVisible(false);
    bg->setPosition(Vec2(win_size.width * 0.5, label->getPosition().y));
    bg->setContentSize(Size(MAX(300,
                                label->getContentSize().width * label->getScale() + 15),
                            label->getContentSize().height *
                            label->getScale() + 10) /
                       bg->getScale());
    director->getRunningScene()->addChild(bg, 10000);
    
    vec_text_elem.erase(vec_text_elem.begin());
    
    // 所有标签上移
    float height = bg->getPositionY() + bg->getContentSize().height * bg->getScale() * 0.5;
    for (int i = (int)vec_label.size() - 1; i >= 0; --i) {
        auto tmp_elem = &vec_label[i];
        
        auto act_move_bg = EaseExponentialOut::create(
                                MoveTo::create(0.1,
                                               Vec2(tmp_elem->spr_bg->getPositionX(),
                                                    height + tmp_elem->spr_bg->getContentSize().height * tmp_elem->spr_bg->getScale() * 0.5)));
        auto act_move_msg = EaseExponentialOut::create(
                                MoveTo::create(0.1,
                                               Vec2(tmp_elem->lbl_message->getPositionX(),
                                                    height + tmp_elem->spr_bg->getContentSize().height * tmp_elem->spr_bg->getScale() * 0.5)));
        
        act_move_bg->setTag(1000);
        act_move_msg->setTag(1000);
        tmp_elem->spr_bg->stopActionByTag(1000);
        tmp_elem->lbl_message->stopActionByTag(1000);

        tmp_elem->spr_bg->runAction(act_move_bg);
        tmp_elem->lbl_message->runAction(act_move_msg);
        
        height += tmp_elem->spr_bg->getContentSize().height * bg->getScale();;
    }
    
    auto lbl_elem = LabelElem();
    lbl_elem.lbl_message = label;
    lbl_elem.spr_bg = bg;
    vec_label.push_back(lbl_elem);
    
    auto act_show_end = Sequence::create(EaseExponentialOut::create(FadeTo::create(0.1, 255)),
                                         CallFuncN::create(CC_CALLBACK_1(MessageView::showMessageActionEnd, this)),
                                         NULL);
    
    auto act_show = Sequence::create(EaseExponentialOut::create(FadeTo::create(0.1, 255)),
                                     NULL);
    
    lbl_elem.spr_bg->setVisible(true);
    lbl_elem.lbl_message->setVisible(true);
    
    lbl_elem.spr_bg->setOpacity(0);
    lbl_elem.lbl_message->setOpacity(0);
    
    lbl_elem.spr_bg->runAction(act_show);
    lbl_elem.lbl_message->runAction(act_show_end);
    
}

void MessageView::showMessageActionEnd(Node* node) {
    is_molding = false;

    auto lbl_elem = getLabelElemByLabel(node);
    if (lbl_elem) {
        lbl_elem->spr_bg->runAction(Sequence::create(MoveBy::create(3, Vec2(0, 30)),
                                                     FadeOut::create(0.5),
                                                     DelayTime::create(0.02),
                                                     RemoveSelf::create(),
                                                     NULL));
        
        lbl_elem->spr_bg->runAction(Sequence::create(DelayTime::create(2.5),
                                                     FadeOut::create(0.5),
                                                     NULL));
        
        
        lbl_elem->lbl_message->runAction(Sequence::create(MoveBy::create(3, Vec2(0, 30)),
                                                          FadeOut::create(0.5),
                                                          CallFuncN::create(CC_CALLBACK_1(MessageView::showMessageEnd, this)),
                                                          DelayTime::create(0.02),
                                                          RemoveSelf::create(),
                                                          NULL));
        
        lbl_elem->lbl_message->runAction(Sequence::create(DelayTime::create(2.5),
                                                          FadeOut::create(0.5),
                                                          NULL));
    }
    showNextMessage();
}

void MessageView::showMessageEnd(Node* node) {
    removeLabelElem(node);
}

void MessageView::showNextNotice() {
    // 防止动画卡住
    int32_t now = Game::instance()->getServerTime();
    if (is_noticing) {
        if (now - last_show_time > 180) {
            is_noticing = false;
            scroll_view = NULL;
            spr_notice_bg = NULL;
        }
    }
    
    if (is_noticing) {
        return;
    }
    
    if (vec_notice.size() <= 0) {
        // 移除公告背景
        if (spr_notice_bg) {
            spr_notice_bg = NULL;
        }
        
        if (scroll_view) {
            scroll_view->removeFromParentAndCleanup(true);
            scroll_view = NULL;
        }
        
        return;
    }
    
    is_noticing = true;
    
    last_show_time = now;
    
    auto iter_text_elem = vec_notice.begin();
    
    Director* director = Director::getInstance();
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    float reverse_scale = Game::instance()->getReverseScale();
    sfc->addSpriteFramesWithFile("ccbi-res/common-ui.plist");
    
    auto win_size = director->getWinSize();
    
    // 创建公告滚动范围
    if (!scroll_view) {
        scroll_view = ScrollView::create(Size(500, 50));
        scroll_view->setTouchEnabled(false);
        scroll_view->setBounceable(false);
        scroll_view->setDirection(ScrollView::Direction::HORIZONTAL);
        scroll_view->setPosition(win_size.width / 2 - scroll_view->getViewSize().width / 2,
                                 win_size.height * 0.75);
        director->getRunningScene()->addChild(scroll_view, 11001);
    }
    
    // 创建UILabelTTF对象，并初始化
    auto label = RichTextEx::createWithXML("");
    label->setScale(0.5);
    label->setFontSize(44);
    label->setColor(FONT_LIGHT_YELLOW);
    label->setXmlText(*iter_text_elem);
    label->formatText();
    label->setVisible(false);
    label->setPosition(Vec2(label->getContentSize().width * label->getScale() / 2 + scroll_view->getViewSize().width,
                            label->getContentSize().height / 2 - 5));
    scroll_view->addChild(label);
    
    vec_notice.erase(iter_text_elem);
    
//    if (spr_notice_bg) {
//        spr_notice_bg->removeFromParentAndCleanup(true);
//        spr_notice_bg = NULL;
//    }
    
    if (!spr_notice_bg) {
        spr_notice_bg = cocos2d::ui::Scale9Sprite::createWithSpriteFrameName("win-bg/block-bg-notice.png");
        spr_notice_bg->ignoreAnchorPointForPosition(false);
        spr_notice_bg->setInsetLeft(70);
        spr_notice_bg->setInsetTop(10);
        spr_notice_bg->setInsetRight(70);
        spr_notice_bg->setInsetBottom(10);
        spr_notice_bg->setAnchorPoint(Vec2(0.5, 0.5));
        spr_notice_bg->setVisible(false);
        spr_notice_bg->setPosition(Vec2(win_size.width * 0.5, scroll_view->getPositionY() + scroll_view->getViewSize().height / 2));
        spr_notice_bg->setContentSize(Size(scroll_view->getViewSize().width + 50, scroll_view->getViewSize().height + 10));
        director->getRunningScene()->addChild(spr_notice_bg, 11000);
    } else {
        spr_notice_bg->stopAllActions();
        spr_notice_bg->setOpacity(255);
    }

    float duration = (label->getContentSize().width * label->getScale() + scroll_view->getViewSize().width) / 100.0f;
    auto act_show_end = Sequence::create(MoveTo::create(duration, Vec2(-label->getContentSize().width * label->getScale() / 2, label->getPositionY())),
                    CallFuncN::create(CC_CALLBACK_1(MessageView::showNoticeActionEnd, this)),
                        RemoveSelf::create(),
                        NULL);
    
    auto act_show = Sequence::create(FadeTo::create(0.1, 255),
                                     DelayTime::create(duration + 0.1f),
                                     CallFuncN::create(CC_CALLBACK_1(MessageView::removeNoticeBg, this)),
                                     NULL);
    
    spr_notice_bg->setVisible(true);
    label->setVisible(true);
    
    spr_notice_bg->setOpacity(0);
    
    spr_notice_bg->runAction(act_show);
    label->runAction(act_show_end);
}

void MessageView::showNoticeActionEnd(Node *node) {
    is_noticing = false;
    
    showNextNotice();
}

void MessageView::removeNoticeBg(Node *node) {
    node->removeFromParentAndCleanup(true);
    if (spr_notice_bg) {
        spr_notice_bg = NULL;
    }
}

void MessageView::clear() {
    is_molding = false;
    for (int i = 0; i < vec_label.size(); ++i) {
        auto lbl_elem = &vec_label[i];
        if (lbl_elem->lbl_message != NULL) {
//            lbl_elem->lbl_message->removeFromParent();
//            lbl_elem->spr_bg->removeFromParent();
            
            lbl_elem->lbl_message = NULL;
            lbl_elem->spr_bg = NULL;
        }
    }
    
    vec_label.clear();
    vec_notice.clear();
}

LabelElem* MessageView::getLabelElemByLabel(Node* node) {
    for (int i = 0; i < vec_label.size(); ++i) {
        auto lbl_elem = &vec_label[i];
        if (lbl_elem->lbl_message == node) {
            return lbl_elem;
        }
    }
    return NULL;
}

void MessageView::removeLabelElem(Node* node) {
    for (auto iter = vec_label.begin(); iter != vec_label.end(); ++iter) {
        if (iter->lbl_message == node) {
            vec_label.erase(iter);
            return;
        }
    }
    
    log("MessageView::removeLabelElem node not found");
}
