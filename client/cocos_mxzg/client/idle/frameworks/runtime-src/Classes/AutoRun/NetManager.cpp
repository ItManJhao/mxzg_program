//
//  NetManager.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "NetManager.h"
#include "../Model/Game.h"
#include "../Comp/UIMessageBox.h"
#include "../Config/LanguageTable.h"
#include "../Model/UserSetting.h"
//#include "../Ctrl/Layer/GuideCtr.h"
#include "../Model/LuaManager.h"

NetManager::NetManager() {
    send_buffer = new DataBuffer(SOCKET_RECV_BUFFER_SIZE);
    
    uid = 0;
    server_id = 0;
    timestamp = 0;
    sign = "";
}

NetManager::~NetManager() {
    delete send_buffer;
}

void NetManager::init() {
    connect_times = 0;
    last_connect_time = 0;
    
    interval = 0.06;
    delay = interval;
    
    last_send_login = 0;
}

void NetManager::run(float delay) {
//     CCLOG("%f", delay);
    if (!client.isConnected()) {
        if (hosts.size() == 0) {
            return;
        }
        
        int t = Game::second();
        if (t < last_connect_time + 7) {
            // 7秒尝试连接1次
            return;
        }
        last_connect_time = t;
        
        int index_tmp = connect_times / 2;
        string& host = hosts[index_tmp].first;
        unsigned short& port = hosts[index_tmp].second;
        if (client.connect(host.c_str(), port) == 0) {
            // 连接成功
            connect_times = 0;
            
            last_send_login = t;
            
            // 恢复缓存有bug。。无法实现重连
//            char* buffer = NULL;
//            int len = send_buffer->getDataLength();
//            if (len > 0) {
//                // 预防越界
//                buffer = (char*)malloc(len + 256);
//                send_buffer->read(buffer, len);
//            }
            
            send_buffer->clear();
            sendReqLogin();
            
//            if (buffer) {
//                send_buffer->write(buffer, len);
//                free(buffer);
//                buffer = NULL;
//            }
        } else {
            connect_times += 1;
            // BECHANGE
            if (connect_times >= hosts.size() * 2) {
//            if (connect_times >= 4) {
                // socket连接不上
                Game::instance()->stopTheGame();
                
                LanguageTable* config = LanguageTable::instance();
                
                // 返回登录界面
                UIMessageBox::create(config->getLanguage(110012),
                                     config->getLanguage(110011),
                                     config->getLanguage(110013),
                                     CC_CALLBACK_1(Game::reLogin, Game::instance()))->show();
            }
        }
        return;
    }
    
    if (last_send_login > 0) {
        int t = Game::second();
        if (t >= last_send_login + 5) {
            last_send_login = t;
            
            // 5秒再次发送
            sendReqLogin();
        }
    }
    
    // 发数据包
    char buffer[1024] = {};
    int length = send_buffer->getDataLength() > 1024 ? 1024 : send_buffer->getDataLength();
    int read = send_buffer->read(buffer, length);
    if (read > 0) {
        int sent = client.send(buffer, length);
        if (sent > 0) {
            CCLOG("sent!");
        } else {
            CCLOG("sent failed!");
        }
    }
    
    int n = client.recv();
    if (n <= 0) {
        return;
    }
    
    ResponseManager* response_manager = ResponseManager::instance();
    
    while (true) {
        
        int readable_bytes = client.getReadableBytes();
        if (readable_bytes < 4) {
            break;
        }
        
        int data_length = 0;
        client.get(&data_length, 4);
        
        if (data_length < 0 || data_length > 1048576) {
            CCLOG("recv error data_length: %d !!!", data_length);
            // 当数据长度小于0或者大于1M时，清空缓冲区
            client.clear();
            break;
        }
        if (readable_bytes < data_length + 4) {
            // dataLength notEnough
            break;
        }
        client.skipBytes(4);
        
        int protocol = 0;
        client.get(&protocol, 4);
        CCLOG("recv: %d", protocol);
        
//        if (protocol == 1216007) {
//            int aa = 0;
//            aa = 0;
//        }
//        GuideCtr::waitRecvProtocol(protocol);
        
        LuaManager::instance()->executeGlobalAutoFunction("waitRecvProtocol", [&](LuaStack * ls) {
            ls->pushInt(protocol);
            return 1;
        });
        
        // 先调用lua的函数
        int64_t function = response_manager->getLuaResponse(protocol);
        
        if (!function) {
            function = response_manager->getResponse(protocol);
        }
        
        if (!function) {
            client.skipBytes(data_length);
            continue;
        }
        
        void* buffer = malloc(data_length);
        client.read(buffer, data_length);
        
        void (*pf)(void* , int32_t) = (void (*)(void* , int32_t))function;
        (*pf)(buffer, data_length);
        CC_SAFE_FREE(buffer);
    }
}

