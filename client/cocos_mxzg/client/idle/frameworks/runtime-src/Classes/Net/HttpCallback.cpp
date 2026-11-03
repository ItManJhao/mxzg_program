//
//  HttpCallback.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "HttpCallback.h"


HttpCallback* HttpCallback::create() {
    HttpCallback* ret = new HttpCallback();
    ret->autorelease();
    return ret;
}

void HttpCallback::login(CSJson::Value json) {
//    LoginCtr::instance()->loginDone(json);
}

void HttpCallback::loginGame(CSJson::Value json) {
//    LoginCtr::instance()->loginGameDone(json);
}

void HttpCallback::receiveServerList(CSJson::Value json) {
//    ChooseServerCtr::instance()->receiveServerList(json);
}
