//
//  ErrorResponse.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "ErrorResponse.h"
#include "../../Comp/MessageView.h"
#include "../../Config/LanguageTable.h"
#include "../../Model/Game.h"
#include "../../Comp/UIMessageBox.h"

void ErrorResponse::getError(void *buffer , int32_t size) {
    // 设置显示文本,并显示错误数据信息
    ResError* res = static_cast<ResError*>(buffer);
    if (!res) {
        return;
    }

    LanguageTable* language_table = LanguageTable::instance();
    
    if (res->reload) {
        // 前后端数据不一致，可能是配置更新了，尝试重新下载配置
        Game::config_loaded = false;
        
//        Game::instance()->onInconsistentData();
        Game::instance()->stopTheGame();
        
        UIMessageBox::create(language_table->getLanguage(res->error),
                             language_table->getLanguage(110021),
                             language_table->getLanguage(110023),
                             CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
        return;
    }
    
    if (res->error == 100012) {
        // 账号在其他设备上登陆
        Game::instance()->stopTheGame();
        
        UIMessageBox::create(language_table->getLanguage(10005),
                             language_table->getLanguage(110024),
                             language_table->getLanguage(110025),
                             CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
        return;
    } else if (res->error == 100013) {
        // 封号
        Game::instance()->stopTheGame();
        
        string content = language_table->getLanguage(201005);
        if (size > sizeof(ResError) - sizeof(res->msg)) {
            content.clear();
            content = res->msg;
        }
        
        UIMessageBox::create(content.c_str(),
                             language_table->getLanguage(7001123),
                             language_table->getLanguage(11023),
                             CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
        return;
    }
//    else if (res->error == 100013) {
//        // 在线服务器维护
//        Game::instance()->stopTheGame();
//
//        string content = language_table->getLanguage(20205);
//        if (size > sizeof(ResError) - sizeof(res->msg)) {
//            content.clear();
//            content = res->msg;
//        }
//
//        UIMessageBox::create(content.c_str(),
//                             language_table->getLanguage(7001123),
//                             language_table->getLanguage(110023),
//                             CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
//        return;
//    }
    else if (res->error == 100032) {
        // 非法字符
        string msg = StringUtils::format(language_table->getLanguage(res->error), res->msg);
        MessageView::instance()->add(msg.c_str());
        
        return;
    } else if (res->error == 201009) {
        //玩家正在被保护(201009)
        MessageView::instance()->add(language_table->getLanguage(7002140));
        return;
    } else if (res->error == 201012) {
        //玩家正在线上(201012)
        MessageView::instance()->add(language_table->getLanguage(367));
        return;
    } else if (res->error == 201014) {
        //玩家正在被攻击(201014)
        MessageView::instance()->add(language_table->getLanguage(369));
        return;
        
    } else if (res->error == 100033) {
        // 已被禁言
        MessageView::instance()->add(language_table->getLanguage(10004));
        return;
    }

//#if COCOS2D_DEBUG > 0
    if (size > (sizeof(ResError) - sizeof(res->msg))) {
        MessageView::instance()->add(StringUtils::format("%s: %s", language_table->getLanguage(res->error), res->msg).c_str());
    } else {
        MessageView::instance()->add(language_table->getLanguage(res->error));
    }
//#else
//    MessageView::instance()->add(language_table->getLanguage(res->error));
//#endif
}
