//
//  AssetDownload.cpp
//  idle
//
//  Created by hua on 2019/9/28.
//

#include "AssetDownload.h"
#include <unistd.h>
#include "cocos-ext.h"
#include "unzip/unzip.h"
#include "base/ccUtils.h"

#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

AssetDownload* AssetDownload::_instance = NULL;

// 线程锁
static pthread_mutex_t download_mutex_2;


// 线程锁
static pthread_mutex_t decompress_mutex_2;

AssetDownload::AssetDownload()
{
    cur_download_file = "";
    is_stop = false;
    is_decompress = false;
    is_resume_download = false;
    
    download_status = ADL_FAIL;
    decompress_status = ADL_DECOMPRESSING_FAIL;
}

AssetDownload::~AssetDownload()
{

}

//
AssetDownload* AssetDownload::instance()
{
    if (_instance == NULL) {
        _instance = new AssetDownload();
    }
    return _instance;
}

void AssetDownload::destroy()
{
    CCLOG("AssetMgr::destroy");
    pthread_mutex_unlock(&download_mutex_2);
    pthread_mutex_unlock(&decompress_mutex_2);
    delete this;
    _instance = NULL;
}

void* thread_func(void *arg) {
    string file = AssetDownload::instance()->getSaveFile();
    if ( file.length() <= 0 ) {
        return NULL;
    }
//    CCLOG("downloadControler funcation started...");
    AssetDownload::instance()->downloadByURL(AssetDownload::instance()->getUrl(), file, false);
    return NULL;
}

// 开始下载
void AssetDownload::startDownload()
{
    pthread_mutex_lock(&download_mutex_2);
    int thread_error_code = 0;
    pthread_t thread_curl; // 线程初始化
    do {
        string current_file = getSaveFile();// hasDownloadFile();
        if (current_file.length() <= 0) {
            // 所有下载任务完成.删除自身
            // destroy();
            break;
        }
        // CCFileUtils::sharedFileUtils()->removeFile(CCFileUtils::sharedFileUtils()->getWritablePath() + current_file);
        is_stop = false;

        pthread_attr_t thread_attr;
        thread_error_code = pthread_attr_init(&thread_attr);
        if (thread_error_code != 0) {
            setDownloadStatus(ADL_FAIL);
//            onError(CURLEC_CREATE_THREAD, "", current_file);
            break;
        }

        thread_error_code = pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if ( thread_error_code != 0 ) {
            pthread_attr_destroy(&thread_attr);
//            onError(CURLEC_CREATE_THREAD, "", current_file);
            setDownloadStatus(ADL_FAIL);
            break;
        }

        thread_error_code = pthread_create(&thread_curl, &thread_attr, thread_func, this);
    } while (0);

    pthread_mutex_unlock(&download_mutex_2);
}

// 停止下载
void AssetDownload::stopDownload()
{
    pthread_mutex_lock(&download_mutex_2);
    setDownloadStatus(ADL_STOP);
    pthread_mutex_unlock(&download_mutex_2);
}

//
void AssetDownload::downloadByURL(const string& url, const string& localFile, bool redownload)
{
    setDownloadStatus(ADL_DOWNLOAD);
    setIsStop(is_stop);

    string current_file = localFile;
    CCLOG("file_path:%s", current_file.c_str());
    
    int ret = 0;
    while (true) {
        ret = download(url, current_file, redownload);

        if ( is_stop ) {
            break;
        }

        if (ret == 1 || ret == -1) {
            break;
        }
    }

    if (ret == 1)
    {
        setDownloadStatus(ADL_SUCCESS);
//        onSuccess(url, localFile);
    } else if (ret == -1) {
        setDownloadStatus(ADL_FILE_MISS);
//        onError(is_stop ? CURLEC_STOP_DOWNLOAD : CURLEC_UNCOMPRESS, url, localFile);
    } else {
        CCLOG("download fail %s", url.c_str());
        setDownloadStatus(ADL_FAIL);
    }
}


static size_t write_file_func2(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
    return written;
}


static int progress_funct(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
    return AssetDownload::instance()->urlProgress(totalToDownload, nowDownloaded, totalToUpLoad, nowUpLoaded);
}


int AssetDownload::urlProgress(double total_download, double now_downloaded, double total_upload, double now_uploaded)
{
    if ( now_downloaded == 0 ) return 0;

//    double download_speed = 0;
//    curl_easy_getinfo(curl_handle, CURLINFO_SPEED_DOWNLOAD, &download_speed);

    setTotalDownload(total_download);
    setTotalUpload(total_upload);

    setNowDownloaded(now_downloaded);
    setNowUploaded(now_uploaded);

//    log("%f, %f, %f, %f", total_download, now_downloaded, total_upload, now_uploaded);
    // 1.结束下载循环.   0.继续下载
    return is_stop; //0;
}

