//
//  HttpCallback.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__HttpCallback__
#define __AVT__HttpCallback__

#include "../Common/CommonDefine.h"

class HttpCallback : public Ref {
    
public:
    static HttpCallback* create();
    
    void login(CSJson::Value json);
    void loginGame(CSJson::Value json);
    
    void receiveServerList(CSJson::Value json);
};

#endif /* defined(__AVT__HttpCallback__) */
