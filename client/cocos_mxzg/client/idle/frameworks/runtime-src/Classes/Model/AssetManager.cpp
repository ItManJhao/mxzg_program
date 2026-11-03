//
//  AssetMgr.cpp
//  Empire
//
//  Created by windy on 2017/8/9.
//
//

#include "AssetManager.h"
#include <unistd.h>
#include "cocos-ext.h"
#include "../Common/CSVFile.h"
#include "Game.h"
#include "../Person/Hero.h"

#include "unzip/unzip.h"

#include "../Common/Base64.h"
#include "../Common/Aes.h"

#include "../Platform/SocialPlatform.h"

#include "../Config/VersionTable.h"
#include "../Model/LuaManager.h"

#define DOWNLOAD_SPEED 0
#define KEY_UPDATE "updated"
#define KEY_VERSION "version"
#define KEY_FILE_SUFFIX ".pre"
#define KEY_FILE "file"
#define KEY_MD5 "tag"
#define KEY_ALWAYS "always"

#define KEY_IS_DOWNLOAD "is_download"
#define KEY_IS_DECOMPRESS "is_decompress"
#define KEY_IS_REMOVE "is_remove"

// #define KEY_BASE_URL Game::config_url
// #define KEY_VERSION_FILE "hd/config/resversion.rvs"

#define KEY_VERSION_FILE "resversion.rvs"
#define IS_DOWNLOAD_MAC 0

// 线程锁
static pthread_mutex_t download_mutex_1;

AssetManager::AssetManager()
: is_stop(true)
, is_check_download(true)
, is_updated_server(false)
, is_need_download_package(false)
, wifi_tip(0)
, can_update(false)
, is_decompress(false)
, is_enough_disk(false)
, curl_handle(NULL)
, version_file("")
, file_length(0)
, max_download_speed(-1)
, free_disk_space(0)
, cur_download_lenght(0)
, total_download_lenght(0)
, tip_wifi_download(0)
{
    version_file = KEY_VERSION_FILE;
    
    setMaxDownloadSpeed(DOWNLOAD_SPEED);
    setConnectTimeOut(4);
    setDownloadTimeOut(0);
    // free_disk_space = Game::instance()->getFreeDiskSpace();
    // TEST
    free_disk_space = 10000000000;
    
#if ((CC_TARGET_PLATFORM != CC_PLATFORM_ANDROID) && !IS_DOWNLOAD_MAC)
    //  MAC 不加载最新的资源
#else
    //CCLOG("free_disk_space = %lldM", Game::instance()->getFreeDiskSpace() / 1000 / 1000);
    writable_path = FileUtils::getInstance()->getWritablePath();
    vector<string> searchPath = FileUtils::getInstance()->getSearchPaths();
    searchPath.insert(searchPath.begin(), writable_path);
    //    searchPath.insert(searchPath.begin(), writable_path + "default");
    //    searchPath.insert(searchPath.begin(), writable_path + "iphone");
    FileUtils::getInstance()->setSearchPaths(searchPath);
#endif
    
    is_check_download = true;//Game::instance()->getReverseScale() == 0.5;
    
    pthread_mutex_init(&download_mutex_1, NULL);
}


void AssetManager::destroy()
{
    CCLOG("AssetMgr::destroy");
    curl_easy_cleanup(curl_handle);
    pthread_mutex_unlock(&download_mutex_1);
    delete this;
    _instance = NULL;
}

string AssetManager::getDownloadUrl() {
    //    return VersionTable::instance()->config.download_urls;
    SocialPlatform* platform = SocialPlatform::instance();
    string str_tmp = "/";
    string url = VersionTable::instance()->config.download_urls + "idle/" + platform->getChannelId() + str_tmp + platform->getPfId() + str_tmp;
    return url;
}

// 是否更新了配置文件
bool AssetManager::isUpdatedMainAsset()
{
    return is_updated_server;
}

// 设置版本文件
void AssetManager::setVersionFile(const string& file)
{
    version_file = file;
}

// 解压已经下载的文件
void AssetManager::decompressDownloadedZip()
{
    if (is_decompress) {
        return;
    }
    
    is_decompress = true;
    int thread_error_code = 0;
    pthread_t thread_config; // 线程初始化
    do {
        pthread_attr_t thread_attr;
        thread_error_code = pthread_attr_init(&thread_attr);
        if (thread_error_code != 0) {
            log("线程创建失败");
            is_decompress = false;
            break;
        }
        
        thread_error_code = pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if ( thread_error_code != 0 ) {
            pthread_attr_destroy(&thread_attr);
            log("线程创建失败");
            is_decompress = false;
            break;
        }
        
        
        thread_error_code = pthread_create(&thread_config, &thread_attr, [](void *arg){
            void* result = NULL;
            log("解压资源线程内部执行");
            
            auto asset_manager = AssetManager::instance();
            asset_manager->decompressDownloadedFile();
            
            bool* status = (bool*)arg;
            *status = false;
            return result;
        }, &is_decompress);
        
    } while (0);
    
//    resetScale();
}