int AssetDownload::download(const string& url, const string& local_file, bool redownload)
{
    log("url = %s ", url.c_str());
    
    auto* file_utils = FileUtils::getInstance();
    FILE *fp = NULL;

    long localFileLenth = 0;    // 已经下载的大小
    if (this->getIsResumeDownload() && access(local_file.c_str(), 0) == 0 && !redownload ) { // 以二进制形式追加
        fp = fopen(local_file.c_str(), "ab+");
        fseek(fp, 0L, SEEK_END);
        localFileLenth = ftell(fp);
    } else {
    
        string file_directory = local_file.substr(0, local_file.rfind('/'));
        if ( ! file_utils->isDirectoryExist(file_directory) ) {
            file_utils->createDirectory(file_directory);
        } else {
            file_utils->removeFile(local_file);
        }
    
        fp = fopen(FileUtils::getInstance()->getSuitableFOpen(local_file).c_str(), "wb+");// 二进制写
    }

    if (fp == NULL) {  // 如果文件初始化失败进行返回
        return 0;
    }
    
    CURLcode code;
    string error;
    
    // CURL 有bug.如果curl_handle闲置超过5分钟.再次调用将会卡在curl_easy_perform
//    if ( curl_handle )
//    {
//        curl_easy_cleanup(curl_handle);
//    }
    
    auto curl_handle = curl_easy_init();
    //    CCLog("filePath:%s；leng:%ld", localFile.c_str() , localFileLenth );
    if (curl_handle == NULL) {
        fclose(fp);
        return 0;
    }
    

//    curl_easy_setopt(curl_handle, CURLOPT_VERBOSE, 1L);
    curl_easy_setopt(curl_handle, CURLOPT_URL, url.c_str());
    
    static const int MAX_REDIRS = 7;
    if (MAX_REDIRS)
    {
        curl_easy_setopt(curl_handle, CURLOPT_FOLLOWLOCATION, true);
        curl_easy_setopt(curl_handle, CURLOPT_MAXREDIRS, MAX_REDIRS);
    }
    
    curl_easy_setopt(curl_handle, CURLOPT_TIMEOUT, 300);
//    curl_easy_setopt(curl_handle, CURLOPT_TIMEOUT_MS, 1);
    curl_easy_setopt(curl_handle, CURLOPT_CONNECTTIMEOUT, 4/*getConnectTimeOut()*/);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, write_file_func2);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, fp);
    curl_easy_setopt(curl_handle, CURLOPT_RESUME_FROM, localFileLenth);// 断点续传
    curl_easy_setopt(curl_handle, CURLOPT_MAX_RECV_SPEED_LARGE , (curl_off_t)10000 * 1024 );
    curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, false);
    curl_easy_setopt(curl_handle, CURLOPT_PROGRESSFUNCTION, progress_funct );
    curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, this);
//    curl_easy_setopt(curl_handle, CURLOPT_HEADER, 1);
//    curl_easy_setopt(curl_handle, CURLOPT_NOBODY, 1);
    
    
    CURLcode res = curl_easy_perform(curl_handle);
    
    int retcode = 0;
    curl_easy_getinfo(curl_handle, CURLINFO_RESPONSE_CODE , &retcode);
    
    // 该文件不支持断点续传
    if (res == CURLE_RANGE_ERROR) {

    }
    
    curl_easy_cleanup(curl_handle);
    if (retcode != 200) {
        fclose(fp);
        return -1;
    }
    
    
    fclose(fp);
    
    if (res == CURLE_OK) {
//        rewind(fp);
//        fp = fopen(FileUtils::getInstance()->getSuitableFOpen(local_file).c_str(), "rb+");// 二进制写
        
        
//        std::ifstream ifs (local_file.c_str(), ios::binary);
//        auto md5 = MD5(ifs).toString();
//        log("local_file.md5 = %s md5 = %s", local_file.c_str(), md5.c_str());
//        setMd5(md5);
//        ifs.close();
        
//        std::ifstream t(local_file.c_str(), ios::binary);
//        std::stringstream buffer;
//        buffer << t.rdbuf();
//        std::string contents(buffer.str());
//        auto md5 = MD5(contents).toString();
//        log("local_file = %s contents = %s, md5 = %s", local_file.c_str(), contents.c_str(), md5.c_str());
//        setMd5(md5);
        
//        FILE *pf = fopen(local_file.c_str(),"rb+");
//        fseek(pf,0,SEEK_END);
//        long lSize = ftell(pf);
//        char* text= (char*)malloc(lSize+1);
//        rewind(pf);
//        fread(text,sizeof(char),lSize,pf);
//        text[lSize] = '\0';
//        fclose(pf);
//
//        string file_data = text;
//        free(text);
//         MD5("1231231asdkajshdjhkjqwhdjkhqwjdhwqkdhqwkdhqwjdhqwjkdhqwkjh231231").toString();
//        setMd5(md5);
//        cocos2d::utils:
        //  IOS release 模式下 toString 函数会崩溃
        // MD5(contents).toString();
        auto md5 = cocos2d::utils::getFileMD5Hash(local_file);
        setMd5(md5);
//        log("local_file = %s contents = %s, md5 = %s", md5.c_str(), md5.c_str(), md5.c_str());
    }
    
    return res == CURLE_OK ? 1 : 0;
}



