//
//  Utils.h
//  ClickerHeroes
//
//  Created by sicoe on 13-3-15.
//
//

#ifndef __ClickerHeroes__Utils__
#define __ClickerHeroes__Utils__

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <functional>
#include "cocos-ext.h"
#include <regex.h>

#include "../Common/CommonDefine.h"

using namespace std;
USING_NS_CC;

class StringUtil
{
public:
    
    /** 將一個數字按時間的進制法以秒數算，轉換為時間最大的前兩位，加上時間單位顯示為字符串 */
    static string convertIntToTime(uint32_t num, const char* space = " ");
    static string convertIntToTimeTest(uint32_t num, const char* space = "");
    static string convertIntToTimeCN(uint32_t num, const char* space = "");
    /** 將一個數字按時間的進制法以秒數算，轉換為時間最大的前兩位，加上時間單位顯示為字符串 */
    static string convertIntToTimeWithColon(uint32_t num);
    /* 將一個數字按時間的進制法以秒數算，轉換為准确时间顯示為字符串 */
    static string convertIntToDetailTime(uint32_t num, const char* space = " ");
    /** 将一个数字按时间的进制法计算，保留两位，如果有秒则忽略秒*/
    static string convertIntToAboutTime(uint32_t num);
    /* 将一个整数型时间转换成距离现在的时间有多久了 , 58分钟前,23小时前,300天前*/
    static string convertToHowLong(const char* format1, const char* format2, const char* format3, const char* format4, int64_t time);
    static string convertToDate(int32_t time);
    /* 时间转换  format = %2d:%2d returnVar = 00:00*/
    static string convertToMinute(const char* format, int32_t time);
    /* 时间转换  format = %2d:%2d returnVar = 00:00*/
    static string convertIntToMinute(const char* format, int32_t time);

    
    static string lTrim(const string& ss);
    static string rTrim(const string& ss);
    static string trim(const string& st);
    
    static int length(const char* s);
    static string left(const char* s, int length);

    /** 将一个数字用科学计数法三位加一个逗号*/
    static string convertIntScientific(int64_t num);
    static string convertIntKScientific(int64_t num);
    static string convertDoubleScientific(double num, bool need_fra);   // need_fra:必须有小数
    static string convertScientific(int64_t num);
    
    
    static string itoa(int64_t num);
    
    static string sign(map<string, string> content);
    
    static void splitStringIntoVector(vector<string>& vec, string token, string src);
    // 新增的函数。不能在lua中调用
    static std::vector<std::string> splist(const std::string& s, const std::string& c);
    

    static string replaceAll(string str, const string& old_str, const string& new_str);
    
    // ios限制输入需要
    static unsigned short getLatterSize(const char* src);
    static unsigned int   getStringLength(const string& src);
    static unsigned int   getStringLetterCount(const string& src);
    static string         cutStringWithLength(const string& src, int length, int min_latter_size = 1);
    static string         cutNameWithLength(const string& src, int length, float letter_size, float chinese_size);

    /**讲一个int64_t的字符串转换成int64_t类型*/
    static int64_t convertStringToInt64(const string& str);
    
    static string getUnits(const char* format1, const char* format2, const char* format3, const char* format4, int64_t time);
    static string getFileMd5WithFilePath(const char* path);
    
    // 将数值转换成K,B M
    static string convertIntKBMScientific(int64_t num);
};

class RegularUtil
{
public:
    static bool match(const char* pattern, const char* str);
    static bool isEmail(const char* str);
private:
    static string getRegError(int errorcode, regex_t *compiled);
};

class ImageUtil {
    
public:
    /** 根据参数将一个图像制作成一个圆形 radius(半径) src_img(源数据)*/
//    static vector<char> convertImgToCircle(int radius, Size origin_size, vector<char>& origin_data, Point dot = Point::ZERO);
};

#endif /* defined(__ClickerHeroes__Utils__) */




