//
//  PlatformApi.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__PlatformApi__
#define __ClickerHeroes__PlatformApi__

#include "../Common/CommonDefine.h"

#include "network/HttpClient.h"

using namespace network;

typedef void (Ref::*SEL_CallFuncJson)(CSJson::Value);

class PlatformApi : public Ref
{
public:
    int time_out;
    
    PlatformApi();
    ~PlatformApi();
    static PlatformApi* create();
    
    void sendGet(const map<string, string>& params, int read_timeout = 60);
    void sendPost(const map<string, string>& params, int read_timeout = 60);
    void setCallback(Ref* pTarget, SEL_CallFuncJson pSelector);
    void setCallback(std::function<void(CSJson::Value json)> callback);
    void sendGet(map<string, string> params, Ref* target, SEL_HttpResponse func, int read_timeout = 60);
    void sendPost(map<string, string> params, Ref* target, SEL_HttpResponse func, int read_timeout = 60);
    
    void sendGet(const string& url, Ref* target, SEL_HttpResponse func, int read_timeout = 60);
    void sendPost(const string& url, Ref* target, SEL_HttpResponse func, int read_timeout = 60);

    void luaSendGet(string json, int read_timeout = 60);
    void luaSendPost(string json, int read_timeout = 60);
    void luaSendGetWithUrl(string url, int read_timeout = 60);
    void luaSendPostWithUrl(string url, int read_timeout = 60);
private:
    int platform_urls_index = 0;
    map<string, string> params_map;
    
    bool is_lua_mode;
    Ref* target;
    SEL_CallFuncJson selector;
    std::function<void(CSJson::Value json)> http_callback;
    void callback(HttpClient* client, HttpResponse* response);
};


#endif /* defined(__ClickerHeroes__PlatformApi__) */