int AssetManager::getDownloadFileFileCount()
{
    int count = 0;
    for (int i = 0 ; i < vec_server_asset.size() ; ++i)
    {
        const AssetUnit& asset_server = vec_server_asset[i];
        
        for (int j = 0 ; j < vec_local_asset.size() ; ++j)
        {
            const AssetUnit& asset_local = vec_local_asset[j];
            if ( (asset_local.is_always && !asset_local.is_download) || (!asset_local.is_ignore && asset_local.file == asset_server.file && ! asset_local.is_download) ) {
                count++;
            }
        }
    }
    return count;
}


int AssetManager::getDecompressFileCount()
{
    int count = 0;
    for (int i = 0 ; i < vec_local_asset.size() ; ++i)
    {
        AssetUnit& asset_local = vec_local_asset[i];
        if (asset_local.is_download && ! asset_local.is_decompress) {
            count++;
        }
    }
    return count;
}

// 获取下载状态
DownloadStatus AssetManager::getDownloadStatus()
{
    
#if ((CC_TARGET_PLATFORM != CC_PLATFORM_ANDROID) && !IS_DOWNLOAD_MAC)
    return DS_FINISH;
#endif
    
    // 下载版本文件
    if (is_enough_disk)
    {
        return DS_NOT_ENOUGH_DISK;
    }
    
//    CCLOG("AssetManager::getDownloadStatus = %d, %d  %d", isUpdatedMainAsset(), isDownLoading(), is_need_download_package);
    
    if ( !isUpdatedMainAsset() ) {
        if ( !isDownLoading() ) {
            // 正在校验版本
            return  DS_UNCHECK_SERVER ;
        }
        return DS_CHECKING_SERVER;
    }
    
    if (is_need_download_package) {
        return DS_NEED_DOWNLOAD_PACKAGE;
    }
    
    int32_t download_files = getDownloadFileFileCount();
    int32_t decompress_files = getDecompressFileCount();
    if (isDownLoading()) {
        return DS_DOWNLOAD_INCOMPLETE;
    } else {
        if (download_files > 0) {
            auto files_size = getDownLoadSize();
            // 大于10m则提示wifi下载
            if (wifi_tip == 0 && tip_wifi_download > 0 && files_size > tip_wifi_download) {
                return DS_WAIT_WIFI_TIP;
            }
            
            if (wifi_tip == 1) {
                return DS_WIFI_TIP_INCOMPLETE;
            }
            
//            if (wifi_tip == 2) {
//                return DS_WIFI_TIP_FINISH;
//            }
            
            return DS_WAIT_DOWNLOAD;
        }
        
        if (decompress_files > 0) {
            return DS_WAIT_DECOMPRESS;
        }
        
        
//        auto engine = LuaEngine::getInstance();
//        engine->executeScriptFile("src/native/AssetCall.lua");
//        LuaManager::instance()->executeGlobalAutoFunction("deleteAsset", [&](LuaStack * ls) {
//            return 0;
//        });
        return DS_FINISH;
    }
    return DS_FAIL;
}

int AssetManager::getDownloadProgress()
{
    double max_lenght = 0;
    double now_lenght = cur_download_lenght;
    for (int i = 0 ; i < vec_server_asset.size() ; ++i)
    {
        const AssetUnit& asset_server = vec_server_asset[i];
        
        vector<AssetUnit>::iterator iter_file = std::find_if(vec_local_asset.begin(),
                                                             vec_local_asset.end(),
                                                             [&](const AssetUnit& data) {
                                                                 if (data.file == asset_server.file) {
                                                                     return true;
                                                                 }
                                                                 return false;
                                                             });
        if (iter_file != vec_local_asset.end() && iter_file->is_download) {
            now_lenght += asset_server.lenght;
        }
        
//        for (int j = 0 ; j < vec_local_asset.size() ; ++j)
//        {
//            const AssetUnit& asset_local = vec_local_asset[j];
//            if (asset_local.file == asset_server.file && asset_local.is_download) {
//                now_lenght += asset_server.lenght;
//            }
//        }
        max_lenght += asset_server.lenght;
    }
    
    return MAX((now_lenght / max_lenght) * 10000.0, 0);
}

long long AssetManager::getDownLoadLenght()
{
    return total_download_lenght + cur_download_lenght;
}

// 是否有需要更新
string AssetManager::hasDownloadFile()
{
    for (int i = 0 ; i < vec_server_asset.size() ; ++i)
    {
        const AssetUnit& asset_server = vec_server_asset[i];
        
        for (int j = 0 ; j < vec_local_asset.size() ; ++j)
        {
            const AssetUnit& asset_local = vec_local_asset[j];
            if (asset_local.is_always && !asset_local.is_download) {
                return asset_local.file;
            }
            
            if (!asset_local.is_ignore && asset_local.file == asset_server.file && ! asset_local.is_download) {
                return asset_server.file;
            }
        }
    }
    return "";
}

