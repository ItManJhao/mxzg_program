//
//  PlatformApi.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "PlatformApi.h"
#include "../Comp/MessageView.h"
#include "../Comp/UIMessageBox.h"
#include "../Model/Utils.h"
#include "../Model/Game.h"
#include "../Config/VersionTable.h"

#include "../Model/LuaManager.h"

#include "../AutoRun/NetManager.h"

#include <stdlib.h>
#include <stdio.h>

typedef unsigned char BYTE;

inline BYTE toHex(const BYTE &x) {
	return x > 9 ? x - 10 + 'A' : x + '0';
}

inline BYTE fromHex(const BYTE &x) {
	return isdigit(x) ? x - '0' : x - 'A' + 10;
}

inline string URLEncode(const string &sIn) {
	string sOut;
	for (size_t ix = 0; ix < sIn.size(); ix++) {
		BYTE buf[4];
		memset(buf, 0, 4);
		if (isalnum((BYTE) sIn[ix])) {
			buf[0] = sIn[ix];
		}
		//else if ( isspace( (BYTE)sIn[ix] ) ) //貌似把空格编码成%20或者+都可以
		//{
		//    buf[0] = '+';
		//}
		else {
			buf[0] = '%';
			buf[1] = toHex((BYTE) sIn[ix] >> 4);
			buf[2] = toHex((BYTE) sIn[ix] % 16);
		}
		sOut += (char *) buf;
	}
	return sOut;
}

inline string URLDecode(const string &sIn) {
	string sOut;
	for (size_t ix = 0; ix < sIn.size(); ix++) {
		BYTE ch = 0;
		if (sIn[ix] == '%') {
			ch = (fromHex(sIn[ix + 1]) << 4);
			ch |= fromHex(sIn[ix + 2]);
			ix += 2;
		} else if (sIn[ix] == '+') {
			ch = ' ';
		} else {
			ch = sIn[ix];
		}
		sOut += (char) ch;
	}
	return sOut;
}

//static size_t httpOnWriteData(void *ptr, size_t size, size_t nmemb, void *stream) {
//    std::vector<char> *recvBuffer = (std::vector<char>*)stream;
//    size_t sizes = size * nmemb;
//
//    // add data to the end of recvBuffer
//    // write data maybe called more than once in a single request
//    recvBuffer->insert(recvBuffer->end(), (char*)ptr, (char*)ptr+sizes);
//
//    return sizes;
//}

PlatformApi* PlatformApi::create() {
	PlatformApi *pRet = new PlatformApi();
	if (pRet) {
		pRet->autorelease();
		return pRet;
	} else {
		delete pRet;
		pRet = NULL;
		return NULL;
	}
}

PlatformApi::PlatformApi() {
    is_lua_mode = false;
	target = NULL;
	selector = NULL;
    time_out = 60;
    http_callback = NULL;
}

PlatformApi::~PlatformApi() {
    // CCLOG("~PlatformApi");
	if (target) {
		target->release();
		target = NULL;
	}
}

void PlatformApi::sendGet(const map<string, string>& params, int read_timeout) {
    time_out = read_timeout;
	if ((target && selector) || http_callback || is_lua_mode) {
		sendGet(params, this, httpresponse_selector(PlatformApi::callback), time_out);
	} else {
		sendGet(params, NULL, NULL, time_out);
	}
}

void PlatformApi::sendPost(const map<string, string>& params, int read_timeout) {
    time_out = read_timeout;
    if ((target && selector) || http_callback || is_lua_mode) {
        sendPost(params, this, httpresponse_selector(PlatformApi::callback), time_out);
    } else {
        sendPost(params, NULL, NULL, time_out);
    }
}

void PlatformApi::sendGet(map<string, string> params, Ref* target, SEL_HttpResponse func, int read_timeout) {
    VersionTable* version_table = VersionTable::instance();
    if (platform_urls_index >= version_table->config.platform_urls.size()) {
        platform_urls_index = 0;
    }
    
	string url = version_table->config.platform_urls[platform_urls_index];

    params_map.clear();
    for (map<string, string>::iterator iter = params.begin(); iter != params.end(); ++iter) {
        params_map[iter->first] = iter->second;
    }
    
	// map<string, string> paramsTmp = params;
	string stime = StringUtils::format("%ld", time(NULL));
	params_map["time"] = stime;

	vector<string> vec;
	for (map<string, string>::iterator i = params_map.begin(); i != params_map.end(); i++) {
		vec.push_back(i->first);
	}
	sort(vec.begin(), vec.end());

	bool first = true;

	for (int i = 0; i < vec.size(); i++) {
		if (first) {
			first = false;
			url += "?";
		} else {
			url += "&";
		}

		string& key = vec[i];
		string& value = params_map[key];

		url += key;
		url += "=";
		url += URLEncode(value);
	}

	url += "&sign=";
	url += StringUtil::sign(params_map);
    
    sendGet(url, target, func, read_timeout);
}

