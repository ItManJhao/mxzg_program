//
//  AutomationManager.cpp
//  idle
//
//  Created by apple on 2021/5/9.
//



#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)



//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
//#include <WinSock2.h>
//#include <ws2tcpip.h>
//#ifndef _WINSOCKAPI_
//#define  _WINSOCKAPI_
//#ifndef _WINSOCK2API_
//#define _WINSOCK2API_
//
//#endif
//#else
//
//#endif
//
//#else
#include <sys/socket.h>
#include <fcntl.h>
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/types.h>

#define SOCKET int
#define SOCKET_ERROR -1
#define INVALID_SOCKET -1
//#endif


#include "AutomationManager.h"
#include "../Model/LuaManager.h"

#define HTTP_BUF_SIZE      1024     /* 缓冲区的大小 */


static SOCKET sockfd = 0;
// 线程锁
static mutex file_change_mutex;

string http_res_hdr_tmpl = "HTTP/1.1 200 OK\r\nServer: Huiyong's Server <0.1>\r\n"
    "Accept-Ranges: bytes\r\nContent-Length: %d\r\nConnection: close\r\n"
    "Content-Type: %s\r\n\r\n";

/**************************************************************************
 *
 * 函数功能: 向客户端发送 HTTP 响应.
 *
 * 参数说明: [IN]  buf, 字符串指针数组;
 *           [IN]  buf_len, buf 的长度;
 *
 * 返 回 值: 成功返回非0, 失败返回0.
 *
 **************************************************************************/
int httpSendResponse(SOCKET soc, char *buf, int buf_len)
{
    int read_len, hdr_len, send_len;
    char *type;
    char http_header[HTTP_BUF_SIZE];
    
    string res_file = "";
    
    /* 构造 HTTP 首部，并发送 */
    hdr_len = sprintf(http_header, http_res_hdr_tmpl.c_str(), res_file.size(), type);
    send_len = send(soc, http_header, hdr_len, 0);

    if (send_len == SOCKET_ERROR)
    {
        printf("[Web] Fail to send, error = \n");
        return 0;
    }

//    do /* 发送文件, HTTP 的消息体 */
//    {
////        read_len = fread(read_buf, sizeof(char), HTTP_BUF_SIZE, res_file.c_str());
////
////        if (read_len > 0)
////        {
//            send_len = send(soc, res_file.c_str(), res_file.size(), 0);
////            file_len -= read_len;
////        }
//    } while ((read_len > 0) && (file_len > 0));

    
    return 1;
}


AutomationManager::~AutomationManager()
{
    if (sockfd != 0) {
//        bool bDontLinger = false;
//        setsockopt(sockfd, SOL_SOCKET, 0x0004, (const char*)&bDontLinger, sizeof(bool));
        close(sockfd);
    }
}