// 获取所有下载文件的大小
long long AssetManager::getDownLoadSize()
{
    long long file_size = 0;
    for (int i = 0 ; i < vec_server_asset.size() ; ++i)
    {
        const AssetUnit& asset_server = vec_server_asset[i];
        vector<AssetUnit>::iterator iter_file = std::find_if(vec_local_asset.begin(),
                                                             vec_local_asset.end(),
                                                             [&](const AssetUnit& data) {
                                                                 if (data.file == asset_server.file) {
                                                                     return true;
                                                                 }
                                                                 return false;
                                                             });
        if (iter_file != vec_local_asset.end() && !iter_file->is_download && !asset_server.is_download) {
            file_size += asset_server.lenght;
        }
        else if (!asset_server.is_download) {
            file_size += asset_server.lenght;
        }
    }
    return file_size;
}


void AssetManager::saveFile(vector<AssetUnit>& vec, string str_delete, CSJson::Value json_package, const string& file)
{
    CSJson::Value document;
    CSJson::Reader reader;
    CSJson::Value json_downloads;
    
    for (int i = 0 ; i < vec.size() ; ++i)
    {
        const AssetUnit& asset = vec[i];
        CSJson::Value object;
        object[KEY_VERSION] = asset.version.c_str();
        object[KEY_FILE] = asset.file.c_str();
        object[KEY_IS_DOWNLOAD] = (int32_t)asset.is_download;
        object[KEY_IS_DECOMPRESS] = (int32_t)asset.is_decompress;
        json_downloads.append(object);
    }
    document["downloads"] = json_downloads;
    
    CSJson::Value json_delete;
    json_delete["version"] = str_delete;
    document["delete"] = json_delete;
    
    document["package"] = json_package;
    
    CSJson::FastWriter writer;
    string json_stirng = writer.write(document);
    CCLOG("json_stirng = %s", json_stirng.c_str());
    saveFile(json_stirng.c_str(), json_stirng.length(), file);
}

bool AssetManager::saveFile(const char* str, unsigned long size, const string& path)
{
    CCAssert(!path.empty() && size != 0, "Invalid parameters.");
    do
    {
        // Read the file from hardware
        FILE *fp = fopen(path.c_str(), "wb");
        CC_BREAK_IF(!fp);
        
        fwrite(str, size, 1, fp);
        
        fclose(fp);
        
        return true;
    } while (0);
    
    return false;
}


void AssetManager::setMaxDownloadSpeed(long speed)
{
    max_download_speed = speed;
}

int AssetManager::getDownloadTimeOut()
{
    return download_time_out;
}


void AssetManager::setDownloadTimeOut(int timeOut)
{
    download_time_out = timeOut;
}

int AssetManager::getConnectTimeOut()
{
    return connect_time_out;
}

void AssetManager::setConnectTimeOut(int timeOut)
{
    connect_time_out = timeOut;
}

void AssetManager::setWiFiTip(int tip)
{
    wifi_tip = tip;
}


void AssetManager::setWiFiTipSize(long long size)
{
    tip_wifi_download = size;
}

string AssetManager::getDownloadPackageURL(string platform)
{
    
    if (!json_server_package.isObject()) {
        return "";
    }
    string str_platform = StringUtils::format("Platform%s", platform.c_str());
    if (!json_server_package.isMember(str_platform.c_str())) {
        return "";
    }
    
    return json_server_package[str_platform.c_str()].asString();
}


// 文件不存在
void AssetManager::onMiss(CURLErrorCode errorCode, const string& url, const string& local_file)
{
    if (local_file == version_file) {
        is_updated_server = false;
        can_update = false;
    }
}

void AssetManager::onError(CURLErrorCode error_code, const string& url, const string& local_file)
{
    is_stop = true;
    
    if (error_code == CURLEC_NOT_ENOUGH_DISK) {
        is_enough_disk = true;
    }
    
    if ( local_file != version_file ) {
        for (int i = 0 ; i < vec_local_asset.size() ; ++i)
        {
            AssetUnit& asset = vec_local_asset[i];
            if ( asset.file == local_file) {
                if (error_code == CURLEC_NOT_ENOUGH_DISK) {
                    asset.is_ignore = true;
                }
                break;
            }
        }
        
        if (error_code == CURLEC_CREATE_THREAD ) {
            is_check_download = false;
            startDownload();
        }
        else if (  error_code != CURLEC_STOP_DOWNLOAD && error_code != CURLEC_NOT_ENOUGH_DISK) {
            startDownload();
        }
    } else {
        
        
        if (error_code == CURLEC_CREATE_THREAD) {
            is_check_download = false;
            startDownload();
        }
    }
    
}

template<typename T> bool compare_file(const T s1 , const T s2){
    return s1.file == s2.file;
}

