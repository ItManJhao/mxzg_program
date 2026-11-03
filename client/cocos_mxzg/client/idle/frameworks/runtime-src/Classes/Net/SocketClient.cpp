
//  SocketClient.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "SocketClient.h"
#include "../Model/Game.h"

#include <unistd.h>        /* System V */
#include <sys/ioctl.h>    /* BSD and Linux */
//#include <stropts.h>    /* XSI STREAMS */


int tcp_connect(const char *host, const char *service)
{
    int sockfd, ret;
    struct addrinfo hints, *res, *ressave;
    bzero(&hints, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_IP;
  
    if (0 != (ret = getaddrinfo(host, service, &hints, &res)))
    {
        cout << "getaddrinfo error: " << gai_strerror(ret) << endl;
        return -1;
    }
  
    ressave = res;
    while (NULL != res)
    {
        if (-1 == (sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol)))
        {
            cout << "create socket error: " << strerror(errno) << endl;
            res = res->ai_next;
            continue;
        }
  
        if (-1 == connect(sockfd, res->ai_addr, res->ai_addrlen))
        {
            cout << "connect error: " << strerror(errno) << endl;
            close(sockfd);
            res = res->ai_next;
            continue;
        }
  
        break;
    }
      
    freeaddrinfo(ressave);
  
    if (NULL == res)
        return -1;
  
    return sockfd;
}

SocketClient::SocketClient() {
    recvBufferSize = SOCKET_RECV_BUFFER_SIZE;
    
    handle = -1;
    readOffset = 0;
    recvOffset = 0;
    recvBuffer = (char*) malloc(recvBufferSize);
    
    connected = false;
}

SocketClient::~SocketClient() {
    free(recvBuffer);
}

