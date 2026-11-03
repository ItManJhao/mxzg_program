//
//  NetManager.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__NetManager__
#define __ClickerHeroes__NetManager__

#include "../Common/CommonDefine.h"
#include "GameAutoRun.h"
#include "../Net/SocketClient.h"
#include "../Net/Protocol/ProtocolRequest.h"
#include "../Net/Response/ResponseManager.h"
#include "../Net/DataBuffer.h"
#include "../Model/ByteArray.h"

class NetManager : public GameAutoRun, public SingleInstance<NetManager> {
protected:
    
    
    SocketClient client;
    
    int last_connect_time;
    short connect_times;
    int relogin_time;
    
    DataBuffer* send_buffer;
    
    virtual void init();
    virtual void run(float delay);
    
public:
    vector< pair<string, unsigned short> > hosts;
    
    int64_t uid;
    int32_t server_id;
    int timestamp;
    string sign;
    
    int last_send_login;
    
//    static NetManager* instance(){};
    
    NetManager();
    virtual ~NetManager();
    
    void send(ProtocolRequest* data, uint32_t length);
    void sendByteArray(ByteArray* data);
    void close();
    void reset();
    void sendReqLogin();
    bool isConnected();
    
    void setUserId(string uid);
    void setServerId(int32_t server_id);
    void setSign(string sign);
    
    void clearHosts();
    void addHosts(string ip, int32_t port);
    int32_t getHostsNum();
    
    void setTimeStamp(int32_t time);
};

#endif /* defined(__ClickerHeroes__NetManager__) */