void AssetManager::onSuccess(const string& url, const string& local_file)
{
    is_stop = true;
    if (local_file == version_file) {
        bool tmp_update_status = false;
        if ( parseAssetByFile(vec_server_asset, writable_path + version_file, &str_delete_server, &json_server_package) ) {
            tmp_update_status = true;
        }
        
        if (json_local_package.isObject() && !json_local_package.isMember("version")) {
            auto vec_tmp_local = vec_local_asset;
            
            // 判断前端本地文件
            parseAssetByFile(vec_local_asset, version_file, &str_delete_local, &json_local_package);
            vec_local_asset = vec_tmp_local;
        }
        
        
//        auto vec_delete_file = getDeleteFiles(writable_path + version_file);
//        for (int i = 0; i < vec_delete_file.size(); ++i)
//        {
//            auto file = vec_delete_file[i];
//            if (file[file.length() - 1] == '/') {
//                FileUtils::getInstance()->removeDirectory(writable_path + file);
//            } else {
//                FileUtils::getInstance()->removeFile(writable_path + file);
//            }
//        }
        
        LuaManager::instance()->executeGlobalAutoFunction("deleteAsset", [&](LuaStack * ls) {
            return 0;
        });
        
//        saveFile(vec_local_asset, str_delete_local, json_local_package, writable_path + version_file + KEY_FILE_SUFFIX);
        
        
        if (json_local_package.isObject() && json_local_package.isMember("version") &&
            json_server_package.isObject() && json_server_package.isMember("version") &&
            json_server_package["version"].asString() != json_local_package["version"].asString()) {
            
            is_updated_server = true;
            is_need_download_package = true;
            return;
        }
        
        // 计算前端跟服务端的区别
        for (int i = 0 ; i < vec_server_asset.size() ; ++i)
        {
            const AssetUnit& asset = vec_server_asset[i];
            // 兼容c99.但是非指针只能拷贝
//            vector<AssetUnit>::iterator iter_file = std::find_if(vec_local_asset.begin(),
//                                                                 vec_local_asset.end(),
//                                                                 bind2nd(ptr_fun(compare_file<AssetUnit>), asset));
            
            
//            if ( iter_file == vec_local_asset.end() )
//            {
//                vec_local_asset.push_back(asset);
//            }
//            else if ( asset.is_always || strcmp(asset.version.c_str(), (*iter_file).version.c_str()) > 0 ) {
//                (*iter_file).version = asset.version;
//                (*iter_file).is_always = asset.is_always;
//                (*iter_file).is_download = false;
//                (*iter_file).is_decompress = false;
//                (*iter_file).is_ignore = false;
//            }
            vector<AssetUnit>::iterator iter_file = std::find_if(vec_local_asset.begin(),
                                                                vec_local_asset.end(),
                                                                 [&](const AssetUnit& data) {
                                                                     if (data.file == asset.file) {
                                                                         return true;
                                                                     }
                                                                     return false;
                                                                 });
            if ( iter_file == vec_local_asset.end() )
            {
                vec_local_asset.push_back(asset);
            }
            else
            {
                auto version1 = atof(asset.version.c_str());
                auto version2 = atof((*iter_file).version.c_str());
                if ( asset.is_always || version1 > version2 ) {
                    (*iter_file).version = asset.version;
                    (*iter_file).is_always = asset.is_always;
                    (*iter_file).is_download = false;
                    (*iter_file).is_decompress = false;
                    (*iter_file).is_ignore = false;
                }
            }
        }
        
//        resetScale();
        auto* file_utils = FileUtils::getInstance();
        for (int i = 0 ; i < vec_server_asset.size() ; ++i)
        {
            AssetUnit& asset = vec_server_asset[i];
            
            vector<AssetUnit>::iterator iter_file = std::find_if(vec_local_asset.begin(),
                                                                 vec_local_asset.end(),
                                                                 [&](const AssetUnit& data) {
                                                                     if (data.file == asset.file) {
                                                                         return true;
                                                                     }
                                                                     return false;
                                                                 });
            
            if ((iter_file == vec_local_asset.end() || !iter_file->is_download) && !asset.is_download) {
//                KEY_BASE_URL + file
                // 删除文件。防止上一个版本下载了一半。然后文件内容变更
                file_utils->removeFile(writable_path + asset.file);
                asset.lenght = getDownloadFileLength(getDownloadUrl() + asset.file);
            }
        }
        
        is_updated_server = tmp_update_status;
        
        if (can_update) {
            startDownload();
        }
    } else {
        for (int i = 0 ; i < vec_local_asset.size() ; ++i)
        {
            AssetUnit& asset_local = vec_local_asset[i];
            if ( asset_local.file == local_file ) {
                asset_local.is_download = true;
                saveFile(vec_local_asset, str_delete_local, json_local_package, writable_path + version_file + KEY_FILE_SUFFIX);
                
                // 开始下载
                startDownload();
                break;
            }
        }
    }
}