int SocketClient::connect(const char* hostName, unsigned short port) {
    
//    int fd4 = -1, fd6 = -1;
//    int ret;
//    struct addrinfo hits;
//    struct addrinfo * results, * aitmp;
//    char host[40], portstr[6];
//
//    //任意一个fd创建成功，都有机会成功连接服务器
//    fd4 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
//    fd6 = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
//    if (fd4 == -1 && fd6 == -1){
//        printf("socket create error:%s\n", strerror(errno));
//        return -1;
//    }
//
//    handle = fd4;
//    setBlocking(D_FALSE); // 设置为非阻塞模式
//    handle = fd6;
//    setBlocking(D_FALSE); // 设置为非阻塞模式
//
//
//    //初始化 getaddrinfo 所需参数 hits
//    memset((void *)&hits, 0, sizeof(hits));
//    hits.ai_family = AF_UNSPEC;     //注意这里不要指定协议，这样getaddrinfo函数会根据网络环境返回得到的全部地址（包含ipv4和ipv6）
//    hits.ai_socktype = SOCK_STREAM;
//    hits.ai_protocol = 0;
//    hits.ai_flags = 0;
//
//    //获取服务器的地址和端口的字符串，域名IP均可
//    if(hostName != NULL){
//        memcpy(host, hostName, strlen(hostName));
//    }else{
////        snprintf(host, sizeof(host), "%d", ip);
//    }
//    snprintf(portstr, sizeof(portstr), "%d", port);
//
//
//    //调用getaddrinfo函数来获取服务器的IP地址，结果存放在以第四个参数results为首地址的链表中
//    //需要注意的是：只有IOS9.2和OS X 10.11.2及以上系统支持IPV6地址的合成，即第一个参数host传入IPV4地址，也能得到对应的IPV6地址
//    //            IOS9.2和OS X 10.11.2以下系统只有第一个参数传入域名时才能得到IPV6地址，若传入IPV4地址则只能得到IPV4地址
//    ret = getaddrinfo("s9999-ios-mxzg.hnguangyi.cn", portstr, &hits, &results);
//    if(ret != 0){
//        printf("getaddrinfo error:%s\n", strerror(errno));
//        return -2;
//    }
//
//
//    //results链表中会存在ipv4和ipv6地址,所以遍历该链表，当有一个connect成功时即可结束遍历直接返回
//    //注意两个connect第二个参数虽然都是aitmp->ai_addr,却指的不同的结构体，第三个参数应该传入对应结构体的大小
//    for(aitmp = results; aitmp != NULL; aitmp = aitmp->ai_next){
//        switch(aitmp->ai_family){
//            case AF_INET:
//                ret = ::connect(fd4, aitmp->ai_addr, sizeof(struct sockaddr_in));
//                if(ret == 0 || errno == EINPROGRESS || errno == EWOULDBLOCK){
//                    if(fd6 >= 0)
//                        ::close(fd6);
//                    return fd4;
//                }
//                printf("IPV4 connect error:%s\n", strerror(errno));
//                break;
//            case AF_INET6:
//                ret = ::connect(fd6, aitmp->ai_addr, sizeof(struct sockaddr_in6));
//                if(ret == 0 || errno == EINPROGRESS || errno == EWOULDBLOCK){
//                    if(fd4 >= 0)
//                        ::close(fd4);
//                    return fd6;
//                }
//                printf("IPV6 connect error:%s\n", strerror(errno));
//                break;
//        }
//    }
//
//    printf("connect fail!\n");
//    if(fd4 >= 0)
//        ::close(fd4);
//    if(fd6 >= 0)
//        ::close(fd6);

    
    
//    string str_portxxx = StringUtils::format("%d", port);
//    auto sockfdxxx = tcp_connect(hostName, str_portxxx.c_str());
//
//    if (sockfdxxx < 0)
//    {
//        cout << "call tcp_connect error" << endl;
//        return -1;
//    }
//
//    handle = sockfd;
//
//    fd_set set;
//    timeval tm;
//    tm.tv_sec = 7; // 设置超时时间
//    tm.tv_usec = 0;
//    FD_ZERO(&set);
//    FD_SET(handle, &set);
//    if (select(handle + 1, NULL, &set, NULL, &tm) > 0) {
//        // 判断是否真的连接上
//        int len = sizeof(int);
//        int error = -1;
//        getsockopt(handle, SOL_SOCKET, SO_ERROR, &error, (socklen_t*)&len);
//        if (error != 0) {
//            // 这一般是IP能连接，但端口不能访问
//            CCLOG("Connect socket failed. getsockopt error.");
//            close();
//            return -1;
//        }
//    } else {
//        // 超时
//        CCLOG("Connect socket failed. Timeout or error happen.");
//        close();
//        return -1;
//    }
//
//    connected = true;
//    CCLOG("Connect done!");
    
    // 兼容IPV6和IPV4
    int sockfd, ret;
    struct addrinfo hints, *res, *ressave;
    bzero(&hints, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_IP;
    string str_port = StringUtils::format("%d", port);
// auto sockfd = tcp_connect(hostName, str_port.c_str());
    
    if (0 != (ret = getaddrinfo(hostName, str_port.c_str(), &hints, &res)))
    {
        cout << "getaddrinfo error: " << gai_strerror(ret) << endl;
        return -1;
    }
    
    ressave = res;
    while (NULL != res)
    {
        if (-1 == (sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol)))
        {
            log("create socket error: %s", strerror(errno));
//            cout << "create socket error: " << strerror(errno) << endl;
            res = res->ai_next;
            continue;
        }
    
        handle = sockfd;
//        setBlocking(D_FALSE); // 设置为非阻塞模式
    
        if (-1 == ::connect(sockfd, res->ai_addr, res->ai_addrlen))
        {
            log("connect error: %s", strerror(errno));
//            cout << "connect error: " << strerror(errno) << endl;
            ::close(sockfd);
            res = res->ai_next;
            continue;
        }
        
        int opt = 1;
        ioctl(sockfd, FIONBIO, &opt);
        break;
    }
    freeaddrinfo(ressave);
    
    if (NULL == res)
        return -1;
    
    
     fd_set set;
     timeval tm;
     tm.tv_sec = 7; // 设置超时时间
     tm.tv_usec = 0;
     FD_ZERO(&set);
     FD_SET(handle, &set);
     if (select(handle + 1, NULL, &set, NULL, &tm) > 0) {
         // 判断是否真的连接上
         int len = sizeof(int);
         int error = -1;
         getsockopt(handle, SOL_SOCKET, SO_ERROR, &error, (socklen_t*)&len);
         if (error != 0) {
             // 这一般是IP能连接，但端口不能访问
             CCLOG("Connect socket failed. getsockopt error.");
             close();
             return -1;
         }
     } else {
         // 超时
         CCLOG("Connect socket failed. Timeout or error happen.");
         close();
         return -1;
     }
    
    connected = true;
    return 0;
    
    
//    if (port == 0) {
//        CCLOG("Error port: %d", port);
//        return -1;
//    }
//
//
//    struct hostent* host;
//    host = gethostbyname(hostName);
//    if (!host) {
//        CCLOG("Error hostName: %s", hostName);
//        return -1;
//    }
//
//    CCLOG("Connecting %s:%d...", hostName, port);
//
//    struct sockaddr_in addr;
//    memset(&addr, 0, sizeof(addr));
//    memcpy((char*)&addr.sin_addr, host->h_addr, host->h_length);
//    addr.sin_family = host->h_addrtype;
//    addr.sin_port = htons(port);
//
//    handle = socket(addr.sin_family, SOCK_STREAM, 0);
//    if (handle < 0) {
//        CCLOG("Create socket failed.");
//        return -1;
//    }
//
//
//    setBlocking(D_FALSE); // 设置为非阻塞模式
//
//    if (::connect(handle, (sockaddr*)&addr, sizeof(addr)) < 0) {
//        if (errno != EINPROGRESS) {
//            CCLOG("Connect socket failed.");
//            close();
//            return  -1;
//        }
//
//        fd_set set;
//        timeval tm;
//        tm.tv_sec = 7; // 设置超时时间
//        tm.tv_usec = 0;
//        FD_ZERO(&set);
//        FD_SET(handle, &set);
//        if (select(handle + 1, NULL, &set, NULL, &tm) > 0) {
//            // 判断是否真的连接上
//            int len = sizeof(int);
//            int error = -1;
//            getsockopt(handle, SOL_SOCKET, SO_ERROR, &error, (socklen_t*)&len);
//            if (error != 0) {
//                // 这一般是IP能连接，但端口不能访问
//                CCLOG("Connect socket failed. getsockopt error.");
//                close();
//                return -1;
//            }
//        } else {
//            // 超时
//            CCLOG("Connect socket failed. Timeout or error happen.");
//            close();
//            return -1;
//        }
//    }
//
//    connected = true;
//    CCLOG("Connect done!");
//
    return 0;
}

