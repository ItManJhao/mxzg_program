//
//  ResManager.cpp
//  idle
//
//  Created by hua on 2020/3/4.
//

#include "ResManager.h"
#include "Utils.h"


#define INIT_RES_KEY "INIT_RES_KEY"
#define INIT_RES_FILE "res/hd/encrypt"
#define DECODE_KEY_FILE string("res/Antarctic")

ResManager* ResManager::_instance = NULL;

ResManager::ResManager()
{
    xxtea_sign_len = 0;
}

ResManager* ResManager::instance()
{
    if (_instance == NULL) {
        _instance = new ResManager();
    }
    return _instance;
}


bool ResManager::initMap()
{
    std::string file = DECODE_KEY_FILE;
    
    auto str_data = cocos2d::FileUtils::getInstance()->getStringFromFile(file);
    // 逐行取值
    std::vector<string> vec_line = StringUtil::splist(str_data, "\n");
    for (int i = 0; i < vec_line.size(); i++)
    {
        std::vector<string> vec_data = StringUtil::splist(vec_line[i], "|");
        // 可能存在空值
        if (vec_data.size() == 2) {
            map_file_name[vec_data[0]] = vec_data[1];
        }
    }
    
    is_init = true;
    return is_init;
}

// 部分资源需要在第一次启动时释放
void ResManager::copyInitRes()
{
    bool is_init_res = cocos2d::UserDefault::getInstance()->getBoolForKey(INIT_RES_KEY, false);
//    bool is_init_res = false;
    if (!is_init_res) {
        auto writable_path = cocos2d::FileUtils::getInstance()->getWritablePath();
        auto str_data = cocos2d::FileUtils::getInstance()->getStringFromFile(INIT_RES_FILE);
        
        std::vector<string> vec_line = StringUtil::splist(str_data, "\n");
        for (auto iter = vec_line.begin(); iter != vec_line.end();++iter)
        {
            if (*iter != "") {
                // 要先创建目录才能写入内容
                std::vector<string> vec_dir = StringUtil::splist(*iter, "/");
                
                std::string dir = "";
                for (int i = 0; i < vec_dir.size() - 1; i++) {
                    dir = dir + vec_dir[i] + "/";
                }
                
                // 创建目录
                if (dir != "") {
                    cocos2d::FileUtils::getInstance()->createDirectory(writable_path + dir);
                }
                
                // 写入文件内容
                auto file_data = cocos2d::FileUtils::getInstance()->getDataFromFile(*iter);
                cocos2d::FileUtils::getInstance()->writeDataToFile(file_data, writable_path + *iter);
            }
        }
    }
    cocos2d::UserDefault::getInstance()->setBoolForKey(INIT_RES_KEY, true);
}

std::string ResManager::decodeFilename(const string& filename)
{
    // 分割目录
    std::string str_file;
    std::vector<string> vec_data = StringUtil::splist(filename, "/");
    
    // 取出对应的目录和文件名
    for (int i = 0; i < vec_data.size(); i++)
    {
        auto& data = vec_data[i];
        auto iter_data = map_file_name.find(data);
        str_file = str_file +
                   ((iter_data == map_file_name.end() ? (data) : iter_data->second) +
                    (i < vec_data.size() - 1 ? "/" : "")) ;
    }
    return str_file;
}

void ResManager::setDecodeKey(const std::string& key, const std::string& sign)
{
    xxtea_key = key;
    xxtea_sign = sign;
}

bool ResManager::isXXTeaFile(const char* filedata)
{
    if (filedata == NULL || xxtea_sign.size() <= 0) {
        return false;
    }
    
    return strncmp(filedata, xxtea_sign.c_str(), xxtea_sign.size()) == 0;
}


void ResManager::skipBOM(const char*& chunk, int& chunkSize)
{
    if (chunk == NULL) {
        return;
    }
    
    // UTF-8 BOM? skip
    if (static_cast<unsigned char>(chunk[0]) == 0xEF &&
        static_cast<unsigned char>(chunk[1]) == 0xBB &&
        static_cast<unsigned char>(chunk[2]) == 0xBF)
    {
        chunk += 3;
        chunkSize -= 3;
    }
}