void AssetManager::checkVersion()
{
    stopDownload();
    
    is_updated_server = false;
    do {
        
        // 判断是否之前是否下载过校验文件并且完成了某些操作
        auto* file_utils = FileUtils::getInstance();
        if ( file_utils->isFileExist(writable_path + version_file + KEY_FILE_SUFFIX) ) {
            if ( parseAssetByFile(vec_local_asset, writable_path + version_file + KEY_FILE_SUFFIX, &str_delete_local, &json_local_package) ) {
                break;
            }
            file_utils->removeFile(writable_path + version_file + KEY_FILE_SUFFIX);
        }
        
        // 判断是否之前是否下载过校验文件
        if ( file_utils->isFileExist(writable_path + version_file) ) {
            if ( parseAssetByFile(vec_local_asset, writable_path + version_file, &str_delete_local, &json_local_package) ) {
                break;
            }
            file_utils->removeFile(writable_path + version_file);
        }
        
        // 判断前端本地文件
        parseAssetByFile(vec_local_asset, version_file, &str_delete_local, &json_local_package);
        
    } while (0);
    
//    log("str_delete_local = %s", str_delete_local.c_str());
    
    vec_server_asset = vec_local_asset;
    
    // 下载服务器文件
    log("checkVersion = %s", string(getDownloadUrl() + version_file).c_str());
    downloadByURL(getDownloadUrl() + version_file, version_file, true);
    
    // 下载完成逻辑
    // onSuccess
    
}


void AssetManager::downloadByURL(const string& url, const string& localFile, bool redownload)
{
    if ( ! is_check_download ) {
        return;
    }
    
    file_length = getDownloadFileLength(url);
    
    if ( file_length <= 0 )
    {
        if ( file_length == 0) {
            onMiss(CURLEC_MISS_FILE, url, localFile);
        } else {
            onError(CURLEC_NETWOEK, url, localFile);
        }
        return;
    }
    
    // 在这里判断文件长度可能会出bug.
    if ( file_length * 2.1 > free_disk_space )
    {
        onError(CURLEC_NOT_ENOUGH_DISK, url, localFile);
        return;
    }
    
    string current_file = writable_path + localFile;
    CCLOG("file_path:%s", current_file.c_str());
    is_stop = false;
    is_resume_download = false;
    bool ret = false;
    while (true) {
        ret = download(url, current_file, redownload);
        
        if ( is_stop ) {
            break;
        }
        
        if (ret) {
            break;
        }
        
        //sleep(3);
    }
    
    if (ret)
    {
        CCLOG("download ok");
        onSuccess(url, localFile);
    } else {
        CCLOG("download fail");
        onError( is_stop ? CURLEC_STOP_DOWNLOAD : CURLEC_UNCOMPRESS, url, localFile);
    }
}


void* thread_funcation(void *arg) {
    string file = AssetManager::instance()->hasDownloadFile();
    if ( file.length() <= 0 ) {
        return NULL;
    }
    CCLOG("downloadControler funcation started...");
    AssetManager::instance()->downloadByURL(AssetManager::getDownloadUrl() + file, file , false);
    return NULL;
}

static size_t write_file_function(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
    return written;
}

static int progress_func(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
    return AssetManager::instance()->urlProgress(totalToDownload, nowDownloaded, totalToUpLoad, nowUpLoaded);
}

int AssetManager::urlProgress(double total_download, double now_downloaded, double total_upload, double now_uploaded)
{
    if ( now_downloaded == 0 ) return 0;
    
    double download_speed = 0;
    curl_easy_getinfo(curl_handle, CURLINFO_SPEED_DOWNLOAD, &download_speed);
    
    cur_download_lenght = (file_length - total_download + now_downloaded);
//    double nowDown = (file_length - total_download + now_downloaded);
//    double curpercent = nowDown / file_length * 100;
//
//    CCLog("now_downloaded:%f; total_download:%d; down_progress:%.2f%%", (file_length - total_download + now_downloaded), (int)file_length , curpercent);
    
    // 1.结束下载循环.   0.继续下载
    return is_stop; //0;
}

bool AssetManager::download(const string& url, const string& local_file, bool redownload)
{
    auto* file_utils = FileUtils::getInstance();
    FILE *fp = NULL;
    
    if ( access(local_file.c_str(), 0) == 0 && ! redownload ) { // 以二进制形式追加
        fp = fopen(local_file.c_str(), "ab+");
    } else {
        string file_directory = local_file.substr(0, local_file.rfind('/'));
        if ( ! file_utils->isDirectoryExist(file_directory) ) {
            file_utils->createDirectory(file_directory);
        }
        fp = fopen(local_file.c_str(), "wb+");// 二进制写
    }
    
    if (fp == NULL) {  // 如果文件初始化失败进行返回
        fclose(fp);
        return false;
    }
    
    // 不支持断点续传。如果需要支持。则需要做文件校验.或先删除上一个版本相同的文件
    long localFileLenth = is_resume_download || redownload ? 0 : getLocalFileLength(local_file);  // 已经下载的大小
    if ( localFileLenth >= file_length ) {
        return 1;
    }
    
    // CURL 有bug.如果curl_handle闲置超过5分钟.再次调用将会卡在curl_easy_perform
    if ( curl_handle )
    {
        curl_easy_cleanup(curl_handle);
    }
    
    curl_handle = curl_easy_init();
//    CCLog("filePath:%s；leng:%ld", localFile.c_str() , localFileLenth );
    curl_easy_setopt(curl_handle, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl_handle, CURLOPT_TIMEOUT, getDownloadTimeOut());
    curl_easy_setopt(curl_handle, CURLOPT_CONNECTTIMEOUT, 4/*getConnectTimeOut()*/);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, write_file_function);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, fp);
    curl_easy_setopt(curl_handle, CURLOPT_RESUME_FROM, localFileLenth);// 断点续传
    curl_easy_setopt(curl_handle, CURLOPT_MAX_RECV_SPEED_LARGE , (curl_off_t)max_download_speed * 1024 );
    curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, 0L);
    curl_easy_setopt(curl_handle, CURLOPT_PROGRESSFUNCTION, progress_func );
    curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, this);
    
    CURLcode res = curl_easy_perform(curl_handle);
    // 该文件不支持断点续传
    if (res == CURLE_RANGE_ERROR) {
        is_resume_download = true;
        setDownloadTimeOut(0);
    }
    fclose(fp);
    return res == CURLE_OK;
}