void PlatformApi::sendPost(map<string, string> params, Ref* target, SEL_HttpResponse func, int read_timeout) {
    VersionTable* version_table = VersionTable::instance();
    if (platform_urls_index >= version_table->config.platform_urls.size()) {
        platform_urls_index = 0;
    }
    
    string url = version_table->config.platform_urls[platform_urls_index];

    params_map.clear();
    for (map<string, string>::iterator iter = params.begin(); iter != params.end(); ++iter) {
        params_map[iter->first] = iter->second;
    }
    
    // map<string, string> paramsTmp = params;
    string stime = StringUtils::format("%ld", time(NULL));
    params_map["time"] = stime;

    vector<string> vec;
    for (map<string, string>::iterator i = params_map.begin(); i != params_map.end(); i++) {
        vec.push_back(i->first);
    }
    sort(vec.begin(), vec.end());

    bool first = true;

    for (int i = 0; i < vec.size(); i++) {
        if (first) {
            first = false;
            url += "?";
        } else {
            url += "&";
        }

        string& key = vec[i];
        string& value = params_map[key];

        url += key;
        url += "=";
        url += URLEncode(value);
    }

    url += "&sign=";
    url += StringUtil::sign(params_map);
    
    sendPost(url, target, func, read_timeout);
}

void PlatformApi::sendGet(const string& url, Ref* target, SEL_HttpResponse func, int read_timeout) {
	HttpClient* client = HttpClient::getInstance();
	client->setTimeoutForConnect(5);
	client->setTimeoutForRead(read_timeout);
	HttpRequest* request = new HttpRequest();
	request->setRequestType(HttpRequest::Type::GET);
	request->setUrl(url.c_str());
	request->setResponseCallback(target, func);
	client->send(request);
	request->release();

	CCLOG("[HTTP SEND GET]: %s", url.c_str());
}

void PlatformApi::sendPost(const string& url, Ref* target, SEL_HttpResponse func, int read_timeout) {
    HttpClient* client = HttpClient::getInstance();
    client->setTimeoutForConnect(5);
    client->setTimeoutForRead(read_timeout);
    HttpRequest* request = new HttpRequest();
    request->setRequestType(HttpRequest::Type::POST);
    request->setUrl(url.c_str());
    request->setResponseCallback(target, func);
    client->send(request);
    request->release();

    CCLOG("[HTTP SEND POST]: %s", url.c_str());
}

void PlatformApi::luaSendGet(string json, int read_timeout)
{
    is_lua_mode = true;
    map<string, string> params;
    
    CSJson::Reader reader;
    CSJson::Value json_params;
    
    if (reader.parse(json, json_params))
    {
        CSJson::Value::Members members;
        members = json_params.getMemberNames();
        for (auto iterMember = members.begin(); iterMember != members.end(); iterMember++)   // 遍历每个key
        {
            std::string strKey = *iterMember;
            params[strKey] = json_params[strKey.c_str()].asString();
        }
        
        sendGet(params, read_timeout);
    }
    else
    {
        log("PlatformApi parse json error: %s", json.c_str());
    }
}

void PlatformApi::luaSendPost(string json, int read_timeout)
{
    is_lua_mode = true;
    map<string, string> params;
    
    CSJson::Reader reader;
    CSJson::Value json_params;
    
    if (reader.parse(json, json_params))
    {
        CSJson::Value::Members members;
        members = json_params.getMemberNames();
        for (auto iterMember = members.begin(); iterMember != members.end(); iterMember++)   // 遍历每个key
        {
            std::string strKey = *iterMember;
            params[strKey] = json_params[strKey.c_str()].asString();
        }
        
        sendPost(params, read_timeout);
    }
    else
    {
        log("PlatformApi parse json error: %s", json.c_str());
    }
}

void PlatformApi::luaSendGetWithUrl(string url, int read_timeout) {
    is_lua_mode = true;
    
    HttpClient* client = HttpClient::getInstance();
    client->setTimeoutForConnect(5);
    client->setTimeoutForRead(read_timeout);
    HttpRequest* request = new HttpRequest();
    request->setRequestType(HttpRequest::Type::GET);
    request->setUrl(url.c_str());
    request->setResponseCallback(this, httpresponse_selector(PlatformApi::callback));
    client->send(request);
    request->release();
    
    CCLOG("[HTTP SEND GET]: %s", url.c_str());
}

