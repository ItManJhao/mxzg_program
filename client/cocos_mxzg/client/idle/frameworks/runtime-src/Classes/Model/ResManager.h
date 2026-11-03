//
//  ResManager.h
//  idle
//
//  Created by hua on 2020/3/4.
//

#ifndef ResManager_h
#define ResManager_h

#include "cocos2d.h"
#include <stdio.h>
#include <iostream>

class ResManager : public cocos2d::Ref
{
public:
    ResManager();
    static ResManager* instance();
    bool isInit() {return is_init;}
    
    // 初始化key列表
    bool initMap();
    
    void setDecodeKey(const std::string& key, const std::string& sign);
    
    void skipBOM(const char*& chunk, int& chunkSize);
    
    bool isXXTeaFile(const char* filedata);
    
    // 部分资源需要在第一次启动时释放
    void copyInitRes();
    
    // 获取混淆后文件名
    std::string decodeFilename(const std::string& filename);
    
    // 不暴露get函数
    std::string xxtea_sign;
    std::string xxtea_key;
private:
    static ResManager* _instance;

    // 防止死循环
    bool is_init = false;
    int32_t xxtea_sign_len;
    
    std::map<std::string, std::string> map_file_name;
    std::map<std::string, std::string> map_res_name;
};

#endif /* ResManager_h */