long AssetManager::getDownloadFileLength(const string& file)
{
    double file_length = -1;
    CURL *handle = curl_easy_init();
    curl_easy_setopt(handle, CURLOPT_TIMEOUT, 3);
    curl_easy_setopt(handle, CURLOPT_CONNECTTIMEOUT, getConnectTimeOut());
    curl_easy_setopt(handle, CURLOPT_URL, file.c_str());
    curl_easy_setopt(handle, CURLOPT_NOBODY, 1L);
    curl_easy_setopt(handle, CURLOPT_HEADER, 0L); // 0 不打印日志 1打印日志
    CURLcode res = curl_easy_perform(handle);
    if (res == CURLE_OK) {
        curl_easy_getinfo(handle, CURLINFO_CONTENT_LENGTH_DOWNLOAD, &file_length);
        // printf("filesize : %0.0f bytes\n", file_length);
    } else if (res == CURLE_COULDNT_CONNECT) {
        file_length = 0;
    }
    curl_easy_cleanup(handle);
    return file_length;
}

long AssetManager::getLocalFileLength(const string& file)
{
    FILE *fp = fopen(file.c_str(), "r");
    if ( fp ) {
        fseek(fp, 0, SEEK_END);
        long length = ftell(fp);
        fclose(fp);
        return length;
    }
    fclose(fp);
    return 0;
}

bool AssetManager::parseAssetByFile(vector<AssetUnit>& vec, const string& file, string* str_delete_version, CSJson::Value* json_package)
{
    vec.clear();
    auto file_data = FileUtils::getInstance()->getStringFromFile(file.c_str());
    
    if ( file_data.length() <= 0 ) {
        return false;
    }
    
    CSJson::Value json_root;
    CSJson::Reader reader;
    reader.parse(file_data, json_root);
    
    if ( ! json_root.isObject() || ! json_root.isMember("downloads")) {
        return false;
    }
    
    auto json_downloads = json_root["downloads"];
    
    CSJson::FastWriter writer;
    for (int i = 0 ; i < json_downloads.size() ; ++i)
    {
        const CSJson::Value& value = json_downloads[i];
        if ( ! value.isObject() ) {
            continue;
        }
        AssetUnit asset;
        
        if ( value.isMember(KEY_FILE) && value[KEY_FILE].isString() ) {
            asset.file = value[KEY_FILE].asString();
        }
        
//        log("AssetManager::parseAssetByFile = %s", asset.file.c_str());
        
        if ( value.isMember(KEY_VERSION) && value[KEY_VERSION].isString() ) {
            asset.version = value[KEY_VERSION].asString();
        }
        
        if ( value.isMember(KEY_MD5) && value[KEY_MD5].isString() ) {
            asset.md5 = value[KEY_MD5].asString();
        }
        
        if ( value.isMember(KEY_IS_DOWNLOAD) && value[KEY_IS_DOWNLOAD].isInt() ) {
            asset.is_download = value[KEY_IS_DOWNLOAD].asBool();
        }
        
        if ( value.isMember(KEY_IS_DECOMPRESS) && value[KEY_IS_DECOMPRESS].isInt() ) {
            asset.is_decompress = value[KEY_IS_DECOMPRESS].asBool();
        }
        
        if ( value.isMember(KEY_IS_REMOVE) && value[KEY_IS_REMOVE].isInt() ) {
            asset.is_remove = value[KEY_IS_REMOVE].asBool();
        }
        
        if ( value.isMember(KEY_ALWAYS) && value[KEY_ALWAYS].isInt() ) {
            asset.is_always = value[KEY_ALWAYS].asBool();
        }
        
        vec.push_back(asset);
    }
    
//    log("file_data = %s", file_data.c_str());
    
    if (str_delete_version != NULL) {
        if ( json_root.isMember("delete") )  {
            auto json_delete = json_root["delete"];
            if (json_delete.isObject() && json_delete.isMember("version")) {
//                log("json_delete = %s", json_delete["version"].asString().c_str());
                *str_delete_version = json_delete["version"].asString();
            }
        }
    }
    
    if (json_root.isMember("package") && json_package) {
        *json_package = json_root["package"];
    }
    
    return true;
}