int SocketClient::close()
{
    if (handle < 0) {
        return handle;
    }
    
    CCLOG("socket disconnect . . . ");
    
    int ret = ::close(handle);
//    closesocket(handle);
    
    handle = -1;
    readOffset = 0;
    recvOffset = 0;
    connected = false;
    
    Game::is_online = false;
    
    return ret;
}

bool SocketClient::isConnected()
{
    return connected;
}

int SocketClient::send(const void* data, unsigned int len) {
    if (handle < 0) {
        CCLOG("Did not connect socket.");
        return 0;
    }
    
    int sent = 0;
    
    // Send the data
    while (len > 0) {
        sent = (int)::send(handle, data, len, 0);
        if (sent <= 0) {
            return sent;
        }
        data = (char*)data + sent;
        len -= sent;
    }
    return sent;
}

int SocketClient::recv()
{
    if (handle < 0)
    {
        // CCLOG("Did not connect socket.");
        return -1;
    }
    
    if (recvOffset >= recvBufferSize)
    {
        if (readOffset > 0)
        {
            // overflow, copy the data and reset offset.
            int unreadLen = recvBufferSize - readOffset;
            if (unreadLen > 0)
            {
                memcpy(recvBuffer, (char*)recvBuffer + readOffset, unreadLen);
            }
            recvOffset = unreadLen;
            readOffset = 0;
        }
        else
        {
            // 缓冲区已经满，暂不接收数据。
            return 0;
        }
    }
    
//    char tmp_buffer[10000000];
    int count = (int)::recv(handle, (char*)recvBuffer + recvOffset, recvBufferSize - recvOffset, 0);
//    int count = (int)::recv(handle, tmp_buffer, 1, 0);
//    int count = (int)::read(handle, (char*)recvBuffer + recvOffset, recvBufferSize - recvOffset);
    if (count > 0) {
        recvOffset += count;
    } else if (count == 0) {
        // Other side has disconnected, so close down our socket
        CCLOG("Other side has disconnected");
        // TEST
        close();
    } else {
        if (errno == EAGAIN) {
            // No data available to read (and socket is non-blocking)
        } else {
            // 服务器主动断开连接
        	CCLOG("::recv error %d", count);
            close();
        }
    }
    
    return count;
}

int SocketClient::read(void* buffer, int len)
{
    int l = get(buffer, len);
    if (l > 0)
    {
        readOffset += l;
    }
    return l;
}

int SocketClient::readPointer(void** pointer, int len)
{
    if (len > recvBufferSize)
    {
        // 获取数据的长度不能大于缓冲区大小
        return -1;
    }
    
    if (readOffset + len > recvOffset)
    {
        // 缓冲区数据不足
        return 0;
    }
    
    *pointer = (char*)recvBuffer + readOffset;
    readOffset += len;
    
    return len;
}

int SocketClient::getReadableBytes()
{
    return recvOffset - readOffset;
}

void SocketClient::skipBytes(int len)
{
    readOffset += len;
}

void SocketClient::clear()
{
    readOffset = 0;
    recvOffset = 0;
}

int SocketClient::get(void *buffer, int len)
{
    if (len > recvBufferSize)
    {
        // 获取数据的长度不能大于缓冲区大小
        return -1;
    }
    
    if (readOffset + len > recvOffset)
    {
        // 缓冲区数据不足
        return 0;
    }
    
    memcpy(buffer, (char*)recvBuffer + readOffset, len);
    
    return len;
}

void SocketClient::setBlocking(bool block) {
    int flags;
    int result;
    
    flags = fcntl(handle, F_GETFL, 0);
    if (flags < 0) {
        return;
    }
    
    if (block) {
        // Set it to blocking...
        result = fcntl(handle, F_SETFL, flags & ~O_NONBLOCK);
    } else {
        // Set it to non-blocking...
        result = fcntl(handle, F_SETFL, flags | O_NONBLOCK);
    }
    
    if ( result < 0 )
    {
        return;
    }
}