void PlatformApi::luaSendPostWithUrl(string url, int read_timeout) {
    is_lua_mode = true;
    
    HttpClient* client = HttpClient::getInstance();
    client->setTimeoutForConnect(5);
    client->setTimeoutForRead(read_timeout);
    HttpRequest* request = new HttpRequest();
    request->setRequestType(HttpRequest::Type::POST);
    request->setUrl(url.c_str());
    request->setResponseCallback(this, httpresponse_selector(PlatformApi::callback));
    client->send(request);
    request->release();
    
    CCLOG("[HTTP SEND POST]: %s", url.c_str());
}

void PlatformApi::setCallback(cocos2d::Ref *pTarget, SEL_CallFuncJson pSelector) {
	if (target) {
		target->release();
	}
	target = pTarget;
	target->retain();
	selector = pSelector;
}

void PlatformApi::setCallback(std::function<void(CSJson::Value json)> callback) {
    http_callback = callback;
}

void PlatformApi::callback(HttpClient* client, HttpResponse* response) {
    if (!response) {
        return;
    }
    
    // 获取对应request的字符串标识
    if (0 != strlen(response->getHttpRequest()->getTag())) {
        CCLOG("%s completed", response->getHttpRequest()->getTag());
    }
    //获取返回代码，比如200、404等
    int64_t statusCode = response->getResponseCode();
    char statusString[64] = {};
    sprintf(statusString, "HTTP Status Code: %lld, tag = %s", statusCode, response->getHttpRequest()->getTag());
//    m_labelStatusCode->setString(statusString);
    CCLOG("response code: %lld", statusCode);
    
	string html = "";
	if (response->isSucceed()) {
		vector<char> vdata = *response->getResponseData();
		for (int i = 0; i < vdata.size(); i++) {
			html += vdata[i];
		}
    } else {
        CCLOG("response failed");
        CCLOG("error buffer: %s", response->getErrorBuffer());//可以调用getErrorBuffer()来获取错误原因
    }

	if (html == "") {
//		 网络完全不通（HTTP连接不上）
        VersionTable* version_table = VersionTable::instance();
        if (platform_urls_index >= version_table->config.platform_urls.size() - 1) {
            platform_urls_index = 0;
            Game::instance()->onOffline();
            return;
        }
        
		platform_urls_index++;
        sendGet(params_map, time_out);
        return;
	}
    
	CCLOG("[HTTP RECV] %s", html.c_str());
    
	CSJson::Reader reader;
	CSJson::Value json;
	//读入字符串，然后转换成json格式
	if (!reader.parse(html, json)) {
		string s = StringUtils::format("wrong json string: %s", html.c_str());
		MessageView::instance()->add(s.c_str());
		return;
	}

	if (json.isMember("error") && atoi(json["error"].asCString()) != 0) {
		int error = atoi(json["error"].asCString());
		if (error == 20102) {
			// 密码不正确
//			LoginCtr::instance()->open(false);
		} else if (error == 20201) {
			// 分服不存在
//			ChooseServerCtr::instance()->open();
		} else if (error == 20205) {
            // 服务器处于维护中
//            LanguageTable* config = LanguageTable::instance();
////            string content = config->getLanguage(20205);
////            if (json.isMember("msg") && strcmp(json["msg"].asCString(), "") != 0) {
////                content = json["msg"].asCString();
////            }
//            
//            UIMessageBox::create(config->getLanguage(110033),
//                                 config->getLanguage(110032),
//                                 config->getLanguage(110023),
//                                 CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
            return;
        }

#if COCOS2D_DEBUG > 0
//		string s = StringUtils::format("error: %d, %s", error, LanguageTable::instance()->getLanguage(error));
//		MessageView::instance()->add(s.c_str());
#else
//		MessageView::instance()->add(LanguageTable::instance()->getLanguage(error));
#endif
		return;
	}
    
    if (target && selector) {
        (target->*selector)(json);
    }
    
    if (http_callback) {
        http_callback(json);
    }
    
    if (is_lua_mode) {
        CSJson::FastWriter writer;
        string str_json = writer.write(json);
        LuaManager::instance()->handleEvent(this, "httpCallback", [&](LuaStack* ls) {
            ls->pushString(str_json.c_str());
            return 1;
        });
    }
}