// 解压所有已经下载的文件
void AssetManager::decompressDownloadedFile()
{
    auto* file_utils = FileUtils::getInstance();
    for (int i = 0 ; i < vec_local_asset.size() ; ++i)
    {
        AssetUnit& asset_local = vec_local_asset[i];
        if (asset_local.is_decompress && ! asset_local.is_remove ) {
            file_utils->removeFile(writable_path + asset_local.file);
            asset_local.is_remove = true;
        }
        
        if ( asset_local.is_download && ! asset_local.is_decompress ) {
            
            auto zip_file_name = writable_path + asset_local.file;
            auto result = unzip(zip_file_name.c_str() , writable_path.c_str(), NULL, true);
            // 解压成功
            if (result >= 1) {
                asset_local.is_decompress = true;
                file_utils->removeFile(writable_path + asset_local.file);
            } else if ( result >= 0 ) {
                // 普通文件
                asset_local.is_decompress = true;
            } else {
                // 解压失败了
                asset_local.is_download = false;
                file_utils->removeFile(writable_path + asset_local.file);
            }
            asset_local.is_remove = true;
            saveFile(vec_local_asset, str_delete_local, json_local_package, writable_path + version_file + KEY_FILE_SUFFIX);
        }
    }
}


vector<string> AssetManager::getDeleteFiles(const string& file)
{
    vector<string> vec_files;
    auto file_data = FileUtils::getInstance()->getStringFromFile(file.c_str());
    if ( file_data.length() <= 0 ) {
        return vec_files;
    }
    
    log("AssetManager::getDeleteFiles = %s, %s", str_delete_server.c_str(), str_delete_local.c_str());
    if (str_delete_server == str_delete_local) {
        return vec_files;
    }
    
    CSJson::Value json_root;
    CSJson::Reader reader;
    reader.parse(file_data, json_root);
    
    if ( ! json_root.isObject() || ! json_root.isMember("delete")) {
        return vec_files;
    }
    
    auto json_delete = json_root["delete"];
    
    if (!json_delete.isMember("list")) {
        return vec_files;
    }
    
    auto json_list = json_delete["list"];
    if (!json_list.isArray()) {
        return vec_files;
    }
    
    for (int i = 0 ; i < json_list.size() ; ++i)
    {
        string value = json_list[i].asString();
        vec_files.push_back(value);
    }
    return vec_files;
}

// 开始下载.请不要在多线程里面调用Game::instance()->getFreeDiskSpace()
void AssetManager::startDownload()
{
#ifdef ASSET_DEBUG
    // return;
#endif
    
    can_update = true;
    total_download_lenght += cur_download_lenght;
    
    cur_download_lenght = 0;
    if ( ! is_updated_server ) {
        return;
    }
    
    pthread_mutex_lock(&download_mutex_1);
    int thread_error_code = 0;
    pthread_t thread_curl; // 线程初始化
    do {
        string current_file = hasDownloadFile();
        if (current_file.length() <= 0) {
            // 所有下载任务完成.删除自身
            // destroy();
            break;
        }
        // CCFileUtils::sharedFileUtils()->removeFile(CCFileUtils::sharedFileUtils()->getWritablePath() + current_file);
        
        if ( ! is_stop ) {
            break;
        }
        
        is_stop = false;
        
        
        pthread_attr_t thread_attr;
        thread_error_code = pthread_attr_init(&thread_attr);
        if (thread_error_code != 0) {
            onError(CURLEC_CREATE_THREAD, "", current_file);
            break;
        }
        
        thread_error_code = pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if ( thread_error_code != 0 ) {
            pthread_attr_destroy(&thread_attr);
            onError(CURLEC_CREATE_THREAD, "", current_file);
            break;
        }
        
        thread_error_code = pthread_create(&thread_curl, &thread_attr, thread_funcation, this);
    } while (0);
    
    pthread_mutex_unlock(&download_mutex_1);
}

void AssetManager::stopDownload()
{
    pthread_mutex_lock(&download_mutex_1);
    is_stop = true;
    can_update = false;
    pthread_mutex_unlock(&download_mutex_1);
}

// 是否正在下载
bool AssetManager::isDownLoading()
{
    return ! is_stop;
}

bool AssetManager::isNeedDownLoad()
{
    if ( ! is_check_download ) {
        return false;
    }
    
    if ( ! is_updated_server ) {
        return false;
    }
    
    string file = hasDownloadFile();
    return file.length() > 0;
}


int32_t _maxUnzipBufSize = 100000000;