void NetManager::send(ProtocolRequest* data, uint32_t length)
{
    send_buffer->write(&length, 4);
    send_buffer->write(data, length);
    CCLOG("pre send protocol: %d", data->protocol);
    
    LuaManager::instance()->executeGlobalAutoFunction("waitSendProtocol", [&](LuaStack * ls) {
        ls->pushInt(data->protocol);
        return 1;
    });
    
//    GuideCtr::waitSendProtocol(data->protocol);
}

void NetManager::sendByteArray(ByteArray* data)
{
    int32_t length = data->getLength();
    send_buffer->write(&length, 4);
    send_buffer->write(data->getData(), length);

//    auto req =  (ProtocolBase*)data->getData();
//    if (req->protocol == 1101010) {
//        auto tmp_req = (ReqError*)req;
//        tmp_req = NULL;
//    }
    
    auto protocol = data->readInt();
    CCLOG("pre send protocol: %d", protocol);
    
    LuaManager::instance()->executeGlobalAutoFunction("waitSendProtocol", [&](LuaStack * ls) {
        ls->pushInt(protocol);
        return 1;
    });
    
//     auto req = (ReqGMCommand*)data->getData();
//    GuideCtr::waitSendProtocol(protocol);
}

void NetManager::close() {
    client.close();
    send_buffer->clear();
}

void NetManager::reset() {
    uid = 0;
    server_id = 0;
    timestamp = 0;
    sign = "";
    
}

void NetManager::sendReqLogin() {
    if (uid <= 0/** || timestamp <= 0*/) {
        return;
    }
////    int server_id = UserSettingManager::instance()->user_setting.server_id;
////    if (server_id <= 0) {
////        return;
////    }
//    ReqLogin req = ReqLogin();
//    req.uid = this->uid;
////    req.uid = 156263512415718;
//    req.time = timestamp;
//    req.server_id = this->server_id;
//
//    string device_token = Game::instance()->getDeviceToken();
//    //memcpy(req.device_token, device_token.c_str(), device_token.length());
//
//    memcpy(req.sign, sign.c_str(), sign.length());
//
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//    req.platform = 1;
//#else
//    req.platform = 0;
//#endif
//
//    send(&req, sizeof(req));
    
//    NetManager::instance()->run(0.017);
    
    // 需要把上面的代码屏蔽
    LuaManager::instance()->executeGlobalAutoFunction("sendReqLogin", [&](LuaStack * ls) {
        return 0;
    });
}

bool NetManager::isConnected() {
    return client.isConnected();
}


void NetManager::setUserId(string uid) {
    this->uid = atoll(uid.c_str());
}

void NetManager::setServerId(int32_t server_id) {
    this->server_id = server_id;
}

void NetManager::setSign(string sign) {
    this->sign = sign;
}

void NetManager::clearHosts() {
    this->hosts.clear();
}

void NetManager::addHosts(string ip, int32_t port) {
    this->hosts.push_back(make_pair(ip, port));
}

int32_t NetManager::getHostsNum() {
    return this->hosts.size();
}

void NetManager::setTimeStamp(int32_t time) {
    this->timestamp = time;
}