std::string AssetDownload::basename(const std::string& path) const
{
    size_t found = path.find_last_of("/\\");
    
    if (std::string::npos != found)
    {
        return path.substr(0, found);
    }
    else
    {
        return path;
    }
}

void* decompress_func(void *arg) {
    string file = AssetDownload::instance()->getDecompressFile();
    if ( file.length() <= 0 ) {
        return NULL;
    }
    //    CCLOG("downloadControler funcation started...");
    if (AssetDownload::instance()->decompress(file)) {
        AssetDownload::instance()->setDecompressStatus(ADL_DECOMPRESSING_SUCCESS);
    } else {
        AssetDownload::instance()->setDecompressStatus(ADL_DECOMPRESSING_FAIL);
    }
    return NULL;
}

void AssetDownload::decompressAsyn()
{
    pthread_mutex_lock(&decompress_mutex_2);
    int thread_error_code = 0;
    pthread_t thread_decompress; // 线程初始化
    do {
        pthread_attr_t thread_attr;
        thread_error_code = pthread_attr_init(&thread_attr);
        if (thread_error_code != 0) {
            setDecompressStatus(ADL_DECOMPRESSING_FAIL);
            break;
        }
        
        thread_error_code = pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if ( thread_error_code != 0 ) {
            pthread_attr_destroy(&thread_attr);
            setDecompressStatus(ADL_DECOMPRESSING_FAIL);
            break;
        }
        
        setDecompressStatus(ADL_DECOMPRESSING);
        thread_error_code = pthread_create(&thread_decompress, &thread_attr, decompress_func, this);
    } while (0);
    
    pthread_mutex_unlock(&decompress_mutex_2);
    
}

bool AssetDownload::decompress(const std::string &zip)
{
    // Find root path for zip file
    size_t pos = zip.find_last_of("/\\");
    if (pos == std::string::npos)
    {
        CCLOG("AssetDownload : no root path specified for zip file %s\n", zip.c_str());
        return false;
    }
    const std::string rootPath = zip.substr(0, pos+1);
    
    // Open the zip file
    unzFile zipfile = unzOpen(FileUtils::getInstance()->getSuitableFOpen(zip).c_str());
    if (! zipfile)
    {
        CCLOG("AssetDownload : can not open downloaded zip file %s\n", zip.c_str());
        return false;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLOG("AssetDownload : can not read file global info of %s\n", zip.c_str());
        unzClose(zipfile);
        return false;
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[BUFFER_SIZE];
    // Loop to extract all files.
    uLong i;
    for (i = 0; i < global_info.number_entry; ++i)
    {
        // Get info about current file.
        unz_file_info fileInfo;
        char fileName[MAX_FILENAME];
        if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  MAX_FILENAME,
                                  NULL,
                                  0,
                                  NULL,
                                  0) != UNZ_OK)
        {
            CCLOG("AssetDownload : can not read compressed file info\n");
            unzClose(zipfile);
            return false;
        }
        const std::string fullPath = rootPath + fileName;
        
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength-1] == '/')
        {
            //There are not directory entry in some case.
            //So we need to create directory when decompressing file entry
            if ( !FileUtils::getInstance()->createDirectory(basename(fullPath)) )
            {
                // Failed to create directory
                CCLOG("AssetDownload : can not create directory %s\n", fullPath.c_str());
                unzClose(zipfile);
                return false;
            }
        }
        else
        {
            // Entry is a file, so extract it.
            // Open current file.
            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
            {
                CCLOG("AssetDownload : can not extract file %s\n", fileName);
                unzClose(zipfile);
                return false;
            }
            
            
            // FIX MAXOS CATALINA
            #if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
            auto dir_index = fullPath.find_last_of("/");
            if (dir_index != string::npos) {
                auto dir = fullPath.substr(0, dir_index);
                FileUtils::getInstance()->createDirectory(dir);
            }
            #endif
            
            
            // Create a file to store current file.
            FILE *out = fopen(FileUtils::getInstance()->getSuitableFOpen(fullPath).c_str(), "wb");
            if (!out)
            {
                CCLOG("AssetDownload : can not create decompress destination file %s\n", fullPath.c_str());
                unzCloseCurrentFile(zipfile);
                unzClose(zipfile);
                return false;
            }
            
            // Write current file content to destinate file.
            int error = UNZ_OK;
            do
            {
                error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
                if (error < 0)
                {
                    CCLOG("AssetDownload : can not read zip file %s, error code is %d\n", fileName, error);
                    fclose(out);
                    unzCloseCurrentFile(zipfile);
                    unzClose(zipfile);
                    return false;
                }
                
                if (error > 0)
                {
                    fwrite(readBuffer, error, 1, out);
                }
            } while(error > 0);
            
            fclose(out);
        }
        
        unzCloseCurrentFile(zipfile);
        
        // Goto next entry listed in the zip file.
        if ((i+1) < global_info.number_entry)
        {
            if (unzGoToNextFile(zipfile) != UNZ_OK)
            {
                CCLOG("AssetDownload : can not read next file for decompressing\n");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
    unzClose(zipfile);
    return true;
}