// IOS ： user header search paths 添加 $(SRCROOT)/../cocos2d/cocos/platform
int32_t AssetManager::unzip(const char *zipPath, const char *dirpath, const char *passwd, bool bAsset)
{
    CCLOG("unzip info:zippath[%s]\n dirpath[%s]", zipPath, dirpath);
    if (false == FileUtils::getInstance()->isFileExist(zipPath)) {
        CCLOG("zipfile [%s] not exist", zipPath);
        return -1;
    }
    unzFile pFile;
    if (!bAsset) {
        pFile = unzOpen(zipPath);
    }
    else {
        ssize_t len = 0;
        // FileUtils::getInstance()->getFileDataFromZip(zipPath, "config.zip", &len);//
        unsigned char *data = FileUtils::getInstance()->getFileData(zipPath, "rb", &len);
        pFile = unzOpenBuffer(data, len);
    }
    if (!pFile) {
        CCLOG("unzip error get zip file false");
        return 0;
    }
    //解压目录
    string szTmpDir = dirpath;
    if (szTmpDir[szTmpDir.length() - 1] != '/'){
        szTmpDir = szTmpDir + "/";
    }
    int err = unzGoToFirstFile(pFile);
    bool ret = 1;
    while (err == UNZ_OK) {
        int nRet = 0;
        int openRet = 0;
        do {
            if (passwd) {
                openRet = unzOpenCurrentFilePassword(pFile, passwd);
                CCLOG("openRet %d", openRet);
            }
            else {
                openRet = unzOpenCurrentFile(pFile);
            }
            CC_BREAK_IF(UNZ_OK != openRet);
            unz_file_info FileInfo;
            char szFilePathA[260];
            nRet = unzGetCurrentFileInfo(pFile, &FileInfo, szFilePathA, sizeof(szFilePathA), NULL, 0, NULL, 0);
            CC_BREAK_IF(UNZ_OK != nRet);
            //如果szFilePathA为中文的话，请使用iocnv转码后再使用。
            std::string newName = szTmpDir + szFilePathA;
            if (newName[newName.length() - 1] == '/') {
                FileUtils::getInstance()->createDirectory(newName.c_str());
                continue;
            }
            
            FILE* pFile2 = fopen(newName.c_str(), "w");
            if (pFile2)
            {
                fclose(pFile2);
            }
            else
            {
                CCLOG("unzip can not create file");
                return -1;
            }
            
            unsigned long savedSize = 0;
            pFile2 = fopen(newName.c_str(), "wb");
            while (pFile2 != NULL && FileInfo.uncompressed_size > savedSize)
            {
                unsigned char *pBuffer = NULL;
                unsigned long once = FileInfo.uncompressed_size - savedSize;
                if (once > _maxUnzipBufSize)
                {
                    once = _maxUnzipBufSize;
                    pBuffer = new unsigned char[once];
                }
                else
                {
                    pBuffer = new unsigned char[once];
                }
                unsigned long nSize = unzReadCurrentFile(pFile, pBuffer, (unsigned int)once);
                fwrite(pBuffer, once, 1, pFile2);
                
                savedSize += nSize;
                delete[]pBuffer;
            }
            
            fclose(pFile2);
        } while (0);
        if (nRet != UNZ_OK)
        {
            ret = false;
        }
        else
        {
            unzCloseCurrentFile(pFile);
        }
        err = unzGoToNextFile(pFile);
    }
    if (err != UNZ_END_OF_LIST_OF_FILE)
    {
        ret = -1;
    }
    unzClose(pFile);
    return ret;
}


/*
 * 注意事项
 * 如果要使用base64.则加密字符串长度要是16的倍数。不过不影响加密解密的结果
 */

void AssetManager::test_encrypt()
{
//    std::string data;
//    std::string fileName;
//    CBase64 base64;
//    unsigned char key[] =
//    {
//        0x2b, 0x7e, 0x15, 0x16,
//        0x28, 0xae, 0xd2, 0xa6,
//        0xab, 0xf7, 0x15, 0x88,
//        0x09, 0xcf, 0x4f, 0x3c,
//        0x09, 0xcf, 0x4f, 0x3c,
//        0x28, 0xae, 0xd2, 0xa6,
//        0x2b, 0x7e, 0x15, 0x16,
//        0xab, 0xf7, 0x15, 0x88,
//    };
//    AES aes(key);
//    
//    log("key = %s", key);
//    
//    fileName = "config/version.csv";
//    data = cocos2d::FileUtils::getInstance()->getStringFromFile(fileName);
//    
//    // 加密部分
//    unsigned long lent = 0;
//    char* buff1 = (char*)malloc(data.size() + 200);
//    memset(buff1, '\0', data.size() + 200);
//    
//    base64.EncodeBuffer((char *)data.c_str(), (int)data.size(), buff1);
//    lent = strlen(buff1);
//    
//    printf("buff = %s size = %lu\n", buff1, lent);
//    data = buff1;
//    aes.encrypt((unsigned char*)data.c_str(), data.size());
////    cout << data << data.size() << endl;
////    saveFile("C:\\Users\\BACCARAT\\Desktop\\myTest\\ConsoleApplication1\\LoginLayer.jsc", data.c_str() , data.size());
//    
//    
//    // 解密部分
//    aes.decrypt((unsigned char*)data.c_str(), data.size());
//    
//    unsigned long buff2Size = data.size();
//    char* buff2 = (char*)malloc(buff2Size);
//    memset(buff2, '\0', buff2Size);
//    lent = base64.DecodeBuffer((char *)data.c_str(), buff2, (int)buff2Size);
//    
//    memset(buff2 + lent, '\0', buff2Size - lent);
//    printf("buff = %s size = %lu\n", buff2, lent);
//    
//    
//    free(buff1);
//    free(buff2);
    
    //sveFile("C:\\Users\\BACCARAT\\Desktop\\myTest\\ConsoleApplication1\\LoginLayer.jsc", buff,strlen(buff));
}
