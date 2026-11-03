//
//  AssetDownload.h
//  idle
//
//  Created by hua on 2019/9/28.
//

#ifndef __AssetDownload_h__
#define __AssetDownload_h__



#include "cocos2d.h"
#include <stdio.h>
#include <iostream>
#include <curl/curl.h>
#include "../Common/SingleInstance.h"


USING_NS_CC;
using namespace std;

enum ADL_STATUS
{
    ADL_FAIL = -1,
    ADL_SUCCESS = 1,
    ADL_DOWNLOAD = 2,
    ADL_STOP = 3,
    ADL_FILE_MISS = 4,
    
    
    
    ADL_DECOMPRESSING_FAIL = 10,
    ADL_DECOMPRESSING_SUCCESS = 11,
    ADL_DECOMPRESSING = 12,
};


// 单个文件下载类,不能同时下载多个
class AssetDownload : public Ref
{
public:
    CC_SYNTHESIZE(string, url, Url);
    CC_SYNTHESIZE(string, save_file, SaveFile);                 // 必须是全路径
    CC_SYNTHESIZE(string, cur_download_file, CurDownloadFile);
    CC_SYNTHESIZE(string, md5, Md5);
    
    
    CC_SYNTHESIZE(double, total_download, TotalDownload);
    CC_SYNTHESIZE(double, now_downloaded, NowDownloaded);
    CC_SYNTHESIZE(double, total_upload, TotalUpload);
    CC_SYNTHESIZE(double, now_uploaded, NowUploaded);
    
    CC_SYNTHESIZE(bool, is_stop, IsStop);
    CC_SYNTHESIZE(bool, is_resume_download, IsResumeDownload);

    // 解压
    CC_SYNTHESIZE(bool, is_decompress, IsDecompress);
    CC_SYNTHESIZE(string, decompress_file, DecompressFile);                 // 必须是全路径
    CC_SYNTHESIZE(ADL_STATUS, decompress_status, DecompressStatus);

    
    CC_SYNTHESIZE(ADL_STATUS, download_status, DownloadStatus);

    
    AssetDownload();
    ~AssetDownload();
    
    static AssetDownload* instance();
    void destroy();

    
    void startDownload();                       // 开始下载
    void stopDownload();                        // 停止下载
    
    void downloadByURL(const string& url, const string& localFile, bool redownload = false);
    int  urlProgress(double total_download, double now_downloaded, double total_upload, double now_uploaded);
    
    int download(const string& url, const string& local_file, bool redownload);
    
    std::string basename(const std::string& path) const;
    bool  decompress(const std::string &zip);
    void decompressAsyn();
private:
    
    static AssetDownload* _instance;
};


#endif /* __AssetDownload_h__ */
