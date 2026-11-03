//
//  SocketClient.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__SocketClient__
#define __AVT__SocketClient__

#define SOCKET_RECV_BUFFER_SIZE 15242880

#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include "sys/errno.h"
#include "../Common/CommonDefine.h"

class SocketClient : public Ref {
public:
    unsigned int recvBufferSize;
    
    SocketClient();
    ~SocketClient();
    int connect(const char* hostName, unsigned short port);
    int close();
    int send(const void* data, unsigned int len);
    int recv();
    int read(void* buffer, int len);
    int readPointer(void** pointer, int len);
    
    int getReadableBytes();
    void skipBytes(int len);
    void clear();
    int get(void* buffer, int len);
    
    bool isConnected();
    
    void setBlocking(bool block);
    
protected:
    int handle;
    char* recvBuffer;
    int recvOffset;
    int readOffset;
    bool connected;
};

#endif /* defined(__AVT__SocketClient__) */