void AutomationManager::listenerFileSave()
{
    #if(CC_TARGET_PLATFORM==CC_PLATFORM_WIN32)
        WORD wVersionRequested;
        WSADATA wsaData;
        int err;
        wVersionRequested = MAKEWORD(1, 1);
        err = WSAStartup(wVersionRequested, &wsaData);
        if (err != 0){
            return;
        }
        if (LOBYTE(wsaData.wVersion) != 1 || HIBYTE(wsaData.wVersion) != 1){
            WSACleanup();
            return;
        }
    #endif

        sockfd = socket(AF_INET, SOCK_STREAM, 0);

        struct sockaddr_in s_add;
        s_add.sin_family = AF_INET;
        s_add.sin_addr.s_addr = htonl(INADDR_ANY);
        s_add.sin_port = htons(15690);
        
        int reuse = 1;
        setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(int));
    
        if (-1 == ::bind(sockfd, (struct sockaddr*)&s_add, sizeof(struct sockaddr_in)))
        {
            CCLOG("bind fail");
    #if(CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

            closesocket(sockfd);
            WSACleanup();
    #else
            close(sockfd);
    #endif
            return;
        }

        if (-1 == listen(sockfd, 10))
        {
            CCLOG("listen fail");
    #if(CC_TARGET_PLATFORM==CC_PLATFORM_WIN32)

            closesocket(sockfd);
            WSACleanup();
    #else
            close(sockfd);
    #endif
            return;
        }
        CCLOG("listen successful");
    
    int thread_error_code = 0;
    pthread_t thread_accept; // 线程初始化
    do {
        pthread_attr_t thread_attr;
        thread_error_code = pthread_attr_init(&thread_attr);
        if (thread_error_code != 0) {
            break;
        }
        
        thread_error_code = pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if ( thread_error_code != 0 ) {
            pthread_attr_destroy(&thread_attr);
            break;
        }
        
        thread_error_code = pthread_create(&thread_accept, &thread_attr, [](void *arg){
            void* result = NULL;
                
            
            SOCKET* sockfd = (SOCKET*)(arg);
            while (true)
            {
                sockaddr_in from;
                unsigned int fromlen = sizeof(from);

  
                SOCKET client_sockfd = ::accept(*sockfd, (sockaddr*)&from, &fromlen);
                char buf[1024];
                if (-1 != recv(client_sockfd, buf, sizeof(buf), 0)){
//                  CCLOG("server recv: %s", buf);
                }
                else{
//                    CCLOG("recv fail");
//                    return result;
                    close(client_sockfd);
                    continue;
                }
                
                /* 向客户端发送响应数据 */
                httpSendResponse(client_sockfd, buf, sizeof(buf));
                
                string para = "";
                
                // 得到请求的参数
                int indexb = strcspn(buf, " ");
                
                if (indexb != -1) {
                    int indexe = strcspn(&buf[indexb + 1], " ");
                    
                    if (indexe != -1) {
                        char buf2[1024];
                        memcpy(buf2, &buf[indexb + 2], indexe - 1);
                        buf2[indexe - 1] = '\0';
                        para = buf2;
                    }
                }
                
//                pthread_mutex_lock(&file_change_mutex);
                file_change_mutex.lock();
                
                auto automation_manager = AutomationManager::instance();
                for(auto iter = automation_manager->listPara.begin(); iter != automation_manager->listPara.end();)
                {
                    auto data = (*iter);
                    if (data->isRead) {
                        iter = automation_manager->listPara.erase(iter);
                        delete data;
                    } else {
                        iter++;
                    }
                }
                
                
                FileData* data = new FileData();
                data->isRead = true;
                data->file = para;
                automation_manager->listPara.push_back(data);
                data->isRead = false;
//                pthread_mutex_unlock(&file_change_mutex);
                file_change_mutex.unlock();
                
//                pthread_mutex_lock(&file_change_mutex);
//                AutomationManager::instance()->recvPara(para);
//                pthread_mutex_unlock(&file_change_mutex);
                
                close(client_sockfd);
            }
            return result;
        }, &sockfd);
        
    } while (0);
    
    
    Scheduler* sharedScheduler = Director::getInstance()->getScheduler();
    sharedScheduler->scheduleUpdate(AutomationManager::instance(), 0, false);
}

void AutomationManager::update(float dt)
{
//    pthread_mutex_lock(&file_change_mutex);
    file_change_mutex.lock();

    if (listPara.size() > 0) {
        for(auto iter = listPara.begin(); iter != listPara.end(); iter++)
        {
            auto data =(*iter);
            if (!data->isRead) {
                LuaManager::instance()->executeGlobalAutoFunction("fileChange", [&](LuaStack * ls) {
                    ls->pushString(data->file.c_str(), data->file.size()); // (v);
                    return 1;
                });
                data->isRead = true;
            }
        }
        
//        for (string v : listPara) {
//            LuaManager::instance()->executeGlobalAutoFunction("fileChange", [&](LuaStack * ls) {
//                ls->pushString(v.c_str(), v.size()); // (v);
//                return 1;
//            });
//        }
//        listPara.clear();
    }
//    pthread_mutex_unlock(&file_change_mutex);
    file_change_mutex.unlock();
}

#endif
