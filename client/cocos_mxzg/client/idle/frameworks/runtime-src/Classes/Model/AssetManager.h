//
//  AssetMgr.h
//  Empire
//
//  Created by windy on 2017/8/9.
//
//

#ifndef Empire__AssetMgr_h__
#define Empire__AssetMgr_h__

#include "cocos2d.h"
#include <stdio.h>
#include <iostream>
#include <curl/curl.h>
#include "../Common/SingleInstance.h"


USING_NS_CC;
using namespace std;

enum CURLErrorCode
{
    // 创建文件失败
    CURLEC_CREATE_FILE = 0,
    
    // 网络超时或者超出单次下载的时间
    CURLEC_NETWOEK,
    
    // 无法打开文件.解压失败.不能创建文件目录
    CURLEC_UNCOMPRESS,
    
    // 线程创建错误,下次打开游戏时再继续更新.
    CURLEC_CREATE_THREAD,
    
    // 磁盘空间不够
    CURLEC_NOT_ENOUGH_DISK,
    
    // 文件不存在
    CURLEC_MISS_FILE,
    
    // 主动停止下载
    CURLEC_STOP_DOWNLOAD,
};

enum DownloadStatus
{
    DS_FAIL= 0,                     // 失败
    DS_FINISH = 1,                 // 下载完成
    DS_CHECKING_SERVER = 2,        // 校验文件中
    DS_UNCHECK_SERVER = 3,         // 未校验文件版本
    DS_NEED_DOWNLOAD_PACKAGE = 4,  // 需要下载安装包
    DS_WAIT_DOWNLOAD = 5,          // 等待开始下载
    DS_WAIT_WIFI_TIP = 6,          // 提示WIFI下载
    DS_WIFI_TIP_INCOMPLETE = 7,    // WIFI提示中
//    DS_WIFI_TIP_FINISH,        // WIFI完成
    DS_NOT_ENOUGH_DISK = 8,        // 磁盘空间不足
    
    DS_DOWNLOAD_INCOMPLETE = 9,    // 正在下载中
    DS_WAIT_DECOMPRESS = 10,        // 等待解压
};

struct AssetUnit
{
    string version;
    string file;
    string md5;
    long long lenght;
    bool is_download;
    bool is_decompress;
    bool is_remove;
    bool is_ignore;             // 可能磁盘满或者其他条件.会忽略该更新
    bool is_always;             // 是否一直下载
    AssetUnit() {
        lenght = 0;
        is_download = false;
        is_decompress = false;
        is_remove = false;
        is_ignore = false;
        is_always = false;
    }
};


class AssetManager : public SingleInstance<AssetManager>, public Ref
{
public:
//    static AssetManager* instance() {}
    AssetManager();
    void destroy();
    
    static string getDownloadUrl();
    
    /*
     *  开始版本文件.比对文件版本
     *      本地版本文件不存在.下载服务器版本文件.服务器版本文件不存在.则下载列表为空
     */
    void checkVersion();                        // 自动更新
    void decompressDownloadedZip();             // 解压上次下载的文件
    int  getDownloadFileFileCount();            // 获取需要下载的文件数
    int  getDecompressFileCount();              // 获取需要解压的文件数
    DownloadStatus getDownloadStatus();         // 获取下载状态
    int getDownloadProgress();                  // 10000 = 100%
    string hasDownloadFile();                   // 是否有需要更新
    long long getDownLoadSize();                // 获取所有下载文件的大小
    long long getDownLoadLenght();              // 当前已经下载的
    void saveFile(vector<AssetUnit>& vec, string str_delete, CSJson::Value json_package, const string& file);
    
    void startDownload();                       // 开始下载
    void stopDownload();                        // 停止下载
    bool isDownLoading();                       // 是否正在下载
    bool isNeedDownLoad();                      // 是否需要下载
    
    bool isUpdatedMainAsset();                  // 是否更新了配置文件
    void setVersionFile(const string& file);    // 设置版本文件
    
    void setMaxDownloadSpeed(long speed);       // 设置为0则不限制下载速度
    
    int  getDownloadTimeOut();                  //
    void setDownloadTimeOut(int timeOut);
    
    int  getConnectTimeOut();
    void setConnectTimeOut(int timeOut);
    
    void setWiFiTip(int tip);
    void setWiFiTipSize(long long size);
    
    string getDownloadPackageURL(string platform);
    
    static int32_t unzip(const char *zipPath, const char *dirpath, const char *passwd, bool bAsset);
    
    // TEST
    static void test_encrypt();
    
    
    // 请不要调用下面的方法
    void downloadByURL(const string& url, const string& localFile, bool redownload = false);
    int  urlProgress(double total_download, double now_downloaded, double total_upload, double now_uploaded);
protected:
    void onMiss(CURLErrorCode error_code, const string& url, const string& local_file);   // 文件不存在
    void onError(CURLErrorCode error_code, const string& url, const string& local_file);  // 下载错误
    void onSuccess(const string& url, const string& local_file);                          // 下载完成
    
    
    bool download(const string& url, const string& local_file, bool redownload);
    long getDownloadFileLength(const string& file);   // 获取下载文件的大小
    long getLocalFileLength(const string& file);      // 当前下载文件大小
    bool parseAssetByFile(vector<AssetUnit>& vec, const string& file, string* str_delete_version, CSJson::Value* json_package);
    void decompressDownloadedFile();                  // 解压所有已经下载的文件
    vector<string> getDeleteFiles(const string& file);
    bool saveFile(const char* str, unsigned long size, const string& path);
protected:
    vector<AssetUnit> vec_server_asset;
    vector<AssetUnit> vec_local_asset;
    
    bool is_check_download; // 是否更新资源
    bool is_stop;           // 暂停状态
    bool is_updated_server; // 是否更新服务器版本了
    bool is_resume_download;// 是否从0开始下载.后端可能不支持断点续传
    bool can_update;        // 是否可以开始更新
    bool is_decompress;     // 是否正在解压
    bool is_enough_disk;    // 磁盘是否不足
    int wifi_tip;           // 非WIFI状态下。会有流量提示框  0:还没出现提示 1：正在提示中 2：提示完成。执行下一步操作
    bool is_need_download_package;  // 是否需要下载安装包
    
    string version_file;    // 版本文件名
    string writable_path;   // 写入路径
    string str_delete_local;// 删除的版本号
    string str_delete_server;// 删除的版本号
    CSJson::Value json_local_package; // 本地包版本
    CSJson::Value json_server_package;// 服务器包版本
    double file_length;     // 下载文件大小
    int download_time_out;  // 下载超时
    int connect_time_out;   // 链接超时
    double max_download_speed;// 最大下载速度
    long long free_disk_space;
    long long cur_download_lenght;      // 现在下载文件的进度
    long long total_download_lenght;    // 总的
    long long tip_wifi_download;    // 文件大小超过多少M提示WiFi下载
    CURL *curl_handle;
};

#endif /* AssetMgr_h */
